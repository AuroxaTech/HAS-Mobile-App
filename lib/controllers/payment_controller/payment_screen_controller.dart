import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:property_app/utils/shared_preferences/preferences.dart';

import '../../utils/api_urls.dart';
class PaymentScreenController extends GetxController {



  Future<Map<String, dynamic>> connectStripeAccount() async {
    try {
      var token = await Preferences.getToken();
      final response = await http.post(
        Uri.parse("${AppUrls.baseUrl}/stripe/connect"),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        print("payment body ${response.body}");
        return jsonDecode(response.body);

      } else {
        return {"message": "Failed to connect Stripe"};
      }
    } catch (e) {
      return {"message": e.toString()};
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchStripeAccount();
  }
  var stripeAccount = Rxn<Map<String, dynamic>>();

  RxBool isLoading = false.obs;

  Future<void> fetchStripeAccount() async {
    try {
      isLoading.value = true;
      final response = await getStripeAccount(); // implement this
      stripeAccount.value = response;
    } catch (e) {
      stripeAccount.value = null;
    } finally {
      isLoading.value = false;
    }
  }

  Future<Map<String, dynamic>> getStripeAccount() async {
    final url = Uri.parse('${AppUrls.baseUrl}/stripe/account');
    var token = await Preferences.getToken();
    try {
      final response = await http.get(url, headers: {
        'Authorization': 'Bearer $token', // Include token if needed
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return json.decode(response.body); // Could be 404 with error
      }
    } catch (e) {
      return {'error': e.toString()};
    }
  }

}
