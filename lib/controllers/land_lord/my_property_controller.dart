import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_app/models/propert_model/ladlord_property_model.dart';
import 'package:property_app/services/property_services/get_property_services.dart';
import 'package:property_app/utils/shared_preferences/preferences.dart';

class MyPropertyController extends GetxController{

  final sheet = GlobalKey();
  final controller = DraggableScrollableController();
  List<String> areaRange = [
    "50 sq ft",
    "100 sq ft",
    "200 sq ft",
    "300 sq ft",
    "400 sq ft"
  ];
  RxInt selectedArea = 0.obs;
  RxInt selectedBedroom = 1.obs;
  RxInt selectedBathrooms = 1.obs;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

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

  @override
  void onInit() {
    getLandLordProperties();
    super.onInit();
  }

 Future<void> getLandLordProperties() async {
    List<Property> list = <Property>[];
    print("we are in land lord property:");
    isLoading.value = true;
    var uId = await Preferences.getUserID();
    print(uId);
    
    try {
      var result = await propertyServices.getLandLordProperties(userId: uId);
      print("property result: $result");
      
      if (result["success"] == true && result["payload"] != null) {
        isLoading.value = false;
        
        // Check if payload contains a 'data' field (new API structure)
        if (result["payload"] is Map && result["payload"]["data"] != null) {
          // New API structure: payload is an object with a data array
          var propertiesData = result["payload"]["data"];
          
          if (propertiesData is List) {
            for (var data in propertiesData) {
              print("property List :: $data");
              list.add(Property.fromJson(data));
            }
            getLandLordPropertiesList.value = list;
          } else {
            print("Error: properties data is not a list");
            getLandLordPropertiesList.value = [];
          }
        } else {
          // Fallback to old structure if needed
          print("Warning: Unexpected payload structure");
          getLandLordPropertiesList.value = [];
        }
      } else {
        isLoading.value = false;
        print("Error: API returned success=false or null payload");
        getLandLordPropertiesList.value = [];
      }
    } catch (e) {
      print("Exception in getLandLordProperties: $e");
      isLoading.value = false;
      getLandLordPropertiesList.value = [];
    }
  }
}