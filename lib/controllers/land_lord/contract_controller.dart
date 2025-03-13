import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:property_app/constant_widget/constant_widgets.dart';
import 'package:property_app/models/authentication_model/user_model.dart';
import 'package:property_app/utils/api_urls.dart';
import 'package:property_app/utils/shared_preferences/preferences.dart';
import 'package:property_app/utils/utils.dart';

class ContractController extends GetxController {
  RxString typeing = 'type'.obs;
  RxString payment = 'Payment'.obs;
  RxString propertyType = 'Property Type'.obs;
  RxString paymentType = 'Payment Method'.obs;
  RxString leasedType = 'Leased Type'.obs;
  RxBool check = false.obs;
  RxInt selectedPropertyType = 1.obs;

  var landLordNameController = TextEditingController();
  var landLordEmailController = TextEditingController();
  var landLordPhoneController = TextEditingController();
  var tenantNameController = TextEditingController();
  var tenantAddressController = TextEditingController();
  var tenantPhoneController = TextEditingController();
  var tenantEmailController = TextEditingController();
  var occupantsController = TextEditingController();
  var premisesAddressController = TextEditingController();
  var leasedStartDateController = TextEditingController();
  var leaseEndDateController = TextEditingController();
  var rentAmountController = TextEditingController();
  var rentDueDateController = TextEditingController();
  // var rentPaymentMethodController = TextEditingController();
  var securityDepositAmountController = TextEditingController();
  // var tenantResponsibilitiesController = TextEditingController();
  var emergencyContactNameController = TextEditingController();
  var emergencyContactPhoneController = TextEditingController();
  var emergencyContactAddressController = TextEditingController();
  var buildingSuperintendentNameController = TextEditingController();
  var buildingSuperintendentAddressController = TextEditingController();
  var buildingSuperintendentPhoneController = TextEditingController();
  var rentIncreaseNoticePeriodPhoneController = TextEditingController();
  var noticePeriodForTerminationController = TextEditingController();
  var latePaymentFeeController = TextEditingController();
  var rentalIncentivesFeeController = TextEditingController();
  var additionalTermsController = TextEditingController();

  RxList<String> selectedUtilities = <String>[].obs;
  RxList<String> selectedResponsibility = <String>[].obs;

  void handleUtilitySelection(List<String> selections) {
    selectedUtilities.value = selections;
  }

  Rx<DateTime> selectedDate = DateTime.now().obs;
  Rx<DateTime> endDate = DateTime.now().obs;
  Rx<DateTime> rentDate = DateTime.now().obs;

  void handleResponsibilitySelection(List<String> selections) {
    selectedResponsibility.value = selections;
  }

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  RxBool isLoading = false.obs;

  void setSelectedOption(int value) {
    selectedPropertyType.value = value;
  }

  var userData = User(
    id: 0,
    fullName: '',
    userName: '',
    email: '',
    phoneNumber: '',
    roleId: '',
    profileImage: '',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    platform: '',
    deviceToken: '',
    address: '',
    postalCode: '',
  ).obs;

  var isLoadingGet = true.obs;
  List<String> ids = [];
  var propertyId = 0.obs;
  var landlordId = "".obs;
  var landlordName = "".obs;
  var landlordEmail = "".obs;
  var phoneNumber = "".obs;
  @override
  void onInit() {
    super.onInit();
    var data = Get.arguments;
    propertyId.value = data[0];
    landlordId.value = data[1].toString();
    landlordName.value = data[2].toString();
    landlordEmail.value = data[3].toString();
    phoneNumber.value = data[4].toString();
    print(propertyId);
    fetchUserData();
  }

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
        var data = User.fromJson(jsonDecode(response.body)["payload"]);
        print(data);
        userData(data);
        landLordNameController.text = landlordName.value;
        landLordEmailController.text = landlordEmail.value;
        landLordPhoneController.text = phoneNumber.value;
        tenantNameController.text = userData.value.fullName;
        tenantEmailController.text = userData.value.email;
        tenantAddressController.text = userData.value.address;
        tenantPhoneController.text = userData.value.phoneNumber;
        isLoadingGet(false);
      } else {
        isLoadingGet(false);
        throw Exception('Failed to load user data');
      }
    } finally {
      isLoadingGet(false);
    }
  }

  Future<void> postContract() async {
    try {
      isLoading.value = true;
      var url = Uri.parse(
          "https://has-backend.wazirafghan.online/api/contract/store");

      String utilities = selectedUtilities.join(', ');
      String responsibilities = selectedResponsibility.join(', ');
      var userId = await Preferences.getUserID();
      var token = await Preferences.getToken();

      print("Token being used: $token");
      print("UserID: $userId");
      print("PropertyID: ${propertyId.value}");

      // **Date Formatting using intl - YYYY/MM/DD**
      DateFormat backendDateFormat =
          DateFormat('yyyy/MM/dd'); // Define the format

      DateTime? startDate;
      DateTime? endDate;
      DateTime? dueDate;

      try {
        startDate = DateFormat('dd-MM-yyyy').parse(leasedStartDateController
            .text); // Parse assuming DD-MM-YYYY format - adjust if needed
        endDate = DateFormat('dd-MM-yyyy').parse(leaseEndDateController
            .text); // Parse assuming DD-MM-YYYY format - adjust if needed
        dueDate = DateFormat('dd-MM-yyyy').parse(rentDueDateController
            .text); // Parse assuming DD-MM-YYYY format - adjust if needed
      } catch (e) {
        print("Date parsing error: $e"); // Handle parsing errors gracefully
        isLoading.value = false;
        AppUtils.errorSnackBar("Error",
            "Invalid date format. Please use DD-MM-YYYY."); // Or your input format
        return; // Stop execution if date parsing fails
      }

      String formattedStartDate =
          backendDateFormat.format(startDate); // Format to YYYY/MM/DD
      String formattedEndDate = backendDateFormat.format(endDate);
      String formattedDueDate = backendDateFormat.format(dueDate);

      var body = {
        "user_id": userId.toString(),
        "property_id": propertyId.value.toString(),
        "landlord_id": landlordId.value.toString(),
        "landlordName": landLordNameController.text,
        "landlordAddress": landLordEmailController.text,
        "landlordPhone": landLordPhoneController.text,
        "tenantName": tenantNameController.text,
        "tenantAddress": tenantAddressController.text,
        "tenantPhone": tenantPhoneController.text,
        "tenantEmail": tenantEmailController.text,
        "occupants": occupantsController.text,
        "premisesAddress": premisesAddressController.text,
        "propertyType": propertyType.value,
        "leaseStartDate": formattedStartDate, // Use formatted dates
        "leaseEndDate": formattedEndDate, // Use formatted dates
        "leaseType": leasedType.value,
        "rentAmount": rentAmountController.text,
        "rentDueDate": formattedDueDate, // Use formatted dates
        "rentPaymentMethod": paymentType.value,
        "securityDepositAmount": securityDepositAmountController.text,
        "includedUtilities": utilities,
        "tenantResponsibilities": responsibilities,
        "emergencyContactName": emergencyContactNameController.text,
        "emergencyContactPhone": emergencyContactPhoneController.text,
        "emergencyContactAddress": emergencyContactAddressController.text,
        "buildingSuperintendentName": buildingSuperintendentNameController.text,
        "buildingSuperintendentAddress":
            buildingSuperintendentAddressController.text,
        "buildingSuperintendentPhone":
            buildingSuperintendentPhoneController.text,
        "rentIncreaseNoticePeriod":
            rentIncreaseNoticePeriodPhoneController.text,
        "noticePeriodForTermination":
            int.tryParse(noticePeriodForTerminationController.text),
        "latePaymentFee": latePaymentFeeController.text,
        "rentalIncentives": rentalIncentivesFeeController.text,
        "additionalTerms": additionalTermsController.text,
        "status": "0"
      };

      print(
          "Request Body (x-www-form-urlencoded) with Formatted Dates: $body"); // Print with dates

      var response = await http.post(
        url,
        headers:
            await header(userToken: token, contentType: 'application/json'),
        body: jsonEncode(body),
      );

      print("Response Headers: ${response.headers}");
      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 201) {
        var jsonData = jsonDecode(response.body);
        print(jsonData);
        Get.back();
        AppUtils.getSnackBar("Success", jsonData["message"]);
      } else {
        AppUtils.errorSnackBar("Error", "Not uploaded");
        throw Exception('Failed to post contract');
      }
    } catch (e) {
      isLoading.value = false;
      print("Error during postContract: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<Map<String, String>> header(
      {required String? userToken,
      String contentType = 'application/json'}) async {
    // **Add contentType parameter**
    Map<String, String> headers = {
      'Content-Type': contentType, // **Use contentType parameter**
    };

    if (userToken != null) {
      headers['Authorization'] = 'Bearer $userToken';
    }
    print("Headers being sent: $headers");
    return headers;
  }
}
