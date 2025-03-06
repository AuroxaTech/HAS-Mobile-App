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

  void toggleFavorite1(int serviceId) async {
    // Safety check to ensure itemList is not null

    // Retrieve the current service directly from `getServiceOne.value`
    var service = getServiceOne.value;
    if (service == null) {
      Get.snackbar('Error', 'Service not found.');
      return;
    }

    // Toggle the isFavorite status
    int newFavoriteStatus = (service.isFavorite == 1) ? 0 : 1;
    service.isFavorite = newFavoriteStatus;

    // Attempt to update the backend with the new favorite status
    try {
      // Determine the API call based on the new favorite status

      print("Printing to favorites... $newFavoriteStatus");

      bool result;
      if (newFavoriteStatus == 1) {
        // If the service is not in favorites, add it
        print("Adding to favorites...");
        result = await servicesService.addFavorite(serviceId);
      } else {
        // If the service is in favorites, remove it
        print("Removing from favorites...");
        result = await servicesService.removeFavoriteService(serviceId);
      }

      // If the API call fails, throw an exception
      if (!result) {
        throw Exception('API call to update favorite failed.');
      } else {
        // If successful, refresh the service state
        getServiceOne.refresh();
      }
    } catch (error) {
      // If the API call fails, revert the local change
      service.isFavorite = (newFavoriteStatus == 1) ? 0 : 1; // Revert to previous state
      Get.snackbar('Error', 'Could not update favorites. Please try again.');
      print('Error: $error');
      rethrow;
    }

    // Force the UI to refresh and reflect the change
  }

}