import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/propert_model/ladlord_property_model.dart';
import '../../services/property_services/get_property_services.dart';

class HomeScreenController extends GetxController with GetTickerProviderStateMixin {
  late TabController tabController;
  late TabController tabController1;
  var selectedIndex = 0.obs;
  var selectedIndex1 = 0.obs;

  @override
  void onInit() {
    getAllProperties();
    tabController = TabController(length: 2, vsync: this);
    tabController1 = TabController(length: 3, vsync: this);
    tabController.addListener(updateIndex);
    tabController1.addListener(updateIndex1);
    super.onInit();
  }

  void updateIndex() {
    selectedIndex.value = tabController.index;
  }
  void updateIndex1() {
    selectedIndex1.value = tabController1.index;
  }

  @override
  void onClose() {
    tabController.removeListener(updateIndex);
    tabController1.removeListener(updateIndex1);
    tabController.dispose();
    tabController1.dispose();
    super.onClose();
  }


  PropertyServices propertyServices = PropertyServices();
  Rx<bool> isLoading = false.obs;
  RxList<Property> getAllPropertiesList = <Property>[].obs;

  Future<void> getAllProperties() async {
    List<Property>  list  = <Property>[];
    print("we are in land lord property:");
    isLoading.value = true;
    var result = await propertyServices.getAllProperties(1);
    print("property result :${result["data"]}");
    isLoading.value = false;
    for (var data in result['data']["data"]) {
      print("property List :: $data");
      list.add(Property.fromJson(data));
    }
    getAllPropertiesList.value = list;
  }
}