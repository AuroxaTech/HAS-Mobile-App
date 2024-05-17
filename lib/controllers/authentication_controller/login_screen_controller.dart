import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_app/services/auth_services/auth_services.dart';
import 'package:property_app/views/main_bottom_bar/main_bottom_bar.dart';
import 'package:property_app/views/main_bottom_bar/service_provider_bottom_ar.dart';
import 'package:property_app/views/main_bottom_bar/tenant_bottom_bar.dart';
import 'package:property_app/views/main_bottom_bar/visitor_bottom_bar.dart';
import 'package:property_app/views/tenant_profile/tenent_dashboard.dart';
import '../../services/notification_services/notification_services.dart';
import '../../utils/shared_preferences/preferences.dart';
import '../../utils/utils.dart';

class LoginScreenController extends GetxController{

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();
  RxBool passwordObscure = true.obs;
  NotificationServices notificationServices = NotificationServices();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  void onInit() {
    super.onInit();
    print("hello controller");
  }
  RxBool isLoading = false.obs;
  AuthServices authServices = AuthServices();
  Future<void> login(BuildContext context, String email, String password) async {
    isLoading.value = true;

    try {
      var deviceId = await notificationServices.getDeviceToken();
      print("deviceToken : $deviceId");

      var data = await authServices.login(
        email: email,
        password: password,
        deviceToken: deviceId,
        platform: Platform.isAndroid ? "android" : "ios",
      );

      //print("Response: ${response.toString()}"); // Log the full response

    //  var data = jsonDecode(response); // This might throw FormatException

      if (data['status'] == true) {
        // Setting user preferences
        Preferences.setToken(data["token"]);
        Preferences.setUserName(data["data"]["fullname"]);
        Preferences.setUserEmail(data["data"]["email"]);
        Preferences.setRoleID(data["data"]["role_id"]);
        Preferences.setUserID(data["data"]["id"]);
        // Navigation based on role
        navigateBasedOnRole(data["data"]["role_id"]);
        debugPrint(data["messages"]);
        isLoading.value = false;
        AppUtils.getSnackBar("Success", data["messages"]);
      } else {
        isLoading.value = false;
        handleErrorResponse(data['messages']);
      }
    } on FormatException catch (e) {
      isLoading.value = false;
      print("Response parsing error: $e");
      AppUtils.errorSnackBar("Error", "Invalid server response. Please try again.");
    } catch (e) {
      isLoading.value = false;
      print("Login error: $e");
      handleErrorResponse(e.toString());
      rethrow;
    }
  }

  void handleErrorResponse(String errorMessage) {
    if (errorMessage.toLowerCase().contains("server error")) {
      AppUtils.errorSnackBar("Server Error", "A server error occurred. Please try again later.");
    } else if (errorMessage.toLowerCase().contains("no input file specified")) {
      AppUtils.errorSnackBar("Not Found", "The requested resource was not found.");
    } else {
      AppUtils.errorSnackBar("Error", errorMessage);
    }
  }

  void navigateBasedOnRole(String roleId) {
    switch (roleId) {
      case "1":
        Get.offAll(() => const MainBottomBar());
        break;
      case "2":
        Get.offAll(() => const TenantBottomBar());
        break;
      case "3":
        Get.offAll(() => const ServiceProviderBottomBar());
        break;
      case "4":
        Get.offAll(() => const VisitorBottomBar());
        break;
    }
  }

}