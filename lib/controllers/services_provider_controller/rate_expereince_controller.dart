import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:property_app/utils/api_urls.dart';
import 'package:property_app/utils/shared_preferences/preferences.dart';

import '../../utils/utils.dart';
import '../../views/land_lords/job_screeen.dart';

class RateExperienceController extends GetxController {
  var descriptionController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  RxInt rating = 0.obs;
  var selectedHome = <String, bool>{
    'Overall Service': false,
    'Flat': false,
    'Upper Portion': false,
    'Lower Portion': false,
    'Farm House': false,
    'Room': false,
    'Penthouse': false,
  }.obs;

  RxInt serviceId = 0.obs;

  RxInt selectedIndex =
      0.obs; // Add this line to declare a variable for storing the index

  void toggleHome(String key) {
    var updatedMap = Map<String, bool>.from(selectedHome);
    updatedMap.updateAll((k, v) => false);
    updatedMap[key] = true;
    selectedHome.value = updatedMap;

    // Update selectedIndex based on the key
    selectedIndex.value = updatedMap.keys.toList().indexOf(key) +
        1; // +1 to convert from 0-based to 1-based indexing
  }

  RxBool isLoading = false.obs;

  Future<void> sendFeedback({
    required int serviceId,
    required int rate,
    required String description,
  }) async {
    var id = await Preferences.getUserID();
    var token = await Preferences.getToken();
    isLoading.value = true;
    final response = await http.post(
      Uri.parse(AppUrls.makeFeedBack),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, dynamic>{
        'user_id': id,
        'service_id': serviceId,
        'rate': rate,
        'description': description,
      }),
    );

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, then parse the JSON.
      isLoading.value = false;
      var jsonData = jsonDecode(response.body);
      print('Feedback sent successfully');
      // Get.back();
      // Get.back();
      // Get.back();
      // Get.back();
      Get.off(() => const JobsScreen(isBack: true));
      AppUtils.getSnackBar("Feedback", jsonData["message"]);
    } else {
      isLoading.value = false;
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to send feedback');
    }
  }

  @override
  void onInit() {
    var data = Get.arguments;
    serviceId.value = data;
    print("service Id : $serviceId");
    super.onInit();
  }
}
