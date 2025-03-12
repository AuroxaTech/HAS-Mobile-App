import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:property_app/constant_widget/constant_widgets.dart';
import 'package:property_app/utils/api_urls.dart';
import 'package:property_app/utils/shared_preferences/preferences.dart';
import 'package:property_app/utils/utils.dart';

import '../../utils/base_api_service.dart';
import '../../utils/connectivity.dart';

class AuthServices extends BaseApiService {
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
    final hasInternet = await ConnectivityUtility.checkInternetConnectivity();
    if (!hasInternet) {
      AppUtils.getSnackBarNoInternet();
      throw ApiException('No internet connectivity');
    }

    try {
      apiUrl = AppUrls.registerUrl;

      // Prepare form data
      final fields = {
        'email': email,
        'full_name': fullName,
        'user_name': userName,
        'phone_number': phoneNumber,
        'address': address ?? '',
        'postal_code': postalCode ?? '',
        'password': password,
        'device_token': deviceToken,
        'platform': 'android',
        'password_confirmation': conPassword,
        'role': 'visitor'
        //'role_id': '4',
      };

      // Log request details
      BaseApiService.logRequest(
          apiUrl,
          'POST',
          {'Accept': 'application/json', 'Content-Type': 'multipart/form-data'},
          fields);

      // Create multipart request
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl))
        ..headers.addAll({
          'Accept': 'application/json',
        })
        ..fields.addAll(fields);

      // Add profile image if provided
      if (profileImage != null) {
        request.files.add(await http.MultipartFile.fromPath(
            'profile_image', profileImage.path));
      }

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      // Log response
      BaseApiService.logResponse(apiUrl, response.statusCode, responseBody);

      // Parse and validate response
      final decodedResponse = json.decode(responseBody);
      validateResponse(response.statusCode, decodedResponse);

      return decodedResponse;
    } catch (e) {
      // Log error
      BaseApiService.logError(apiUrl, e.toString());

      if (e is ApiException) {
        BaseApiService.handleApiException(e as ApiException);
        rethrow;
      }
      throw ApiException('Failed to register: $e');
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
    required String role,
    XFile? profileImage,
    required String type,
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
    final hasInternet = await ConnectivityUtility.checkInternetConnectivity();
    if (!hasInternet) {
      AppUtils.getSnackBarNoInternet();
      throw ApiException('No internet connectivity');
    }

    try {
      apiUrl = AppUrls.registerUrl;
      final url = Uri.parse(apiUrl);

      // Prepare form data
      final fields = {
        'full_name': fullName,
        'user_name': userName,
        'email': email,
        'phone_number': phoneNumber,
        'password': password,
        'device_token': 'werty134',
        'platform': platform,
        'password_confirmation': cPassword,
        'role': role,
        'type': type.toString(),
        'city': city,
        'amount': amount.toString(),
        'address': address ?? '',
        'lat': lat.toString(),
        'long': long.toString(),
        'area_range': areaRange,
        'bedroom': bedroom.toString(),
        'bathroom': bathroom,
        'description': description,
        'postal_code': postalCode ?? '',
        'no_of_property': noOfProperty.toString(),
        'property_type': propertyType,
        'property_sub_type': subtype,
        'availability_start_time': availabilityStartTime,
        'availability_end_time': availabilityEndTime,
      };

      // Log request details
      BaseApiService.logRequest(
          url.toString(),
          'POST',
          {'Accept': 'application/json', 'Content-Type': 'multipart/form-data'},
          fields);

      // Create multipart request
      var request = http.MultipartRequest('POST', url)
        ..headers.addAll({
          'Accept': 'application/json',
        })
        ..fields.addAll(fields);

      // Add profile image if provided
      if (profileImage != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'profile_image',
          File(profileImage.path).path,
          filename: 'profile_image.jpg',
        ));
      }
      // Add electricity bill image
      request.files.add(await http.MultipartFile.fromPath(
        'electricity_bill',
        electricityBill.path,
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

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      // Log response
      BaseApiService.logResponse(
          url.toString(), response.statusCode, responseBody);

      // Parse and validate response
      final decodedResponse = json.decode(responseBody);
      validateResponse(response.statusCode, decodedResponse);

      return decodedResponse;
    } catch (e) {
      BaseApiService.logError(apiUrl, e.toString());
      if (e is ApiException) {
        BaseApiService.handleApiException(e);
        rethrow;
      }
      throw ApiException('Failed to register property: $e');
    }
  }

  //Service Provider

  Future<Map<String, dynamic>> registerServiceProvider({
    required String fullName,
    required String userName,
    required String email,
    required String phoneNumber,
    required String password,
    required String city,
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
    required String pricing,
    required String duration,
    required String country,
    required String location,
    required String description,
    required String additionalInfo,
  }) async {
    final hasInternet = await ConnectivityUtility.checkInternetConnectivity();
    if (!hasInternet) {
      AppUtils.getSnackBarNoInternet();
      throw ApiException('No internet connectivity');
    }

    try {
      apiUrl = AppUrls.registerUrl;
      final url = Uri.parse(apiUrl);

      // Convert services to array format
      final servicesList = [services]; // Create array with single service

      // Prepare form data
      final fields = {
        'full_name': fullName,
        'user_name': userName,
        'email': email,
        'phone_number': phoneNumber,
        'password': password,
        'device_token': "werty134",
        'platform': platform,
        'password_confirmation': cPassword,
        'role': "service_provider",
        'services[]': servicesList, // Send as array
        'address': address ?? '',
        'postal_code': postalCode ?? '',
        'year_experience': yearExperience,
        'availability_start_time': availabilityStartTime,
        'availability_end_time': availabilityEndTime,
        'certification': certification ?? 'No',
        'pricing': pricing,
        'duration': duration,
        'country': country,
        'location': location,
        'city': city,
        'description': description,
        'additional_information': additionalInfo,
      };

      // Log request
      BaseApiService.logRequest(
          url.toString(),
          'POST',
          {'Accept': 'application/json', 'Content-Type': 'multipart/form-data'},
          fields);

      // Create multipart request
      var request = http.MultipartRequest('POST', url)
        ..headers.addAll({
          'Accept': 'application/json',
        });

      // Add all fields except services
      fields.forEach((key, value) {
        if (key != 'services[]') {
          request.fields[key] = value.toString();
        }
      });

      // Add services as array
      for (var service in servicesList) {
        request.fields['services[]'] = service;
      }

      // Add profile image if provided
      if (profileImage != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'profile_image',
          profileImage.path,
          filename: 'profile_image.jpg',
        ));
      }

      // Add CNIC images
      request.files.add(await http.MultipartFile.fromPath(
        'cnic_front',
        cnicFront.path,
        filename: 'cnic_front.jpg',
      ));

      request.files.add(await http.MultipartFile.fromPath(
        'cnic_back',
        cnicBack.path,
        filename: 'cnic_back.jpg',
      ));

      // Add certification file if provided
      if (certificationFile != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'certification_file',
          certificationFile.path,
          filename: 'certification_file.jpg',
        ));
      }

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      // Log response
      BaseApiService.logResponse(
          url.toString(), response.statusCode, responseBody);

      // Parse and validate response
      final decodedResponse = json.decode(responseBody);
      validateResponse(response.statusCode, decodedResponse);

      return decodedResponse;
    } catch (e) {
      BaseApiService.logError(apiUrl, e.toString());
      if (e is ApiException) {
        BaseApiService.handleApiException(e);
        rethrow;
      }
      throw ApiException('Failed to register service provider: $e');
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
    required String role,
    XFile? profileImage,
    required int lastStatus,
    String? lastLandlordName,
    String? lastTenancy,
    String? lastLandlordContact,
    String? occupation,
    String? leasedDuration,
    String? noOfOccupants,
  }) async {
    final hasInternet = await ConnectivityUtility.checkInternetConnectivity();
    if (!hasInternet) {
      AppUtils.getSnackBarNoInternet();
      throw ApiException('No internet connectivity');
    }

    try {
      apiUrl = AppUrls.registerUrl;
      final url = Uri.parse(apiUrl);

      // Prepare form data
      final fields = {
        'full_name': fullName,
        'user_name': userName,
        'email': email,
        'phone_number': phoneNumber,
        'password': password,
        'device_token': "werty134",
        'platform': platform,
        'address': address ?? '',
        'postal_code': postalCode ?? '',
        'password_confirmation': cPassword,
        'role': "tenant",
        'last_status': lastStatus.toString(),
        'last_landlord_name': lastLandlordName ?? '',
        'last_tenancy': lastTenancy ?? '',
        'last_landlord_contact': lastLandlordContact ?? '',
        'occupation': occupation ?? '',
        'leased_duration': leasedDuration ?? '',
        'no_of_occupants': noOfOccupants ?? '',
      };

      // Log request
      BaseApiService.logRequest(
          url.toString(),
          'POST',
          {'Accept': 'application/json', 'Content-Type': 'multipart/form-data'},
          fields);

      // Create multipart request
      var request = http.MultipartRequest('POST', url)
        ..headers.addAll({
          'Accept': 'application/json',
        })
        ..fields.addAll(fields);

      // Add profile image if provided
      if (profileImage != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'profile_image',
          profileImage.path,
          filename: 'profile_image.jpg',
        ));
      }

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      // Log response
      BaseApiService.logResponse(
          url.toString(), response.statusCode, responseBody);

      // Parse and validate response
      final decodedResponse = json.decode(responseBody);
      validateResponse(response.statusCode, decodedResponse);

      return decodedResponse;
    } catch (e) {
      BaseApiService.logError(apiUrl, e.toString());
      if (e is ApiException) {
        BaseApiService.handleApiException(e);
        rethrow;
      }
      throw ApiException('Failed to register tenant: $e');
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
    final hasInternet = await ConnectivityUtility.checkInternetConnectivity();
    if (!hasInternet) {
      AppUtils.getSnackBarNoInternet();
      throw ApiException('No internet connectivity');
    }

    try {
      apiUrl = AppUrls.loginUrl;

      // Prepare query parameters
      final queryParams = {
        'email': email,
        'password': password,
        'device_token': deviceToken,
        'platform': platform,
      };

      final url = Uri.parse(apiUrl).replace(queryParameters: queryParams);

      // Log request
      BaseApiService.logRequest(
          url.toString(), 'POST', {'Accept': 'application/json'}, queryParams);

      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
        },
      );

      // Log response
      BaseApiService.logResponse(
          url.toString(), response.statusCode, response.body);

      // Check if response is HTML
      if (response.body.trim().startsWith('<!DOCTYPE html>')) {
        throw ApiException(
            'Server returned HTML instead of JSON. Please contact support.');
      }

      // Parse and validate response
      final decodedResponse = json.decode(response.body);
      validateResponse(response.statusCode, decodedResponse);

      return decodedResponse;
    } catch (e) {
      // Log error with full URL
      BaseApiService.logError(
          Uri.parse(apiUrl).replace(queryParameters: {
            'email': email,
            'platform': platform,
            // Omit password and device token from error logs
          }).toString(),
          e.toString());

      if (e is ApiException) {
        BaseApiService.handleApiException(e);
        rethrow;
      }
      if (e is FormatException) {
        throw ApiException('Invalid JSON response from server: ${e.message}');
      }
      throw ApiException(e.toString());
    }
  }

  Future<Map<String, dynamic>> getUserState() async {
    try {
      var data = await Preferences.getUserID();
      var token = await Preferences.getToken();
      Uri url = Uri.parse("${AppUrls.userState}?serviceprovider_id=$data");

      // Log request
      BaseApiService.logRequest(
          url.toString(), 'GET', getHeader(userToken: token), null);

      var response = await http.get(url, headers: getHeader(userToken: token));

      // Log response
      BaseApiService.logResponse(
          url.toString(), response.statusCode, response.body);

      if (response.statusCode == 200) {
        final decodedResponse = json.decode(response.body);
        return decodedResponse;
      } else {
        throw ApiException('Failed to fetch service provider state',
            statusCode: response.statusCode);
      }
    } catch (e) {
      // Log error
      BaseApiService.logError(AppUrls.userState, e.toString());

      if (e is FormatException) {
        throw ApiException('Invalid response format from server');
      }

      throw ApiException(e.toString());
    }
  }

  getLandLordState() async {
    var data = await Preferences.getUserID();
    var token = await Preferences.getToken();
    print("Data ==> $data");

    Uri url = Uri.parse(
      AppUrls.landlordStat,
    );
    try {
      var res = await http.post(url,
          headers: getHeader(userToken: token),
          body: jsonEncode({"landlord_id": data}));
      return json.decode(res.body);
    } catch (e) {
      // Log error
      BaseApiService.logError(AppUrls.landlordStat, e.toString());

      if (e is FormatException) {
        throw ApiException('Invalid response format from server');
      }

      throw ApiException(e.toString());
    }
  }

  Future<Map<String, dynamic>> getTenantState() async {
    try {
      var data = await Preferences.getUserID();
      var token = await Preferences.getToken();
      Uri url = Uri.parse("${AppUrls.tenantStat}?tenant_id=$data");

      // Log request
      BaseApiService.logRequest(
          url.toString(), 'POST', getHeader(userToken: token), null);

      var response = await http.get(url, headers: getHeader(userToken: token));

      // Log response
      BaseApiService.logResponse(
          url.toString(), response.statusCode, response.body);

      if (response.statusCode == 200) {
        final decodedResponse = json.decode(response.body);
        return decodedResponse;
      } else {
        throw ApiException('Failed to fetch tenant state',
            statusCode: response.statusCode);
      }
    } catch (e) {
      // Log error
      BaseApiService.logError(AppUrls.tenantStat, e.toString());

      if (e is FormatException) {
        throw ApiException('Invalid response format from server');
      }

      throw ApiException(e.toString());
    }
  }

  Future<Map<String, dynamic>> getVisitorState() async {
    try {
      var data = await Preferences.getUserID();
      var token = await Preferences.getToken();
      Uri url = Uri.parse("${AppUrls.visitorStat}?visitor_id=$data");

      // Log request
      BaseApiService.logRequest(
          url.toString(), 'GET', getHeader(userToken: token), null);

      var response = await http.get(url, headers: getHeader(userToken: token));

      // Log response
      BaseApiService.logResponse(
          url.toString(), response.statusCode, response.body);

      // Check if response is HTML
      if (response.body.trim().startsWith('<!DOCTYPE html>')) {
        throw ApiException(
            'Server returned HTML instead of JSON. Please try again.');
      }

      if (response.statusCode == 200) {
        final decodedResponse = json.decode(response.body);
        return decodedResponse;
      } else {
        throw ApiException('Failed to fetch visitor state',
            statusCode: response.statusCode);
      }
    } catch (e) {
      // Log error
      BaseApiService.logError(AppUrls.visitorStat, e.toString());

      if (e is FormatException) {
        throw ApiException('Invalid response format from server');
      }

      throw ApiException(e.toString());
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
