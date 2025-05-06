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
    id.value = data;
    getJobRequest(id: data);
    super.onInit();
  }

  Future<void> getJobRequest({required int? id}) async {
    try {
      isLoading.value = true;
      var result = await serviceRequestService.getServiceJob(id: id);
      print("Raw API Response: $result");

      if (result['success'] == true && result['payload'] != null) {
        final data = result['payload'];
        if (data is Map<String, dynamic>) {
          print("Processing data: $data");
          getServiceRequestOne.value = CalendarData.fromJson(data);
          
          // Handle service images if any
          if (getServiceRequestOne.value?.serviceImages != null && 
              getServiceRequestOne.value!.serviceImages.isNotEmpty) {
            
            // Extract image paths from service images
            images = [];
            // for (var imageData in getServiceRequestOne.value!.serviceImages) {
            //   if (imageData is Map<String, dynamic> && imageData.containsKey('image_path')) {
            //     String imagePath = imageData['image_path'].toString();
            //     if (imagePath.isNotEmpty) {
            //       images.add(imagePath);
            //     }
            //   } else if (imageData is String && imageData.isNotEmpty) {
            //     images.add(imageData);
            //   }
            // }
            
            print("Loaded ${images.length} images: $images");
          } else {
            print("No service images found");
            images = [];
          }
        } else {
          print("Unexpected data format: ${data.runtimeType}");
          getServiceRequestOne.value = null;
        }
      } else {
        print("Invalid response format or no data");
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
    try {
      isLoading.value = true;
      var result = await serviceRequestService.deleteService(id: id);
      print("Service Result : $result");

      if (result['success'] == true) {
        isLoading.value = false;
        Get.back();
        Get.back();
        Get.back();
        AppUtils.getSnackBar("Delete", result['messages']);
      } else {
        isLoading.value = false;
        AppUtils.getSnackBar("Error", result['messages']);
      }
    } catch (e) {
      isLoading.value = false;
      AppUtils.errorSnackBar("Error", "Failed to delete service: ${e.toString()}");
    }
  }
}
