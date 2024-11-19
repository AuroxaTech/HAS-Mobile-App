import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/service_provider_model/calendar_service.dart';
import '../../route_management/constant_routes.dart';
import '../../services/property_services/add_services.dart';
import '../../utils/utils.dart';

class JobDetailController extends GetxController {
  final sheet = GlobalKey();
  final controller = DraggableScrollableController();

  final PageController pageController = PageController();
  ServiceProviderServices serviceRequestService = ServiceProviderServices();
  Rx<bool> isLoading = false.obs;
  Rx<CalendarData?> getServiceRequestOne = Rx<CalendarData?>(null);

  List<String> images = [];

  RxInt id = 0.obs;
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
      print("Service Result : ${result['data']}");

      if (result['data'] != null) {
        if (result['data'] is Map) {
          var data = result['data'];
          print("Data :: $data");
          getServiceRequestOne.value = CalendarData.fromJson(data);

          if (getServiceRequestOne.value!.request.service != null) {
            String imagesString =
                getServiceRequestOne.value!.request.service!.media.toString();
            List<String> imageList = imagesString.split(',');
            images = imageList;
          } else {
            print("Service media is null");
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

  Future<void> acceptServiceRequest({
    required int? jobId,
    required int? status,
  }) async {
    isLoading.value = true;

    try {
      var result = await serviceRequestService.markJobCompleteRequest(
        jobId: jobId,
        status: status,
      );
      print(result);
      if (result['status'] == true) {
        await Get.toNamed(kRateExperienceScreen, arguments: jobId);
        AppUtils.getSnackBar("Success", result['message']);
      } else {
        AppUtils.errorSnackBar("Error", result['message']);
      }
    } catch (e) {
      // Get.back();
      print(e);
      AppUtils.errorSnackBar("Error", "Failed request");
    } finally {
      // Get.back();
      isLoading.value = false;
    }
  }
}
