import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:property_app/utils/shared_preferences/preferences.dart';

import '../../constant_widget/constant_widgets.dart';
import '../../models/authentication_model/user_model.dart';
import '../../services/property_services/add_services.dart';
import '../../utils/api_urls.dart';
import '../../utils/utils.dart';

class NewServiceRequestScreenController extends GetxController {
  RxString propertyType = "Choose Property Type".obs;
  RxInt propertyTypeIndex = 0.obs;
  final items = [
    'Choose Property Type',
    "Apartment",
    "House",
    "Condo",
    "Townhouse",
    "Other"
  ];

  List<dynamic> data = [];

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  var nameController = TextEditingController();
  var contactController = TextEditingController();
  var emailController = TextEditingController();
  var addressController = TextEditingController();
  var descriptionController = TextEditingController();
  var instructionController = TextEditingController();
  var priceController = TextEditingController();
  var postalCodeController = TextEditingController();

  RxBool isLoading = false.obs;

  Rx<TimeOfDay> startTime = const TimeOfDay(hour: 9, minute: 0).obs;
  Rx<TimeOfDay> endTime = const TimeOfDay(hour: 17, minute: 0).obs;
  RxString selectedWeekdayRange = ''.obs;

  final List<String> weekdayRanges = [
    'Monday to Friday',
    'Full Week',
    "Request Now"
  ];

  Future<void> selectDateTime(BuildContext context) async {
    // Open the weekday range selection first
    await _selectWeekdayRange(context);

    // If selectedWeekdayRange is not 'Request Now', show time picker
    if (selectedWeekdayRange.value != 'Request Now') {
      await _selectTime(context, true); // Start time
      await _selectTime(context, false); // End time
    }
  }

  Future<void> _selectWeekdayRange(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: weekdayRanges.map((range) {
            return ListTile(
              title: Text(range),
              onTap: () {
                selectedWeekdayRange.value = range;
                Navigator.pop(context);
              },
            );
          }).toList(),
        );
      },
    );
  }

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStartTime ? startTime.value : endTime.value,
    );

    if (picked != null) {
      if (isStartTime) {
        startTime.value = picked;
      } else {
        endTime.value = picked;
      }
    }
  }

  @override
  void onInit() {
    data = Get.arguments;
    fetchUserData();
    print(data);
    super.onInit();
  }

  var userData = User(
    id: 0,
    fullname: '',
    userName: '',
    email: '',
    phoneNumber: '',
    roleId: 0,
    profileimage: '',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    platform: '',
    deviceToken: '',
  ).obs;

  var isLoadingGet = true.obs;
  var propertyId = 0.obs;

  Future<void> fetchUserData() async {
    try {
      isLoadingGet(true);
      var id = await Preferences.getUserID();
      var token = await Preferences.getToken();
      final response = await http.get(
          Uri.parse(
            "${AppUrls.getUser}/$id",
          ),
          headers: getHeader(userToken: token));

      if (response.statusCode == 200) {
        var data = User.fromJson(jsonDecode(response.body)["data"]);
        print(data.profileimage);
        userData(data);

        nameController.text = userData.value.fullname;
        emailController.text = userData.value.email;
        contactController.text = userData.value.phoneNumber;
        isLoadingGet(false);
      } else {
        isLoadingGet(false);
        throw Exception('Failed to load user data');
      }
    } finally {
      isLoadingGet(false);
    }
  }

  Future<void> newServiceRequest({
    required String serviceId,
    required String serviceProviderId,
    required String address,
    required double lat,
    required double lng,
    required int propertyType,
    required int price,
    required String date,
    required String time,
    required String description,
    required String additionalInfo,
    required int postalCode,
    required int isApplied,
  }) async {
    isLoading.value = true;

    try {
      var data = await ServiceProviderServices().newServiceRequest(
        serviceId: serviceId,
        serviceProviderId: serviceProviderId,
        address: address,
        lat: lat,
        lng: lng,
        propertyType: 1,
        date: date,
        time: time,
        description: description,
        additionalInfo: additionalInfo,
        price: price,
        postalCode: postalCode,
        isApplied: isApplied,
      );

      if (kDebugMode) {
        print("Data : $data");
      }

      if (data['status'] == true) {
        isLoading.value = false;
        // Handle success scenario
        Get.back();
        AppUtils.getSnackBar("Success", data['message']);
      } else {
        isLoading.value = false;
        // Handle error scenario
        AppUtils.errorSnackBar("Error", data['message']);
      }
    } catch (e) {
      isLoading.value = false;
      print(e);

      // Handle general errors
      AppUtils.errorSnackBar("Error", "Failed to add service");
    }
  }
}
