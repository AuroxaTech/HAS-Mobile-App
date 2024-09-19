import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app_constants/color_constants.dart';
import '../../controllers/stripe_controller/stripe_payment_controller.dart';

class StripePaymentView extends StatelessWidget {
  final StripePaymentController _controller = Get.put(StripePaymentController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stripe Payment',style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500
        ),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(() => _controller.isProcessing.value
                ? const CircularProgressIndicator()
                :  ElevatedButton(
              onPressed: () {
                // Withdraw payment with Stripe PaymentSheet
                _controller.withdrawPayment('50000', 'usd'); // Example: Withdraw $50.00
              },
              child: Text('Withdraw',style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                color: Colors.white
              ),),
            )),
            SizedBox(height: 20),
            Text(
              'Enter your payment details in the Stripe Payment Sheet',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
