import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/propert_model/service_job_status.dart';
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
  Rx<Job?> getServiceRequestOne = Rx<Job?>(null); // Using Job model

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
    print("Fetching job details for ID: $id");
    isLoading.value = true;
    try {
      var result = await serviceRequestService.getServiceJob(id: id);
      print("Job Detail API Result : ${result['payload']}"); // Log full payload

      if (result['success'] == true && result['payload'] != null) {
        // Assuming payload directly contains the Job data
        var jobData = result['payload']; // Adjust based on actual API response, assuming 'job' key
        if (jobData != null && jobData is Map<String, dynamic>) {
          getServiceRequestOne.value = Job.fromJson(jobData); // Parse directly into Job model
          print("Parsed Job Detail: ${getServiceRequestOne.value?.toJson()}");

          // if (getServiceRequestOne.value!.serviceImages != null) {
          //   images = getServiceRequestOne.value!.serviceImages.cast<String>().toList(); // Assuming serviceImages is already a list of URLs, cast to String
          //   print("Job Detail Images: ${images}");
          // } else {
          //   print("Service images are null");
          // }
        } else {
          print("Job data is null or not a Map");
        }
      } else {
        print("API Error: ${result['message']}");
      }
    } catch (e) {
      print("Exception in getJobRequest: $e");
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }
  Future<void> acceptServiceRequest({
    required int? jobId,
    required String status,
  }) async {
    isLoading.value = true;

    try {
      var result = await serviceRequestService.markJobCompleteRequest(
        jobId: jobId,
        status: status,
      );
      print("job response $result");
      if (result['success'] == true) {
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
