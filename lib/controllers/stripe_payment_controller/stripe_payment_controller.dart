import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../models/stripe_payment_model/stripe_payment_model.dart';
import '../../services/auth_services/auth_services.dart';
import '../../utils/api_urls.dart';
import '../../utils/shared_preferences/preferences.dart';

class StripePaymentScreenController extends GetxController {
  AuthServices authServices = AuthServices();
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

  Future<void> withdrawPayment(String amount, String currency) async {
    isProcessing(true);
    try {
      final paymentIntent =
          await _stripePaymentModel.createPaymentIntent(amount, currency);
      if (paymentIntent != null) {
        await _initializePaymentSheet(paymentIntent['client_secret']);
      } else {
        Get.snackbar('Payment Failed', 'Unable to create payment intent.');
      }
    } catch (e) {
      print('Error making payment: $e');
      Get.snackbar('Payment Failed', 'Error making payment: $e');
    } finally {
      isProcessing(false);
    }
  }

  Future<void> _initializePaymentSheet(String clientSecret) async {
    try {
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'Has App',
          style: ThemeMode.system,
          // billingDetails: const BillingDetails(
          //   email:
          //       'salman.e.alansari@gmail.com', // Pass dynamic details in production
          // ),
        ),
      );

      await _presentPaymentSheet();
    } catch (e) {
      Get.snackbar('Payment Failed', 'Error initializing payment sheet: $e');
      print('Error initializing payment sheet: $e');
    }
  }

  Future<void> _presentPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      await collectPaymentFromTenant();
    } catch (e) {
      Get.snackbar('Payment Failed', 'Error presenting payment sheet: $e');
    }
  }

  Future<void> collectPaymentFromTenant() async {
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
        //'Content-Type': 'application/json',
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
    } else {
      Get.snackbar(
          "Payment Failed", "Unable to process the payment. Please try again.");
    }
  }
}
