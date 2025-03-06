import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_app/models/service_provider_model/all_services.dart';
import 'package:property_app/services/property_services/add_services.dart';

import '../../models/service_provider_model/get_services.dart';

class ServiceListingDetailScreenController extends GetxController{

  ServiceProviderServices servicesService = ServiceProviderServices();
  Rx<bool> isLoading = false.obs;
  Rx<AllService?> getServiceOne = Rx<AllService?>(null);
  List<String> images = [];
  @override
  void onInit() {
    var data = Get.arguments;
    int id = data[0];
    images = data[1];
    print("IDDDDDD $id");
    print("Hello");
    getService(id: id);
    super.onInit();
  }


  Future<void> getService({required int id}) async {
    print("we are in get service");
    isLoading.value = true;

    // Fetch the service data
    var result = await servicesService.getService(id: id);
    print("Service Result : $result[data]");

    // Check if 'data' is not null and is of type Map
    if (result['data'] != null && result['data'] is Map) {
      var data = result['data'] as Map<String, dynamic>;
      print("Data :: $data");
      isLoading.value = false;
      if (getServiceOne != null) {
        getServiceOne.value = AllService.fromJson(data);
      } else {
        isLoading.value = false;
        print("getServiceOne is null");
      }
    } else {
      isLoading.value = false;
      print("Invalid or null data format");
      // Handle other cases if necessary
    }
  }

  void toggleFavorite1( int serviceId) async {
    // Safety check to ensure itemList is not null

    // Retrieve the current service directly from pagingController's itemList
    var service = getServiceOne.value;
    // Toggle the isFavorite status
    bool newFavoriteStatus = !(service?.isFavorite ?? false);
    service?.isFavorite = newFavoriteStatus;

    // Attempt to update the backend with the new favorite status
    try {
      // Make the API call
      bool result = await servicesService.addFavorite(serviceId);
      if (!result) {
        throw Exception('API call to add favorite failed.');
      }else{
        getServiceOne.refresh();
      }
      // If successful, no need to do anything as the local state is already updated
    } catch (error) {
      // If the API call fails, revert the local change
      service?.isFavorite = !newFavoriteStatus;
      Get.snackbar('Error', 'Could not update favorites. Please try again.');
    }

    // Force the UI to refresh and reflect the change
  }

}