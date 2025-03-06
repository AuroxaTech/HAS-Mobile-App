import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:property_app/services/property_services/add_services.dart';
import 'package:property_app/utils/api_urls.dart';
import 'package:intl/intl.dart';

import '../../utils/utils.dart';

class AddServiceController extends GetxController {
  final formKey = GlobalKey<FormState>();
  var servicesNameController = TextEditingController();
  var cityNameController = TextEditingController();
  var descriptionController = TextEditingController();
  var categoryController = TextEditingController();
  var pricingController = TextEditingController();
  var durationController = TextEditingController();
  var availabilityController = TextEditingController();
  var locationController = TextEditingController();
  var additionalInfoController = TextEditingController();
  var yearsExperienceController = TextEditingController();

  var selectedCountry = RxnString();
  var countriesList = <String>[].obs;
  final List<String> allCountries = [
    'Afghanistan',
    'Albania',
    'Algeria',
    'Andorra',
    'Angola',
    'Antigua and Barbuda',
    'Argentina',
    'Armenia',
    'Australia',
    'Austria',
    'Azerbaijan',
    'Bahamas',
    'Bahrain',
    'Bangladesh',
    'Barbados',
    'Belarus',
    'Belgium',
    'Belize',
    'Benin',
    'Bhutan',
    'Bolivia',
    'Bosnia and Herzegovina',
    'Botswana',
    'Brazil',
    'Brunei',
    'Bulgaria',
    'Burkina Faso',
    'Burundi',
    'Cabo Verde',
    'Cambodia',
    'Cameroon',
    'Canada',
    'Central African Republic',
    'Chad',
    'Chile',
    'China',
    'Colombia',
    'Comoros',
    'Congo (Congo-Brazzaville)',
    'Congo (Democratic Republic of the Congo)',
    'Costa Rica',
    'Croatia',
    'Cuba',
    'Cyprus',
    'Czech Republic (Czechia)',
    'Denmark',
    'Djibouti',
    'Dominica',
    'Dominican Republic',
    'Ecuador',
    'Egypt',
    'El Salvador',
    'Equatorial Guinea',
    'Eritrea',
    'Estonia',
    'Eswatini (fmr. "Swaziland")',
    'Ethiopia',
    'Fiji',
    'Finland',
    'France',
    'Gabon',
    'Gambia',
    'Georgia',
    'Germany',
    'Ghana',
    'Greece',
    'Grenada',
    'Guatemala',
    'Guinea',
    'Guinea-Bissau',
    'Guyana',
    'Haiti',
    'Holy See',
    'Honduras',
    'Hungary',
    'Iceland',
    'India',
    'Indonesia',
    'Iran',
    'Iraq',
    'Ireland',
    'Israel',
    'Italy',
    'Ivory Coast',
    'Jamaica',
    'Japan',
    'Jordan',
    'Kazakhstan',
    'Kenya',
    'Kiribati',
    'Kuwait',
    'Kyrgyzstan',
    'Laos',
    'Latvia',
    'Lebanon',
    'Lesotho',
    'Liberia',
    'Libya',
    'Liechtenstein',
    'Lithuania',
    'Luxembourg',
    'Madagascar',
    'Malawi',
    'Malaysia',
    'Maldives',
    'Mali',
    'Malta',
    'Marshall Islands',
    'Mauritania',
    'Mauritius',
    'Mexico',
    'Micronesia',
    'Moldova',
    'Monaco',
    'Mongolia',
    'Montenegro',
    'Morocco',
    'Mozambique',
    'Myanmar (formerly Burma)',
    'Namibia',
    'Nauru',
    'Nepal',
    'Netherlands',
    'New Zealand',
    'Nicaragua',
    'Niger',
    'Nigeria',
    'North Korea',
    'North Macedonia (formerly Macedonia)',
    'Norway',
    'Oman',
    'Pakistan',
    'Palau',
    'Palestine State',
    'Panama',
    'Papua New Guinea',
    'Paraguay',
    'Peru',
    'Philippines',
    'Poland',
    'Portugal',
    'Qatar',
    'Romania',
    'Russia',
    'Rwanda',
    'Saint Kitts and Nevis',
    'Saint Lucia',
    'Saint Vincent and the Grenadines',
    'Samoa',
    'San Marino',
    'Sao Tome and Principe',
    'Saudi Arabia',
    'Senegal',
    'Serbia',
    'Seychelles',
    'Sierra Leone',
    'Singapore',
    'Slovakia',
    'Slovenia',
    'Solomon Islands',
    'Somalia',
    'South Africa',
    'South Korea',
    'South Sudan',
    'Spain',
    'Sri Lanka',
    'Sudan',
    'Suriname',
    'Sweden',
    'Switzerland',
    'Syria',
    'Tajikistan',
    'Tanzania',
  ];
  @override
  void onInit() {
    super.onInit();
    countriesList.addAll(allCountries);
  }

  void searchCountry(String query) {
    if (query.isEmpty) {
      countriesList.assignAll(allCountries);
    } else {
      countriesList.assignAll(
        allCountries
            .where((country) =>
                country.toLowerCase().contains(query.toLowerCase()))
            .toList(),
      );
    }
  }

  Rx<TimeOfDay> startTime = const TimeOfDay(hour: 9, minute: 0).obs;
  Rx<TimeOfDay> endTime = const TimeOfDay(hour: 17, minute: 0).obs;
  RxString selectedWeekdayRange = ''.obs;

  final List<String> weekdayRanges = ['Monday to Friday', 'Full Week'];

  Future<void> selectDateTime(BuildContext context) async {
    await _selectWeekdayRange(context);
    await _selectTime(context, true);
    await _selectTime(context, false);

    availabilityController.text =
        "${selectedWeekdayRange.value.isEmpty ? '' : selectedWeekdayRange.value}, ${startTime.value.format(context)} - ${endTime.value.format(context)}";
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

  var isLoading = false.obs;

  Future<void> addService({
    required int userId,
    required String serviceName,
    required String description,
    required String pricing,
    required String startTime,
    required String endTime,
    required String location,
    required String country,
    required String city,
    required double lat,
    required double long,
    required String additionalInformation,
    required String yearsExperience,
    required String weekdayRange,
    List<XFile>? mediaFiles,
  }) async {
    try {
      isLoading.value = true;

      var result = await ServiceProviderServices().addService(
        userId: userId,
        serviceName: serviceName,
        description: description,
        pricing: pricing,
        startTime: startTime,
        endTime: endTime,
        location: location,
        country: country,
        city: city,
        lat: lat,
        long: long,
        additionalInformation: additionalInformation,
        yearsExperience: yearsExperience,
        duration: weekdayRange,
        mediaFiles: mediaFiles,
      );

      if (result['status'] == true) {
        Get.back();
        AppUtils.getSnackBar("Success", result['messages']);
      } else {
        AppUtils.errorSnackBar("Error", result['messages'] ?? "Failed to add service");
      }
    } catch (e) {
      print("Error adding service: $e");
      AppUtils.errorSnackBar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> uploadDataWithImages({
    required String userId,
    required String serviceName,
    required String description,
    required String categoryId,
    required String pricing,
    required String durationId,
    required String startTime,
    required String endTime,
    required String location,
    required String lat,
    required String long,
    required String additionalInformation,
    List<XFile>? mediaFiles,
  }) async {
    var uri = Uri.parse(AppUrls.updateService); // Your API endpoint as a Uri

    // Create a multipart request
    var request = http.MultipartRequest('POST', uri)
      ..fields['user_id'] = userId
      ..fields['service_name'] = serviceName
      ..fields['description'] = description
      ..fields['category_id'] = categoryId
      ..fields['pricing'] = pricing
      ..fields['duration_id'] = durationId
      ..fields['start_time'] = '08:00 AM'
      ..fields['end_time'] = '07:00 PM'
      ..fields['location'] = location
      ..fields['lat'] = lat
      ..fields['long'] = long
      ..fields['additional_information'] = description;

    // Add images to the request
    for (var image in images) {
      var length = await image.length();
      request.files.add(
        http.MultipartFile(
          'media[]',
          image.openRead(),
          length,
          filename: image.path.split('/').last,
          // Set the content type for each image, if known. Replace 'jpeg' if different.
          // contentType: MediaType('image', 'jpeg'),
        ),
      );
    }

    // Add headers if necessary (e.g., Authorization)
    request.headers.addAll({
      'Authorization':
          'Bearer 29|PE0YeLEKnEopJ7bphb5MZThmZxu7V0YmchtbRfFn71edaac4', // Replace with your actual token
      'Content-Type': 'multipart/form-data',
    });

    // Send the request
    try {
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      // Check if the request was successful
      if (response.statusCode == 200) {
        print('Upload successful');
      } else {
        print('Upload failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  @override
  void onClose() {
    super.onClose();
    servicesNameController.dispose();
    cityNameController.dispose();
    descriptionController.dispose();
    categoryController.dispose();
    pricingController.dispose();
    durationController.dispose();
    availabilityController.dispose();
    locationController.dispose();
    additionalInfoController.dispose();
    yearsExperienceController.dispose();
  }

  String formatTimeOfDay(TimeOfDay time) {
    // Convert to 12-hour format
    int hour = time.hourOfPeriod;
    if (hour == 0) hour = 12; // Handle midnight (12 AM)
    
    // Format hour with leading zero if needed
    String hourStr = hour.toString().padLeft(2, '0');
    
    // Format minutes with leading zero if needed
    String minute = time.minute.toString().padLeft(2, '0');
    
    // Determine AM/PM
    String period = time.period == DayPeriod.am ? 'AM' : 'PM';
    
    // Format as "hh:mm PP" (e.g., "04:00 PM" for 4:00 PM)
    return '$hourStr:$minute $period';
  }
}
