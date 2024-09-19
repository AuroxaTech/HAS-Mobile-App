import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../models/stripe_payment_model/stripe_payment_model.dart';

class StripePaymentController extends GetxController {
  final StripePaymentModel _stripePaymentModel = StripePaymentModel();
  var isProcessing = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeStripe();
  }

  // Initialize Stripe with publishable key
  void _initializeStripe() {
    Stripe.publishableKey = "pk_test_51Q0Gu9I2037pL7hB3AmEuJLRahLYS2fq526p9aVNW1cebhDfebb2JadzrM3ioBA0MxI6D2lLYRvC14Zd75YQbM4w00pZB5DAn8"; // Replace with your publishable key
  }

  // Handle the payment process (Withdrawal)
  Future<void> withdrawPayment(String amount, String currency) async {
    isProcessing(true);
    try {
      // Create Payment Intent
      final paymentIntent = await _stripePaymentModel.createPaymentIntent(amount, currency);
      if (paymentIntent != null) {
        // Initialize and show the payment sheet
        await _initializePaymentSheet(paymentIntent['client_secret']);
      }
    } catch (e) {
      print('Error making payment: $e');
    } finally {
      isProcessing(false);
    }
  }

  // Initialize the payment sheet with client secret from payment intent
  Future<void> _initializePaymentSheet(String clientSecret) async {
    try {
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'Your App Name',  // Name of your business
          style: ThemeMode.system,
          billingDetails: BillingDetails(
            email: 'email@test.com', // Pass dynamic details in production
          ),
        ),
      );

      // Present the payment sheet to the user
      await _presentPaymentSheet();
    } catch (e) {
      Get.snackbar('Payment Failed', 'Error initializing payment sheet: $e');
      print('Error initializing payment sheet: $e');
    }
  }

  // Present the payment sheet to the user
  Future<void> _presentPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      Get.snackbar('Payment Success', 'Your payment was successful!');
    } catch (e) {
      Get.snackbar('Payment Failed', 'Error presenting payment sheet: $e');
    }
  }
}
