import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:property_app/services/auth_services/auth_services.dart';
import 'package:property_app/utils/utils.dart';

import '../../services/notification_services/notification_services.dart';

class SignUpController extends GetxController {
  RxString userRoleValue = 'Select Role'.obs;
  RxString noOfPropertiesValue = 'No of Properties'.obs;
  RxString propertiesTypeValue = 'Choose Property Type'.obs;
  RxInt propertyTypeIndex = 0.obs;
  final items = [
    'Choose Property Type',
    "Apartment",
    "House",
    "Condo",
    "Townhouse",
    "Other"
  ];
  RxString contactMethodValue = 'Preferred Contact Method'.obs;
  RxString onRentValue = 'Select last status'.obs;
  RxString leasedDuration = 'Select Leased Duration'.obs;
  RxString noOfOccupant = 'Number of Occupant'.obs;
  RxString electricalValue = 'Choose service'.obs;
  RxString yesValue = 'Any Certificate ?'.obs;
  RxBool isSale = false.obs;
  RxInt selectedArea = 0.obs;
  RxString selectedRange = "1 sq ft".obs;
  RxString selectedBothList = "1".obs;
  RxInt selectedBedroom = 1.obs;
  RxInt selectedBathrooms = 1.obs;
  List<String> areaRange = [
    "50 sq ft",
    "100 sq ft",
    "200 sq ft",
    "300 sq ft",
    "400 sq ft"
  ];
  var currentRange = const RangeValues(1, 1000).obs;

  void updateRangeValues(RangeValues values) {
    currentRange.value = values;
  }

  var map = {};

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
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> formKeyDetail = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController postalCode = TextEditingController();
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
  TextEditingController postalAddressController = TextEditingController();
  RxBool streetField = true.obs;
  TextEditingController description = TextEditingController();

  String phone = "";
  String countryCode = "";
  String addressPostalCode = "";
  String selectedAddress = "";
  double selectedLat = 0.0;
  double selectedLng = 0.0;
  @override
  void onInit() {
    super.onInit();
    print("hello controller");
  }

  @override
  void onClose() {
    nameController.dispose();
    userNameController.dispose();
    super.onClose();
  }

  RxList<XFile> images = <XFile>[].obs;
  Rx<XFile?> certificateImage = Rx<XFile?>(null);
  Rx<XFile?> profileImage = Rx<XFile?>(null);
  Rx<XFile?> frontCNICImage = Rx<XFile?>(null);
  Rx<XFile?> backCNICImage = Rx<XFile?>(null);

  void pickProfileImage() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 70);

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

  NotificationServices notificationServices = NotificationServices();
  void removeImage(int index) {
    images.removeAt(index);
  }

  Rx<TimeOfDay> startTime = const TimeOfDay(hour: 9, minute: 0).obs;
  Rx<TimeOfDay> endTime = const TimeOfDay(hour: 17, minute: 0).obs;
  RxString selectedWeekdayRange = ''.obs;

  final List<String> weekdayRanges = ['Monday to Friday', 'Full Week'];

  Future<void> selectDateTime(BuildContext context) async {
    await _selectWeekdayRange(context);
    await _selectTime(context, true);
    await _selectTime(context, false);
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

  Rx<PlatformFile?> pickFile = Rx<PlatformFile?>(null);
  void pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );
    if (result != null) {
      pickFile.value = result.files.first;
    } else {
      // User canceled the picker
    }
  }

  Icon getFileIcon(String fileName) {
    if (fileName.endsWith('.pdf')) {
      return const Icon(
        Icons.picture_as_pdf,
        size: 35,
      );
    } else if (fileName.endsWith('.doc') || fileName.endsWith('.docx')) {
      return const Icon(
        Icons.description,
        size: 35,
      );
    } else {
      return const Icon(Icons.insert_drive_file);
    }
  }

  AuthServices authServices = AuthServices();
  RxBool isLoading = false.obs;
  RxString errorMessage = "".obs;

  Future<void> registerVisitor(
    BuildContext context,
    String fullName,
    String userName,
    String email,
    String phoneNumber,
    String address,
    String postalCode,
    String password,
    String conPassword, {
    XFile? profileImage,
  }) async {
    isLoading.value = true;

    try {
      // Step 1: Check if the email is already in use
      //var emailCheckResponse = await authServices.checkEmailExists(email);

      // if (emailCheckResponse['exists'] == true) {
      //   // If email already exists, show an error message and return
      //   isLoading.value = false;
      //   AppUtils.errorSnackBar("Error", "Email is already registered.");
      //   return;
      // }

      // Step 2: If email is not registered, proceed with registration
      // var deviceId = await notificationServices.getDeviceToken();
      // print("deviceToken : $deviceId");

      var registrationData = await authServices.registerVisitor(
        fullName: fullName,
        userName: userName,
        email: email,
        phoneNumber: phoneNumber,
        address: address,
        postalCode: postalCode,
        password: password,
        conPassword: conPassword,
        profileImage: profileImage,
        deviceToken: "deviceId",
        platform: Platform.isAndroid ? "android" : "ios",
      );

      if (registrationData['status'] == true) {
        // Registration successful
        isLoading.value = false;
        AppUtils.getSnackBar(
            "Success", "Registration successful. You can now log in.");
      } else {
        // If registration failed, show error message
        isLoading.value = false;
        AppUtils.errorSnackBar(
            "Error", registrationData['messages']["email"][0]);
      }
    } catch (e) {
      // Handle exception
      print(e);
      isLoading.value = false;
      AppUtils.errorSnackBar(
          "Error", "Something went wrong. Please try again.");
    }
  }

  Future<void> registerProperty({
    required String fullName,
    required String userName,
    required String email,
    required String phoneNumber,
    required String password,
    required String cPassword,
    required int roleId,
    XFile? profileImage,
    required int type,
    required String city,
    required double amount,
    String? address,
    required double lat,
    required double long,
    required String areaRange,
    required int bedroom,
    required String bathroom,
    required XFile electricityBill,
    required List<XFile> propertyImages,
    required int noOfProperty,
    required String propertyType,
    required String subType,
    required String availabilityStartTime,
    required String availabilityEndTime,
    required String description,
    String? postalCode,
  }) async {
    isLoading.value = true;

    try {
      var deviceId;
      if (Platform.isAndroid) {
        deviceId = await notificationServices.getDeviceToken();
      } else {
        deviceId = await notificationServices.getIOSDeviceToken();
      }
      print("deviceToken : $deviceId");
      var data = await authServices.registerProperty(
          fullName: fullName,
          userName: userName,
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
          subtype: subType,
          postalCode: postalCode);

      print("Data : $data");

      if (data['status'] == true) {
        // Handle success scenario
        debugPrint("Print if ${data["messages"]}");
        Get.back();
        Get.back();
        AppUtils.getSnackBar("Success", data["messages"]);

        isLoading.value = false;
      } else {
        // Handle error scenario
        isLoading.value = false;
        if (data['messages'] != null) {
          if (data['messages']['username'] != null) {
            // Show the username error message
            AppUtils.errorSnackBar("Error", data['messages']['username'][0]);
          } else if (data['messages']['email'] != null) {
            // Show the email error message
            AppUtils.errorSnackBar("Error", data['messages']['email'][0]);
          } else {
            // Show a general error message if neither username nor email has a specific error
            AppUtils.errorSnackBar("Error", "An unknown error occurred.");
          }
        }
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
    required String userName,
    required String email,
    required String phoneNumber,
    required String password,
    required String cPassword,
    String? address,
    String? postalCode,
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
    print("deviceToken : $deviceId");

    var data = await authServices.registerServiceProvider(
      fullName: fullName,
      userName: userName,
      email: email,
      phoneNumber: phoneNumber,
      password: password,
      cPassword: cPassword,
      deviceToken: deviceId,
      address: address,
      postalCode: postalCode,
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
      AppUtils.getSnackBar("Success", data["messages"]);
    } else {
      // Handle error scenario
      isLoading.value = false;
      if (data['messages'] != null) {
        if (data['messages']['username'] != null) {
          // Show the username error message
          AppUtils.errorSnackBar("Error", data['messages']['username'][0]);
        } else if (data['messages']['email'] != null) {
          // Show the email error message
          AppUtils.errorSnackBar("Error", data['messages']['email'][0]);
        } else {
          // Show a general error message if neither username nor email has a specific error
          AppUtils.errorSnackBar("Error", "An unknown error occurred.");
        }
      }
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
    required String userName,
    required String email,
    required String phoneNumber,
    required String password,
    required String cPassword,
    required int roleId,
    String? address,
    String? postalCode,
    XFile? profileImage,
    required int lastStatus,
    String? lastLandlordName,
    String? lastTenancy,
    String? lastLandlordContact,
    String? occupation,
    String? leasedDuration,
    String? noOfOccupants,
  }) async {
    isLoading.value = true;
    try {
      var deviceId = await notificationServices.getDeviceToken();
      var data = await authServices.registerTenant(
        fullName: fullName,
        userName: userName,
        email: email,
        phoneNumber: phoneNumber,
        address: address,
        postalCode: postalCode,
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
        AppUtils.getSnackBar("Success", data['messages']);
      } else {
        // Handle error scenario
        isLoading.value = false;
        if (data['messages'] != null) {
          if (data['messages']['username'] != null) {
            // Show the username error message
            AppUtils.errorSnackBar("Error", data['messages']['username'][0]);
          } else if (data['messages']['email'] != null) {
            // Show the email error message
            AppUtils.errorSnackBar("Error", data['messages']['email'][0]);
          } else {
            // Show a general error message if neither username nor email has a specific error
            AppUtils.errorSnackBar("Error", "An unknown error occurred.");
          }
        }
      }
    } catch (e) {
      isLoading.value = false;
      AppUtils.errorSnackBar("Error", "Failed to register tenant");
    }
  }
}
