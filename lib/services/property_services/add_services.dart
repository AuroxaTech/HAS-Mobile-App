import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:property_app/constant_widget/constant_widgets.dart';
import 'package:property_app/utils/shared_preferences/preferences.dart';
import 'package:path/path.dart' as path;

import '../../models/propert_model/service_image_model.dart';
import '../../models/service_provider_model/all_services.dart';
import '../../utils/api_urls.dart';
import '../../utils/base_api_service.dart';
import '../../utils/connectivity.dart';

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
    required String yearsExperience,
    required String duration,
    required String categoryId,
    List<XFile>? mediaFiles,
  }) async {
    try {
      var token = await Preferences.getToken();
      Uri url = Uri.parse(AppUrls.addServices);

      // Create multipart request
      var request = http.MultipartRequest('POST', url)
        ..headers.addAll({
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        })
        ..fields.addAll({
          'service_name': serviceName,
          'description': description,
          'pricing': pricing,
          'duration': duration,
          'start_time': startTime,
          'end_time': endTime,
          'location': location,
          'lat': lat.toString(),
          'long': long.toString(),
          'additional_information': additionalInformation,
          'country': country,
          'city': city,
          'year_experience': yearsExperience,
          'category_id': categoryId,
        });

      // Add media files if provided
      if (mediaFiles != null) {
        for (var file in mediaFiles) {
          var stream = http.ByteStream(file.openRead());
          var length = await file.length();

          var multipartFile = http.MultipartFile(
            'service_images[]',
            stream,
            length,
            filename: file.name,
          );
          request.files.add(multipartFile);
        }
      }

      // Log request
      BaseApiService.logRequest(
        url.toString(),
        'POST',
        request.headers,
        request.fields,
      );

      // Send request
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      // Log response
      BaseApiService.logResponse(
        url.toString(),
        response.statusCode,
        response.body,
      );

      print("Server responded with status code: ${response.statusCode}");
      print("Raw Response: ${response.body}");

      if (response.statusCode == 302) {
        throw Exception(
            "Server redirected the request. Please check the API endpoint.");
      }

      if (response.body.trim().startsWith('<!DOCTYPE html>')) {
        throw Exception(
            "Server returned HTML instead of JSON. Please check the API endpoint.");
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decodedResponse = json.decode(response.body);

        if (decodedResponse['success'] == true) {
          return {
            'status': true,
            'messages': decodedResponse['message'],
            'data': decodedResponse['payload']
          };
        } else {
          throw Exception(
              decodedResponse['message'] ?? 'Failed to add service');
        }
      } else {
        throw Exception(
            'Failed to add service, server responded with status code: ${response.statusCode}');
      }
    } catch (e) {
      print("Error in addService: $e");
      throw Exception('Failed to add service: $e');
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

  Future<Map<String, dynamic>> getAllServices(int page,
      {Map<String, dynamic>? filters}) async {
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
    Uri url =
        Uri.parse(AppUrls.getServices).replace(queryParameters: queryParams);

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
              decodedResponse['message'] ?? 'Failed to fetch service details');
        }
      } else {
        throw ApiException('Failed to fetch service details',
            statusCode: response.statusCode);
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
    required String serviceName,
    required String location,
    required double lat,
    required double lng,
    required String description,
    required String propertyType,
    required String price,
    required String duration,
    required String startTime,
    required String endTime,
    required String additionalInfo,
    required String country,
    required String city,
    required String yearExperience,
    required String cnicFrontPic,
    required String cnicBackPic,
    required String certification,
    required String resume,
    required String providerId,
    required int isApplied,
    required List<dynamic> serviceImages,
  }) async {
    try {
      var token = await Preferences.getToken();
      var userId = await Preferences.getUserID();
      Uri url = Uri.parse(AppUrls.addServiceRequest);

      // Create multipart request
      var request = http.MultipartRequest('POST', url)
        ..headers.addAll({
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        })
        ..fields.addAll({
          'user_id': userId.toString(),
          'service_id': serviceId,
          'service_name': serviceName,
          'property_type': propertyType,
          'location': location,
          'lat': lat.toString(),
          'long': lng.toString(),
          'description': description,
          'pricing': price,
          'duration': duration,
          'start_time': startTime,
          'end_time': endTime,
          'additional_information': additionalInfo,
          'country': country,
          'city': city,
          'year_experience': yearExperience,
          'provider_id': providerId,
          'is_applied': isApplied.toString(),
        });

      // Add service images
      if (serviceImages.isNotEmpty) {
        for (int i = 0; i < serviceImages.length; i++) {
          var image = serviceImages[i];
          String imageUrl;

          if (image is ServiceImage) {
            imageUrl = image.imagePath;
          } else if (image is Map) {
            imageUrl = image['image_path'];
          } else {
            imageUrl = image.toString();
          }

          try {
            // Download the image
            var imageResponse = await http.get(Uri.parse(imageUrl));
            if (imageResponse.statusCode == 200) {
              // Create a temporary file
              final tempDir = Directory.systemTemp;
              final fileName = path.basename(imageUrl);
              final tempFile = File('${tempDir.path}/$fileName');
              await tempFile.writeAsBytes(imageResponse.bodyBytes);

              // Add the file to the request
              var multipartFile = await http.MultipartFile.fromPath(
                'service_images[$i]',
                tempFile.path,
              );
              request.files.add(multipartFile);
            }
          } catch (e) {
            print('Error downloading image $i: $e');
            continue;
          }
        }
      }

      // Log request
      BaseApiService.logRequest(
        url.toString(),
        'POST',
        request.headers,
        request.fields,
      );

      // Send request
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      // Log response
      BaseApiService.logResponse(
        url.toString(),
        response.statusCode,
        response.body,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decodedResponse = json.decode(response.body);

        if (decodedResponse['success'] == true) {
          return {
            'status': true,
            'message': decodedResponse['message'],
            'data': decodedResponse['payload']
          };
        } else {
          throw ApiException(
            decodedResponse['message'] ?? 'Failed to create service request',
          );
        }
      } else {
        throw ApiException(
          'Failed to create service request',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      print("Error in newServiceRequest: $e");
      throw ApiException(e.toString());
    }
  }

  Future<bool> addFavorite(
    int serviceId,
  ) async {
    try {
      // Check internet connectivity first
      bool? isConnected = await ConnectivityUtility.checkInternetConnectivity();
      if (!isConnected) {
        return false; // Return false or throw a custom exception if you prefer
      }

      var url = Uri.parse(AppUrls.addFavouriteService);
      var token = await Preferences
          .getToken(); // Ensure you handle null or exceptions in getToken

      final response = await http.post(
        url,
        headers: getHeader(userToken: token),
        body: jsonEncode({
          'service_id': serviceId,
        }),
      );

      print("response body: ${response.body}");
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

  Future<bool> removeFavoriteService(int propertyId) async {
    try {
      // Check internet connectivity first
      bool? isConnected = await ConnectivityUtility.checkInternetConnectivity();
      if (!isConnected) {
        return false; // Return false or throw a custom exception if you prefer
      }

      // Define the API URL for the DELETE request
      var url =
          Uri.parse('${AppUrls.baseUrl}/service-favourites/delete/$propertyId');

      var id = await Preferences
          .getUserID(); // Ensure you handle null or exceptions in getUserID
      var token = await Preferences
          .getToken(); // Ensure you handle null or exceptions in getToken

      // Make the API DELETE call
      final response = await http.get(
        url,
        headers: getHeader(userToken: token),
      );

      print("Response body: " + response.body);

      if (response.statusCode == 200) {
        print(response.body);
        return true; // Successfully removed from favorites
      } else {
        print(response.body);
        return false; // Failed to remove favorite
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
      var token = await Preferences.getToken();
      Uri url = Uri.parse("${AppUrls.deleteService}/$id");

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
        return {
          'success': decodedResponse['success'] ?? false,
          'messages': decodedResponse['message'] ?? 'Unknown error occurred',
          'data': decodedResponse['payload']
        };
      } else {
        throw ApiException('Failed to delete service',
            statusCode: response.statusCode);
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error in deleteService: $e");
      }
      if (e is FormatException) {
        return {
          'success': false,
          'messages': 'Invalid response format from server'
        };
      }
      return {'success': false, 'messages': e.toString()};
    }
  }

  Future<Map<String, dynamic>> updateService({
    required String id,
    required String serviceName,
    required String description,
    required String pricing,
    required String duration,
    required String startTime,
    required String endTime,
    required String location,
    required String country,
    required String city,
    required String lat,
    required String long,
    required String additionalInformation,
    required String yearsExperience,
    List<XFile>? mediaFiles,
  }) async {
    try {
      var token = await Preferences.getToken();
      Uri url = Uri.parse("${AppUrls.updateService}/$id");

      // Create multipart request
      var request = http.MultipartRequest('POST', url)
        ..headers.addAll({
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        })
        ..fields.addAll({
          'service_name': serviceName,
          'description': description,
          'pricing': pricing,
          'duration': duration,
          'start_time': startTime,
          'end_time': endTime,
          'location': location,
          'lat': lat,
          'long': long,
          'additional_information': additionalInformation,
          'country': country,
          'city': city,
          'year_experience': yearsExperience,
        });

      // Add media files if provided
      if (mediaFiles != null) {
        for (var file in mediaFiles) {
          var stream = http.ByteStream(file.openRead());
          var length = await file.length();

          var multipartFile = http.MultipartFile(
            'service_images[]',
            stream,
            length,
            filename: file.name,
          );
          request.files.add(multipartFile);
        }
      }

      // Log request
      BaseApiService.logRequest(
        url.toString(),
        'POST',
        request.headers,
        request.fields,
      );

      // Send request
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      // Log response
      BaseApiService.logResponse(
        url.toString(),
        response.statusCode,
        response.body,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decodedResponse = json.decode(response.body);

        if (decodedResponse['success'] == true) {
          return {
            'status': true,
            'messages': decodedResponse['message'],
            'data': decodedResponse['payload']
          };
        } else {
          throw Exception(
              decodedResponse['message'] ?? 'Failed to update service');
        }
      } else {
        throw Exception(
            'Failed to update service, server responded with status code: ${response.statusCode}');
      }
    } catch (e) {
      print("Error in updateService: $e");
      throw Exception('Failed to update service: $e');
    }
  }

  Future<Map<String, dynamic>> getServiceProviderRequest(
      {required int page}) async {
    try {
      var token = await Preferences.getToken();
      var userId = await Preferences.getUserID();
      Uri url = Uri.parse(
          "${AppUrls.getServiceProviderRequest}?serviceprovider_id=$userId&page=$page");

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

        if (decodedResponse['status'] == true) {
          return {
            'status': true,
            'data': decodedResponse['data'],
            'message': decodedResponse['message']
          };
        } else {
          throw ApiException(
              decodedResponse['message'] ?? 'Failed to fetch service requests');
        }
      } else {
        throw ApiException('Failed to fetch service requests',
            statusCode: response.statusCode);
      }
    } catch (e) {
      // Log error
      BaseApiService.logError(AppUrls.getServiceProviderRequest, e.toString());

      if (e is FormatException) {
        throw ApiException('Invalid response format from server');
      }

      throw ApiException(e.toString());
    }
  }

  Future<Map<String, dynamic>> getServiceUserRequest(
      {required int userId}) async {
    var token = await Preferences.getToken();
    var userId = await Preferences.getUserID();
    Uri url = Uri.parse("${AppUrls.getServiceUserRequest}?user_id=$userId");
    try {
      BaseApiService.logRequest(
          'GET',
          '${AppUrls.getServiceUserRequest}?user_id=$userId',
          getHeader(userToken: token),
          null);
      var response = await http.get(url, headers: getHeader(userToken: token));

      BaseApiService.logResponse(
          url.toString(), response.statusCode, response.body);
      if (response.body.startsWith('<!DOCTYPE html>')) {
        throw ApiException('Received HTML response instead of JSON');
      }

      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      if (jsonResponse['status'] == true) {
        return {
          'status': true,
          'data': jsonResponse['data'],
          'message': jsonResponse['message'] ??
              'Service requests retrieved successfully',
        };
      } else {
        return {
          'status': false,
          'message':
              jsonResponse['message'] ?? 'Failed to retrieve service requests',
        };
      }
    } catch (e) {
      BaseApiService.logError('getServiceUserRequest', e);
      if (e is ApiException) {
        print("'Failed to retrieve service requests: ${e.toString()}");
        rethrow;
      }
      throw ApiException(
          'Failed to retrieve service requests: ${e.toString()}');
    }
  }

  getMyJobs({required int userId, required int page}) async {
    print("UserId ==> $userId");
    Uri url = Uri.parse(
      "${AppUrls.getJobs}?user_id=$userId&page=$page",
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

  Future<Map<String, dynamic>> getFavoriteServices(
      {required int id, required int page}) async {
    try {
      Uri url = Uri.parse("${AppUrls.getFavouriteServices}?page=$page");
      var id = await Preferences.getUserID();
      var res = await http.get(
        url,
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
    required int serviceProviderId,
  }) async {
    try {
      print("iddd $requestId $serviceProviderId");
      Uri url = Uri.parse(AppUrls.serviceRequestDecline);
      var token = await Preferences.getToken();
      var res = await http.post(
        url,
        body: json.encode({
          "service_request_id": requestId,
          "serviceprovider_id": serviceProviderId,
        }),
        headers: getHeader(userToken: token),
      );

      print("rescue ${res.body}");
      return json.decode(res.body);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return {'error': 'Failed to decline service request.'};
    }
  }

  Future<Map<String, dynamic>> acceptServiceRequest({
    required String userid,
    required String providerId,
    required int requestId,
  }) async {
    try {
      var token = await Preferences.getToken();
      Uri url = Uri.parse(AppUrls.serviceRequestAccept);

      // Create form data
      var request = http.MultipartRequest('POST', url)
        ..headers.addAll(getHeader(userToken: token))
        ..fields.addAll({
          'serviceprovider_id': providerId,
          'service_request_id': requestId.toString(),
        });

      // Log request
      BaseApiService.logRequest(
          url.toString(), 'POST', request.headers, request.fields);

      // Send request
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

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
            'message': decodedResponse['message'],
            'data': decodedResponse['payload']
          };
        } else {
          throw ApiException(
              decodedResponse['message'] ?? 'Failed to accept service request');
        }
      } else {
        throw ApiException('Failed to accept service request',
            statusCode: response.statusCode);
      }
    } catch (e) {
      // Log error
      BaseApiService.logError(AppUrls.serviceRequestAccept, e.toString());

      if (e is FormatException) {
        throw ApiException('Invalid response format from server');
      }

      throw ApiException(e.toString());
    }
  }

  Future<Map<String, dynamic>> markJobCompleteRequest({
    required int? jobId,
    required String status,
  }) async {
    try {
      Uri url = Uri.parse("${AppUrls.markCompleteRequest}/$jobId/status");
      var token = await Preferences.getToken();
      var res = await http.post(
        url,
        body: json.encode({
          //  "job_id": jobId,
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

  Future<Map<String, dynamic>> makePayment({
    required dynamic amount,
    required String serviceId,
  }) async {
    try {
      Uri url = Uri.parse("${AppUrls.baseUrl}/stripe/payment");
      var token = await Preferences.getToken();
      var res = await http.post(
        url,
        body: json.encode({
          //  "job_id": jobId,
          "amount": amount,
          "payment_method_id" : "pm_card_visa",
          "service_id" : serviceId
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

  getTenantContracts(int page) async {
    Uri url = Uri.parse("${AppUrls.getTenantContract}");
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

  Future<Map<String, dynamic>> getServiceJob({required int? id}) async {
    print("Calling service job API for ID: $id");
    Uri url = Uri.parse(
      "${AppUrls.getServiceJobDetail}/$id",
    );
    try {
      var token = await Preferences.getToken();

      // Log request
      BaseApiService.logRequest(
          url.toString(), 'GET', getHeader(userToken: token), null);

      var response = await http.get(url, headers: getHeader(userToken: token));

      // Log response
      BaseApiService.logResponse(
          url.toString(), response.statusCode, response.body);

      // Check if response is HTML
      if (response.body.trim().startsWith('<!DOCTYPE html>')) {
        print("Received HTML response instead of JSON");
        return {
          'success': false,
          'message': 'Server returned HTML instead of JSON. Please try again.'
        };
      }

      if (response.statusCode == 200) {
        final decodedResponse = json.decode(response.body);

        if (decodedResponse['success'] == true) {
          return {
            'success': true,
            'payload': decodedResponse['payload'],
            'message': decodedResponse['message'] ??
                'Service job details retrieved successfully'
          };
        } else {
          return {
            'success': false,
            'message': decodedResponse['message'] ??
                'Failed to fetch service job details'
          };
        }
      } else {
        return {
          'success': false,
          'message': 'Server responded with status code: ${response.statusCode}'
        };
      }
    } catch (e) {
      print("Error in getServiceJob: $e");

      // Log error
      BaseApiService.logError(url.toString(), e.toString());

      if (e is FormatException) {
        return {
          'success': false,
          'message': 'Invalid response format from server'
        };
      }

      return {
        'success': false,
        'message': 'Failed to fetch service job details: ${e.toString()}'
      };
    }
  }
}
