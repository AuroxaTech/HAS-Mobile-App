import 'dart:convert';

import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:property_app/models/propert_model/service_job_status.dart';
import 'package:property_app/utils/shared_preferences/preferences.dart';

import '../../models/service_provider_model/service_request_model.dart';
import '../../services/property_services/add_services.dart';

class JobScreenController extends GetxController {
  RxBool pending = true.obs;
  RxBool completed = false.obs;
  RxBool reject = false.obs;

  ServiceProviderServices servicesService = ServiceProviderServices();
  Rx<bool> isLoading = false.obs;
  RxList<ServiceRequestUser> getServicesRequestList =
      <ServiceRequestUser>[].obs;

  @override
  void onInit() {
    var data = Get.arguments;
    print("IDDDDDD $data");
    print("Hello");
    pendingJobController.addPageRequestListener((pageKey) {
      Future.microtask(() => getServiceJobs(pageKey));
    });
    super.onInit();
  }

  // Future<void> getServicesRequest() async {
  //   List<ServiceRequestUser> list = <ServiceRequestUser>[];
  //   print("we are in get services");
  //   isLoading.value = true;
  //   var id = await Preferences.getUserID();
  //   var result = await servicesService.getServiceUserRequest(userId: id);
  //   print("Service result : $result");
  //   if (result["status"] == true) {
  //     isLoading.value = false;
  //     for (var data in result['data']) {
  //       print("Service List :: $data");
  //       list.add(ServiceRequestUser.fromJson(data));
  //     }
  //     getServicesRequestList.value = list;
  //   } else {
  //     isLoading.value = false;
  //   }
  // }

  RxList<PendingJob> pendingJob = <PendingJob>[].obs;
  RxList<CompletedJob> completedJob = <CompletedJob>[].obs;
  RxList<RejectedJob> rejectedJob = <RejectedJob>[].obs;

  Future<void> getServiceJob() async {
    isLoading.value = true;
    try {
      var id = await Preferences.getUserID();
      var result = await servicesService.getMyJobs(userId: id, page: 1);
      print("result $result");
      if (result['status'] == true) {
        DataStatus providerFavorite = DataStatus.fromJson(result);
        print("Pending  ${providerFavorite.pendingJobs}");
        pendingJob.value = providerFavorite.pendingJobs;
        completedJob.value = providerFavorite.completedJobs;
        rejectedJob.value = providerFavorite.rejectedJobs;
      } else {
        print(result['message']);
      }
    } catch (e) {
      print(e);
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  final PagingController<int, PendingJob> pendingJobController =
      PagingController(firstPageKey: 1);
  final PagingController<int, CompletedJob> completedJobController =
      PagingController(firstPageKey: 1);
  final PagingController<int, RejectedJob> rejectedJobController =
      PagingController(firstPageKey: 1);

  // Future<void> getServiceJobs(int pageKey) async {
  //   isLoading.value = true;
  //   try {
  //     var id = await Preferences.getUserID();
  //     var result = await servicesService.getMyJobs(userId: id, page: pageKey);
  //     if (result['status'] == true) {
  //       var data = result['data'];
  //       print(data);
  //       // Parsing the entire data using DataStatus model
  //       DataStatus dataStatus = DataStatus.fromJson(data);
  //
  //       if (dataStatus.pendingJobsPagination.currentPage == dataStatus.pendingJobsPagination.lastPage) {
  //         pendingJobController.appendLastPage(dataStatus.pendingJobs);
  //       } else {
  //         pendingJobController.appendPage(dataStatus.pendingJobs, pageKey + 1);
  //       }
  //
  //       if (dataStatus.completedJobsPagination.currentPage == dataStatus.completedJobsPagination.lastPage) {
  //         completedJobController.appendLastPage(dataStatus.completedJobs);
  //       } else {
  //         completedJobController.appendPage(dataStatus.completedJobs, pageKey + 1);
  //       }
  //
  //       if (dataStatus.rejectedJobsPagination.currentPage == dataStatus.rejectedJobsPagination.lastPage) {
  //         rejectedJobController.appendLastPage(dataStatus.rejectedJobs);
  //       } else {
  //         rejectedJobController.appendPage(dataStatus.rejectedJobs, pageKey + 1);
  //       }
  //     } else {
  //       print(result['message']);
  //     }
  //   } catch (e) {
  //     print(e);
  //     pendingJobController.error = e;
  //     completedJobController.error = e;
  //     rejectedJobController.error = e;
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  Future<void> getServiceJobs(int pageKey) async {
    isLoading.value = true;
    try {
      var id = await Preferences.getUserID();
      var result = await servicesService.getMyJobs(userId: id, page: pageKey);

      // Log the response for debugging
      print("API Result: ${json.encode(result)}");

      if (result['success'] == true) {
        var data = result['payload']["data"];
        print("Data to be parsed: $data"); // Debugging line

        if (data is List) {
          // Convert list of JSON to DataStatus object properly
          List<DataStatus> dataList =
              data.map((json) => DataStatus.fromJson(json)).toList();

          for (var dataStatus in dataList) {
            updatePagination(pendingJobController, dataStatus.pendingJobs,
                dataStatus.pendingJobsPagination, pageKey);
            updatePagination(completedJobController, dataStatus.completedJobs,
                dataStatus.completedJobsPagination, pageKey);
            updatePagination(rejectedJobController, dataStatus.rejectedJobs,
                dataStatus.rejectedJobsPagination, pageKey);
          }
        } else if (data is Map<String, dynamic>) {
          DataStatus dataStatus = DataStatus.fromJson(data);

          updatePagination(pendingJobController, dataStatus.pendingJobs,
              dataStatus.pendingJobsPagination, pageKey);
          updatePagination(completedJobController, dataStatus.completedJobs,
              dataStatus.completedJobsPagination, pageKey);
          updatePagination(rejectedJobController, dataStatus.rejectedJobs,
              dataStatus.rejectedJobsPagination, pageKey);
        } else {
          print("Unexpected data format: $data");
        }
      } else {
        print("API Error: ${result['message']}");
      }
    } catch (e) {
      print("Exception during parsing or API call: $e");
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  void updatePagination<T>(PagingController<int, T> controller, List<T> jobs,
      Pagination pagination, int pageKey) {
    if (pagination.currentPage == pagination.lastPage) {
      controller.appendLastPage(jobs);
    } else {
      controller.appendPage(jobs, pageKey + 1);
    }
  }
}
