import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:property_app/constant_widget/constant_widgets.dart';
import 'package:property_app/utils/api_urls.dart';
import 'package:property_app/utils/shared_preferences/preferences.dart';

import '../../utils/connectivity.dart';
import '../../utils/utils.dart';

class PropertyServices {

    getProperties() async {
      Uri url = Uri.parse(AppUrls.getProperties,);
      try {
        var res = await http.get(
            url,
          headers: getHeader(userToken: await Preferences.getToken())
        );
        return json.decode(res.body);
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
        return e;
      }
    }

  getLandLordProperties({required int userId}) async {
    Uri url = Uri.parse("${AppUrls.getLandLordProperty}?user_id=$userId",);
    try {
      var token = await Preferences.getToken();
      var res = await http.get(
        url,
        headers: getHeader(userToken: token)
      );
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

    Future<Map<String, dynamic>> getAllProperties(int pageKey, {Map<String, dynamic>? filters}) async {
      Uri url = Uri.parse("${AppUrls.getAllProperty}?page=$pageKey");
      try {
        var token = await Preferences.getToken();
        Map<String, String> headers = getHeader(userToken: token);

        // Prepare the body of the POST request
        Map<String, dynamic> body = filters ?? {};
        var response = await http.post(
            url,
            headers: headers,
            body: json.encode(body)  // Encoding the body to JSON format
        );

        if (response.statusCode == 200) {
          return json.decode(response.body);
        } else {
          // Handling errors or unsuccessful responses
          print('Error fetching properties: ${response.statusCode} ${response.body}');
          return {'status': false, 'message': 'Error fetching properties'};
        }
      } catch (e) {
        if (kDebugMode) {
          print('Exception caught: $e');
        }
        return {'status': false, 'message': e.toString()};
      }
    }

  getProperty({required int id}) async {
    Uri url = Uri.parse("${AppUrls.getProperty}/$id",);
    try {
      var token = await Preferences.getToken();
      var res = await http.get(
          url,
          headers: getHeader(userToken: token)
      );
      return json.decode(res.body);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return e;
    }
  }

  Future<Map<String, dynamic>> updateProperty({
    required int type,
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
    // required int noOfProperty,
    // required String propertyType,
    // required String availabilityStartTime,
    // required String availabilityEndTime,
    required String description,
  }) async {
    if (await ConnectivityUtility.checkInternetConnectivity() == true) {
      var url = Uri.parse("${AppUrls.updateProperty}/$id");
      var myId = await Preferences.getUserID();
      var token = await Preferences.getToken();
      var request = http.MultipartRequest('POST', url)
        ..headers.addAll({
          'Content-Type': 'multipart/form-data', // Add your desired content type
          'Authorization': 'Bearer $token', // Add your authorization token if needed
          // Add other headers as needed
        })
        ..fields.addAll({
          "user_id" : myId,
          'type': type.toString(),
          'city': city,
          'amount': amount.toString(),
          'address': address,
          'lat': lat.toString(),
          'long': long.toString(),
          'area_range': areaRange,
          'bedroom': bedroom.toString(),
          'bathroom': bathroom.toString(),
          "property_type" : propertyType,
          "property_sub_type" : propertyType,
          'description': bathroom.toString(),
        });

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
      // request.fields.addAll({
      //   'no_of_property': noOfProperty.toString(),
      //   'property_type': propertyType,
      //   'availability_start_time': availabilityStartTime,
      //   'availability_end_time': availabilityEndTime,
      // });

      try {
        var response = await request.send();
        var responseBody = await response.stream.bytesToString();
        return json.decode(responseBody);
      } catch (e) {
        // Handle general errors
        throw Exception('Failed to register property: $e');
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
      var request = http.MultipartRequest('POST', url)
        ..headers.addAll({
          'Content-Type': 'multipart/form-data', // Add your desired content type
          'Authorization': 'Bearer $token', // Add your authorization token if needed
           // Add other headers as needed
        })
        ..fields.addAll({
          "user_id" : myId.toString(),
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
          "property_type" : propertyType,
          "property_sub_type" : propertySubType,
        });

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
        throw Exception('Failed to register property: $e');
      }
    } else {
      AppUtils.getSnackBarNoInternet();
      throw Exception('No internet connectivity');
    }
  }

  deleteProperty({required int id}) async {
    Uri url = Uri.parse("${AppUrls.deleteProperty}/$id",);
    try {
      var res = await http.get(
          url,
          headers: getHeader(userToken: "2|klnaa5CRhLR8G8ik3kPQfTKurymTgSnbZdawrw5rdfff43e8")
      );
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
        var id = await Preferences.getUserID(); // Ensure you handle null or exceptions in getUserID
        var token = await Preferences.getToken(); // Ensure you handle null or exceptions in getToken

        final response = await http.post(
          url,
          headers: getHeader(userToken: token),
          body: jsonEncode({
            'user_id': id,
            'property_id': propertyId,
            'fav_flag': favFlag.toString(),
          }),
        );
        if (response.statusCode == 200) {
          print(response.body);
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




    Future<Map<String, dynamic>> getRentedProperties(int pageKey,) async {
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
          print('Error fetching properties: ${response.statusCode} ${response.body}');
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