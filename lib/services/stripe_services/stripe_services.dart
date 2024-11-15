import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:property_app/utils/api_urls.dart';

class StripeService {
  static const String _stripeApiBase = 'https://api.stripe.com/v1';

  Future<Map<String, dynamic>?> createPaymentIntent(
      String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount':
            amount, 
        'currency': currency,
        'payment_method_types[]': 'card',
      };

      var response = await http.post(
        Uri.parse('$_stripeApiBase/payment_intents'),
        body: body,
        headers: {
          'Authorization': 'Bearer ${AppUrls.stripeSKLiveKey}',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Failed to create payment intent: ${response.body}');
        return null;
      }
    } catch (error) {
      print('Error creating payment intent: $error');
      return null;
    }
  }

  // Confirm the payment intent with the payment method ID
  Future<Map<String, dynamic>?> confirmPayment(
      String paymentIntentId, String paymentMethodId) async {
    try {
      var response = await http.post(
        Uri.parse('$_stripeApiBase/payment_intents/$paymentIntentId/confirm'),
        body: {'payment_method': paymentMethodId},
        headers: {
          'Authorization': 'Bearer ${AppUrls.stripeSKLiveKey}',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Failed to confirm payment intent: ${response.body}');
        return null;
      }
    } catch (error) {
      print('Error confirming payment: $error');
      return null;
    }
  }
}
