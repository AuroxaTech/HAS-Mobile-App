import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/service_provider_model/calendar_service.dart';
import '../../services/property_services/add_services.dart';
import '../../utils/utils.dart';

class CalendarDetailController extends GetxController {
  final sheet = GlobalKey();
  final controller = DraggableScrollableController();
  late PageController pageController = PageController();
  ServiceProviderServices servicesService = ServiceProviderServices();
  Rx<bool> isLoading = false.obs;
  Rx<CalendarData?> getCalendarOne = Rx<CalendarData?>(null);
  RxInt id = 0.obs;
  @override
  void onInit() {
    pageController = PageController(initialPage: 0);
    var data = Get.arguments;
    print("IDDDDDD $data");
    print("Hello");
    id.value = data;
    getServiceJob(id: data);
    super.onInit();
  }

  List<String> images = [];

  Future<void> getServiceJob({required int id}) async {
    print("we are in get service");
    isLoading.value = true;

    try {
      var result = await servicesService.getServiceJob(id: id);
      print("Service Result : ${result['data']}");

      print("Type of result['data']: ${result['data']?.runtimeType}");

      if (result['data'] != null) {
        if (result['data'] is Map) {
          var data = result['data'];
          print("Data :: $data");
          getCalendarOne.value = CalendarData.fromJson(data);

          // Check if the necessary fields are not null
          if (getCalendarOne.value?.request?.service?.media != null) {
            String imagesString = getCalendarOne.value!.request.service!.media!;
            List<String> imageList = imagesString.split(',');
            images = imageList;
          } else {
            print("Media is null or not available");
          }
        } else {
          print("Data is not a Map");
        }
      } else {
        print("Data is null");
      }
    } catch (e) {
      print("Error fetching service request: $e");
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteService({required int id}) async {
    print("we are in delete service");
    isLoading.value = true;
    var result = await servicesService.deleteService(id: id);
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
      AppUtils.errorSnackBar("Error", result['messages']);
    }
    isLoading.value = false;
  }
}
