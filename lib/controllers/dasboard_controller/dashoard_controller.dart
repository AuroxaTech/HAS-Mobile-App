import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:property_app/constant_widget/constant_widgets.dart';
import 'package:property_app/utils/utils.dart';
import 'package:property_app/views/authentication_screens/login_screen.dart';
import '../../models/stat_models/landlord_stat.dart';
import '../../services/auth_services/auth_services.dart';
import '../../utils/shared_preferences/preferences.dart';

class DashboardController extends GetxController with GetSingleTickerProviderStateMixin  {
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
    print("we are in get land stat");
    print("we are in get${await Preferences.getUserID()}");
    isLoading.value = true;
    print(await Preferences.getUserID());
    var result = await authServices.getLandLordState();
    print("Service Result : $result");

    isLoading.value = false;

    if (result['data'] != null && result['data'] is Map) {
      var data = result['data'] as Map<String, dynamic>;
      print("Data :: $data");

      if (getLandlord != null) {
        getLandlord.value = LandLordData.fromJson(data);

        print("landlord value ${getLandlord.value!.landlord.user}");
      } else {
        isLoading.value = false;
        print("getServiceOne is null");
      }
    } else {
      isLoading.value = false;
      print("Invalid or null data format");
    }
  }

  Future<void> deleteUser() async {
    const url = 'https://haservices.ca:8080/user/delete';
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