import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:property_app/constant_widget/constant_widgets.dart';
import 'package:property_app/utils/api_urls.dart';
import 'package:property_app/utils/shared_preferences/preferences.dart';

class ChatServices {
  Future<Map<String, dynamic>> searchUser(String query) async {
    final url = Uri.parse('${AppUrls.searchUser}?query=$query');
    var userToken = await Preferences.getToken();
    try {
      final response =
          await http.get(url, headers: getHeader(userToken: userToken));

      // Print the full response for debugging
      print("API Response Status Code: ${response.statusCode}");
      print("API Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return data;
      } else {
        print("Failed to load users with status code: ${response.statusCode}");
        return {'status': false, 'message': 'Failed to load users'};
      }
    } catch (e) {
      print("Error during API call: $e");
      return {'status': false, 'message': 'Error: $e'};
    }
  }
}
