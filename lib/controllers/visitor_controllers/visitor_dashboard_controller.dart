import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:property_app/models/stat_models/visitor_stat.dart';

import '../../constant_widget/constant_widgets.dart';
import '../../services/auth_services/auth_services.dart';
import '../../utils/api_urls.dart';
import '../../utils/base_api_service.dart';
import '../../utils/shared_preferences/preferences.dart';
import '../../utils/utils.dart';
import '../../views/authentication_screens/login_screen.dart';

class VisitorDashboardController extends GetxController {
  final GlobalKey<ScaffoldState> key = GlobalKey();

  @override
  void onInit() {
    super.onInit();
    getVisitorState();
  }

  RxBool isLoading = false.obs;
  AuthServices authServices = AuthServices();
  Rx<VisitorData?> getVisitor = Rx<VisitorData?>(null);

  Future<void> getVisitorState() async {
    try {
      isLoading.value = true;
      var result = await authServices.getVisitorState();
      print("Service Result : $result");

      if (result['success'] == true && result['payload'] != null) {
        final payload = result['payload'];
        
        // Create VisitorData from the new response format
        final data = {
          'visitor': payload['visitor'],
          'pending_job': payload['pending_job'] ?? 0,
          'total_spend': payload['total_spend'] ?? "0",
          'total_favorite': payload['total_favorite'] ?? 0,
        };

        getVisitor.value = VisitorData.fromJson(data);
        print("Visitor data loaded successfully");
      } else {
        print("Invalid response format: ${result['message']}");
        AppUtils.errorSnackBar("Error", "Failed to load visitor data");
      }
    } catch (e) {
      print("Error loading visitor state: $e");
      String errorMessage = "Failed to load visitor data";
      
      if (e is ApiException) {
        errorMessage = e.message;
      }
      
      AppUtils.errorSnackBar("Error", errorMessage);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteUser() async {
    try {
      isLoading(true);
      var userId = await Preferences.getUserID();
      var userToken = await Preferences.getToken();
      // Making the HTTP POST request
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
