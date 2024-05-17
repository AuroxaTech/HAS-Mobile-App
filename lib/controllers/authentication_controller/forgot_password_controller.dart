import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:property_app/utils/api_urls.dart';
import 'package:property_app/utils/utils.dart';
class ForgotPasswordController extends GetxController{
  var emailController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  RxBool isLoading = false.obs;

  void sendPasswordResetEmail(email) async {
    try {
      isLoading.value = true;
      final response = await http.post(
        Uri.parse(AppUrls.forgotPassword),
        body: json.encode({'email': emailController.text}),
        headers: {
          "Content-Type" : "application/json"
        }
      );
      if (response.statusCode == 200) {
        // Handle success
        var jsonData = jsonDecode(response.body);
        Get.back();
        isLoading.value = false;
        AppUtils.getSnackBar("Success", "${jsonData["message"]}");

      } else {
        // Handle error
        isLoading.value = false;
        var jsonData = jsonDecode(response.body);
        AppUtils.errorSnackBar("Error", "${jsonData["message"]}");
      }
    } catch (e) {
      isLoading.value = false;
      AppUtils.errorSnackBar("Error", "An error occurred");
      rethrow;
    }
  }

}