import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../models/propert_model/ladlord_property_model.dart';
import '../../services/property_services/get_property_services.dart';
import '../../utils/utils.dart';

class CurrentRantedPropertiesController extends GetxController {
  PropertyServices propertyServices = PropertyServices();
  Rx<bool> isLoading = false.obs;
  RxList<Property> getLandLordPropertiesList = <Property>[].obs;

  final PagingController<int, Property> pagingController =
      PagingController(firstPageKey: 1);

  @override
  void onInit() {
    pagingController.addPageRequestListener((pageKey) {
      Future.microtask(() => getProperty(pageKey));
    });
    // getLandLordProperties();
    super.onInit();
  }

  Future<void> getProperty(int pageKey) async {
    try {
      isLoading.value = true;

      // Make the API request
      var result = await propertyServices.getRentedProperties(pageKey);
      isLoading.value = false;

      if (result['status'] == true && result['data'] != null) {
        // Parse the properties from the API response
        final propertiesData = result['data']['data'];
        
        if (propertiesData is List) {
          final List<Property> newItems = [];
          
          for (var propertyJson in propertiesData) {
            try {
              // Parse each property and add to the list
              Property property = Property.fromJson(propertyJson);
              newItems.add(property);
            } catch (e) {
              print("Error parsing property: $e");
            }
          }
          
          // Check if this is the last page
          final isLastPage = result['data']['current_page'] == result['data']['last_page'];
          
          if (isLastPage) {
            pagingController.appendLastPage(newItems);
          } else {
            final nextPageKey = pageKey + 1;
            pagingController.appendPage(newItems, nextPageKey);
          }
        } else {
          pagingController.error = "Invalid data format from API";
        }
      } else {
        // Handle API error
        String errorMessage = result['message'] ?? 'Failed to fetch properties';
        pagingController.error = errorMessage;
        AppUtils.errorSnackBar("Error", errorMessage);
      }
    } catch (error) {
      isLoading.value = false;
      print("Error in getProperty: $error");
      pagingController.error = error.toString();
      AppUtils.errorSnackBar("Error", "Failed to load properties: ${error.toString()}");
    }
  }

  void refreshPropertiesWithFilters(Map<String, dynamic> filters) {
    pagingController.value.itemList!.clear();
    pagingController.refresh();
  }
}
