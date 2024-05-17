import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:property_app/utils/utils.dart';

import '../../constant_widget/constant_widgets.dart';
import '../../models/authentication_model/user_model.dart';
import '../../utils/api_urls.dart';
import '../../utils/shared_preferences/preferences.dart';
import 'package:http/http.dart' as http;
class ProfileSettingsScreenController extends GetxController{
  Rx<XFile?> profileImage = Rx<XFile?>(null);

  void pickProfileImage() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      profileImage.value = XFile(pickedFile.path);
      print("New image picked: ${profileImage.value!.path}"); // Verify path in console
      update();
    }

  }
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var email = TextEditingController();
  var phoneNumber = TextEditingController();
  var currentPassword = TextEditingController();
  var newPassword = TextEditingController();
  var confirmPassword = TextEditingController();

  String image = "";

  var userData = User(
    id: 0,
    fullname: '',
    email: '',
    phoneNumber: '',
    roleId: '',
    profileimage: '',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    platform: '', deviceToken: '',
  ).obs;

  var isLoadingGet = true.obs;
  var propertyId = 0.obs;
  @override
  void onInit() {
    super.onInit();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      isLoadingGet(true);
      var id = await Preferences.getUserID();
      var token = await Preferences.getToken();
      final response = await http.get(Uri.parse("${AppUrls.getUser}/$id",),
          headers: getHeader(userToken: token)
      );

      if (response.statusCode == 200) {
        var data = User.fromJson(jsonDecode(response.body)["data"]);
        print(data.profileimage);
        userData(data);

        nameController.text = userData.value.fullname;
        email.text = userData.value.email;
        phoneNumber.text = userData.value.phoneNumber;
        image = userData.value.profileimage;
        isLoadingGet(false);

      } else {
        isLoadingGet(false);
        throw Exception('Failed to load user data');
      }
    } finally {
      isLoadingGet(false);
    }
  }

  RxBool isLoading = false.obs;

  Future<void> updateDataAndImage({
    required String name,
    required String phoneNumber,
    XFile? filePath,
  }) async {
    isLoading.value = true;
    var uri = Uri.parse(AppUrls.updateProfile); // Replace with your API endpoint
    var token = await Preferences.getToken();
    var headers = {
      'Authorization': 'Bearer $token',
      "Content-Type" : "application/json"
    };
    try {
      var request = http.MultipartRequest('POST', uri);

      // Adding text fields
      request.fields['fullname'] = name;
      request.fields['phone_number'] = phoneNumber;

     if(filePath != null){
       request.files.add(await http.MultipartFile.fromPath(
         'profileimage',
         File(filePath.path).path,
         filename: 'profile_images.jpg',
       ));
     }



      request.headers.addAll(headers);
      var response = await request.send();

      if (response.statusCode == 200) {
        var responseBody = await response.stream.bytesToString();
        isLoading.value = false;
        AppUtils.getSnackBar("Success", "Profile updated");
        print('Uploaded successfully: $responseBody');
      } else {
        var errorBody = await response.stream.bytesToString();
        isLoading.value = false;
        AppUtils.getSnackBar("Error", "Failed to update profile");
        print('Failed to upload with status code ${response.statusCode} and body: $errorBody');
      }
    } catch (e) {
      isLoading.value = false;
      print('An error occurred: $e');
    }
  }

}