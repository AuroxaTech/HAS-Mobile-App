import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_app/services/auth_services/auth_services.dart';
import 'package:property_app/utils/shared_preferences/preferences.dart';

import '../../constant_widget/constant_widgets.dart';
import '../../models/authentication_model/user_state_model.dart';
import 'package:http/http.dart' as http;

import '../../utils/api_urls.dart';
import '../../utils/utils.dart';
import '../../views/authentication_screens/login_screen.dart';

class ServiceProviderController extends GetxController {
  RxBool isLoading = false.obs;
  AuthServices authServices = AuthServices();
  final GlobalKey<ScaffoldState> key = GlobalKey();
  Rx<Provider?> getServiceOne = Rx<Provider?>(null);

  @override
  void onInit() {
    getUserState();
    super.onInit();
  }

  Future<void> getUserState() async {
    try {
      print("Getting service for user ID: ${await Preferences.getUserID()}");
      isLoading.value = true;

      var result = await authServices.getUserState();
      print("Service Result : $result");

      if (result['status'] == "Unauthorized") {
        Get.snackbar("Profile Status", result['message'] ?? "Your profile is not approved.");
        isLoading.value = false;
        return;
      }

      if (result['data'] != null && result['data'] is Map) {
        var data = result['data'] as Map<String, dynamic>;
        print("Data received: $data");

        if (data.containsKey('serviceprovider')) {
          getServiceOne.value = Provider.fromJson(data);
        } else {
          getServiceOne.value = null;
        }
      } else {
        getServiceOne.value = null;
      }
    } catch (e) {
      print("Error in getUserState: $e");
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> deleteUser() async {
    try {
      isLoading(true);
      var userId = await Preferences.getUserID();
      var userToken = await Preferences.getToken();
      // Making the HTTP DELETE request
      final response = await http.delete(
        Uri.parse(AppUrls.deleteUser),
        headers: getHeader(userToken: userToken),
      );
      print(response.body);
      // Handling the response
      if (response.statusCode == 200) {
        AppUtils.getSnackBar('Success', 'User deleted successfully');
        Get.offAll(const LoginScreen());
      } else if (response.statusCode == 404) {
        AppUtils.errorSnackBar('Error', 'User not found');
      } else if (response.statusCode == 500) {
        AppUtils.errorSnackBar('Error', 'Server error, please try again later');
      } else {
        AppUtils.errorSnackBar('Error', 'Unexpected error occurred');
      }
    } catch (error) {
      // Error handling for network or other issues
      print(error);
      rethrow;
      AppUtils.errorSnackBar('Error', 'Failed to delete user: $error');
    } finally {
      isLoading(false);
    }
  }
}
