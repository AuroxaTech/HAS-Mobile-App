import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:property_app/constant_widget/constant_widgets.dart';
import 'package:property_app/utils/shared_preferences/preferences.dart';

import '../../utils/api_urls.dart';
import '../../utils/connectivity.dart';
import '../../utils/utils.dart';

class ServiceProviderServices {
  Future<Map<String, dynamic>> addService({
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
    List<XFile>? mediaFiles,
  }) async {
    if (await ConnectivityUtility.checkInternetConnectivity() == true) {
      var url = Uri.parse(AppUrls.addServices); // Ensure this is correct
      var token = await Preferences.getToken();
      var request = http.MultipartRequest('POST', url)
        ..headers.addAll({
          'Authorization': 'Bearer $token',
        })
        ..fields.addAll({
          'user_id': userId.toString(),
          'service_name': serviceName.toString(),
          'description': description,
          'pricing': pricing,
          'start_time': startTime,
          'end_time': endTime,
          'location': location,
          'country': country,
          'city': city,
          'lat': lat.toString(),
          'long': long.toString(),
          'additional_information': additionalInformation,
        });

      if (mediaFiles != null) {
        for (var file in mediaFiles) {
          request.files.add(await http.MultipartFile.fromPath(
            'media[]',
            file.path,
          ));
        }
      }

      try {
        var streamedResponse = await request.send();
        var response = await http.Response.fromStream(streamedResponse);

        if (response.statusCode == 200) {
          print("Raw Response: ${response.body}");
          return json.decode(response.body);
        } else {
          // Handle non-200 responses
          print("Server responded with status code: ${response.statusCode}");
          print("Raw Response: ${response.body}");
          throw Exception(
              'Failed to add service, server responded with status code: ${response.statusCode}');
        }
      } catch (e) {
        // Handle general errors
        throw Exception('Failed to add service: $e');
      }
    } else {
      // Handle no internet connectivity
      AppUtils.getSnackBarNoInternet();
      throw Exception('No internet connectivity');
    }
  }

  getServices({required int userId}) async {
    Uri url = Uri.parse(
      "${AppUrls.getServices}?user_id=$userId",
    );
    var token = await Preferences.getToken();
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

  getAllServices(int page, {Map<String, dynamic>? filters}) async {
    Uri url = Uri.parse(
      "${AppUrls.getServices}?page=$page",
    );
    try {
      var token = await Preferences.getToken();
      Map<String, String> headers = getHeader(userToken: token);

      // Prepare the body of the POST request
      Map<String, dynamic> body = filters ?? {};
      var res = await http.post(url,
          headers: headers,
          body: json.encode(body) // Encoding the body to JSON format
          );
      print("All Services ==> ${json.decode(res.body)}");
      return json.decode(res.body);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      rethrow;
    }
  }

  getService({required int id}) async {
    Uri url = Uri.parse(
      "${AppUrls.getService}/$id",
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

  Future<Map<String, dynamic>> newServiceRequest({
    required String serviceId,
    required String serviceProviderId,
    required String address,
    required double lat,
    required double lng,
    required int propertyType,
    required int price,
    required String date,
    required String time,
    required String description,
    required String additionalInfo,
    required int postalCode,
    required int isApplied,
  }) async {
    if (await ConnectivityUtility.checkInternetConnectivity() == true) {
      var url = Uri.parse(AppUrls.addServiceRequest);
      var token = await Preferences.getToken();
      var id = await Preferences.getUserID();
      print("isApplied ===> $isApplied");
      // Create the body map
      final bodyData = {
        "user_id": id,
        "serviceprovider_id": serviceProviderId,
        "service_id": serviceId,
        "address": address,
        "lat": lat,
        "long": lng,
        "property_type": propertyType,
        "date": date,
        "time": time,
        "description": description,
        "additional_info": additionalInfo,
        "price": price,
        "postal_code": postalCode,
        "is_applied": isApplied
      };

      // Print the entire data before sending it in the API request
      print("Data being sent in the API request: $bodyData");

      var response = await http.post(
        url,
        headers: getHeader(userToken: token),
        body: json.encode(bodyData),
      );

      print("New Service Request ==> ${response.toString()}");

      if (response.statusCode == 200) {
        try {
          var data = json.decode(response.body);
          return data;
        } catch (e) {
          print("Error decoding JSON: $e");
          // Handle non-JSON response
          return {"error": "Invalid JSON format"};
        }
      } else {
        print("Server returned an error: ${response.statusCode}");
        // Handle server error
        return {"error": "Server returned an error"};
      }
    } else {
      // Handle no internet connectivity
      AppUtils.getSnackBarNoInternet();
      throw Exception('No internet connectivity');
    }
  }

  Future<bool> addFavorite(int serviceId, int favFlag) async {
    try {
      // Check internet connectivity first
      bool? isConnected = await ConnectivityUtility.checkInternetConnectivity();
      if (!isConnected!) {
        return false; // Return false or throw a custom exception if you prefer
      }

      var url = Uri.parse(AppUrls.addFavouriteService);
      var id = await Preferences
          .getUserID(); // Ensure you handle null or exceptions in getUserID
      var token = await Preferences
          .getToken(); // Ensure you handle null or exceptions in getToken

      final response = await http.post(
        url,
        headers: getHeader(userToken: token),
        body: jsonEncode({
          'user_id': id,
          'service_id': serviceId,
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

  deleteService({required int id}) async {
    Uri url = Uri.parse(
      "${AppUrls.deleteService}/$id",
    );
    var token = await Preferences.getToken();
    try {
      var res = await http.delete(url, headers: getHeader(userToken: token));
      return json.decode(res.body);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return e;
    }
  }

  Future<Map<String, dynamic>> updateService({
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
    if (await ConnectivityUtility.checkInternetConnectivity() == true) {
      var url = Uri.parse("${AppUrls.updateService}/$id");
      var token = await Preferences.getToken();
      var ids = await Preferences.getToken();
      var request = http.MultipartRequest('POST', url)
        ..headers.addAll({
          'Content-Type': 'multipart/form-data',
          'Authorization': 'Bearer $token',
        })
        ..fields.addAll({
          'user_id': ids,
          'service_name': serviceName,
          'description': description,
          'category_id': categoryId,
          'pricing': pricing,
          'duration_id': durationId,
          'start_time': startTime,
          'end_time': endTime,
          'location': location,
          'lat': lat,
          'long': long,
          'additional_information': additionalInformation,
        });
      if (mediaFiles != null) {
        for (var i = 0; i < mediaFiles.length; i++) {
          request.files.add(await http.MultipartFile.fromPath(
            'media[$i]',
            mediaFiles[i].path,
            filename: 'media_$i.jpg',
          ));
        }
      }

      try {
        var response = await request.send();
        var responseBody = await response.stream.bytesToString();
        print("Raw Response: $responseBody");
        var data = json.decode(responseBody);
        print("Data Response: $data");
        return data = json.decode(responseBody);
      } catch (e) {
        // Handle general errors
        throw Exception('Failed to add service: $e');
      }
    } else {
      // Handle no internet connectivity
      AppUtils.getSnackBarNoInternet();
      throw Exception('No internet connectivity');
    }
  }

  getServiceProviderRequest({required int page}) async {
    print("Page ==> $page");
    Uri url = Uri.parse(
      "${AppUrls.getServiceProviderRequest}?page=$page",
    );
    try {
      var token = await Preferences.getToken();
      var id = await Preferences.getUserID();
      print("serviceprovider_id ==> $id");
      var res = await http.post(url,
          headers: getHeader(userToken: token),
          body: json.encode({"serviceprovider_id": id}));
      return json.decode(res.body);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return e;
    }
  }

  getServiceUserRequest({required int userId}) async {
    Uri url = Uri.parse(
      "${AppUrls.getServiceUserRequest}?user_id=$userId",
    );
    try {
      var token = await Preferences.getToken();
      var res = await http.post(url, headers: getHeader(userToken: token));
      return json.decode(res.body);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return e;
    }
  }

  getMyJobs({required int userId, required int page}) async {
    print("UserId ==> $userId");
    Uri url = Uri.parse(
      "${AppUrls.getJobs}?user_id=$userId&page=$page",
    );
    try {
      var token = await Preferences.getToken();
      var res = await http.post(url, headers: getHeader(userToken: token));
      return json.decode(res.body);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return e;
    }
  }

  getMyServiceUserRequest({required int userId}) async {
    Uri url = Uri.parse(
      "${AppUrls.getServiceUserRequest}?user_id=$userId",
    );
    try {
      var token = await Preferences.getToken();
      var res = await http.post(url, headers: getHeader(userToken: token));
      return json.decode(res.body);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return e;
    }
  }

  Future<Map<String, dynamic>> getFavoriteServices(
      {required int id, required int page}) async {
    try {
      Uri url = Uri.parse("${AppUrls.getFavourite}?page=$page");
      var id = await Preferences.getUserID();
      var res = await http.post(url,
          headers: getHeader(userToken: await Preferences.getToken()),
          body: json.encode({
            "user_id": id,
          }));
      print(res);
      return json.decode(res.body);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      rethrow;
      return {'error': 'Failed to fetch favorite services.'};
    }
  }

  Future<Map<String, dynamic>> declineServiceRequest({
    required int requestId,
  }) async {
    try {
      Uri url = Uri.parse(AppUrls.serviceRequestDecline);
      var token = await Preferences.getToken();
      var res = await http.post(
        url,
        body: json.encode({"request_id": requestId}),
        headers: getHeader(userToken: token),
      );
      return json.decode(res.body);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return {'error': 'Failed to decline service request.'};
    }
  }

  Future<Map<String, dynamic>> acceptServiceRequest(
      {required String userid,
      required String providerId,
      required int requestId}) async {
    try {
      Uri url = Uri.parse(AppUrls.serviceRequestAccept);
      var token = await Preferences.getToken();
      var res = await http.post(
        url,
        body: json.encode({
          "user_id": userid,
          "provider_id": providerId,
          "request_id": requestId,
        }),
        headers: getHeader(userToken: token),
      );
      return json.decode(res.body);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return {'error': 'Failed to decline service request.'};
    }
  }

  Future<Map<String, dynamic>> markJobCompleteRequest({
    required int? jobId,
    required int? status,
  }) async {
    try {
      Uri url = Uri.parse(AppUrls.markCompleteRequest);
      var token = await Preferences.getToken();
      var res = await http.post(
        url,
        body: json.encode({
          "job_id": jobId,
          "status": status,
        }),
        headers: getHeader(userToken: token),
      );
      return json.decode(res.body);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return {'error': 'Failed to decline service request.'};
    }
  }

  getServiceRequest({required int id}) async {
    Uri url = Uri.parse(
      "${AppUrls.getServiceRequest}/$id",
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

  getAllProviderJob(int page) async {
    Uri url = Uri.parse(
      "${AppUrls.getServiceProviderJob}?page=$page",
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

  getAllServiceFeedBack(int page) async {
    Uri url = Uri.parse(
      "${AppUrls.getServiceFeedback}?page=$page",
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

  getTenantContracts() async {
    Uri url = Uri.parse(AppUrls.getTenantContract);
    try {
      var token = await Preferences.getToken();
      var res = await http.get(
        url,
        headers: getHeader(userToken: token),
      );
      return json.decode(res.body);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return e;
    }
  }

  getLandLordContracts() async {
    Uri url = Uri.parse(AppUrls.getLandlordContract);
    try {
      var token = await Preferences.getToken();
      var res = await http.get(
        url,
        headers: getHeader(userToken: token),
      );
      return json.decode(res.body);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return e;
    }
  }

  Future<Map<String, dynamic>> acceptContractRequest(
      {required int contractId, required String status}) async {
    try {
      var token = await Preferences.getToken();
      Uri url = Uri.parse(AppUrls.acceptContract);
      var res = await http.post(
        url,
        body: json.encode({
          "contract_id": contractId,
          "status": status,
        }),
        headers: getHeader(userToken: token),
      );
      return json.decode(res.body);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return {'error': 'Failed to accept contract request.'};
    }
  }

  getContractDetail({required int id}) async {
    Uri url = Uri.parse(
      "${AppUrls.contractDetail}/$id",
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

  getJobDetail({required int id}) async {
    Uri url = Uri.parse(
      "${AppUrls.getServiceRequest}/$id",
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

  getServiceJob({required int? id}) async {
    print("Calling service job API for ID: $id");
    Uri url = Uri.parse(
      "${AppUrls.getServiceJobDetail}/$id",
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
}
