import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:property_app/controllers/stripe_payment_controller/stripe_payment_controller.dart';
import 'package:property_app/models/propert_model/service_job_status.dart';
import 'package:property_app/services/property_services/add_services.dart';
import 'package:property_app/utils/api_urls.dart';
import 'package:property_app/utils/shared_preferences/preferences.dart';
import 'package:property_app/utils/utils.dart';

import '../../constant_widget/constant_widgets.dart';

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
        var jobData = result[
            'payload']; // Adjust based on actual API response, assuming 'job' key
        if (jobData != null && jobData is Map<String, dynamic>) {
          getServiceRequestOne.value =
              Job.fromJson(jobData); // Parse directly into Job model
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

  Future<bool> acceptServiceRequest({int? jobId, String? status}) async {
    isLoading.value = true;
    try {
      var token = await Preferences.getToken();
      Uri url = Uri.parse("${AppUrls.markCompleteRequest}/$jobId/status");
      final response = await http.post(
        url,
        body: json.encode({
          //  "job_id": jobId,
          "status": status,
        }),
        headers: getHeader(userToken: token),
      );

      print("Mark Complete Response ==> ${response.body}");
      print("HEADERS ${response.headers}");
      print("Status Code ${response.statusCode}");

      if (response.statusCode == 200) {
        isLoading.value = false;
        var data = jsonDecode(response.body);
        if (data['success'] == true) {
          AppUtils.getSnackBar("Success", data['message']);
          return true;
        } else {
          AppUtils.errorSnackBar("Error", data['message']);
          return false;
        }
      } else {
        isLoading.value = false;
        AppUtils.errorSnackBar("Error", "Something went wrong");
        return false;
      }
    } catch (e) {
      isLoading.value = false;
      AppUtils.errorSnackBar("Error", e.toString());
      return false;
    }
  }

  void prepareForPayment(Job jobDetail) {
    // Initialize the payment controller with job details
    final paymentController = Get.find<StripePaymentScreenController>();
    paymentController.initializePaymentDetails(
      serviceId: jobDetail.serviceId,
      serviceProviderId: jobDetail.providerId ?? 0,
      price: double.tryParse(jobDetail.pricing ?? '0.0') ?? 0.0,
    );
  }

  // You can remove or deprecate this method if it's no longer needed
  Future<void> makePayment({String? amount, String? serviceId}) async {
    // This method is now deprecated as we're using the new payment flow
    print("This method is deprecated. Using new payment flow instead.");
  }
}
