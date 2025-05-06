import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:property_app/constant_widget/constant_widgets.dart';
import 'package:property_app/utils/api_urls.dart';
import 'package:property_app/utils/shared_preferences/preferences.dart';
import 'package:property_app/utils/connectivity.dart';

import '../../models/service_provider_model/favorite_provider.dart';
import '../../services/property_services/add_services.dart';
import '../../utils/base_api_service.dart';
import '../../utils/utils.dart';

class MyFavouriteScreenController extends GetxController
    with GetTickerProviderStateMixin {
  late TabController tabController;
  RxInt selectedIndex = 0.obs;
  
  // Paging controller for services
  final PagingController<int, FavoriteItem> pagingController =
      PagingController(firstPageKey: 1);
  
  // Paging controller for properties
  final PagingController<int, FavoriteItem> propertyPagingController =
      PagingController(firstPageKey: 1);
      
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      selectedIndex.value = tabController.index;
      
      // Load data for the selected tab if not already loaded
      if (selectedIndex.value == 0 && pagingController.itemList == null) {
        pagingController.refresh();
      } else if (selectedIndex.value == 1 && propertyPagingController.itemList == null) {
        propertyPagingController.refresh();
      }
    });
    
    // Add listeners for pagination
    pagingController.addPageRequestListener((pageKey) {
      Future.microtask(() => getFavoriteServices(pageKey));
    });
    
    propertyPagingController.addPageRequestListener((pageKey) {
      Future.microtask(() => getFavoriteProperties(pageKey));
    });
  }

  @override
  void onClose() {
    tabController.removeListener(updateIndex);
    tabController.dispose();
    pagingController.dispose();
    propertyPagingController.dispose();
    super.onClose();
  }

  void updateIndex() {
    if (tabController.indexIsChanging) {
      selectedIndex.value = tabController.index;
    }
  }

  Future<void> getFavoriteServices(int pageKey) async {
    try {
      isLoading.value = true;
      
      // Check internet connectivity
      final hasInternet = await ConnectivityUtility.checkInternetConnectivity();
      if (!hasInternet) {
        AppUtils.getSnackBarNoInternet();
        pagingController.error = "No internet connection";
        return;
      }
      
      var token = await Preferences.getToken();
      
      // Log request
      BaseApiService.logRequest(
        AppUrls.getFavouriteServices + "?page=$pageKey",
        'GET',
        getHeader(userToken: token),
        null
      );

      final response = await http.get(
        Uri.parse("${AppUrls.getFavouriteServices}?page=$pageKey"),
        headers: getHeader(userToken: token),
      );
      
      // Log response
      BaseApiService.logResponse(
        AppUrls.getFavouriteServices,
        response.statusCode,
        response.body
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body);

        if (result['success'] == true) {
          final FavoriteResponse favoriteResponse = FavoriteResponse.fromJson(result);
          final List<FavoriteItem> newItems = favoriteResponse.payload.data;

          final isLastPage = favoriteResponse.payload.currentPage == favoriteResponse.payload.lastPage;

          if (isLastPage) {
            pagingController.appendLastPage(newItems);
          } else {
            pagingController.appendPage(newItems, pageKey + 1);
          }
        } else {
          pagingController.error = result['message'] ?? 'Failed to fetch favorites';
        }
      } else {
        pagingController.error = 'Server error: ${response.statusCode}';
      }
    } catch (error) {
      BaseApiService.logError(AppUrls.getFavouriteServices, error.toString());
      pagingController.error = error;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getFavoriteProperties(int pageKey) async {
    try {
      isLoading.value = true;
      
      // Check internet connectivity
      final hasInternet = await ConnectivityUtility.checkInternetConnectivity();
      if (!hasInternet) {
        AppUtils.getSnackBarNoInternet();
        propertyPagingController.error = "No internet connection";
        return;
      }
      
      var token = await Preferences.getToken();
      
      // Log request
      BaseApiService.logRequest(
        AppUrls.getFavouriteProperties + "?page=$pageKey",
        'GET',
        getHeader(userToken: token),
        null
      );

      final response = await http.get(
        Uri.parse("${AppUrls.getFavouriteProperties}?page=$pageKey"),
        headers: getHeader(userToken: token),
      );
      
      // Log response
      BaseApiService.logResponse(
        AppUrls.getFavouriteProperties,
        response.statusCode,
        response.body
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body);

        if (result['success'] == true) {
          final FavoriteResponse favoriteResponse = FavoriteResponse.fromJson(result);
          final List<FavoriteItem> newItems = favoriteResponse.payload.data;

          final isLastPage = favoriteResponse.payload.currentPage == favoriteResponse.payload.lastPage;

          if (isLastPage) {
            propertyPagingController.appendLastPage(newItems);
          } else {
            propertyPagingController.appendPage(newItems, pageKey + 1);
          }
        } else {
          propertyPagingController.error = result['message'] ?? 'Failed to fetch favorites';
        }
      } else {
        propertyPagingController.error = 'Server error: ${response.statusCode}';
      }
    } catch (error) {
      BaseApiService.logError(AppUrls.getFavouriteProperties, error.toString());
      propertyPagingController.error = error;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> toggleFavoriteServiceStatus({
    required String serviceId, 
    required bool isFavorite
  }) async {
    try {
      isLoading.value = true;
      
      // Check internet connectivity
      final hasInternet = await ConnectivityUtility.checkInternetConnectivity();
      if (!hasInternet) {
        AppUtils.getSnackBarNoInternet();
        return;
      }
      
      var userId = await Preferences.getUserID();
      var token = await Preferences.getToken();
      
      final requestBody = {
        'user_id': userId,
        'service_id': serviceId,
        'fav_flag': isFavorite ? 1 : 2, // 1 for favorite, 2 for unfavorite
      };
      
      // Log request
      BaseApiService.logRequest(
        AppUrls.addFavouriteService,
        'POST',
        getHeader(userToken: token),
        requestBody
      );
      
      final response = await http.post(
        Uri.parse(AppUrls.addFavouriteService),
        headers: getHeader(userToken: token),
        body: json.encode(requestBody),
      );
      
      // Log response
      BaseApiService.logResponse(
        AppUrls.addFavouriteService,
        response.statusCode,
        response.body
      );
      
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        AppUtils.getSnackBar('Success', jsonData['message'] ?? 'Favorite status updated');
      } else {
        AppUtils.errorSnackBar('Error', 'Failed to update favorite status');
      }
    } catch (error) {
      BaseApiService.logError(AppUrls.addFavouriteService, error.toString());
      AppUtils.errorSnackBar('Error', 'An error occurred: ${error.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> toggleFavoritePropertyStatus({
    required String propertyId, 
    required bool isFavorite
  }) async {
    try {
      isLoading.value = true;
      
      // Check internet connectivity
      final hasInternet = await ConnectivityUtility.checkInternetConnectivity();
      if (!hasInternet) {
        AppUtils.getSnackBarNoInternet();
        return;
      }
      
      var userId = await Preferences.getUserID();
      var token = await Preferences.getToken();
      
      final requestBody = {
        'user_id': userId,
        'property_id': propertyId,
        'fav_flag': isFavorite ? 1 : 2, // 1 for favorite, 2 for unfavorite
      };
      
      // Log request
      BaseApiService.logRequest(
        AppUrls.addFavoriteProperty,
        'POST',
        getHeader(userToken: token),
        requestBody
      );
      
      final response = await http.post(
        Uri.parse(AppUrls.addFavoriteProperty),
        headers: getHeader(userToken: token),
        body: json.encode(requestBody),
      );
      
      // Log response
      BaseApiService.logResponse(
        AppUrls.addFavoriteProperty,
        response.statusCode,
        response.body
      );
      
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        AppUtils.getSnackBar('Success', jsonData['message'] ?? 'Favorite status updated');
      } else {
        AppUtils.errorSnackBar('Error', 'Failed to update favorite status');
      }
    } catch (error) {
      BaseApiService.logError(AppUrls.addFavoriteProperty, error.toString());
      AppUtils.errorSnackBar('Error', 'An error occurred: ${error.toString()}');
    } finally {
      isLoading.value = false;
    }
  }
}
