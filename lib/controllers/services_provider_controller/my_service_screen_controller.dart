import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../../models/service_provider_model/all_services.dart';
import '../../services/property_services/add_services.dart';
import '../../utils/utils.dart';
import 'package:path/path.dart' as p;
import 'package:http/http.dart' as http;

class MyServicesDetailScreenController extends GetxController{


  final formKey = GlobalKey<FormState>();
  var servicesNameController = TextEditingController();
  var descriptionController = TextEditingController();
  var categoryController = TextEditingController();
  var pricingController = TextEditingController();
  var durationController = TextEditingController();
  var availabilityController = TextEditingController();
  var locationController = TextEditingController();
  var additionalInfoController = TextEditingController();
  var cityNameController = TextEditingController();
  List<XFile> convertFilesToXFiles(List<File> files) {
    return files.map((file) => XFile(file.path)).toList();
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
    update();
  }


  Future<File> downloadImage(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = p.join(directory.path, p.basename(url));
      final file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);
      return file;
    } else {
      throw Exception("Failed to download file from $url");
    }
  }

  DateTime selectedDate = DateTime.now();
  Rx<TimeOfDay> startTime = const TimeOfDay(hour: 9, minute: 0).obs;
  Rx<TimeOfDay> endTime = const TimeOfDay(hour: 17, minute: 0).obs;

  Future<void> selectDateTime(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return Container(
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              )
          ),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: const Text('Select Start Time', style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),),
                  onTap: () async {
                    //Navigator.pop(context);
                    await _selectTime(context, true);
                  },
                ),
                ListTile(
                  title: const Text('Select End Time', style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),),
                  onTap: () async {
                    Navigator.pop(context);
                    await _selectTime(context, false);
                  },
                ),
                const SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
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
      // Update the availabilityController text after both start and end times are updated

      print(availabilityController.text);
    }
  }


  final sheet = GlobalKey();
  final controller = DraggableScrollableController();
  final PageController pageController = PageController();
  ServiceProviderServices servicesService = ServiceProviderServices();
  Rx<bool> isLoading = false.obs;
  Rx<AllService?> getServiceOne = Rx<AllService?>(null);
  RxInt idService = 0.obs;

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


  void searchCountry(String query) {
    if (query.isEmpty) {
      countriesList.assignAll(allCountries);
    } else {
      countriesList.assignAll(
        allCountries.where((country) => country.toLowerCase().contains(query.toLowerCase())).toList(),
      );
    }
  }
  List<String> imagesNetWork = [];

  @override
  void onInit() {
    var data = Get.arguments;
    print("IDDDDDD $data");
    print("Hello");
    idService.value = data;
    Future.microtask(() => getService(id: data));
    countriesList.addAll(allCountries);
    super.onInit();
  }

  var images = <String>[].obs; // Using RxList for reactivity

  void removeNetWork(int index) {
    if (index >= 0 && index < images.length) {
      images.removeAt(index);
      print("Image at $index removed, new list: $images");
      update();  // Notify listeners about the update
    } else {
      print("Attempted to remove image at invalid index $index");
    }
  }

  Future<void> getService({required int id}) async {
    print("we are in get service");
    isLoading.value = true;
    // Fetch the service data
    var result = await servicesService.getService(id: id);
    print("Service Result : $result");

    isLoading.value = false;

    // Check if 'data' is not null and is of type Map
    if (result['data'] != null && result['data'] is Map) {
      var data = result['data'] as Map<String, dynamic>;
      print("Data :: $data");

      if (getServiceOne != null) {
        getServiceOne.value = AllService.fromJson(data);
        String imagesString = getServiceOne.value!.media.toString();
        images.value = imagesString.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
        servicesNameController.text = getServiceOne.value!.serviceName;
        descriptionController.text = getServiceOne.value!.description;
        pricingController.text = getServiceOne.value!.pricing;
        availabilityController.text ="${getServiceOne.value!.startTime} - ${getServiceOne.value!.endTime}";
        locationController.text = getServiceOne.value!.location.toString();
        additionalInfoController.text = getServiceOne.value!.additionalInformation.toString();
      } else {
        isLoading.value = false;
        print("getServiceOne is null");
      }
    } else {
      isLoading.value = false;
      print("Invalid or null data format");
      // Handle other cases if necessary
    }
  }

  Future<void> deleteService({required int id}) async {
    print("we are in delete service");
    isLoading.value = true;
    var result = await servicesService.deleteService(id: id);
    print("Service Result : $result");

    isLoading.value = false;

    if (result['status'] == true) {
      isLoading.value = false;
      Get.back();
      Get.back();
      Get.back();
      AppUtils.getSnackBar("Delete", result['messages']);
    } else {
      isLoading.value = false;
      print("getPropertyOne is null");
      AppUtils.errorSnackBar("Error", result['messages']);
    }
    isLoading.value = false;
  }

  Future<void> updateService({
    required String id,
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
    isLoading.value = true;

    try {
      var data = await ServiceProviderServices().updateService(
        id: id,
        userId: userId,
        serviceName: serviceName,
        description: description,
        categoryId: categoryId,
        pricing: pricing,
        durationId: durationId,
        startTime: startTime,
        endTime: endTime,
        location: location,
        lat: lat,
        long: long,
        additionalInformation: additionalInformation,
        mediaFiles: mediaFiles,
      );

      if (kDebugMode) {
        print("Data : $data");
      }

      if (data['status'] == true) {
        isLoading.value = false;
        Get.back();
        getService(id: idService.value);
        AppUtils.getSnackBar("Success", data['messages']);
      } else {
        isLoading.value = false;
        AppUtils.errorSnackBar("Error", data['messages']);
      }
    } catch (e) {
      isLoading.value = false;
      print(e);
      // Handle general errors
      AppUtils.errorSnackBar("Error", "Failed to add service", backgroundColor: Colors.red);
    }
  }


}