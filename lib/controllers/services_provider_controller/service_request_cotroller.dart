import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:property_app/models/service_provider_model/service_request_model.dart';
import 'package:property_app/utils/utils.dart';

import '../../models/service_provider_model/get_services.dart';
import '../../models/service_provider_model/provider_job.dart';
import '../../services/property_services/add_services.dart';
import '../../utils/shared_preferences/preferences.dart';

class ServiceRequestController extends GetxController{
  ServiceProviderServices servicesService = ServiceProviderServices();
  Rx<bool> isLoading = false.obs;
  RxList<ServiceRequestProvider> getServicesRequestList = <ServiceRequestProvider>[].obs;

  @override
  void onInit() {
    var data = Get.arguments;
    print("IDDDDDD $data");
    print("Hello");
    //getServicesRequest();
    pagingController.addPageRequestListener((pageKey) {
      Future.microtask(() => getServicesRequests(pageKey));
    });
    super.onInit();
  }

  final PagingController<int, ServiceRequestProvider> pagingController = PagingController(firstPageKey: 1);


  Future<void> getServicesRequests(int pageKey) async {
    try {
      isLoading.value = true;
      var result = await servicesService.getServiceProviderRequest(page: pageKey);
      isLoading.value = false;
      print("My JOB REQUEST Data $result");
      if (result['status'] == true) {
        final List<ServiceRequestProvider> newItems = (result['data']['data'] as List)
            .map((json) => ServiceRequestProvider.fromJson(json))
            .toList();

        final isLastPage = result['data']['current_page'] == result['data']['last_page'];

        if (isLastPage) {
          pagingController.appendLastPage(newItems);
        } else {
          final nextPageKey = pageKey + 1;
          pagingController.appendPage(newItems, nextPageKey);
        }
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


  Future<void> getServicesRequest() async {
    List<ServiceRequestProvider>  list  = <ServiceRequestProvider>[];
    print("we are in get services");
    isLoading.value = true;
    var id = await Preferences.getUserID();
    var result = await servicesService.getServiceProviderRequest(page: id);
    print("Service result : $result" );
    if(result["status"] == true){
      isLoading.value = false;
      var serviceRequests = result['data']['data'] as List;
      for (var data in serviceRequests) {
        print("Service List :: $data");

        list.add(ServiceRequestProvider.fromJson(data));
      }
      getServicesRequestList.value = list;
    }else {
      isLoading.value = false;
    }
  }

  Future<void> declineServiceRequest({required int requestId}) async {
    isLoading.value = true;
    try {
      var result = await servicesService.declineServiceRequest(
           requestId: requestId);
      print(result);
      if (result['status'] == true) {
        Get.back();
        AppUtils.getSnackBar("Success", result['message']);
      } else {
        AppUtils.errorSnackBar("Error", result['message']);
      }
    } catch (e) {
      // Handle general errors
      print(e);
      AppUtils.errorSnackBar("Error", "Failed to decline service request");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> acceptServiceRequest({ required String userId, required String providerId,
    required int requestId, }) async {
    isLoading.value = true;

    try {
      var result = await servicesService.acceptServiceRequest(
          userid: userId,
          providerId: providerId,
          requestId: requestId,
      );
      print(result);
     if (result['status'] == true) {
        Get.back();
        AppUtils.getSnackBar("Success", result['message']);
      } else {
        AppUtils.errorSnackBar("Error", result['message']);
      }
    } catch (e) {
     // Get.back();
      // Handle general errors
      print(e);
      AppUtils.errorSnackBar("Error", "Failed to decline service request");
    } finally {
     // Get.back();
      isLoading.value = false;
    }
  }

}