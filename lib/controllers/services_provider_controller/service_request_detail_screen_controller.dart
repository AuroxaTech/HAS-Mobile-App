import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/service_provider_model/service_request_model.dart';
import '../../services/property_services/add_services.dart';
import '../../utils/utils.dart';

class ServiceRequestDetailScreenController extends GetxController {
  final sheet = GlobalKey();
  final controller = DraggableScrollableController();

  final PageController pageController = PageController();
  ServiceProviderServices serviceRequestService = ServiceProviderServices();
  Rx<bool> isLoading = false.obs;
  Rx<ServiceRequestProvider?> getServiceRequestOne =
      Rx<ServiceRequestProvider?>(null);

  List<String> images = [];
  RxInt id = 0.obs;
  @override
  void onInit() {
    var data = Get.arguments;
    print("IDDDDDD $data");
    print("Hello");
    id.value = data;
    getServiceRequest(id: data);
    super.onInit();
  }

  Future<void> getServiceRequest({required int id}) async {
    print("we are in get service");
    isLoading.value = true;
    var result = await serviceRequestService.getServiceRequest(id: id);
    print("Service Result : $result");

    isLoading.value = false;

    if (result['data'] != null && result['data'] is Map) {
      var data = result['data'] as Map<String, dynamic>;
      print("Data :: $data");
      print("User Data :: ${data['user']}");

      getServiceRequestOne.value = ServiceRequestProvider.fromJson(data);
      String imagesString = getServiceRequestOne.value!.serviceImages == null
          ? ""
          : getServiceRequestOne.value!.serviceImages.toString();
      List<String> imageList = imagesString.split(',');
      images = imageList;
      isLoading.value = false;
      // selectedBathrooms.value = int.parse(getPropertyOne.value!.bathroom);
      // selectedBedroom.value = int.parse(getPropertyOne.value!.bedroom);
      // selectedArea.value = int.parse(getPropertyOne.value!.areaRange);
    } else {
      isLoading.value = false;
      print("Invalid or null data format");
      // Handle other cases if necessary
    }
  }

  Future<void> declineServiceRequest({required int requestId}) async {
    isLoading.value = true;

    try {
      var result = await serviceRequestService.declineServiceRequest(
          requestId: requestId);
      print(result);
      if (result['status'] == true) {
        Get.back();
        Get.back();
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

  Future<void> acceptServiceRequest({
    required String userId,
    required String providerId,
    required int requestId,
  }) async {
    isLoading.value = true;

    try {
      var result = await serviceRequestService.acceptServiceRequest(
        userid: userId,
        providerId: providerId,
        requestId: requestId,
      );
      print(result);
      if (result['status'] == true) {
        Get.back();
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
