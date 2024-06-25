
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../models/propert_model/ladlord_property_model.dart';
import '../../services/property_services/get_property_services.dart';
import '../../utils/shared_preferences/preferences.dart';


class AllPropertyController extends GetxController with GetTickerProviderStateMixin {

  final sheet = GlobalKey();
  final controller = DraggableScrollableController();
  List<String> areaRange = [
    "50 sq ft",
    "100 sq ft",
    "200 sq ft",
    "300 sq ft",
    "400 sq ft"
  ];

  late TabController tabController;
  RxInt selectedIndex = 0.obs;

  RxInt selectedArea = 0.obs;
  RxInt selectedBedroom = 1.obs;
  RxInt selectedBathrooms = 1.obs;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  RxBool isSale = false.obs;
  var description = TextEditingController();
  var minPriceController = TextEditingController();
  var maxPriceController = TextEditingController();
  RxBool home = true.obs;
  RxBool plots = false.obs;
  RxBool commercial = false.obs;

  var selectedHome = <String, bool>{
    'House': false,
    'Flat': false,
    'Upper Portion': false,
    'Lower Portion': false,
    'Farm House': false,
    'Room': false,
    'Penthouse': false,
  }.obs;
  var selectedPlots = <String, bool>{
    'Residential plot': false,
    'Commercial plot': false,
    'Agriculture land': false,
    'Industrial land': false,
    'Plot file': false,
  }.obs;
  var selectedCommercial = <String, bool>{
    'Office': false,
    'Shop': false,
    'Warehouse': false,
    'Factory': false,
    'Building': false,
  }.obs;

  void toggleHome(String key) {
    var updatedMap = Map<String, bool>.from(selectedHome.value);
    updatedMap.updateAll((k, v) => false);
    updatedMap[key] = true;
    selectedHome.value = updatedMap;
  }

  void togglePlots(String key) {
    var updatedMap = Map<String, bool>.from(selectedPlots.value);
    updatedMap.updateAll((k, v) => false);
    updatedMap[key] = true;
    selectedPlots.value = updatedMap;
  }

  void toggleCommercial(String key) {
    var updatedMap = Map<String, bool>.from(selectedCommercial.value);
    updatedMap.updateAll((k, v) => false);
    updatedMap[key] = true;
    selectedCommercial.value = updatedMap;
  }

  int getSelectedHomeSubTypeIndex() {
    List<MapEntry<String, bool>> entries = selectedHome.entries.toList();
    int index = entries.indexWhere((MapEntry<String, bool> entry) => entry.value);
    return index != -1 ? index + 1 : 0;
  }

  int getSelectedPlotsSubTypeIndex() {
    List<MapEntry<String, bool>> entries = selectedPlots.entries.toList();
    int index = entries.indexWhere((MapEntry<String, bool> entry) => entry.value);
    return index != -1 ? index + 1 : 0;
  }

  int getSelectedCommercialSubTypeIndex() {
    List<MapEntry<String, bool>> entries = selectedCommercial.entries.toList();
    int index = entries.indexWhere((MapEntry<String, bool> entry) => entry.value);
    return index != -1 ? index + 1 : 0;
  }

  PropertyServices propertyServices = PropertyServices();
  Rx<bool> isLoading = false.obs;
  RxList<Property> getLandLordPropertiesList = <Property>[].obs;

  final PagingController<int, Property> pagingController = PagingController(firstPageKey: 1);


  @override
  void onInit() {
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      selectedIndex.value = tabController.index;
    });
    pagingController.addPageRequestListener((pageKey) {
      getProperties(pageKey);
    });
   // getLandLordProperties();
    super.onInit();
  }

  Future<void> getProperties(int pageKey, [Map<String, dynamic>? filters]) async {
    try {
      isLoading.value = true;

      // Include the filters in the API request
      var result = await propertyServices.getAllProperties(pageKey, filters: filters);
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
      getProperties(pageKey, filters);
    });
  }

  // Future<void> getProperties(int pageKey) async {
  //   try {
  //     isLoading.value = true;
  //     var result = await propertyServices.getAllProperties(pageKey);
  //     isLoading.value = false;
  //
  //     if (result['status'] == true) {
  //       final List<Property> newItems = (result['data']['data'] as List)
  //           .map((json) => Property.fromJson(json))
  //           .toList();
  //
  //       final isLastPage = result['data']['current_page'] == result['data']['last_page'];
  //
  //       if (isLastPage) {
  //         pagingController.appendLastPage(newItems);
  //       } else {
  //         final nextPageKey = pageKey + 1;
  //         pagingController.appendPage(newItems, nextPageKey);
  //       }
  //     } else {
  //       pagingController.error = Exception('Failed to fetch services');
  //     }
  //   } catch (error) {
  //     isLoading.value = false;
  //     print(error);
  //
  //     final errorMessage = error.toString();
  //     pagingController.error = errorMessage;
  //     rethrow;
  //   }
  // }
// Future<void> getLandLordProperties() async {
//   List<Property>  list  = <Property>[];
//   print("we are in land lord property:");
//   isLoading.value = true;
//   //var uId = await Preferences.getUserID();
//   var result = await propertyServices.getAllProperties(1);
//   print(result);
//   if(result["status"] == true){
//  //   print("property result :${result["properties"]}");
//     isLoading.value = false;
//     for (var data in result['data']["data"]) {
//       print("property List :: $data");
//       list.add(Property.fromJson(data));
//     }
//     getLandLordPropertiesList.value = list;
//   }else{
//     isLoading.value = false;
//   }
// }


  void toggleFavorite1(int index, int propertyId) async {
    if (pagingController.itemList == null) return;
    // Retrieve the current service directly from pagingController's itemList
    var service = pagingController.itemList![index];
    // Toggle the isFavorite status
    bool newFavoriteStatus = !(service.isFavorite ?? false);
    service.isFavorite = newFavoriteStatus;

    // Attempt to update the backend with the new favorite status
    try {
      // Make the API call
      bool result = await propertyServices.addFavoriteProperty(propertyId, newFavoriteStatus ? 1 : 2);
      if (!result) {
        throw Exception('API call to add favorite failed.');
      }
      // If successful, no need to do anything as the local state is already updated
    } catch (error) {
      // If the API call fails, revert the local change
      service.isFavorite = !newFavoriteStatus;
      Get.snackbar('Error', 'Could not update favorites. Please try again.');
    }

    // Force the UI to refresh and reflect the change
    pagingController.notifyListeners();
  }

}