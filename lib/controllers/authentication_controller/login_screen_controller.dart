import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_app/services/auth_services/auth_services.dart';
import 'package:property_app/views/main_bottom_bar/main_bottom_bar.dart';
import 'package:property_app/views/main_bottom_bar/service_provider_bottom_ar.dart';
import 'package:property_app/views/main_bottom_bar/tenant_bottom_bar.dart';
import 'package:property_app/views/main_bottom_bar/visitor_bottom_bar.dart';

import '../../services/notification_services/notification_services.dart';
import '../../utils/shared_preferences/preferences.dart';
import '../../utils/utils.dart';

class LoginScreenController extends GetxController {
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

  Future<void> login(
      BuildContext context, String email, String password) async {
    isLoading.value = true;

    try {
      var data = await authServices.login(
        email: email,
        password: password,
        deviceToken: "deviceId",
        platform: Platform.isAndroid ? "android" : "ios",
      );

      if (data['status'] == true) {
        // Success path remains the same
        print("Response: ${data["data"]}");
        await handleSuccessfulLogin(data);
      } else {
        isLoading.value = false;
        final errorMessage =
            data['error'] ?? data['messages'] ?? 'Unknown error occurred';
        handleErrorResponse(errorMessage);
      }
    } catch (e) {
      isLoading.value = false;
      print("Login error: $e");

      if (e.toString().contains('Server returned HTML')) {
        AppUtils.errorSnackBar("Server Error",
            "There was a problem with this account. Please contact support.");
      } else {
        handleErrorResponse(e.toString());
      }
    }
  }

  void handleErrorResponse(String errorMessage) {
    if (errorMessage.toLowerCase().contains("server error")) {
      AppUtils.errorSnackBar(
          "Server Error", "A server error occurred. Please try again later.");
    } else if (errorMessage.toLowerCase().contains("no input file specified")) {
      AppUtils.errorSnackBar(
          "Not Found", "The requested resource was not found.");
    } else {
      AppUtils.errorSnackBar("Error", errorMessage);
    }
  }

  Future<void> handleSuccessfulLogin(Map<String, dynamic> data) async {
    try {
      await Preferences.setToken(data["token"]);
      await Preferences.setUserName(data["data"]["fullname"]);
      await Preferences.setUserEmail(data["data"]["email"]);
      await Preferences.setRoleID(data["data"]["role_id"]);
      await Preferences.setUserID(data["data"]["id"]);

      await updateFirestoreUser(data["data"]);

      isLoading.value = false;
      AppUtils.getSnackBar("Success", data["messages"]);
      navigateBasedOnRole(data["data"]["role_id"]);
    } catch (e) {
      isLoading.value = false;
      throw Exception('Error processing login response: $e');
    }
  }

// New helper method to update Firestore user
  Future<void> updateFirestoreUser(Map<String, dynamic> userData) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final String userId = userData["id"].toString();

    try {
      DocumentSnapshot docSnapshot =
          await firestore.collection('users').doc(userId).get();

      Map<String, dynamic> userDataMap = {
        'fullname': userData["fullname"],
        'email': userData["email"],
        "userId": userData["id"],
        'role_id': userData["role_id"],
        "online": true,
        'profileimage': userData["profileimage"],
        'lastSeen': FieldValue.serverTimestamp(),
        "deviceToken": "deviceId"
      };

      if (docSnapshot.exists) {
        await firestore.collection('users').doc(userId).update(userDataMap);
      } else {
        userDataMap.addAll({
          'mobileNumber': userData["phone_number"],
          "createdAT": FieldValue.serverTimestamp(),
        });
        await firestore.collection('users').doc(userId).set(userDataMap);
      }
    } catch (e) {
      print("Firestore update error: $e");
      // Don't throw here - we want login to succeed even if Firestore update fails
    }
  }

  Future<void> addOrUpdateUserInFirebase(Map<String, dynamic> userData) async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      CollectionReference users = firestore.collection('users');

      DocumentSnapshot docSnapshot =
          await users.doc(userData['id'].toString()).get();

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
          'created_at':
              FieldValue.serverTimestamp(), // Optional: track creation time
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
