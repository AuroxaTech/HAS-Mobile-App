import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../models/stripe_payment_model/stripe_payment_model.dart';
import '../../services/auth_services/auth_services.dart';
import '../../utils/api_urls.dart';
import '../../utils/shared_preferences/preferences.dart';

class StripePaymentScreenController extends GetxController {
  RxInt serviceId = 0.obs;
  RxInt serviceProviderId = 0.obs;
  RxDouble price = 0.0.obs;

  final StripePaymentModel _stripePaymentModel = StripePaymentModel();
  var isProcessing = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeStripe();
  }

  void _initializeStripe() {
    Stripe.publishableKey = AppUrls.stripePKLiveKey;
  }

  void initializePaymentDetails(
      {required int serviceId,
      required int serviceProviderId,
      required double price}) {
    this.serviceId.value = serviceId;
    this.serviceProviderId.value = serviceProviderId;
    this.price.value = price;
  }

  Future<bool> withdrawPayment(String amount, String currency) async {
    isProcessing(true);
    try {
      final paymentIntent =
      await _stripePaymentModel.createPaymentIntent(amount, currency);
      if (paymentIntent != null) {
        bool paymentResult = await _initializePaymentSheet(paymentIntent['client_secret']);
        return paymentResult;
      } else {
        Get.snackbar('Payment Failed', 'Unable to create payment intent.');
        return false;
      }
    } catch (e) {
      print('Error making payment: $e');
      Get.snackbar('Payment Failed', 'Error making payment: $e');
      return false;
    } finally {
      isProcessing(false);
    }
  }

  Future<bool> _initializePaymentSheet(String clientSecret) async {
    try {
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'Has App',
          style: ThemeMode.system,
        ),
      );
      return await _presentPaymentSheet();
    } catch (e) {
      Get.snackbar('Payment Failed', 'Error initializing payment sheet: $e');
      print('Error initializing payment sheet: $e');
      return false;
    }
  }

  Future<bool> _presentPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      bool paymentSuccess = await collectPaymentFromTenant();
      return paymentSuccess;
    } on StripeException catch (e) {
      if (e.error.code == FailureCode.Canceled) {
        print('Payment canceled');
        Get.snackbar('Payment Canceled', 'Payment sheet was canceled.');
      } else {
        print('Payment failed: $e');
        Get.snackbar('Payment Failed', 'Error presenting payment sheet: $e');
      }
      return false;
    } catch (e) {
      Get.snackbar('Payment Failed', 'Error presenting payment sheet: $e');
      print('Error presenting payment sheet: $e');
      return false;
    }
  }

  Future<bool> collectPaymentFromTenant() async {
    final url = Uri.parse('https://haservices.ca:8080/payment');
    var token = await Preferences.getToken();
    print('Sending request to: $url');
    print('Headers: {Authorization: Bearer $token, Accept: application/json}');
    print(
        'Body: {service_id: ${serviceId.value}, service_provider_id: ${serviceProviderId.value}, price: ${price.value}}');

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
      body: {
        'service_id': serviceId.value.toString(),
        'service_provider_id': serviceProviderId.value.toString(),
        'price': price.value.toString(),
      },
    );
    print("service provider id ${serviceProviderId.value}");
    print("service id ${serviceId.value}");
    print('Payout Response ===> ${response.body}');
    print('Status Code ===> ${response.statusCode}');

    if (response.statusCode == 201) {
      Get.snackbar(
          "Payment Successful", "The payment was successfully processed.");
      return true;
    } else {
      Get.snackbar(
          "Payment Failed", "Unable to process the payment. Please try again.");
      return false;
    }
  }
}
