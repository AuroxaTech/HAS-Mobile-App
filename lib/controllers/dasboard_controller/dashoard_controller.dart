import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:property_app/constant_widget/constant_widgets.dart';
import 'package:property_app/route_management/constant_routes.dart';
import 'package:property_app/utils/api_urls.dart';
import 'package:property_app/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/stat_models/landlord_stat.dart';
import '../../services/auth_services/auth_services.dart';
import '../../utils/base_api_service.dart';
import '../../utils/shared_preferences/preferences.dart';

class DashboardController extends GetxController
    with GetSingleTickerProviderStateMixin {
  Rx<TabController?> tabController = Rx<TabController?>(null);
  final GlobalKey<ScaffoldState> key = GlobalKey();
  @override
  void onInit() {
    super.onInit();
    tabController.value = TabController(vsync: this, length: 3);
    getLandLordState();
  }

  RxBool isLoading = false.obs;
  AuthServices authServices = AuthServices();
  Rx<LandLordData?> getLandlord = Rx<LandLordData?>(null);

  Future<void> getLandLordState() async {
    try {
      isLoading.value = true;
      var result = await authServices.getLandLordState();

      if (result['success'] == true && result['payload'] != null) {
        final payload = result['payload'];
        final landlordData = {
          'landlord': {
            'id': payload['landlord']?['id'],
            'full_name': payload['landlord']?['full_name'],
            'email': payload['landlord']?['email'],
            'phone_number': payload['landlord']?['phone_number'],
            'profile_image': payload['landlord']?['profile_image'],
            'user': {
              'fullname': payload['landlord']?['full_name'],
              'profileimage': payload['landlord']?['profile_image'],
            },
          },
          'total_properties': payload['total_properties'],
          'pending_contract': payload['pending_contract'],
          'total_spend': payload['total_rent_income'],
        };

        getLandlord.value = LandLordData.fromJson(landlordData);
        print("Landlord data loaded successfully");
      } else {
        print("Invalid response format: ${result['message']}");
        AppUtils.errorSnackBar("Error", "Failed to load dashboard data");
      }
    } catch (e) {
      print("Error loading landlord state: $e");
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
    const url = AppUrls.deleteUser;
    try {
      isLoading(true);
      var userId = await Preferences.getUserID();
      var userToken = await Preferences.getToken();
      // Making the HTTP POST request
      final response = await http.delete(
        Uri.parse(url),
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
