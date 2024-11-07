import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:property_app/constant_widget/constant_widgets.dart';
import 'package:property_app/utils/api_urls.dart';
import 'package:property_app/utils/shared_preferences/preferences.dart';
import 'package:property_app/utils/utils.dart';

import '../../utils/connectivity.dart';

class AuthServices {
  Future<Map<String, dynamic>> registerVisitor({
    required String fullName,
    required String userName,
    required String email,
    required String phoneNumber,
    String? address,
    String? postalCode,
    required String password,
    required String deviceToken,
    required String platform,
    required String conPassword,
    XFile? profileImage,
  }) async {
    if (await ConnectivityUtility.checkInternetConnectivity() == true) {
      try {
        var request =
            http.MultipartRequest('POST', Uri.parse(AppUrls.registerUrl));
        request.fields.addAll({
          'email': email,
          'fullname': fullName,
          'username': userName,
          'phone_number': phoneNumber,
          'address': address!,
          'postal_code': postalCode!,
          'password': password,
          'device_token': deviceToken,
          'platform': platform,
          'password_confirmation': conPassword,
          'role_id': '4',
        });
        // Add profileImage to the request if it's not null
        if (profileImage != null) {
          request.files.add(await http.MultipartFile.fromPath(
              'profileimage', profileImage.path));
        }
        var response = await request.send();
        var responseBody = await response.stream.bytesToString();
        return json.decode(responseBody);
      } catch (e) {
        // Handle general errors
        throw Exception('Failed to register: $e');
      }
    } else {
      AppUtils.getSnackBarNoInternet();
      // You might want to throw an exception here or return a specific value
      throw Exception('No internet connectivity');
    }
  }

  Future<Map<String, dynamic>> registerProperty({
    required String fullName,
    required String userName,
    required String email,
    required String phoneNumber,
    required String password,
    required String cPassword,
    required String deviceToken,
    required String platform,
    required int roleId,
    XFile? profileImage, // Make profile image non-required
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
    required String subtype,
    required String availabilityStartTime,
    required String availabilityEndTime,
    required String description,
    String? postalCode,
  }) async {
    if (await ConnectivityUtility.checkInternetConnectivity() == true) {
      var url = Uri.parse(AppUrls.registerUrl);
      var data = {
        'fullname': fullName,
        'username': userName,
        'email': email,
        'phone_number': phoneNumber,
        'password': password,
        'device_token': deviceToken,
        'platform': platform,
        'password_confirmation': cPassword,
        'role_id': roleId.toString(),
        'type': type.toString(),
        'city': city,
        'amount': amount.toString(),
        'address': address,
        'lat': lat.toString(),
        'long': long.toString(),
        'area_range': areaRange,
        'bedroom': bedroom.toString(),
        'bathroom': bathroom.toString(),
        'description': description.toString(),
        'postal_code': postalCode.toString(),
        'no_of_property': noOfProperty.toString(),
        'property_type': propertyType,
        'property_sub_type': subtype,
        'availability_start_time': availabilityStartTime,
        'availability_end_time': availabilityEndTime,
      };

      print(data);
      var request = http.MultipartRequest('POST', url)
        ..headers.addAll({
          'Content-Type': 'multipart/form-data',
        })
        ..fields.addAll({
          'fullname': fullName,
          'username': userName,
          'email': email,
          'phone_number': phoneNumber,
          'password': password,
          'device_token': deviceToken,
          'platform': platform,
          'password_confirmation': cPassword,
          'role_id': roleId.toString(),
          'type': type.toString(),
          'city': city,
          'amount': amount.toString(),
          'address': address!,
          'lat': lat.toString(),
          'long': long.toString(),
          'area_range': areaRange,
          'bedroom': bedroom.toString(),
          'bathroom': bathroom.toString(),
          'description': description.toString(),
          'postal_code': postalCode.toString(),
          'property_images[]': propertyImages.toString(),
          'electricity_bill': electricityBill.name,
        });

      // Add profile image if provided
      if (profileImage != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'profileimage',
          File(profileImage.path).path,
          filename: 'profile_image.jpg',
        ));
      }

      // Add electricity bill image
      request.files.add(await http.MultipartFile.fromPath(
        'electricity_bill',
        File(electricityBill.path).path,
        filename: 'electricity_bill.jpg',
      ));

      // Add property images
      for (var i = 0; i < propertyImages.length; i++) {
        File propertyImageFile = File(propertyImages[i].path);
        request.files.add(await http.MultipartFile.fromPath(
          'property_images[$i]',
          propertyImageFile.path,
          filename: 'property_image_$i.jpg',
        ));
      }

      // Add remaining fields
      request.fields.addAll({
        'no_of_property': noOfProperty.toString(),
        'property_type': propertyType,
        'property_sub_type': subtype,
        'availability_start_time': availabilityStartTime,
        'availability_end_time': availabilityEndTime,
      });
      var response = await request.send();

      var responseBody = await response.stream.bytesToString();
      print("Response body : $responseBody");
      print("Response body : ${response.statusCode}");
      return jsonDecode(responseBody);
    } else {
      AppUtils.getSnackBarNoInternet();
      throw Exception('No internet connectivity');
    }
  }

  //Service Provider

  Future<Map<String, dynamic>> registerServiceProvider({
    required String fullName,
    required String userName,
    required String email,
    required String phoneNumber,
    required String password,
    String? address,
    String? postalCode,
    required String cPassword,
    required String deviceToken,
    required String platform,
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
    var url =
        Uri.parse(AppUrls.registerUrl); // Replace with your actual API endpoint
    var data = {
      'fullname': fullName,
      'username': userName,
      'email': email,
      'phone_number': phoneNumber,
      'password': password,
      'device_token': deviceToken,
      'platform': platform,
      'password_confirmation': cPassword,
      'role_id': "3",
      'services': "2",
      'year_experience': yearExperience.toString(),
      'availability_start_time': availabilityStartTime,
      'availability_end_time': availabilityEndTime,
      if (certification != null) 'certification': certification,
    };

    print(data.toString());
    var request = http.MultipartRequest('POST', url)
      ..headers['Content-Type'] = 'multipart/form-data'
      ..fields.addAll({
        'fullname': fullName,
        'username': userName,
        'email': email,
        'phone_number': phoneNumber,
        'password': password,
        'device_token': deviceToken,
        'platform': platform,
        'password_confirmation': cPassword,
        'role_id': "3",
        'services': "2",
        'address': address!,
        'postal_code': postalCode!,
        'year_experience': yearExperience.toString(),
        'availability_start_time': "9 : am",
        'availability_end_time': "5 : PM",
        'certification': "No",
      })
      ..files.add(await http.MultipartFile.fromPath(
        'cnic_front',
        File(cnicFront.path).path,
        filename: 'cnic_front.jpg',
      ))
      ..files.add(await http.MultipartFile.fromPath(
        'cnic_back',
        File(cnicBack.path).path,
        filename: 'cnic_back.jpg',
      ));
    if (profileImage != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'profileimage',
        File(profileImage.path).path,
        filename: 'profile_image.jpg',
      ));
    }
    if (certificationFile != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'certification_file_name',
        File(certificationFile.path).path,
        filename: 'certification_file.jpg',
      ));
    }
    var response = await request.send();

    var responseBody = await response.stream.bytesToString();
    print("Response : $responseBody");
    return json.decode(responseBody);
    try {} catch (e) {
      rethrow;
      throw Exception('Failed to register service provider: $e');
    }
  }

  Future<Map<String, dynamic>> registerTenant({
    required String fullName,
    required String userName,
    required String email,
    required String phoneNumber,
    required String password,
    required String cPassword,
    String? address,
    String? postalCode,
    required String deviceToken,
    required String platform,
    required int roleId,
    XFile? profileImage,
    required int lastStatus,
    String? lastLandlordName,
    String? lastTenancy,
    String? lastLandlordContact,
    String? occupation,
    String? leasedDuration,
    String? noOfOccupants,
  }) async {
    if (await ConnectivityUtility.checkInternetConnectivity() == true) {
      var url = Uri.parse(AppUrls.registerUrl);

      var request = http.MultipartRequest('POST', url)
        ..headers.addAll({
          'Content-Type':
              'multipart/form-data', // Add your desired content type
          //'Authorization': 'Bearer YOUR_ACCESS_TOKEN', // Add your authorization token if needed
          // Add other headers as needed
        })
        ..fields.addAll({
          'fullname': fullName,
          'username': userName,
          'email': email,
          'phone_number': phoneNumber,
          'password': password,
          'device_token': deviceToken,
          'platform': platform,
          'address': address!,
          'postal_code': postalCode!,
          'password_confirmation': cPassword,
          'role_id': roleId.toString(),
          'last_status': lastStatus.toString(),
          if (lastLandlordName != null)
            'last_landlord_name': lastLandlordName ?? '',
          if (lastTenancy != null) 'last_tenancy': lastTenancy ?? '',
          if (lastLandlordContact != null)
            'last_landlord_contact': lastLandlordContact ?? '',
        });

      // Add these fields outside the conditional statements
      request.fields.addAll({
        'occupation': occupation!,
        'leased_duration': leasedDuration!,
        'no_of_occupants': noOfOccupants!.toString(),
      });

      if (profileImage != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'profileimage',
          File(profileImage.path).path,
          filename: 'profile_image.jpg',
        ));
      }

      try {
        var response = await request.send();
        var responseBody = await response.stream.bytesToString();
        print(responseBody);
        return json.decode(responseBody);
      } catch (e) {
        // Handle general errors
        throw Exception('Failed to register tenant: $e');
      }
    } else {
      AppUtils.getSnackBarNoInternet();
      throw Exception('No internet connectivity');
    }
  }

  Future<void> createConnectedAccount(
      {required int userId, required String email}) async {
    try {
      var response = await http.post(
        Uri.parse('https://yourapi.com/api/stripe/create-connected-account'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user_id': userId,
          'email': email,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Optionally handle the account_id
        print('Connected account created successfully: ${data['account_id']}');
      } else {
        // Handle error response
        final data = jsonDecode(response.body);
        print('Error creating connected account: ${data['error']}');
        // You might want to throw an exception or handle it accordingly
      }
    } catch (e) {
      // Handle exception
      print('Exception creating connected account: $e');
      // You might want to throw the exception or handle it accordingly
    }
  }

  Future<String> createPaymentIntent({
    required int amount,
    required String currency,
    required String connectedAccountId,
  }) async {
    final url =
        Uri.parse('https://your-backend.com/api/stripe/create-payment-intent');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'amount': amount,
        'currency': currency,
        'connected_account_id': connectedAccountId,
      }),
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return body['clientSecret'];
    } else {
      // Handle error
      throw Exception('Failed to create Payment Intent: ${response.body}');
    }
  }

  // Login APi

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
    required String deviceToken,
    required String platform,
  }) async {
    if (await ConnectivityUtility.checkInternetConnectivity() == true) {
      Uri url = Uri.parse(
        '${AppUrls.loginUrl}?email=$email&password=$password&device_token=$deviceToken&platform=$platform',
      );
      try {
        var res = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
          },
        );
        print(res.body);
        return json.decode(res.body);
      } catch (e) {
        // Handle general errors
        throw Exception('Failed to Login: $e');
      }
    } else {
      AppUtils.getSnackBarNoInternet();
      // You might want to throw an exception here or return a specific value
      throw Exception('No internet connectivity');
    }
  }

  getUserState() async {
    var data = await Preferences.getUserID();
    var token = await Preferences.getToken();
    Uri url = Uri.parse(
      "${AppUrls.userState}?serviceprovider_id=$data",
    );
    try {
      var res = await http.post(url, headers: getHeader(userToken: token));
      return json.decode(res.body);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return e;
    }
  }

  getLandLordState() async {
    var data = await Preferences.getUserID();
    var token = await Preferences.getToken();
    Uri url = Uri.parse(
      "${AppUrls.landlordStat}?landlord_id=$data",
    );
    try {
      var res = await http.post(url, headers: getHeader(userToken: token));
      return json.decode(res.body);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return e;
    }
  }

  getTenantState() async {
    var data = await Preferences.getUserID();
    var token = await Preferences.getToken();
    Uri url = Uri.parse(
      "${AppUrls.tenantStat}?tenant_id=$data",
    );
    try {
      var res = await http.post(url, headers: getHeader(userToken: token));
      return json.decode(res.body);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return e;
    }
  }

  getVisitorState() async {
    var data = await Preferences.getUserID();
    var token = await Preferences.getToken();
    Uri url = Uri.parse(
      "${AppUrls.visitorStat}?visitor_id=$data",
    );
    try {
      var res = await http.post(url, headers: getHeader(userToken: token));
      return json.decode(res.body);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return e;
    }
  }

  Future<Map<String, dynamic>> checkEmailExists(String email) async {
    try {
      // API endpoint to check if email exists
      final url = Uri.parse('/api/check-email');

      // Assuming it's a POST request, but could also be a GET request
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({"email": email}),
      );

      if (response.statusCode == 200) {
        // Assuming the backend returns a JSON like { "exists": true }
        return json.decode(response.body);
      } else {
        throw Exception('Failed to check email');
      }
    } catch (e) {
      print('Error in checkEmailExists: $e');
      return {"exists": false}; // Returning false if there's an error
    }
  }

  // Function to send a verification email to the user
  Future<Map<String, dynamic>> sendVerificationEmail(String email) async {
    try {
      // API endpoint to send a verification email
      final url = Uri.parse('/api/send-verification-email');

      // Assuming it's a POST request
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({"email": email}),
      );

      if (response.statusCode == 200) {
        // Assuming the backend returns a JSON like { "status": true }
        return json.decode(response.body);
      } else {
        throw Exception('Failed to send verification email');
      }
    } catch (e) {
      print('Error in sendVerificationEmail: $e');
      return {"status": false}; // Returning false if there's an error
    }
  }
}
