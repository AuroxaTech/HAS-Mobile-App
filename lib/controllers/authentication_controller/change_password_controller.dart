import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:property_app/utils/utils.dart';

import '../../constant_widget/constant_widgets.dart';
import '../../models/authentication_model/user_model.dart';
import '../../utils/api_urls.dart';
import '../../utils/shared_preferences/preferences.dart';
import 'package:http/http.dart' as http;
class ChangePasswordController extends GetxController {

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  var currentPassword = TextEditingController();
  var newPassword = TextEditingController();
  var confirmPassword = TextEditingController();

  RxBool isLoading = false.obs;

  Future<void> updateDataAndImage({
    required String currentPassword,
    required String password,
    required String conPassword,
  }) async {
    isLoading.value = true;
    var uri = Uri.parse(AppUrls.updatePassword); // Replace with your API endpoint
    var token = await Preferences.getToken();
    try {
      var response = await http.post(uri,
        headers: {
          "Authorization" : "Bearer $token",
          "Content-Type": "application/json", // Ensure to set content type to application/json
        },
        body: json.encode({
          'current_password': currentPassword, // Corrected field name and value
          'password': password, // Corrected value
          'password_confirmation': conPassword, // Corrected field name and value
        }),
      );

      if (response.statusCode == 200) {
        isLoading.value = false;
        var jsonData =  jsonDecode(response.body);
        Get.back();
        AppUtils.getSnackBar("Success", jsonData["messages"]);
      } else {
        isLoading.value = false;
        var jsonData =  jsonDecode(response.body);
        AppUtils.errorSnackBar("Error", "${jsonData["messages"]}");

        print('Failed to upload with status code $jsonData}');
      }
    } catch (e) {
      isLoading.value = false;
      print('An error occurred: $e');
      rethrow;
    }
  }

}