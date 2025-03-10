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
      Future.microtask(() => getServiceJobs(pageKey, "pending"));
    });
    super.onInit();
  }

  Future<void> getServicesRequest() async {
    List<ServiceRequestUser> list = <ServiceRequestUser>[];
    print("we are in get services");
    isLoading.value = true;
    var id = await Preferences.getUserID();
    var result = await servicesService.getServiceUserRequest(userId: id);
    print("Service result : $result");
    if (result["status"] == true) {
      isLoading.value = false;
      for (var data in result['data']) {
        print("Service List :: $data");
        list.add(ServiceRequestUser.fromJson(data));
      }
      getServicesRequestList.value = list;
    } else {
      isLoading.value = false;
    }
  }
  //x

  final PagingController<int, Job> pendingJobController = // Changed to Job
  PagingController(firstPageKey: 1);
  final PagingController<int, Job> completedJobController = // Changed to Job
  PagingController(firstPageKey: 1);
  final PagingController<int, Job> rejectedJobController = // Changed to Job
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

  Future<void> getServiceJobs(int pageKey, String status) async { // Added status parameter
    isLoading.value = true;
    try {
      var id = await Preferences.getUserID();
      var result = await servicesService.getMyJobs(userId: id, page: pageKey,); // Pass status to service
      print("API Result for $status jobs (page $pageKey): ${json.encode(result)}");

      if (result['success'] == true) {
        var payload = result['payload']; // Changed from data to payload
        print("Payload to be parsed for $status jobs: $payload");

        ServiceStatus serviceStatus = ServiceStatus.fromJson(result); // Parse the whole response

        JobsData jobsData;
        PagingController<int, Job>? currentController;

        switch (status) { // Determine which controller and JobsData to use based on status
          case 'pending':
            jobsData = serviceStatus.data.pendingJobs; // Access nested jobs data
            currentController = pendingJobController;
            break;
          case 'completed':
            jobsData = serviceStatus.data.completedJobs; // Access nested jobs data
            currentController = completedJobController;
            break;
          case 'rejected':
            jobsData = serviceStatus.data.rejectedJobs; // Access nested jobs data
            currentController = rejectedJobController;
            break;
          case 'accepted': // Handle accepted jobs
            jobsData = serviceStatus.data.acceptedJobs;
          //  currentController = acceptedJobController;
            break;
          case 'cancelled': // Handle cancelled jobs
            jobsData = serviceStatus.data.cancelledJobs;
          //  currentController = cancelledJobController;
            break;
          default:
            throw Exception('Unknown job status: $status');
        }

        updatePagination(currentController!, jobsData.data, jobsData.pagination, pageKey); // Pass jobsData.data and jobsData.pagination
      } else {
        print("API Error for $status jobs: ${result['message']}");
      }
    } catch (e) {
      print("Exception during parsing or API call for $status jobs: $e");
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
