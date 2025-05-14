import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:property_app/utils/shared_preferences/preferences.dart';
import 'package:property_app/utils/api_urls.dart';
import 'package:property_app/utils/utils.dart';

class PaymentScreenController extends GetxController {
  RxBool isLoading = false.obs;
  RxList<dynamic> providerPayments = RxList<dynamic>([]);
  RxDouble totalPaymentsReceived = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProviderPayments();
  }

  Future<void> fetchProviderPayments() async {
    try {
      isLoading.value = true;
      final token = await Preferences.getToken();
      
      final response = await http.get(
        Uri.parse('${AppUrls.baseUrl}/stripe/provider-payments'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      print('Provider payments response: ${response.statusCode}');
      print('Response body: ${response.body}');
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        
        if (data['success'] == true && data['payments'] != null) {
          providerPayments.assignAll(data['payments']);
          
          // Calculate total payments received - amount is already in dollars
          double total = 0;
          for (var payment in providerPayments) {
            total += (payment['amount'] ?? 0);
          }
          totalPaymentsReceived.value = total;
        } else {
          providerPayments.clear();
          AppUtils.warningSnackBar('No payments', 'No payment history found');
        }
      } else {
        providerPayments.clear();
        AppUtils.errorSnackBar('Error', 'Failed to load payment history');
      }
    } catch (e) {
      print('Error fetching provider payments: $e');
      providerPayments.clear();
      AppUtils.errorSnackBar('Error', 'Error fetching payment history: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<Map<String, dynamic>> connectStripeAccount() async {
    try {
      isLoading.value = true;
      final token = await Preferences.getToken();
      
      final response = await http.get(
        Uri.parse('${AppUrls.baseUrl}/stripe/connect'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return {
          'success': true,
          'onboarding_url': data['url'],
          'account_id': data['account_id'],
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to connect Stripe account',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error: $e',
      };
    } finally {
      isLoading.value = false;
    }
  }
}
