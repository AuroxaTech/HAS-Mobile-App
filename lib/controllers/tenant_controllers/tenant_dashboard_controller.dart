import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_app/models/stat_models/tenant_stat.dart';

import '../../services/auth_services/auth_services.dart';
import '../../utils/shared_preferences/preferences.dart';

class TenantDashboardController extends GetxController {

  final GlobalKey<ScaffoldState> key = GlobalKey();
  @override
  void onInit() {
    super.onInit();
    getTenantState();
  }


  RxBool isLoading = false.obs;
  AuthServices authServices = AuthServices();
  Rx<TenantData?> getTenant = Rx<TenantData?>(null);


  Future<void> getTenantState() async {
    print("we are in get land stat");
    print("we are in get${await Preferences.getUserID()}");
    isLoading.value = true;
    print(await Preferences.getUserID());
    var result = await authServices.getTenantState();
    print("Service Result : $result");

    isLoading.value = false;

    if (result['data'] != null && result['data'] is Map) {
      var data = result['data'] as Map<String, dynamic>;
      print("Data :: $data");

      if (getTenant != null) {
        getTenant.value = TenantData.fromJson(data);

        print("Tenant value ${getTenant.value!.tenant.user}");
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