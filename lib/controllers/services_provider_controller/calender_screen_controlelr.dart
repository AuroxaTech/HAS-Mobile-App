import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../models/service_provider_model/provider_job.dart';
import '../../models/service_provider_model/rating.dart';
import '../../services/property_services/add_services.dart';

class CalendarScreenController extends GetxController{
  Rx<CalendarFormat> calendarFormat = CalendarFormat.month.obs;
  Rx<DateTime> focusedDay = DateTime.now().obs;
  Rx<DateTime> selectedDay = DateTime.now().obs;
  Rx<DateTime> kToday = DateTime.now().obs;
  final GlobalKey<ScaffoldState> key = GlobalKey();
  RxSet<DateTime> highlightedDates = <DateTime>{}.obs;
  void updateHighlightedDates() {
    Set<DateTime> tempSet = {};
    for (var job in pagingController.itemList!) { // Assuming allJobList is your list of jobs
      String createdAtStr = job.createdAt.toString(); // Get the date string
      DateTime parsedDate = DateTime.parse(createdAtStr);
      DateTime dateWithoutTime = DateTime(parsedDate.year, parsedDate.month, parsedDate.day);
      tempSet.add(dateWithoutTime); // Add the date to the set
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
      Future.microtask(() =>  getMyJob(pageKey));
    });
  }

  Future<void> getProviderJOB() async {
    List<ProviderJobData>  list  = <ProviderJobData>[];
    print("we are in get job");
    isLoading.value = true;
    var result = await servicesService.getAllProviderJob(1);
    print("Service result : $result" );
    if(result["status"] == true ){
      isLoading.value = false;
      for (var data in result['data']["data"]) {
        print("Service List :: $data");
        list.add(ProviderJobData.fromJson(data));
      }

      allJobList.value = list;
      updateHighlightedDates();
    }else{
      isLoading.value = false;
    }

  }



  final PagingController<int, ProviderJobData> pagingController = PagingController(firstPageKey: 1);


  Future<void> getMyJob(int pageKey) async {
    try {
      isLoading.value = true;
      var result = await servicesService.getAllProviderJob(pageKey);
      isLoading.value = false;
      print("My Job Data $result");
      if (result['status'] == true) {
        final List<ProviderJobData> newItems = (result['data']['data'] as List)
            .map((json) => ProviderJobData.fromJson(json))
            .toList();

        final isLastPage = result['data']['current_page'] == result['data']['last_page'];

        if (isLastPage) {
          pagingController.appendLastPage(newItems);
        } else {
          final nextPageKey = pageKey + 1;
          pagingController.appendPage(newItems, nextPageKey);
        }
        updateHighlightedDates();
      } else {
        pagingController.error = Exception('Failed to fetch services');
      }

    } catch (error) {
      isLoading.value = false;
      print(error);

      final errorMessage = error.toString();
      pagingController.error = errorMessage;
      rethrow;
    }
  }




}