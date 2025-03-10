import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:property_app/utils/shared_preferences/preferences.dart';

import '../../app_constants/color_constants.dart';
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

  RxList<String> selectedDays = <String>[].obs;
  final List<String> weekDays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  RxString selectedOption = "".obs;
  final List<String> options = [
    'Select Specific Days',
    'Full Week',
    'Request Now'
  ];

  Future<void> selectDateTime(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Select Option:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ...options.map((option) => RadioListTile(
                        title: Text(option),
                        value: option,
                        groupValue: selectedOption.value,
                        onChanged: (value) {
                          setState(() {
                            selectedOption.value = value.toString();
                            if (value == 'Full Week') {
                              selectedDays.value = List.from(weekDays);
                            } else if (value == 'Request Now') {
                              selectedDays.clear();
                            }
                          });
                        },
                      )),
                  if (selectedOption.value == 'Select Specific Days') ...[
                    const Divider(),
                    const Text(
                      'Select Days:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      children: weekDays.map((day) {
                        bool isSelected = selectedDays.contains(day);
                        return FilterChip(
                          selected: isSelected,
                          label: Text(day),
                          onSelected: (bool selected) {
                            setState(() {
                              if (selected) {
                                selectedDays.add(day);
                              } else {
                                selectedDays.remove(day);
                              }
                            });
                          },
                          selectedColor: primaryColor,
                          checkmarkColor: Colors.white,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          selectedDays.clear();
                          selectedOption.value = "";
                          Get.back();
                        },
                        child: const Text('Clear'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (selectedOption.value == 'Request Now') {
                            Get.back();
                          } else if (selectedOption.value.isNotEmpty &&
                              (selectedDays.isNotEmpty ||
                                  selectedOption.value == 'Request Now')) {
                            Get.back();

                            if (selectedOption.value != 'Request Now') {
                              // Select start time using Get.dialog
                              final TimeOfDay? startPicked = await Get.dialog(
                                TimePickerDialog(
                                  initialTime: startTime.value,
                                ),
                              );

                              if (startPicked != null) {
                                startTime.value = startPicked;

                                // Select end time using Get.dialog
                                final TimeOfDay? endPicked = await Get.dialog(
                                  TimePickerDialog(
                                    initialTime: TimeOfDay(
                                      hour: (startPicked.hour + 1) % 24,
                                      minute: startPicked.minute,
                                    ),
                                  ),
                                );

                                if (endPicked != null) {
                                  // Validate end time is after start time
                                  if (endPicked.hour > startPicked.hour ||
                                      (endPicked.hour == startPicked.hour &&
                                          endPicked.minute >
                                              startPicked.minute)) {
                                    endTime.value = endPicked;
                                  } else {
                                    Get.snackbar(
                                      'Invalid Time',
                                      'End time must be after start time',
                                      snackPosition: SnackPosition.BOTTOM,
                                      backgroundColor: Colors.red,
                                      colorText: Colors.white,
                                    );
                                  }
                                }
                              }
                            }
                          }
                        },
                        child: const Text('Continue'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  String get getSelectedTimeRangeText {
    if (selectedOption.value.isEmpty) return 'Select days and time';
    if (selectedOption.value == 'Request Now') return 'Request Now';
    if (selectedOption.value == 'Full Week') {
      return 'Full Week, ${startTime.value.format(Get.context!)} - ${endTime.value.format(Get.context!)}';
    }
    if (selectedDays.isEmpty) return 'Select days and time';

    String daysText = selectedDays.join(', ');
    return '$daysText, ${startTime.value.format(Get.context!)} - ${endTime.value.format(Get.context!)}';
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
    fullName: '',
    userName: '',
    email: '',
    phoneNumber: '',
    roleId: "",
    profileImage: '',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    platform: '',
    deviceToken: '',
    address: '',
    postalCode: '',
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
        var data = User.fromJson(jsonDecode(response.body)["payload"]);
        print(data.profileImage);
        userData(data);

        nameController.text = userData.value.fullName;
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
    required String serviceName,
    required String serviceId,
    required String providerId,
    required String location,
    required double lat,
    required double lng,
    required int propertyType,
    required String duration,
    required String startTime,
    required String endTime,
    required String description,
    required String additionalInfo,
    required String country,
    required String city,
    required String yearExperience,
    String cnicFrontPic = '',
    String cnicBackPic = '',
    String certification = '',
    String resume = '',
    required int price,
    required int isApplied,
  }) async {
    isLoading.value = true;

    try {
      var data = await ServiceProviderServices().newServiceRequest(
        serviceName: serviceName,
        serviceId: serviceId,
        location: location,
        lat: lat,
        lng: lng,
        description: description,
        price: price,
        duration: duration,
        startTime: startTime,
        endTime: endTime,
        additionalInfo: additionalInfo,
        country: country,
        city: city,
        yearExperience: yearExperience,
        cnicFrontPic: cnicFrontPic,
        cnicBackPic: cnicBackPic,
        certification: certification,
        resume: resume,
        providerId: providerId,
        isApplied: isApplied,
      );

      if (kDebugMode) {
        print("Data : $data");
      }

      if (data['status'] == true) {
        isLoading.value = false;
        Get.back();
        AppUtils.getSnackBar("Success", data['message']);
      } else {
        isLoading.value = false;
        AppUtils.errorSnackBar("Error", data['message']);
      }
    } catch (e) {
      isLoading.value = false;
      print(e);
      AppUtils.errorSnackBar("Error", "Failed to add service");
    }
  }

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStartTime ? startTime.value : endTime.value,
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child!,
        );
      },
    );

    if (picked != null) {
      if (isStartTime) {
        startTime.value = picked;
        // Validate that end time is after start time
        if (endTime.value.hour < picked.hour ||
            (endTime.value.hour == picked.hour &&
                endTime.value.minute < picked.minute)) {
          // If end time is before start time, set end time to start time + 1 hour
          endTime.value = TimeOfDay(
            hour: (picked.hour + 1) % 24,
            minute: picked.minute,
          );
        }
      } else {
        // Validate that selected end time is after start time
        if (picked.hour > startTime.value.hour ||
            (picked.hour == startTime.value.hour &&
                picked.minute > startTime.value.minute)) {
          endTime.value = picked;
        } else {
          // Show error message if end time is before start time
          Get.snackbar(
            'Invalid Time',
            'End time must be after start time',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      }
    }
  }
}
