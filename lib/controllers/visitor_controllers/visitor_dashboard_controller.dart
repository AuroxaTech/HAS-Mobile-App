import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_app/models/stat_models/visitor_stat.dart';

import '../../models/stat_models/tenant_stat.dart';
import '../../services/auth_services/auth_services.dart';
import '../../utils/shared_preferences/preferences.dart';

class VisitorDashboardController extends GetxController {

  final GlobalKey<ScaffoldState> key = GlobalKey();

  @override
  void onInit() {
    super.onInit();
    getVisitorState();
  }

  RxBool isLoading = false.obs;
  AuthServices authServices = AuthServices();
  Rx<VisitorData?> getVisitor = Rx<VisitorData?>(null);


  Future<void> getVisitorState() async {
    print("we are in get land stat");
    print("we are in get${await Preferences.getUserID()}");
    isLoading.value = true;
    print(await Preferences.getUserID());
    var result = await authServices.getVisitorState();
    print("Service Result : $result");

    isLoading.value = false;

    if (result['data'] != null && result['data'] is Map) {
      var data = result['data'] as Map<String, dynamic>;
      print("Data :: $data");

      if (getVisitor != null) {
        getVisitor.value = VisitorData.fromJson(data);

        print("Tenant value ${getVisitor.value!.visitor.user}");
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