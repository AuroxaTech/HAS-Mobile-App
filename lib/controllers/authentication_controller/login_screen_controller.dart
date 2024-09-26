import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
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
      // var deviceId;
      // if(Platform.isAndroid){
      //    deviceId = await notificationServices.getDeviceToken();
      // }else if(Platform.isIOS){
      //   deviceId = await notificationServices.getIOSDeviceToken();
      // }else if(Platform.isMacOS){
      //   deviceId = await notificationServices.getIOSDeviceToken();
      // }

      //print("deviceToken : $deviceId");

      var data = await authServices.login(
        email: email,
        password: password,
        deviceToken: "deviceId",
        platform: Platform.isAndroid ? "android" : "ios",
      );

      // Log the full response

      //  var data = jsonDecode(response); // This might throw FormatException

      if (data['status'] == true) {
        print("Response: ${data["data"]}");
        // Setting user preferences
        Preferences.setToken(data["token"]);
        Preferences.setUserName(data["data"]["fullname"]);
        Preferences.setUserEmail(data["data"]["email"]);
        Preferences.setRoleID(data["data"]["role_id"]);
        Preferences.setUserID(data["data"]["id"]);
        // Navigation based on role
        navigateBasedOnRole(data["data"]["role_id"]);
        debugPrint(data["messages"]);


        final FirebaseFirestore firestore = FirebaseFirestore.instance;
        CollectionReference users = firestore.collection('users');

        DocumentSnapshot docSnapshot = await users.doc(data["data"]["id"].toString()).get();

        if (docSnapshot.exists) {

          await users.doc(data["data"]["id"].toString()).update({
            'fullname': data["data"]["fullname"],
            'email': data["data"]["email"],
            "userId" : data["data"]["id"],
            'role_id': data["data"]["role_id"],
            "online" : true,
            'profileimage': data["data"]["profileimage"],
            'lastSeen': FieldValue.serverTimestamp(),
            "deviceToken" : "deviceId"
          });
          print("user updated");
        } else {
          await users.doc(data["data"]["id"].toString()).set({
            'fullname': data["data"]["fullname"],
            'email': data["data"]["email"],
            "userId" : data["data"]["id"],
            'role_id': data["data"]["role_id"],
            'profileimage': data["data"]["profileimage"],
            "online" : true,
            'mobileNumber': data["data"]["phone_number"],
            'lastSeen': FieldValue.serverTimestamp(),
            "createdAT" : FieldValue.serverTimestamp(),
            "deviceToken" : "deviceId"
          });
          print("user added");
        }
        isLoading.value = false;

        AppUtils.getSnackBar("Success", data["messages"]);
      } else {
        isLoading.value = false;
        handleErrorResponse(data['error']!=null?data['error']:data['messages']);
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

  Future<void> addOrUpdateUserInFirebase(Map<String, dynamic> userData) async {
    try {

      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      CollectionReference users = firestore.collection('users');

      DocumentSnapshot docSnapshot = await users.doc(userData['id'].toString()).get();

      if (docSnapshot.exists) {

        await users.doc(userData['id'].toString()).update({
          'fullname': userData['fullname'],
          'email': userData['email'],
          'role_id': userData['role_id'],
          'last_login': FieldValue.serverTimestamp(),
          // Optional: track last login time
        });
      } else {
        // User does not exist, create new document
        await users.doc(userData['id'].toString()).set({
          'id': userData['id'],
          'fullname': userData['fullname'],
          'email': userData['email'],
          'role_id': userData['role_id'],
          'created_at': FieldValue.serverTimestamp(), // Optional: track creation time
        });
      }
      print("User data added/updated in Firebase");
    } catch (e) {
      print("Error adding/updating user in Firebase: $e");
      throw Exception("Failed to update user data in Firebase.");
    }
  }

  void navigateBasedOnRole(int roleId) {
    switch (roleId) {
      case 1:
        Get.offAll(() => const MainBottomBar());
        break;
      case 2:
        Get.offAll(() => const TenantBottomBar());
        break;
      case 3:
        Get.offAll(() => const ServiceProviderBottomBar());
        break;
      case 4:
        Get.offAll(() => const VisitorBottomBar());
        break;
    }
  }

}