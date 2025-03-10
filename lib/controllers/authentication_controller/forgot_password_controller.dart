import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:property_app/utils/api_urls.dart';
import 'package:property_app/utils/utils.dart';
import '../../utils/base_api_service.dart';
import '../../utils/connectivity.dart';

class ForgotPasswordController extends GetxController {
  var emailController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  RxBool isLoading = false.obs;

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      // Check internet connectivity
      final hasInternet = await ConnectivityUtility.checkInternetConnectivity();
      if (!hasInternet) {
        AppUtils.getSnackBarNoInternet();
        return;
      }

      isLoading.value = true;

      final url = Uri.parse(AppUrls.forgotPassword);
      
      // Prepare headers
      final headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      };

      // Prepare body
      final body = json.encode({'email': email});

      // Log request
      BaseApiService.logRequest(url.toString(), 'POST', headers, {'email': email});

      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      // Log response
      BaseApiService.logResponse(url.toString(), response.statusCode, response.body);

      // Check if response is HTML
      if (response.body.trim().startsWith('<!DOCTYPE html>')) {
        throw ApiException('Server returned HTML instead of JSON. Please try again.');
      }

      final decodedResponse = json.decode(response.body);

      if (decodedResponse['success'] == true) {
        Get.back();
        AppUtils.getSnackBar("Success", decodedResponse["message"] ?? "Password reset link sent successfully");
      } else {
        AppUtils.errorSnackBar("Error", decodedResponse["message"] ?? "Failed to send reset link");
      }
    } catch (e) {
      print("Error in sendPasswordResetEmail: $e");
      String errorMessage = "An error occurred while processing your request";
      
      if (e is ApiException) {
        errorMessage = e.message;
      } else if (e is FormatException) {
        errorMessage = "Invalid response format from server";
      }
      
      AppUtils.errorSnackBar("Error", errorMessage);
    } finally {
      isLoading.value = false;
    }
  }
}