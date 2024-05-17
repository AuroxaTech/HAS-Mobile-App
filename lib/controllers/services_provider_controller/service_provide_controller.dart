import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_app/services/auth_services/auth_services.dart';
import 'package:property_app/utils/shared_preferences/preferences.dart';

import '../../models/authentication_model/user_state_model.dart';

class ServiceProviderController extends GetxController {
  RxBool isLoading = false.obs;
  AuthServices authServices = AuthServices();
  final GlobalKey<ScaffoldState> key = GlobalKey();
  Rx<Provider?> getServiceOne = Rx<Provider?>(null);

  @override
  void onInit() {
    getUserState();
    super.onInit();
  }

  Future<void> getUserState() async {
    print("we are in get service");
    print("we are in get${await Preferences.getUserID()}");
    isLoading.value = true;
    print(await Preferences.getUserID());
    var result = await authServices.getUserState();
    print("Service Result : $result");

    isLoading.value = false;

    if (result['data'] != null && result['data'] is Map) {
      var data = result['data'] as Map<String, dynamic>;
      print("Data :: $data");

    if (getServiceOne != null) {
        getServiceOne.value = Provider.fromJson(data);
      } else {
        isLoading.value = false;
        print("getServiceOne is null");
      }
    } else {
      isLoading.value = false;
      print("Invalid or null data format");
    }

  }

}