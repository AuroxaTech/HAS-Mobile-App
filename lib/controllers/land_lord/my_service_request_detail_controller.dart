import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/service_provider_model/calendar_service.dart';
import '../../services/property_services/add_services.dart';
import '../../utils/utils.dart';

class MyServiceRequestDetailController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final sheet = GlobalKey();
  final controller = DraggableScrollableController();
  final PageController pageController = PageController();
  ServiceProviderServices serviceRequestService = ServiceProviderServices();
  Rx<bool> isLoading = false.obs;
  Rx<CalendarData?> getServiceRequestOne = Rx<CalendarData?>(null);
  RxInt id = 0.obs;
  List<String> images = [];

  @override
  void onInit() {
    var data = Get.arguments;
    print("IDDDDDD $data");
    print("Hello");
    id.value = data;
    getJobRequest(id: data);
    super.onInit();
  }

  Future<void> getJobRequest({required int? id}) async {
    print("we are in get service");
    isLoading.value = true;

    try {
      var result = await serviceRequestService.getServiceJob(id: id);
      print("Raw API Response: $result");

      // Handle case where result or result['data'] is null or empty
      if (result == null ||
          result['data'] == null ||
          (result['data'] is List && (result['data'] as List).isEmpty)) {
        print("No data returned from API");
        getServiceRequestOne.value = null;
        isLoading.value = false;
        return;
      }

      // If data is a List but not empty, take first item
      var data = result['data'];
      if (data is List && data.isNotEmpty) {
        data = data[0];
      }

      if (data is Map<String, dynamic>) {
        print("Processing data: $data");
        getServiceRequestOne.value = CalendarData.fromJson(data);

        if (getServiceRequestOne.value?.request.service?.media != null) {
          String imagesString =
              getServiceRequestOne.value!.request.service!.media.toString();
          images = imagesString
              .split(',')
              .where((s) => s.trim().isNotEmpty)
              .toList();
          print("Loaded ${images.length} images");
        } else {
          print("No media found in service data");
          images = [];
        }
      } else {
        print("Unexpected data format: ${data.runtimeType}");
        getServiceRequestOne.value = null;
      }
    } catch (e, stackTrace) {
      print("Error fetching service request: $e");
      print("Stack trace: $stackTrace");
      getServiceRequestOne.value = null;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteService({required int id}) async {
    print("we are in delete service");
    isLoading.value = true;
    var result = await serviceRequestService.deleteService(id: id);
    print("Service Result : $result");

    isLoading.value = false;

    if (result['status'] == true) {
      isLoading.value = false;
      Get.back();
      Get.back();
      Get.back();
      AppUtils.getSnackBar("Delete", result['messages']);
    } else {
      isLoading.value = false;
      print("getPropertyOne is null");
      AppUtils.getSnackBar("Error", result['messages']);
    }
    isLoading.value = false;
  }
}
