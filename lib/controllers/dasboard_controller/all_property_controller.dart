import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../models/propert_model/ladlord_property_model.dart';
import '../../services/property_services/get_property_services.dart';

class AllPropertyController extends GetxController {
  final sheet = GlobalKey();
  final controller = DraggableScrollableController();
  List<String> areaRange = [
    "50 sq ft",
    "100 sq ft",
    "200 sq ft",
    "300 sq ft",
    "400 sq ft"
  ];

  List<String> bathroomsList = [
    "1",
    "1  1/2",
    "2",
    "2  1/2",
    "3",
    "3  1/2",
    "4",
    "4  1/2",
    "5",
    "5  1/2",
    "6",
    "6  1/2",
    "7",
    "7  1/2"
  ];

  // Removed TabController and vsync mixin
  RxInt selectedIndex = 0.obs;

  RxString selectedRange = "1 sq ft".obs;
  RxInt selectedBedroom = 1.obs;
  RxInt selectedBathrooms = 1.obs;
  RxString selectedBothList = "1".obs;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  RxBool isSale = false.obs;
  var description = TextEditingController();
  var minPriceController = TextEditingController();
  var maxPriceController = TextEditingController();
  RxBool home = true.obs;
  RxBool plots = false.obs;
  RxBool commercial = false.obs;

  var currentRange = const RangeValues(1, 1000).obs;

  void updateRangeValues(RangeValues values) {
    currentRange.value = values;
  }

  var selectedHome = <String, bool>{
    'House': false,
    'Flat': false,
    'Apartments': false,
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
    int index =
        entries.indexWhere((MapEntry<String, bool> entry) => entry.value);
    return index != -1 ? index + 1 : 0;
  }

  int getSelectedPlotsSubTypeIndex() {
    List<MapEntry<String, bool>> entries = selectedPlots.entries.toList();
    int index =
        entries.indexWhere((MapEntry<String, bool> entry) => entry.value);
    return index != -1 ? index + 1 : 0;
  }

  int getSelectedCommercialSubTypeIndex() {
    List<MapEntry<String, bool>> entries = selectedCommercial.entries.toList();
    int index =
        entries.indexWhere((MapEntry<String, bool> entry) => entry.value);
    return index != -1 ? index + 1 : 0;
  }

  PropertyServices propertyServices = PropertyServices();
  Rx<bool> isLoading = false.obs;
  RxList<Property> getLandLordPropertiesList = <Property>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Removed TabController initialization
    pagingController.itemList?.clear();
    pagingController.addPageRequestListener((pageKey) {
      getProperties(pageKey);
    });

    // getLandLordProperties();
  }

  final PagingController<int, Property> pagingController =
      PagingController(firstPageKey: 1);

  Future<void> getProperties(int pageKey,
      [Map<String, dynamic>? filters]) async {
    try {
      isLoading.value = true;

      // Include the filters in the API request
      var result =
          await propertyServices.getAllProperties(pageKey, filters: filters);
      isLoading.value = false;
      if (filters != null) {
        print(filters);
      }
      if (result['success'] == true) {
        final List<Property> newItems = (result['payload']['data'] as List)
            .map((json) => Property.fromJson(json))
            .toList();
        final isLastPage =
            result['payload']['current_page'] == result['payload']['last_page'];
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

  void toggleFavorite1(int index, int propertyId) async {
    if (pagingController.itemList == null) return;

    // Retrieve the current service directly from pagingController's itemList
    var service = pagingController.itemList![index];

    // Toggle the isFavorite status based on integer values (0 for not favorite, 1 for favorite)
    int newFavoriteStatus = (service.isFavorite == 1) ? 0 : 1;

    // Update the local state (UI update) to reflect the new status
    service.isFavorite = newFavoriteStatus;

    print("Favorite status: $newFavoriteStatus");

    // Attempt to update the backend with the new favorite status
    try {
      // Check if the property is already favorited (isFavorite == 1)
      bool result;
      if (newFavoriteStatus == 1) {
        // If the property is not in favorites, add it
        result = await propertyServices.addFavoriteProperty(propertyId);
      } else {
        // If the property is in favorites, remove it
        result = await propertyServices.removeFavoriteProperty(propertyId);
      }

      // If the API call fails, throw an exception
      if (!result) {
        throw Exception('API call to update favorite status failed.');
      }
    } catch (error) {
      // If the API call fails, revert the local state to the previous value
      service.isFavorite = (newFavoriteStatus == 1) ? 0 : 1;
      Get.snackbar('Error', 'Could not update favorites. Please try again.');
    }

    // Force the UI to refresh and reflect the change
    pagingController.notifyListeners();
  }



  void resetFilters() {
    // Reset all filter values to their defaults
    isSale.value = false;
    selectedRange.value = "1 sq ft";
    selectedBedroom.value = 1;
    selectedBathrooms.value = 1;
    selectedBothList.value = "1";
    currentRange.value = const RangeValues(1, 1000);

    // Just clear the text controllers instead of disposing them
    minPriceController.text = '';
    maxPriceController.text = '';

    // Reset property type selection
    home.value = true;
    plots.value = false;
    commercial.value = false;

    // Reset all sub-type selections
    var updatedHomeMap = Map<String, bool>.from(selectedHome);
    updatedHomeMap.updateAll((k, v) => false);
    selectedHome.value = updatedHomeMap;

    var updatedPlotsMap = Map<String, bool>.from(selectedPlots);
    updatedPlotsMap.updateAll((k, v) => false);
    selectedPlots.value = updatedPlotsMap;

    var updatedCommercialMap = Map<String, bool>.from(selectedCommercial);
    updatedCommercialMap.updateAll((k, v) => false);
    selectedCommercial.value = updatedCommercialMap;

    // Clear existing items and refresh the list
    pagingController.itemList?.clear();

    // Refresh the form
    formKey.currentState?.reset();

    // Force UI update
    update();

    // Refresh with no filters
    getProperties(1);
  }
}
