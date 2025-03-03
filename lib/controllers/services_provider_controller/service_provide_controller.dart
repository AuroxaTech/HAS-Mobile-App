import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:property_app/services/auth_services/auth_services.dart';
import 'package:property_app/utils/shared_preferences/preferences.dart';

import '../../constant_widget/constant_widgets.dart';
import '../../models/authentication_model/user_state_model.dart';
import '../../utils/api_urls.dart';
import '../../utils/base_api_service.dart';
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

      if (result['success'] == true && result['payload'] != null) {
        final payload = result['payload'];
        
        // Create a Provider object with the new response format
        final provider = Provider(
          user: User.fromJson(payload['user']),
          services: (payload['services'] as List<dynamic>)
              .map((x) => ServiceData.fromJson(x))
              .toList(),
          totalService: payload['services']?.length ?? 0,
          totalJobs: payload['total_jobs'] ?? 0,
          totalPrice: payload['total_price'] ?? 0,
          rate: payload['rate'] ?? 0,
        );
        
        getServiceOne.value = provider;
        print("Service provider data loaded successfully");
      } else {
        print("Invalid response format: ${result['message']}");
        AppUtils.errorSnackBar("Error", "Failed to load profile data");
      }
    } catch (e) {
      print("Error loading service provider state: $e");
      String errorMessage = "Failed to load profile data";
      
      if (e is ApiException) {
        errorMessage = e.message;
      }
      
      AppUtils.errorSnackBar("Error", errorMessage);
    } finally {
      isLoading.value = false;
    }
  }

  // Future<void> getUserState() async {
  //   try {
  //     isLoading.value = true;
  //     var result = await authServices.getUserState();
  //     print("Service Result : $result");
  //
  //     if (result['success'] == true && result['payload'] != null) {
  //       final payload = result['payload'];
  //       getServiceOne.value = Provider.fromJson(payload);
  //       print("Service provider data loaded successfully");
  //     } else {
  //       print("Invalid response format: ${result['message']}");
  //       AppUtils.errorSnackBar("Error", "Failed to load profile data");
  //     }
  //   } catch (e) {
  //     print("Error loading service provider state: $e");
  //     String errorMessage = "Failed to load profile data";
  //
  //     if (e is ApiException) {
  //       errorMessage = e.message;
  //     }
  //
  //     AppUtils.errorSnackBar("Error", errorMessage);
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

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
