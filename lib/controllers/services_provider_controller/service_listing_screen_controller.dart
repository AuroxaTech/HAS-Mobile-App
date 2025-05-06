import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:property_app/models/service_provider_model/all_services.dart';
import 'package:property_app/services/property_services/add_services.dart';

import '../../utils/shared_preferences/preferences.dart';

class ServiceListingScreenController extends GetxController {
  final sheet = GlobalKey();
  final controller = DraggableScrollableController();
  List<String> areaRange = [
    "50 sq ft",
    "100 sq ft",
    "200 sq ft",
    "300 sq ft",
    "400 sq ft"
  ];
  late int currentUserId;
  RxInt selectedArea = 0.obs;
  RxInt selectedBedroom = 1.obs;
  RxInt selectedBathrooms = 1.obs;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  var minPriceController = TextEditingController();
  var serviceNameController = TextEditingController();
  var cityController = TextEditingController();
  var countryController = TextEditingController();
  var maxPriceController = TextEditingController();

  Future<void> _loadCurrentUserId() async {
    currentUserId = await Preferences.getUserID();
  }

  ServiceProviderServices servicesService = ServiceProviderServices();
  Rx<bool> isLoading = false.obs;
  final GlobalKey<ScaffoldState> key = GlobalKey();
  RxList<AllService> allServicesList = <AllService>[].obs;
  AllService? alltServiceOne;

  final PagingController<int, AllService> pagingController =
      PagingController(firstPageKey: 1);

  Future<void> getServices(int pageKey, [Map<String, dynamic>? filters]) async {
    try {
      isLoading.value = true;
      var result =
          await servicesService.getAllServices(pageKey, filters: filters);
      isLoading.value = false;

      if (result['success'] == true) {
        final List<AllService> newItems = [];
        
        // Get the data array from the payload
        final dataList = result['payload']['data'] as List;
        
        // Fetch current user ID
        int currentUserId = await Preferences.getUserID();
        print("Current user ID: $currentUserId");
        
        // Process each service item
        for (var json in dataList) {
          // Create the AllService object from JSON
          AllService service = AllService.fromJson(json);
          
          // Debug the isApplied value from API
          print("Service ID ${service.id} - API isApplied value: ${json['is_applied']}");
          
          // Ensure isApplied is set directly from the API response
          service.isApplied = json['is_applied'] ?? 0;
          
          // Add to our list
          newItems.add(service);
        }

        final isLastPage =
            result['payload']['current_page'] == result['payload']['last_page'];

        if (isLastPage) {
          pagingController.appendLastPage(newItems);
        } else {
          final nextPageKey = pageKey + 1;
          pagingController.appendPage(newItems, nextPageKey);
        }
      } else {
        pagingController.error = Exception('Failed to fetch services');
      }
    } catch (error) {
      isLoading.value = false;
      print("Error fetching services: $error");

      final errorMessage = error.toString();
      pagingController.error = errorMessage;
      rethrow;
    }
  }

  @override
  void onInit() {
    _loadCurrentUserId();
    var data = Get.arguments;
    print("IDDDDDD $data");
    print("Hello");
    pagingController.addPageRequestListener((pageKey) {
      getServices(pageKey);
    });
    //data == null ? null : getService(data);
    super.onInit();
  }

  RxInt page = 1.obs;

  // Future<void> getServices(int pageKey) async {
  //   List<AllService>  list  = <AllService>[];
  //   print("we are in get services");
  //   isLoading.value = true;
  //   var result = await servicesService.getAllServices(pageKey);
  //   print("Service result : $result" );
  //
  //   isLoading.value = false;
  //   for (var data in result['data']["data"]) {
  //     print("Service List :: $data");
  //     list.add(AllService.fromJson(data));
  //   }
  //   allServicesList.value = list;
  // }

  RxInt pageSize = 10.obs;

  Future<void> getService(id) async {
    print("we are in get service");
    isLoading.value = true;
    var result = await servicesService.getService(id: id);
    print("Service : $result");

    isLoading.value = false;
    for (var data in result['data']) {
      print("Service :: $data");
      alltServiceOne = AllService.fromJson(data);
    }
  }

  void toggleFavorite(int userId, int providerId) async {
    isFavorite.value = !isFavorite.value; // Toggle the favorite status
    int favFlag =
        isFavorite.value ? 1 : 2; // 1 for favorite, 2 for not favorite
    bool result = await servicesService.addFavorite(providerId);
    if (!result) {
      // If the API call failed, revert the favorite status
      isFavorite.value = !isFavorite.value;
    }
  }

  var isFavorite = false.obs;

  // void toggleFavorite1(int index, int serviceId) async {
  //   // Toggle the isFavorite status in local data for immediate UI update
  //   var service = allServicesList[index];
  //   bool newFavoriteStatus = !(service.isFavorite ?? false);
  //   service.isFavorite = newFavoriteStatus;
  //   allServicesList[index] = service; // Update the list
  //
  //
  //   // Convert the boolean to an integer for the API
  //   int favFlag = newFavoriteStatus ? 1 : 2; // Assuming 1 is favorite, 0 is not
  //
  //   // Make the API call
  //   bool result = await servicesService.addFavorite(serviceId, favFlag);
  //   if (!result) {
  //     // If the API call fails, revert the local data
  //     service.isFavorite = !newFavoriteStatus;
  //     allServicesList[index] = service;
  //     allServicesList.refresh();
  //     allServicesList.refresh(); // Refresh the observable list to update UI
  //
  //     // Optionally show a message to the user
  //     Get.snackbar('Error', 'Could not update favorites. Please try again.');
  //   }else{
  //    // getServices();
  //   }
  // }

  void toggleFavorite1(int index, int serviceId) async {
    // Safety check to ensure itemList is not null

    print("service_id $serviceId");
    if (pagingController.itemList == null) return;

    // Retrieve the current service directly from pagingController's itemList
    var service = pagingController.itemList![index];

    // Toggle the isFavorite status based on integer values (0 for not favorite, 1 for favorite)
    int newFavoriteStatus = (service.isFavorite == 1) ? 0 : 1;
    service.isFavorite = newFavoriteStatus;

    // Attempt to update the backend with the new favorite status
    try {
      // Make the API call
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
      print(result);
      if (!result) {
        throw Exception('API call to add favorite failed.');
      }
      // If successful, no need to do anything as the local state is already updated
    } catch (error) {
      // If the API call fails, revert the local change
      service.isFavorite = (newFavoriteStatus == 1) ? 0 : 1; // Revert to previous state
      Get.snackbar('Error', 'Could not update favorites. Please try again.');
      rethrow;
    }

    // Force the UI to refresh and reflect the change
    pagingController.notifyListeners();
  }
}
