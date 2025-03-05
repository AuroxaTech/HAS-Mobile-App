import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:property_app/services/property_services/get_property_services.dart';

import '../../utils/utils.dart';

class AddPropertyController extends GetxController{
  RxBool isSale = false.obs;
  RxString selectedRange = "1 sq ft".obs;
  RxInt selectedBedroom = 1.obs;
  RxInt selectedBathrooms = 1.obs;
  RxString selectedBothList = "1".obs;
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
  ] ;
  var currentRange = const RangeValues(1, 1000).obs;

  void updateRangeValues(RangeValues values) {
    currentRange.value = values;
  }

  TextEditingController newYorkController = TextEditingController();
  RxBool newYorkField = true.obs;
  TextEditingController amountController = TextEditingController();
  RxBool amountField = true.obs;
  TextEditingController streetController = TextEditingController();
  TextEditingController description = TextEditingController();
  RxBool streetField = true.obs;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  RxBool home = true.obs;
  RxBool plots = false.obs;
  RxBool commercial = false.obs;

  String selectedAddress = "";
  double selectedLat = 0.0;
  double selectedLng = 0.0;

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

  // String getSelectedHomeSubType() {
  //   String selectedKey = selectedHome.entries
  //       .firstWhere((MapEntry<String, bool> entry) => entry.value, orElse: () => MapEntry('', false))
  //       .key;
  //   return selectedKey;
  // }

  int getSelectedHomeSubTypeIndex() {
    List<MapEntry<String, bool>> entries = selectedHome.entries.toList();

    int index = entries.indexWhere((MapEntry<String, bool> entry) => entry.value);

    return index != -1 ? index + 1 : 0;
  }

  // String getSelectedPlotsSubType() {
  //   String selectedKey = selectedPlots.entries
  //       .firstWhere((MapEntry<String, bool> entry) => entry.value, orElse: () => MapEntry('', false))
  //       .key;
  //   return selectedKey;
  // }

  int getSelectedPlotsSubTypeIndex() {
    List<MapEntry<String, bool>> entries = selectedPlots.entries.toList();

    int index = entries.indexWhere((MapEntry<String, bool> entry) => entry.value);

    return index != -1 ? index + 1 : 0;
  }

  // String getSelectedCommercialSubType() {
  //   String selectedKey = selectedCommercial.entries
  //       .firstWhere((MapEntry<String, bool> entry) => entry.value, orElse: () => MapEntry('', false))
  //       .key;
  //   return selectedKey;
  // }
  int getSelectedCommercialSubTypeIndex() {
    // Convert map entries to a list
    List<MapEntry<String, bool>> entries = selectedCommercial.entries.toList();

    // Find the index of the selected entry
    int index = entries.indexWhere((MapEntry<String, bool> entry) => entry.value);

    // If found, return index + 1 to start counting from 1, else return 0
    return index != -1 ? index + 1 : 0;
  }

  RxList<XFile> images = <XFile>[].obs;
  void pickImages() async {
    final imagePicker = ImagePicker();
    final pickedFiles = await imagePicker.pickMultiImage();

    if (pickedFiles != null) {
      images.addAll(pickedFiles);
    }
  }
  void removeImage(int index) {
    images.removeAt(index);
  }

  @override
  void onInit() {
    super.onInit();
  }
  RxBool isLoading = false.obs;

  PropertyServices propertyServices = PropertyServices();

  Future<void> addProperty({
    required String type,
    required String city,
    required double amount,
    required String address,
    required double lat,
    required double long,
    required String areaRange,
    required int bedroom,
    required String bathroom,
    required XFile electricityBill,
    required List<XFile> propertyImages,
    required String description,
    required String propertyType,
    required String propertySubType,
  }) async {
    isLoading.value = true;

    try {
      var data = await propertyServices.addProperty(
        type: type,
        city: city,
        amount: amount,
        address: address,
        lat: lat,
        long: long,
        areaRange: areaRange,
        bedroom: bedroom,
        bathroom: bathroom,
        electricityBill: electricityBill,
        propertyImages: propertyImages,
        description: description,
        propertySubType: propertySubType,
        propertyType: propertyType,
      );

      print("Data : $data");

      if (data['success'] == true) {
        // Handle success scenario
        debugPrint("Print if ${data["message"]}");
        Get.back();
        Get.back();
        AppUtils.getSnackBar("Success",data["message"]);

        isLoading.value = false;
      } else {
        // Handle error scenario
        isLoading.value = false;
        AppUtils.errorSnackBar("Error", data['message']);
      }
    } catch (e) {
      // Handle general errors
      print(e);

      isLoading.value = false;
      rethrow;
     // AppUtils.getSnackBar("Error", e.toString());
    }
  }

}