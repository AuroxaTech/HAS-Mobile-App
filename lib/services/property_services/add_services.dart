import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:property_app/constant_widget/constant_widgets.dart';
import 'package:property_app/utils/shared_preferences/preferences.dart';

import '../../utils/api_urls.dart';
import '../../utils/base_api_service.dart';
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

  Future<Map<String, dynamic>> getServices({required int userId}) async {
    try {
      var token = await Preferences.getToken();
      Uri url = Uri.parse("${AppUrls.getServices}?user_id=$userId");

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

        if (decodedResponse['success'] == true) {
          return {
            'status': true,
            'data': decodedResponse['payload'],
            'message': decodedResponse['message']
          };
        } else {
          throw ApiException(
              decodedResponse['message'] ?? 'Failed to fetch services');
        }
      } else {
        throw ApiException('Failed to fetch services',
            statusCode: response.statusCode);
      }
    } catch (e) {
      // Log error
      BaseApiService.logError(AppUrls.getServices, e.toString());

      if (e is FormatException) {
        throw ApiException('Invalid response format from server');
      }

      throw ApiException(e.toString());
    }
  }

  Future<Map<String, dynamic>> getAllServices(int page, {Map<String, dynamic>? filters}) async {
    // Construct query parameters
    Map<String, String> queryParams = {'page': page.toString()};

    if (filters != null) {
      filters.forEach((key, value) {
        if (value != null && value.toString().isNotEmpty) {
          queryParams[key] = value.toString();
        }
      });
    }

    // Construct final URL with query parameters
    Uri url = Uri.parse(AppUrls.getServices).replace(queryParameters: queryParams);

    try {
      var token = await Preferences.getToken();
      Map<String, String> headers = getHeader(userToken: token);

      // Use GET request instead of POST
      var res = await http.get(url, headers: headers);

      print("All Services ==> ${json.decode(res.body)}");

      if (res.statusCode == 200) {
        return json.decode(res.body);
      } else {
        print('Error fetching services: ${res.statusCode} ${res.body}');
        return {'status': false, 'message': 'Error fetching services'};
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return {'status': false, 'message': e.toString()};
    }
  }


  Future<Map<String, dynamic>> getService({required int id}) async {
    try {
      var token = await Preferences.getToken();
      Uri url = Uri.parse("${AppUrls.getService}/$id");

      // Log request
      BaseApiService.logRequest(
        url.toString(),
        'GET',
        getHeader(userToken: token),
        null
      );

      var response = await http.get(
        url,
        headers: getHeader(userToken: token)
      );

      // Log response
      BaseApiService.logResponse(
        url.toString(),
        response.statusCode,
        response.body
      );

      // Check if response is HTML
      if (response.body.trim().startsWith('<!DOCTYPE html>')) {
        throw ApiException('Server returned HTML instead of JSON. Please try again.');
      }

      if (response.statusCode == 200) {
        final decodedResponse = json.decode(response.body);
        
        if (decodedResponse['success'] == true) {
          return {
            'status': true,
            'data': decodedResponse['payload'],
            'message': decodedResponse['message']
          };
        } else {
          throw ApiException(decodedResponse['message'] ?? 'Failed to fetch service details');
        }
      } else {
        throw ApiException(
          'Failed to fetch service details',
          statusCode: response.statusCode
        );
      }
    } catch (e) {
      // Log error
      BaseApiService.logError("${AppUrls.getService}/$id", e.toString());

      if (e is FormatException) {
        throw ApiException('Invalid response format from server');
      }

      throw ApiException(e.toString());
    }
  }

  Future<Map<String, dynamic>> newServiceRequest({
    required String serviceId,
    required String serviceProviderId,
    required String address,
    required double lat,
    required double lng,
    required int propertyType,
    required String date,
    required String time,
    required String description,
    required String additionalInfo,
    required int price,
    required int postalCode,
    required int isApplied,
  }) async {
    try {
      var token = await Preferences.getToken();
      var userId = await Preferences.getUserID();
      Uri url = Uri.parse(AppUrls.addServiceRequest);

      // Create multipart request
      var request = http.MultipartRequest('POST', url)
        ..headers.addAll(getHeader(userToken: token))
        ..fields.addAll({
          'user_id': userId.toString(),
          'service_name': serviceId,
          'location': address,
          'lat': lat.toString(),
          'long': lng.toString(),
          'description': description,
          'pricing': price.toString(),
          'duration': '1', // Default duration
          'start_time': time.split(' - ')[0],
          'end_time': time.split(' - ')[1],
          'additional_information': additionalInfo,
          'country': 'Canada', // Default country
          'city': address.split(',').last.trim(),
          'year_experience': '0', // Not required for request
          'provider_id': serviceProviderId,
        });

      // Log request
      BaseApiService.logRequest(
        url.toString(),
        'POST',
        request.headers,
        request.fields
      );

      // Send request
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      // Log response
      BaseApiService.logResponse(
        url.toString(),
        response.statusCode,
        response.body
      );

      if (response.statusCode == 200) {
        final decodedResponse = json.decode(response.body);
        
        if (decodedResponse['success'] == true) {
          return {
            'status': true,
            'message': decodedResponse['message'],
            'data': decodedResponse['payload']
          };
        } else {
          throw ApiException(decodedResponse['message'] ?? 'Failed to create service request');
        }
      } else {
        throw ApiException(
          'Failed to create service request',
          statusCode: response.statusCode
        );
      }
    } catch (e) {
      // Log error
      BaseApiService.logError(AppUrls.addServiceRequest, e.toString());

      if (e is FormatException) {
        throw ApiException('Invalid response format from server');
      }

      throw ApiException(e.toString());
    }
  }

  Future<bool> addFavorite(int serviceId, ) async {
    try {
      // Check internet connectivity first
      bool? isConnected = await ConnectivityUtility.checkInternetConnectivity();
      if (!isConnected) {
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
          'service_id': serviceId,
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
      var res = await http.get(url,
          headers: getHeader(userToken: await Preferences.getToken()),
         );
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
