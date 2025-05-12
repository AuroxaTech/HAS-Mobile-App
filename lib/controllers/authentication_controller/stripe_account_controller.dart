import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:property_app/utils/api_urls.dart';
import 'package:property_app/utils/shared_preferences/preferences.dart';
import 'package:property_app/utils/utils.dart';
import 'package:property_app/views/main_bottom_bar/service_provider_bottom_ar.dart';
import 'package:url_launcher/url_launcher.dart';

class StripeAccountController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLoading2 = false.obs;
  RxString stripeUrl = ''.obs;
  RxString accountId = ''.obs;

  Future<void> getStripeConnectUrl() async {
    try {
      isLoading.value = true;
      final token = await Preferences.getToken();

      final response = await http.post(
        Uri.parse('${AppUrls.baseUrl}/stripe/connect'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print("Get Stripe Connect Url == > ${response.body}");

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        stripeUrl.value = responseData['url'] ?? '';
        accountId.value = responseData['account_id'] ?? '';

        if (stripeUrl.value.isNotEmpty) {
          final uri = Uri.parse(stripeUrl.value);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          } else {
            AppUtils.errorSnackBar(
                "Error", "Could not launch Stripe setup page.");
          }
        } else {
          AppUtils.errorSnackBar("Error", "No Stripe setup URL received.");
        }
      } else {
        AppUtils.errorSnackBar(
            "Error", "Failed to get Stripe connect URL. Please try again.");
      }
    } catch (e) {
      print("Error getting Stripe connect URL: $e");
      AppUtils.errorSnackBar(
          "Error", "An error occurred while connecting to Stripe.");
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> checkStripeAccountStatus() async {
    try {
      isLoading2.value = true;
      final token = await Preferences.getToken();

      final response = await http.get(
        Uri.parse('${AppUrls.baseUrl}/stripe/account/status'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final status = responseData['status'];

        if (status == 'active') {
          Get.offAll(() => const ServiceProviderBottomBar());
          return true;
        } else {
          Get.defaultDialog(
              title: "Stripe Account Not Setup",
              middleText:
                  "Your Stripe account is not setup. Please set up your account first.",
              textConfirm: "OK",
              confirmTextColor: Colors.white,
              onConfirm: () {
                Get.back();
              });
          return false;
        }
      } else {
        AppUtils.errorSnackBar(
            "Error", "Failed to check Stripe account status.");
        return false;
      }
    } catch (e) {
      print("Error checking Stripe account status: $e");
      AppUtils.errorSnackBar("Error",
          "An error occurred while checking your Stripe account status.");
      return false;
    } finally {
      isLoading2.value = false;
    }
  }
}
