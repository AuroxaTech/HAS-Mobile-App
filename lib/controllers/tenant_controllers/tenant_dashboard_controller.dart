import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:property_app/models/stat_models/tenant_stat.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constant_widget/constant_widgets.dart';
import '../../route_management/constant_routes.dart';
import '../../services/auth_services/auth_services.dart';
import '../../utils/api_urls.dart';
import '../../utils/base_api_service.dart';
import '../../utils/shared_preferences/preferences.dart';
import '../../utils/utils.dart';

class TenantDashboardController extends GetxController {
  final GlobalKey<ScaffoldState> key = GlobalKey();
  @override
  void onInit() {
    super.onInit();
    getTenantState();
  }

  RxBool isLoading = false.obs;
  AuthServices authServices = AuthServices();
  Rx<TenantData?> getTenant = Rx<TenantData?>(null);

  Future<void> getTenantState() async {
    try {
      isLoading.value = true;
      var result = await authServices.getTenantState();

      if (result['success'] == true && result['payload'] != null) {
        final payload = result['payload'];
        final data = {
          'tenant': payload['tenant'],
          'pending_contract': payload['pending_contract'] ?? 0,
          'total_rented': payload['total_rented'] ?? 0,
          'total_spend': payload['total_spend'] ?? "0",
          'properties': payload['properties'] ?? []
        };

        getTenant.value = TenantData.fromJson(data);
        print("Tenant data loaded successfully");
      } else {
        print("Invalid response format: ${result['message']}");
        AppUtils.errorSnackBar("Error", "Failed to load dashboard data");
      }
    } catch (e) {
      print("Error loading tenant state: $e");
      String errorMessage = "Failed to load dashboard data";

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
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.remove("token");
        await prefs.remove("role");
        await prefs.remove("user_id");
        Get.offAllNamed(kLoginScreen);
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
