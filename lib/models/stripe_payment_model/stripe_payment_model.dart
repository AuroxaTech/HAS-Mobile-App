import '../../services/stripe_services/stripe_services.dart';

class StripePaymentModel {
  final StripeService _stripeService = StripeService();

  // Create a payment intent
  Future<Map<String, dynamic>?> createPaymentIntent(
      String amount, String currency) {
    return _stripeService.createPaymentIntent(amount, currency);
  }

  // Confirm a payment intent
  Future<Map<String, dynamic>?> confirmPayment(
      String paymentIntentId, String paymentMethodId) {
    return _stripeService.confirmPayment(paymentIntentId, paymentMethodId);
  }
}
