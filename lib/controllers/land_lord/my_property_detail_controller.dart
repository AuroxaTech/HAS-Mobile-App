import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/propert_model/ladlord_property_model.dart';
import '../../models/service_provider_model/get_services.dart';
import '../../services/property_services/add_services.dart';
import '../../services/property_services/get_property_services.dart';
import '../../utils/utils.dart';

class MyPropertyDetailController extends GetxController {

  RxBool isSale = false.obs;
  RxInt selectedArea = 0.obs;
  RxInt selectedBedroom = 1.obs;
  RxInt selectedBathrooms = 1.obs;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  List<String> areaRange = [
    "3",
    "5",
    "7",
    "10",
    "12"
  ];
  TextEditingController newYorkController = TextEditingController();
  RxBool newYorkField = true.obs;
  TextEditingController amountController = TextEditingController();
  RxBool amountField = true.obs;
  TextEditingController streetController = TextEditingController();
  TextEditingController description = TextEditingController();
  RxBool streetField = true.obs;

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

  String getSelectedHomeSubType() {
    String selectedKey = selectedHome.entries
        .firstWhere((MapEntry<String, bool> entry) => entry.value, orElse: () => MapEntry('', false))
        .key;
    return selectedKey;
  }

  String getSelectedPlotsSubType() {
    String selectedKey = selectedPlots.entries
        .firstWhere((MapEntry<String, bool> entry) => entry.value, orElse: () => MapEntry('', false))
        .key;
    return selectedKey;
  }

  String getSelectedCommercialSubType() {
    String selectedKey = selectedCommercial.entries
        .firstWhere((MapEntry<String, bool> entry) => entry.value, orElse: () => MapEntry('', false))
        .key;
    return selectedKey;
  }

  RxList<XFile> pickedImages = <XFile>[].obs;

  void pickImages() async {
    final imagePicker = ImagePicker();
    final pickedFiles = await imagePicker.pickMultiImage();

    if (pickedFiles != null) {
      pickedImages.addAll(pickedFiles);
    }
  }

  void removeImage(int index) {
    pickedImages.removeAt(index);
  }
  void removeElect() {
    electBill.value = null;
  }

  Rx<XFile?> electBill = Rx<XFile?>(null);

  void pickElectImage() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      electBill.value = XFile(pickedFile.path);
    }
  }


  final sheet = GlobalKey();
  final controller = DraggableScrollableController();
  final PageController pageController = PageController();
  PropertyServices propertyService = PropertyServices();
  Rx<bool> isLoading = false.obs;
  Rx<Property?> getPropertyOne = Rx<Property?>(null);

  List<String> images = [];
  RxInt id = 0.obs;
  @override
  void onInit() {
    var data = Get.arguments;
    print("IDDDDDD $data");
    print("Hello");
    id.value = data;
    print("iddd ${ id.value }");

    getService(id: data);
    super.onInit();
  }


  Future<void> getService({required int id}) async {
    print("we are in get service");
    isLoading.value = true;
    var result = await propertyService.getProperty(id: id);
    print("Service Result : $result");

    isLoading.value = false;

    if (result['payload'] != null && result['payload'] is Map) {
      var data = result['payload'] as Map<String, dynamic>;
      print("Data :: $data");

      if (getPropertyOne != null) {

        getPropertyOne.value = Property.fromJson(data);
        String imagesString = getPropertyOne.value!.images.toString();
        List<String> imageList = imagesString.split(',');
        images = imageList;
        newYorkController.text = getPropertyOne.value!.city;
        amountController.text = getPropertyOne.value!.amount;
        streetController.text = getPropertyOne.value!.address;
        // selectedBathrooms.value = int.parse(getPropertyOne.value!.bathroom);
        // selectedBedroom.value = int.parse(getPropertyOne.value!.bedroom);
        // selectedArea.value = int.parse(getPropertyOne.value!.areaRange);
      } else {
        isLoading.value = false;
        print("getPropertyOne is null");
      }
    } else {
      isLoading.value = false;
      print("Invalid or null data format");
      // Handle other cases if necessary
    }
  }

  Future<void> updateProperty({
    required String type,
    required String city,
    required double amount,
    required String address,
    required double lat,
    required double long,
    required String areaRange,
    required int bedroom,
    required int bathroom,
    required XFile electricityBill,
    required List<XFile> propertyImages,
    required String propertyType,
    required String propertySubType,
    // required int noOfProperty,
    // required String propertyType,
    // required String availabilityStartTime,
    // required String availabilityEndTime,
    required String description,
  }) async {
    isLoading.value = true;

    try {
      var data = await propertyService.updateProperty(
        id: id.value,
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
        propertyType: propertyType,
        propertySubType: propertySubType,
        // noOfProperty: noOfProperty,
        // propertyType: propertyType,
        // availabilityStartTime: availabilityStartTime,
        // availabilityEndTime: availabilityEndTime,
        description: description,
      );

      print("Data : $data");

      if (data['success'] == true) {
        // Handle success scenario
        debugPrint("Print if ${data["messages"]}");
        Get.back();
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
      AppUtils.errorSnackBar("Error", e.toString());
      rethrow;
    }
  }


  Future<void> deleteService({required int id}) async {
    print("we are in delete service");
    isLoading.value = true;
    var result = await propertyService.deleteProperty(id: id);
    print("Service Result : $result");

    isLoading.value = false;

    if (result['success'] == true) {
        isLoading.value = false;
        Get.back();
        Get.back();
       AppUtils.getSnackBar("Delete", result['message']);
    } else {
        isLoading.value = false;
        print("getPropertyOne is null");
        AppUtils.errorSnackBar("Error", result['message']);
      }
     isLoading.value = false;
    }
}