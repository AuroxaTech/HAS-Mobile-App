import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:property_app/services/auth_services/auth_services.dart';
import 'package:property_app/utils/utils.dart';

import '../../services/notification_services/notification_services.dart';

class SignUpController extends GetxController{
  RxString userRoleValue = 'Select Role'.obs;
  RxString noOfPropertiesValue = 'No of Properties'.obs;
  RxString propertiesTypeValue = 'Choose Property Type'.obs;
  RxInt propertyTypeIndex = 0.obs;
  final items = ['Choose Property Type', "Apartment", "House", "Condo", "Townhouse", "Other"];
  RxString contactMethodValue = 'Preferred Contact Method'.obs;
  RxString onRentValue = 'Select last status'.obs;
  RxString electricalValue = 'Choose service'.obs;
  RxString yesValue = 'Any Certificate ?'.obs;
  RxBool isSale = false.obs;
  RxInt selectedArea = 0.obs;
  RxString selectedRange = "50 sq ft".obs;
  RxInt selectedBedroom = 1.obs;
  RxInt selectedBathrooms = 1.obs;
  List<String> areaRange = [
    "50 sq ft",
    "100 sq ft",
    "200 sq ft",
    "300 sq ft",
    "400 sq ft"
  ] ;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> formKeyDetail = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  RxBool nameField = true.obs;
  TextEditingController emailController = TextEditingController();
  RxBool emailField = true.obs;
  TextEditingController phoneController = TextEditingController();
  RxBool phoneField = true.obs;
  TextEditingController passwordController = TextEditingController();
  RxBool passwordField = true.obs;
  RxBool passwordObscure = true.obs;
  TextEditingController confirmPasswordController = TextEditingController();
  RxBool cPasswordObscure = true.obs;
  RxBool isConfirmPasswordValid = true.obs;

  TextEditingController lastTenancyController = TextEditingController();
  RxBool lastTenancyField = true.obs;
  TextEditingController lastLandLordController = TextEditingController();
  RxBool lastLandLordField = true.obs;
  TextEditingController lastLandLordContactController = TextEditingController();
  RxBool lastLandLordContactField = true.obs;
  TextEditingController occupationController = TextEditingController();
  RxBool occupationField = true.obs;
  TextEditingController leasedDurationController = TextEditingController();
  RxBool leasedDurationField = true.obs;
  TextEditingController noOfOccupants = TextEditingController();
  RxBool occupantsField = true.obs;

  TextEditingController experienceController = TextEditingController();
  RxBool experienceField = true.obs;
  //Add Detail screen
  TextEditingController newYorkController = TextEditingController();
  RxBool newYorkField = true.obs;
  TextEditingController amountController = TextEditingController();
  RxBool amountField = true.obs;
  TextEditingController streetController = TextEditingController();
  RxBool streetField = true.obs;
 TextEditingController description = TextEditingController();



  @override
  void onInit() {
    super.onInit();
    print("hello controller");
  }





  @override
  void onClose() {
    nameController.dispose();
    super.onClose();
  }


  RxList<XFile> images = <XFile>[].obs;
  Rx<XFile?> certificateImage = Rx<XFile?>(null);
  Rx<XFile?> profileImage = Rx<XFile?>(null);
  Rx<XFile?> frontCNICImage = Rx<XFile?>(null);
  Rx<XFile?> backCNICImage = Rx<XFile?>(null);

  void pickProfileImage() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      profileImage.value = XFile(pickedFile.path);
    }
  }

  void pickCertificate() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      certificateImage.value = XFile(pickedFile.path);
    }
  }
  void frontCNIC() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      frontCNICImage.value = XFile(pickedFile.path);
    }
  }

  void backCNIC() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      backCNICImage.value = XFile(pickedFile.path);
    }
  }

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

  DateTime selectedDate = DateTime.now();
  Rx<TimeOfDay> startTime = const TimeOfDay(hour: 9, minute: 0).obs;
  Rx<TimeOfDay> endTime = const TimeOfDay(hour: 17, minute: 0).obs;

  Future<void> selectDateTime(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Select Start Time'),
                onTap: () async {
                  //Navigator.pop(context);

                  await _selectTime(context, true);
                },
              ),
              ListTile(
                title: const Text('Select End Time'),
                onTap: () async {
                  Navigator.pop(context);
                  await _selectTime(context, false);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2021),
      lastDate: DateTime(2030),
    );

    if (picked != null && picked != selectedDate) {
        selectedDate = picked;
    }
  }
  NotificationServices notificationServices = NotificationServices();

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
  AuthServices authServices = AuthServices();
  RxBool isLoading = false.obs;
  RxString errorMessage = "".obs;
  Future<void> registerVisitor(
      BuildContext context,
      String fullName,
      String email,
      String phoneNumber,
      String password,
      String conPassword,
      {XFile? profileImage,}
      ) async {
    isLoading.value = true;
    try {
      var deviceId = await notificationServices.getDeviceToken();
      print("deviceToken : $deviceId" );

      var data = await authServices.registerVisitor(
        fullName: fullName,
        email: email,
        phoneNumber: phoneNumber,
        password: password,
        conPassword: conPassword,
        profileImage: profileImage,
        deviceToken: deviceId,
        platform: Platform.isAndroid ? "android" : "ios",
      );

      print("Data : $data");

      if (data['status'] == true) {
        // Handle success
        isLoading.value = false;
        Get.back();
        AppUtils.getSnackBar("Success", data["messages"]);

      } else {
        // Handle error
        isLoading.value = false;
        AppUtils.errorSnackBar("Error", data['messages']["email"][0]);
      }
    } catch (e) {
      // Handle exception
      print(e);
      isLoading.value = false;
    }
  }

  Future<void> registerProperty({
  required String fullName,
  required String email,
  required String phoneNumber,
  required String password,
  required String cPassword,
  required int roleId,
  XFile? profileImage,
  required int type,
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
  required int noOfProperty,
  required String propertyType,
  required String subType,
  required String availabilityStartTime,
  required String availabilityEndTime,
  required String description,
  }) async {
    isLoading.value = true;

    try {
      var deviceId = await notificationServices.getDeviceToken();
      print("deviceToken : $deviceId" );
      var data = await authServices.registerProperty(
        fullName: fullName,
        email: email,
        password: password,
        phoneNumber: phoneNumber,
        deviceToken: deviceId,
        platform: Platform.isAndroid ? "android" : "ios",
        cPassword: cPassword,
        roleId: roleId,
        profileImage: profileImage,
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
        noOfProperty: noOfProperty,
        propertyType: propertyType,
        availabilityStartTime: availabilityStartTime,
        availabilityEndTime: availabilityEndTime,
        description: description,
        subtype: subType
      );

      print("Data : $data");

      if (data['status'] == true) {
        // Handle success scenario
        debugPrint("Print if ${data["messages"]}");
        Get.back();
        Get.back();
        AppUtils.getSnackBar("Success",data["messages"]);

        isLoading.value = false;
      } else {
        // Handle error scenario
        isLoading.value = false;
        AppUtils.errorSnackBar("Error", data['messages']["email"][0]);
      }
    } catch (e) {
      // Handle general errors
      print(e);
      isLoading.value = false;
      AppUtils.errorSnackBar("Error", e.toString());
      rethrow;
    }
  }

  //Service Provider


  Future<void> registerServiceProvider({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String password,
    required String cPassword,
    XFile? profileImage,
    required String services,
    required String yearExperience,
    required String availabilityStartTime,
    required String availabilityEndTime,
    required XFile cnicFront,
    required XFile cnicBack,
    String? certification,
    XFile? certificationFile,
  }) async {
    isLoading.value = true;

  //  try {
      var deviceId = await notificationServices.getDeviceToken();
      print("deviceToken : $deviceId" );

      var data = await authServices.registerServiceProvider(
        fullName: fullName,
        email: email,
        phoneNumber: phoneNumber,
        password: password,
        cPassword: cPassword,
        deviceToken: deviceId,
        platform: Platform.isAndroid ? "android" : "ios",
        profileImage: profileImage,
        services: services,
        yearExperience: yearExperience,
        availabilityStartTime: availabilityStartTime,
        availabilityEndTime: availabilityEndTime,
        cnicFront: cnicFront,
        cnicBack: cnicBack,
        certification: certification,
        certificationFile: certificationFile,
      );


      if (data['status'] == true) {
        isLoading.value = false;
        print("Data : $data");
        Get.back();
        AppUtils.getSnackBar("Success",data["messages"]);

      } else {
        isLoading.value = false;
        AppUtils.errorSnackBar("Error", data['messages']["email"][0]);
      }
    // } catch (e) {
    //   print(e);
    //   isLoading.value = false;
    //   AppUtils.getSnackBar("Error", "Failed to register service provider");
    //   rethrow;
    // }
  }

  Future<void> registerTenant({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String password,
    required String cPassword,
    required int roleId,
    XFile? profileImage,
    required int lastStatus,
    String? lastLandlordName,
    String? lastTenancy,
    String? lastLandlordContact,
    String? occupation,
    String? leasedDuration,
    int? noOfOccupants,
  }) async {
    isLoading.value = true;
    try {
      var deviceId = await notificationServices.getDeviceToken();
      var data = await authServices.registerTenant(
        fullName: fullName,
        email: email,
        phoneNumber: phoneNumber,
        password: password,
        cPassword: cPassword,
        roleId: roleId,
        profileImage: profileImage,
        lastStatus: lastStatus,
        lastLandlordName: lastLandlordName,
        lastTenancy: lastTenancy,
        lastLandlordContact: lastLandlordContact,
        occupation: occupation,
        leasedDuration: leasedDuration,
        noOfOccupants: noOfOccupants,
        deviceToken: deviceId,
        platform: Platform.isAndroid ? "android" : "ios",
      );

      print("Data : $data");

      if (data['status'] == true) {
        isLoading.value = false;
        Get.back();
        AppUtils.getSnackBar("Success",data['messages']);

      } else {
        isLoading.value = false;
        AppUtils.errorSnackBar("Error",data['messages']["email"][0]);

      }
    } catch (e) {

      isLoading.value = false;
      AppUtils.errorSnackBar("Error", "Failed to register tenant");
    }
  }

}
