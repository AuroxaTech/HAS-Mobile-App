import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:property_app/utils/api_urls.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../constant_widget/constant_widgets.dart';
import '../../models/service_provider_model/provider_job.dart';
import '../../services/property_services/add_services.dart';
import '../../utils/shared_preferences/preferences.dart';
import '../../utils/utils.dart';
import '../../views/authentication_screens/login_screen.dart';

class CalendarScreenController extends GetxController {
  Rx<CalendarFormat> calendarFormat = CalendarFormat.month.obs;
  Rx<DateTime> focusedDay = DateTime.now().obs;
  Rx<DateTime> selectedDay = DateTime.now().obs;
  Rx<DateTime> kToday = DateTime.now().obs;
  final GlobalKey<ScaffoldState> key = GlobalKey();
  RxSet<DateTime> highlightedDates = <DateTime>{}.obs;
  void updateHighlightedDates() {
    Set<DateTime> tempSet = {};

    // Iterate through the list of jobs
    for (var job in pagingController.itemList!) {
      if (job.createdAt != null) {
        // Check if createdAt is not null
        try {
          DateTime parsedDate = job
              .createdAt!; // Directly use DateTime object (since createdAt is already a DateTime)
          DateTime dateWithoutTime =
              DateTime(parsedDate.year, parsedDate.month, parsedDate.day);
          tempSet.add(dateWithoutTime); // Add the date without time to the set
        } catch (e) {
          print("Error parsing date: $e");
        }
      } else {
        print("createdAt is null for job with id: ${job.id}");
      }
    }

    highlightedDates.value = tempSet; // Update the reactive variable
  }

  ServiceProviderServices servicesService = ServiceProviderServices();
  Rx<bool> isLoading = false.obs;
  RxList<ProviderJobData> allJobList = <ProviderJobData>[].obs;
  @override
  void onInit() {
    // getProviderJOB();

    super.onInit();
    pagingController.addPageRequestListener((pageKey) {
      Future.microtask(() => getMyJob(pageKey));
    });
  }

  Future<void> getProviderJOB() async {
    List<ProviderJobData> list = <ProviderJobData>[];
    print("we are in get job");
    isLoading.value = true;
    var result = await servicesService.getAllProviderJob(1);
    print("Service result : $result");
    if (result["status"] == true) {
      isLoading.value = false;
      for (var data in result['data']["data"]) {
        print("Service List :: $data");
        list.add(ProviderJobData.fromJson(data));
      }

      allJobList.value = list;
      updateHighlightedDates();
    } else {
      isLoading.value = false;
    }
  }

  final PagingController<int, ProviderJobData> pagingController =
      PagingController(firstPageKey: 1);

  Future<void> getMyJob(int pageKey) async {
    try {
      isLoading.value = true;
      var result = await servicesService.getAllProviderJob(pageKey);
      isLoading.value = false;
      print("My Job Data $result");
      
      if (result['success'] == true) {
        final payload = result['payload'];
        final List<ProviderJobData> newItems = (payload['data'] as List? ?? [])
            .map((json) => ProviderJobData.fromJson(json))
            .toList();

        final isLastPage = payload['current_page'] == payload['last_page'];

        if (isLastPage) {
          pagingController.appendLastPage(newItems);
        } else {
          final nextPageKey = pageKey + 1;
          pagingController.appendPage(newItems, nextPageKey);
        }
        updateHighlightedDates();
      } else {
        pagingController.error = Exception(result['message'] ?? 'Failed to fetch services');
      }
    } catch (error) {
      isLoading.value = false;
      print("Error fetching jobs: $error");
      pagingController.error = 'Failed to fetch jobs: ${error.toString()}';
    }
  }

  Future<void> deleteUser() async {
    try {
      isLoading(true);
      var userId = await Preferences.getUserID();
      var userToken = await Preferences.getToken();
      // Making the HTTP POST request
      final response = await http.delete(
        Uri.parse(AppUrls.deleteUser),
        headers: getHeader(userToken: userToken),
      );
      print(response.body);
      // Handling the response
      if (response.statusCode == 200) {
        AppUtils.getSnackBar('Success', 'User deleted successfully');
        Get.offAll(const LoginScreen());
      } else if (response.statusCode == 404) {
        AppUtils.errorSnackBar('Error', 'User not found');
      } else if (response.statusCode == 500) {
        AppUtils.errorSnackBar('Error', 'Server error, please try again later');
      } else {
        AppUtils.errorSnackBar('Error', 'Unexpected error occurred');
      }
    } catch (error) {
      // Error handling for network or other issues
      print(error);
      rethrow;
      AppUtils.errorSnackBar('Error', 'Failed to delete user: $error');
    } finally {
      isLoading(false);
    }
  }
}
