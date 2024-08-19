import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_app/models/stat_models/visitor_stat.dart';

import '../../constant_widget/constant_widgets.dart';
import '../../models/stat_models/tenant_stat.dart';
import '../../services/auth_services/auth_services.dart';
import '../../utils/api_urls.dart';
import '../../utils/shared_preferences/preferences.dart';
import 'package:http/http.dart' as http;

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
    print("we are in get land stat");
    print("we are in get${await Preferences.getUserID()}");
    isLoading.value = true;
    print(await Preferences.getUserID());
    var result = await authServices.getVisitorState();
    print("Service Result : $result");

    isLoading.value = false;

    if (result['data'] != null && result['data'] is Map) {
      var data = result['data'] as Map<String, dynamic>;
      print("Data :: $data");

      if (getVisitor != null) {
        getVisitor.value = VisitorData.fromJson(data);

        print("Tenant value ${getVisitor.value!.visitor.user}");
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