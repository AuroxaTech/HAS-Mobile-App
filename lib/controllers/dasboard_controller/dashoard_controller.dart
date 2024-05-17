import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/stat_models/landlord_stat.dart';
import '../../services/auth_services/auth_services.dart';
import '../../utils/shared_preferences/preferences.dart';

class DashboardController extends GetxController with GetSingleTickerProviderStateMixin  {
  Rx<TabController?> tabController = Rx<TabController?>(null);
  final GlobalKey<ScaffoldState> key = GlobalKey();
  @override
  void onInit() {
    super.onInit();
    tabController.value = TabController(vsync: this, length: 3);
    getLandLordState();
  }


  RxBool isLoading = false.obs;
  AuthServices authServices = AuthServices();
  Rx<LandLordData?> getLandlord = Rx<LandLordData?>(null);


  Future<void> getLandLordState() async {
    print("we are in get land stat");
    print("we are in get${await Preferences.getUserID()}");
    isLoading.value = true;
    print(await Preferences.getUserID());
    var result = await authServices.getLandLordState();
    print("Service Result : $result");

    isLoading.value = false;

    if (result['data'] != null && result['data'] is Map) {
      var data = result['data'] as Map<String, dynamic>;
      print("Data :: $data");

      if (getLandlord != null) {
        getLandlord.value = LandLordData.fromJson(data);

        print("landlord value ${getLandlord.value!.landlord.user}");
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