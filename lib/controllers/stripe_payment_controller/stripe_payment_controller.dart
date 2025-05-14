import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../utils/api_urls.dart';
import '../../utils/shared_preferences/preferences.dart';
import '../../utils/utils.dart';

class StripePaymentScreenController extends GetxController {
  RxInt serviceId = 0.obs;
  RxInt serviceProviderId = 0.obs;
  RxDouble price = 0.0.obs;

  var isProcessing = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeStripe();
  }

  void _initializeStripe() {
    // Initialize Stripe with publishable key
    Stripe.publishableKey = AppUrls.stripePKTestKey;

    // Optional: Log to verify initialization
    print(
        "Stripe initialized with key: ${AppUrls.stripePKTestKey.substring(0, 10)}...");
  }

  void initializePaymentDetails({
    required int serviceId,
    required int serviceProviderId,
    required double price,
  }) {
    this.serviceId.value = serviceId;
    this.serviceProviderId.value = serviceProviderId;
    this.price.value = price;
  }

  Future<bool> processPayment() async {
    isProcessing.value = true;
    try {
      // Get the client secret from the backend
      final response = await _makeStripePaymentRequest();

      if (response != null && response['success'] == true) {
        // Extract client secret from response
        final clientSecret = response['client_secret'];

        print("Client Secret: $clientSecret");

        // Validate client secret
        if (clientSecret == null || clientSecret.toString().isEmpty) {
          print("Missing client secret");
          AppUtils.errorSnackBar(
              "Payment Failed", "Invalid payment configuration from server.");
          return false;
        }

        try {
          // Initialize and present payment sheet in one step without local variables
          await _presentStripePaymentSheet(clientSecret.toString());

          // Payment succeeded
          AppUtils.getSnackBar(
              "Payment Successful", "The payment was successfully processed.");
          return true;
        } catch (e) {
          _handlePaymentError(e);
          return false;
        }
      } else {
        AppUtils.errorSnackBar("Payment Failed",
            "Could not initialize payment. Please try again.");
        return false;
      }
    } catch (e) {
      print("Top level error: $e");
      AppUtils.errorSnackBar(
          "Payment Failed", "An unexpected error occurred: $e");
      return false;
    } finally {
      isProcessing.value = false;
    }
  }

  Future<void> _presentStripePaymentSheet(String clientSecret) async {
    // Initialize payment sheet with client secret
    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: clientSecret,
        merchantDisplayName: 'HAS App',
        style: ThemeMode.system,
      ),
    );

    // Present payment sheet
    await Stripe.instance.presentPaymentSheet();
  }

  void _handlePaymentError(dynamic error) {
    print("Payment error: $error");

    if (error is StripeException) {
      if (error.error.code == FailureCode.Canceled) {
        AppUtils.warningSnackBar(
            "Payment Canceled", "You canceled the payment process.");
      } else {
        print("Stripe error details: "
            "Code: ${error.error.code}, "
            "Message: ${error.error.message}, "
            "Stripe Error Code: ${error.error.stripeErrorCode}");
        AppUtils.errorSnackBar("Payment Failed",
            "Error processing payment: ${error.error.localizedMessage}");
      }
    } else {
      AppUtils.errorSnackBar(
          "Payment Failed", "An unexpected error occurred: $error");
    }
  }

  Future<Map<String, dynamic>?> _makeStripePaymentRequest() async {
    try {
      final url = Uri.parse('${AppUrls.baseUrl}/stripe/payment');
      final token = await Preferences.getToken();

      // Prepare body parameters as a map
      final Map<String, dynamic> bodyParams = {
        'provider_id': serviceProviderId.value,
        'amount': price.value.toInt(),
        'service_id': serviceId.value,
      };

      print('Making payment request:');
      print('URL: $url');
      print('Provider ID: ${serviceProviderId.value}');
      print('Amount: ${price.value.toInt()}');
      print('Service ID: ${serviceId.value}');
      print('Request body: ${jsonEncode(bodyParams)}');

      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(bodyParams),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Failed to create payment: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error creating payment: $e');
      return null;
    }
  }
}
