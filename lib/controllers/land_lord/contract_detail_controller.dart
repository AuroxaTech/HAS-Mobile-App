import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_app/models/propert_model/contract_model.dart';
import 'package:property_app/models/service_provider_model/all_services.dart';
import 'package:property_app/services/property_services/add_services.dart';

import '../../models/service_provider_model/get_services.dart';
import '../../utils/utils.dart';

class ContractDetailController extends GetxController{

  ServiceProviderServices servicesService = ServiceProviderServices();
  Rx<bool> isLoading = false.obs;
  Rx<Contracts?> getContractOne = Rx<Contracts?>(null);
  List<String> images = [];
  @override
  void onInit() {
    var data = Get.arguments;
    print("IDDDDDD $data");
    print("Hello");
    getContractDetail(id: data);
    super.onInit();
  }


  Future<void> getContractDetail({required int id}) async {
    print("we are in get contract");
    isLoading.value = true;
    try {
      // Fetch the service data
      var result = await servicesService.getContractDetail(id: id);
      print("contract Result : ${result['data']}");

      // Check if 'data' is not null
      if (result['data'] != null) {
        // Handling both Map and List cases
        var data;
        if (result['data'] is Map) {
          data = result['data'];
        } else if (result['data'] is List) {
          // If your service is supposed to return a list, handle it appropriately here.
          // For now, just printing or handling the first element for demo purposes.
          data = (result['data'] as List).first;
          // If 'data' should be a List, adjust the logic here instead of taking 'first'.
        } else {
          throw FormatException("Unexpected data format");
        }
        print("Data :: $data");
        if (getContractOne != null) {
          getContractOne.value = Contracts.fromJson(data);
        } else {
          print("contract is null");
        }
      } else {
        print("Invalid or null data format");
        // Handle other cases if necessary
      }
    } catch (e) {
      // Handle exceptions from service calls or data parsing
      print("Error occurred: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> acceptContractRequest({required int contractId, required String status,}) async {
    isLoading.value = true;

    try {
      var result = await servicesService.acceptContractRequest(
        contractId: contractId,
        status: status,
      );
      print(result);
      if (result['status'] == true) {
        Get.back();
        AppUtils.getSnackBar("Success", result['message']);
      } else {
        AppUtils.errorSnackBar("Error", result['message']);
      }
    } catch (e) {
      // Get.back();
      // Handle general errors
      print(e);
      AppUtils.errorSnackBar("Error", "Failed to decline service request");
    } finally {
      // Get.back();
      isLoading.value = false;
    }
  }

}