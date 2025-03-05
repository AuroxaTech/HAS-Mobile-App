import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:property_app/constant_widget/constant_widgets.dart';
import 'package:property_app/utils/api_urls.dart';
import 'package:property_app/utils/base_api_service.dart';
import 'package:property_app/utils/shared_preferences/preferences.dart';

import '../../utils/connectivity.dart';
import '../../utils/utils.dart';

class PropertyServices extends BaseApiService {
  getProperties() async {
    Uri url = Uri.parse(
      AppUrls.getProperties,
    );
    try {
      var res = await http.get(url,
          headers: getHeader(userToken: await Preferences.getToken()));
      return json.decode(res.body);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return e;
    }
  }

  getLandLordProperties({required int userId}) async {
    Uri url = Uri.parse(
      "${AppUrls.getAllProperty}?user_id=$userId",
    );
    try {
      var token = await Preferences.getToken();
      var res = await http.get(url, headers: getHeader(userToken: token));
      return json.decode(res.body);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return e;
    }
  }

  // getAllProperties(int pageKey) async {
  //   Uri url = Uri.parse("${AppUrls.getAllProperty}?page=$pageKey",);
  //   try {
  //     var token = await Preferences.getToken();
  //     var res = await http.post(
  //         url,
  //         headers: getHeader(userToken: token)
  //     );
  //     return json.decode(res.body);
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print(e);
  //     }
  //     return e;
  //   }
  // }

  Future<Map<String, dynamic>> getAllProperties(int pageKey,
      {Map<String, dynamic>? filters}) async {
    try {
      var token = await Preferences.getToken();

      // Build URL with query parameters
      Uri url = Uri.parse(AppUrls.getAllProperty);
      if (filters != null && filters.isNotEmpty) {
        // Add filters as query parameters if they exist
        url = url.replace(queryParameters: {
          'page': pageKey.toString(),
          ...filters.map((key, value) => MapEntry(key, value.toString())),
        });
      } else {
        // Just add page parameter if no filters
        url = url.replace(queryParameters: {'page': pageKey.toString()});
      }

      // Log request
      BaseApiService.logRequest(
          url.toString(), 'GET', getHeader(userToken: token), filters);

      // Make GET request
      final response = await http.get(
        url,
        headers: getHeader(userToken: token),
      );

      // Log response
      BaseApiService.logResponse(
          url.toString(), response.statusCode, response.body);

      if (response.statusCode == 200) {
        final decodedResponse = json.decode(response.body);

        // Adapt the response to match the expected format
        if (decodedResponse['success'] == true) {
          final properties = decodedResponse['payload'] as List;

          // Only return properties if this is the first page
          // For subsequent pages, return empty list to stop pagination
          return {
            'status': true,
            'data': {
              'current_page': pageKey,
              'data': pageKey == 1 ? properties : [],
              'last_page': 1,
            }
          };
        } else {
          throw ApiException(
              decodedResponse['message'] ?? 'Failed to fetch properties',
              statusCode: response.statusCode);
        }
      } else {
        throw ApiException('Error fetching properties',
            statusCode: response.statusCode);
      }
    } catch (e) {
      BaseApiService.logError(AppUrls.getAllProperty, e.toString());

      if (e is ApiException) {
        BaseApiService.handleApiException(e);
        rethrow;
      }

      return {'status': false, 'message': e.toString()};
    }
  }

  getProperty({required int id}) async {
    Uri url = Uri.parse(
      "${AppUrls.propertyDetail}/$id",
    );
    try {
      var token = await Preferences.getToken();
      var res = await http.get(url, headers: getHeader(userToken: token));
      return json.decode(res.body);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return e;
    }
  }

  Future<Map<String, dynamic>> updateProperty({
    required String type,
    required int id,
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
    required String propertyType,
    required String propertySubType,
    required String description,
  }) async {
    if (await ConnectivityUtility.checkInternetConnectivity() == true) {
      var url = Uri.parse("${AppUrls.updateProperty}/$id");
      var token = await Preferences.getToken();
      var request = http.MultipartRequest('POST', url)
        ..headers.addAll({
          'Content-Type': 'multipart/form-data',
          'Authorization': 'Bearer $token',
        })
        ..fields.addAll({
          'type': type,
          'city': city,
          'amount': amount.toString(),
          'address': address,
          'lat': lat.toString(),
          'long': long.toString(),
          'area_range': areaRange,
          'bedroom': bedroom.toString(),
          'bathroom': bathroom.toString(),
          "property_type": propertyType,
          "property_sub_type": propertySubType,
          'description': description,
        });

      // Add electricity bill file
      request.files.add(await http.MultipartFile.fromPath(
        'electricity_bill_image',
        electricityBill.path,
        filename: 'electricity_bill.jpg',
      ));

      // Add property images
      for (var i = 0; i < propertyImages.length; i++) {
        request.files.add(await http.MultipartFile.fromPath(
          'property_images[$i]',
          propertyImages[i].path,
          filename: 'property_image_$i.jpg',
        ));
      }

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      print("Raw Response: $responseBody"); // Debugging step

      try {
        var response = await request.send();
        var responseBody = await response.stream.bytesToString();

        print("Raw Response: $responseBody"); // Debugging step

        var data = json.decode(responseBody);
        return data;
      } catch (e) {
        print("Error updating property: $e");
        throw Exception('Failed to update property: $e');
      }
    } else {
      AppUtils.getSnackBarNoInternet();
      throw Exception('No internet connectivity');
    }
  }


  Future<Map<String, dynamic>> addProperty({
    required int type,
    required String city,
    required double amount,
    required String address,
    required double lat,
    required double long,
    required String areaRange,
    required int bedroom,
    required String bathroom,
    required XFile electricityBill,
    required List<XFile> propertyImages,
    required String description,
    required String propertyType,
    required String propertySubType,
  }) async {
    if (await ConnectivityUtility.checkInternetConnectivity() == true) {
      var url = Uri.parse(AppUrls.addProperty);
      var myId = await Preferences.getUserID();
      var token = await Preferences.getToken();
      print(myId);
      print(token);
      var request = http.MultipartRequest('POST', url)
        ..headers.addAll({
          'Content-Type':
              'multipart/form-data', // Add your desired content type
          'Authorization':
              'Bearer $token', // Add your authorization token if needed
          // Add other headers as needed
        })
        ..fields.addAll({
          'type': "$type",
          'city': city,
          'amount': amount.toString(),
          'address': address,
          'lat': lat.toString(),
          'long': long.toString(),
          'area_range': areaRange,
          'bedroom': bedroom.toString(),
          'bathroom': bathroom.toString(),
          'description': description.toString(),
          "property_type": propertyType,
          "property_sub_type": propertySubType,
        });

      request.files.add(await http.MultipartFile.fromPath(
        'electricity_bill_image',
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
      // request.fields.addAll({
      //   'no_of_property': noOfProperty.toString(),
      //   'property_type': propertyType,
      //   'availability_start_time': availabilityStartTime,
      //   'availability_end_time': availabilityEndTime,
      // });



      try {
        var response = await request.send();
        print(response.statusCode);
        var responseBody = await response.stream.bytesToString();
        return json.decode(responseBody);
      } catch (e) {
        // Handle general errors
        var response = await request.send();
        var responseBody = await response.stream.bytesToString();
        print("response $responseBody");
        rethrow;
        throw Exception('Failed to register property: $e');
      }
    } else {
      AppUtils.getSnackBarNoInternet();
      throw Exception('No internet connectivity');
    }
  }

  deleteProperty({required int id}) async {
    Uri url = Uri.parse(
      "${AppUrls.deleteProperty}/$id",
    );
    var token = await Preferences.getToken();
    try {
      var res = await http.get(url,
          headers: getHeader(
              userToken: token));
      return json.decode(res.body);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return e;
    }
  }

  Future<bool> addFavoriteProperty(int propertyId, int favFlag) async {
    try {
      // Check internet connectivity first
      bool? isConnected = await ConnectivityUtility.checkInternetConnectivity();
      if (!isConnected!) {
        return false; // Return false or throw a custom exception if you prefer
      }

      var url = Uri.parse(AppUrls.addFavoriteProperty);
      var id = await Preferences
          .getUserID(); // Ensure you handle null or exceptions in getUserID
      var token = await Preferences
          .getToken(); // Ensure you handle null or exceptions in getToken

      final response = await http.post(
        url,
        headers: getHeader(userToken: token),
        body: jsonEncode({
          'user_id': id,
          'property_id': propertyId,
          'fav_flag': favFlag.toString(),
        }),
      );
      print( "body" +response.body);

      if (response.statusCode == 200) {
        print(response.body);
        print(response);
        return true;
      } else {
        print(response.body);
        return false;
      }
    } catch (e) {
      print(e); // Consider logging the error
      return false; // Return false or handle as needed
    }
  }

  Future<Map<String, dynamic>> getRentedProperties(
    int pageKey,
  ) async {
    Uri url = Uri.parse("${AppUrls.getApprovedContractProperty}?page=$pageKey");
    try {
      var token = await Preferences.getToken();
      Map<String, String> headers = getHeader(userToken: token);

      // Prepare the body of the POST request
      var response = await http.get(
        url,
        headers: headers,
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        // Handling errors or unsuccessful responses
        print(
            'Error fetching properties: ${response.statusCode} ${response.body}');
        return {'status': false, 'message': 'Error fetching properties'};
      }
    } catch (e) {
      if (kDebugMode) {
        print('Exception caught: $e');
      }
      return {'status': false, 'message': e.toString()};
    }
  }
}
