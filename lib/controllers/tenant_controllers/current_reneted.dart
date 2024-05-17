
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../models/propert_model/ladlord_property_model.dart';
import '../../services/property_services/get_property_services.dart';
import '../../utils/shared_preferences/preferences.dart';

class CurrentRantedPropertiesController extends GetxController {

   PropertyServices propertyServices = PropertyServices();
  Rx<bool> isLoading = false.obs;
  RxList<Property> getLandLordPropertiesList = <Property>[].obs;

  final PagingController<int, Property> pagingController = PagingController(firstPageKey: 1);


  @override
  void onInit() {
    pagingController.addPageRequestListener((pageKey) {
      Future.microtask(() => getProperty(pageKey));
    });
    // getLandLordProperties();
    super.onInit();
  }

  Future<void> getProperty(int pageKey,) async {
    try {
      isLoading.value = true;

      // Include the filters in the API request
      var result = await propertyServices.getRentedProperties(pageKey,);
      isLoading.value = false;

      if (result['status'] == true) {
        final List<Property> newItems = (result['data']['data'] as List)
            .map((json) => Property.fromJson(json))
            .toList();

        final isLastPage = result['data']['current_page'] == result['data']['last_page'];
        if (isLastPage) {
          pagingController.appendLastPage(newItems);
        } else {
          final nextPageKey = pageKey + 1;
          pagingController.appendPage(newItems, nextPageKey);
        }
      } else {
        pagingController.error = Exception('Failed to fetch properties');
      }
    } catch (error) {
      isLoading.value = false;
      print(error);
      pagingController.error = error.toString();
      rethrow;
    }
  }

  void refreshPropertiesWithFilters(Map<String, dynamic> filters) {
    pagingController.value.itemList!.clear();
    pagingController.addPageRequestListener((pageKey) {
      getProperty(pageKey,);
    });
  }


}