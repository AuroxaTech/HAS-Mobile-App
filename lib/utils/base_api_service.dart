import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;

enum APIMethod { post, put, patch, get }

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() => 'ApiException: $message (Status Code: $statusCode)';
}

abstract class BaseApiService {
  String apiurl = '';

  static void logRequest(
      String url, String method, Map<String, String>? headers, dynamic body) {
    log('🌐 API Request:', name: 'API');
    log('URL: $url', name: 'API');
    log('Method: $method', name: 'API');
    log('Headers: $headers', name: 'API');
    if (body != null) log('Body: $body', name: 'API');
  }

  static void logResponse(String url, int statusCode, dynamic response) {
    log('📥 API Response:', name: 'API');
    log('URL: $url', name: 'API');
    log('Status Code: $statusCode', name: 'API');
    log('Response: $response', name: 'API');
  }

  static void logError(String url, dynamic error) {
    log('❌ API Error:', name: 'API');
    log('URL: $url', name: 'API');
    log('Error: $error', name: 'API');
  }

  set apiUrl(String apiUrl) {
    apiurl = apiUrl;
  }

  String get apiUrl => apiurl;

  String getAPIMethod(APIMethod api) {
    return switch (api) {
      APIMethod.put => 'PUT',
      APIMethod.patch => 'PATCH',
      APIMethod.post => 'POST',
      APIMethod.get => 'GET',
    };
  }

  Future<Map<String, dynamic>> requestApiMethod({
    String endPoints = '',
    required APIMethod method,
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  }) async {
    final url = Uri.parse('$apiUrl$endPoints');

    try {
      logRequest(url.toString(), getAPIMethod(method), headers, body);

      // ✅ Choose HTTP Method
      http.Response response;
      final defaultHeaders = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        if (headers != null) ...headers,
      };

      switch (method) {
        case APIMethod.post:
          response = await http.post(url,
              headers: defaultHeaders, body: jsonEncode(body));
          break;
        case APIMethod.put:
          response = await http.put(url,
              headers: defaultHeaders, body: jsonEncode(body));
          break;
        case APIMethod.patch:
          response = await http.patch(url,
              headers: defaultHeaders, body: jsonEncode(body));
          break;
        case APIMethod.get:
        default:
          response = await http.get(url, headers: defaultHeaders);
          break;
      }

      logResponse(url.toString(), response.statusCode, response.body);

      final decodedResponse = jsonDecode(response.body);
      validateResponse(response.statusCode, decodedResponse);

      return decodedResponse;
    } on SocketException {
      logError(url.toString(), 'No Internet connection');
      throw ApiException('No Internet connection');
    } on FormatException {
      logError(url.toString(), 'Invalid response format');
      throw ApiException('Invalid response format');
    } on ApiException catch (e) {
      handleApiException(e);
      throw ApiException(e.message, statusCode: e.statusCode);
    } catch (e) {
      logError(url.toString(), e.toString());
      throw ApiException(e.toString());
    }
  }

  void validateResponse(int statusCode, Map<String, dynamic> response) {
    switch (statusCode) {
      case 200:
      case 201:
        // Handle login specific response
        if (response['payload']?['original']?['message'] == 'Invalid credentials') {
          throw ApiException('Invalid email or password');
        }
        // Handle general success=false cases
        if (response['success'] == false || response['status'] == false) {
          throw ApiException(
            response['payload']?['original']?['message'] ?? 
            response['message'] ?? 
            'Operation failed'
          );
        }
        return;
      case 422:
        final message = response['messages']?['email']?.first ?? 
                       response['messages']?['username']?.first ??
                       'Validation failed';
        throw ApiException(message, statusCode: 422);
      case 403:
        throw ApiException('Access forbidden', statusCode: 403);
      case 404:
        throw ApiException('Resource not found', statusCode: 404);
      case 500:
        throw ApiException('Internal server error', statusCode: 500);
      default:
        throw ApiException(
          response['message'] ?? 'Unknown error occurred',
          statusCode: statusCode
        );
    }
  }

  static void handleApiException(ApiException e) {
    logError("API Exception", e.toString());

    // Optional: Show user-friendly error message if needed
    switch (e.statusCode) {
      case 403:
        log("🚫 Access Forbidden: ${e.message}");
        break;
      case 404:
        log("❌ Resource Not Found: ${e.message}");
        break;
      case 500:
        log("💥 Internal Server Error: ${e.message}");
        break;
      default:
        log("⚠️ API Error: ${e.message}");
    }
  }
}
