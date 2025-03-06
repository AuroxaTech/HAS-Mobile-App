import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:property_app/constant_widget/constant_widgets.dart';
import 'package:property_app/models/authentication_model/user_model.dart';
import 'package:property_app/utils/api_urls.dart';
import 'package:property_app/utils/shared_preferences/preferences.dart';
import 'package:property_app/utils/utils.dart';

class ContractController extends GetxController{
  RxString typeing= 'type'.obs;
  RxString payment = 'Payment'.obs;
  RxString propertyType = 'Property Type'.obs;
  RxString paymentType = 'Payment Method'.obs;
  RxString leasedType = 'Leased Type'.obs;
  RxBool check  = false.obs;
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
    fullname: '',
    userName: '',
    email: '',
    phoneNumber: '',
    roleId: "",
    profileimage: '',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    platform: '', deviceToken: '',
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
          Uri.parse("${AppUrls.getUser}/$id",),
        headers: getHeader(userToken: token)
      );

      if (response.statusCode == 200) {
        var data = User.fromJson(jsonDecode(response.body)["data"]);
        print(data);
        userData(data);
        landLordNameController.text = landlordName.value;
        landLordEmailController.text = landlordEmail.value;
        landLordPhoneController.text = phoneNumber.value;
        tenantNameController.text = userData.value.fullname;
        tenantEmailController.text = userData.value.email;
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

   try{
     isLoading.value = true;
     var url = Uri.parse(AppUrls.addContract); // Replace with your actual endpoint
     String utilities = selectedUtilities.join(', ');
     String responsibilities = selectedResponsibility.join(', ');

     var body = jsonEncode({
       "property_id" : propertyId.value,
       "landlord_id" : landlordId.value,
       "landlordName": landLordNameController.text,
       "landlordAddress": landLordEmailController.text,
       "landlordPhone": landLordPhoneController.text,
       "tenantName": tenantNameController.text,
       "tenantAddress": tenantAddressController.text,
       "tenantPhone": tenantPhoneController.text,
       "tenantEmail": tenantEmailController.text,
       "occupants": occupantsController.text,  // Assume this to be an array or string based on your API, adjust accordingly
       "premisesAddress": premisesAddressController.text,
       "propertyType": propertyType.value, // Fill this in with actual data or leave it as default if optional
       "leaseStartDate": leasedStartDateController.text,
       "leaseEndDate": leaseEndDateController.text,
       "leaseType": leasedType.value,
       "rentAmount": rentAmountController.text,
       "rentDueDate": rentDueDateController.text,
       "rentPaymentMethod": paymentType.value, // Fill in the actual data if available
       "securityDepositAmount": securityDepositAmountController.text, // Ensure this is a number; adjust according to actual data
       "includedUtilities": utilities,
       "tenantResponsibilities": responsibilities,
       "emergencyContactName": emergencyContactNameController.text,
       "emergencyContactPhone": emergencyContactPhoneController.text,
       "emergencyContactAddress": emergencyContactAddressController.text,
       "buildingSuperintendentName": buildingSuperintendentNameController.text,
       "buildingSuperintendentAddress": buildingSuperintendentAddressController.text,
       "buildingSuperintendentPhone": buildingSuperintendentPhoneController.text,
       "rentIncreaseNoticePeriod": rentIncreaseNoticePeriodPhoneController.text,
       "noticePeriodForTermination": noticePeriodForTerminationController.text,
       "latePaymentFee": latePaymentFeeController.text,
       "rentalIncentives": rentalIncentivesFeeController.text,
       "additionalTerms": additionalTermsController.text
       // Add more parameters as required by your API
     });
     var response = await http.post(
       url,
       headers: getHeader(userToken: await Preferences.getToken()),
       body: body,
     );
     print(body);
     if (response.statusCode == 200) {
       // Handle successful response
       var jsonData = jsonDecode(response.body);
       print(jsonData);
       Get.back();
       AppUtils.getSnackBar("Success", jsonData["message"]);
       isLoading.value = false;
       print("Successfully posted data");
     } else {
       isLoading.value = false;
       // Handle error
       AppUtils.errorSnackBar("Error", "Not uploaded");
       print("Failed to post data");
       throw Exception('Failed to post contract');
     }
   }catch(e){
     isLoading.value = false;
     print(e);
   }
  }


}