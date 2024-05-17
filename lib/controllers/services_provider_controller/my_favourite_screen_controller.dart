import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:property_app/constant_widget/constant_widgets.dart';
import 'package:property_app/services/property_services/get_property_services.dart';
import 'package:property_app/utils/api_urls.dart';
import 'package:property_app/utils/shared_preferences/preferences.dart';
import 'package:http/http.dart' as http;
import '../../models/service_provider_model/favorite_provider.dart';
import '../../services/property_services/add_services.dart';

class MyFavouriteScreenController extends GetxController with GetTickerProviderStateMixin {
  late TabController tabController;
  RxInt selectedIndex = 0.obs;
  final PagingController<int, FavoriteService> pagingController = PagingController(firstPageKey: 1);
  RxBool isLoading = false.obs; // Assuming isLoading is defined like this

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
     selectedIndex.value = tabController.index;
    });
    pagingController.addPageRequestListener((pageKey) {
      Future.microtask(() => getFavorite(pageKey));
    });
    propertyPagingController.addPageRequestListener((pageKey) {
      Future.microtask(() => getPropertyFav(pageKey));
    });
  }
  @override
  void onClose() {
    tabController.removeListener(updateIndex);
    tabController.dispose();
    pagingController.dispose();
    super.onClose();
  }

  void updateIndex() {
    if (tabController.indexIsChanging) {
      selectedIndex.value = tabController.index;
    }
  }

  final PagingController<int, FavoriteProperty> propertyPagingController = PagingController(firstPageKey: 1);


  Future<void> getFavorite(int pageKey) async {
    try {
      isLoading.value = true;
      var id = await Preferences.getUserID();
      print("My id $id");
      var result = await favoriteService.getFavoriteServices(id: id , page: pageKey);

      print(result);
      if (result['status'] == true) {
        final List<FavoriteService> newItems = (result['favorite_services']['data'] as List)
            .map((json) => FavoriteService.fromJson(json))
            .toList();

        final isLastPage = result["favorite_services"]['current_page'] == result['favorite_services']['last_page'];

        if (isLastPage) {
          pagingController.appendLastPage(newItems);
        } else {
          final nextPageKey = pageKey + 1;
          pagingController.appendPage(newItems, nextPageKey);
        }
      } else {
        pagingController.error = Exception('Failed to fetch favorite');
      }
    } catch (error) {
      isLoading.value = false;
      print("My Error $error");

      final errorMessage = error.toString();
      pagingController.error = errorMessage;
      rethrow;
    }
  }

  Future<void> getPropertyFav(int pageKey) async {
    try {
      isLoading.value = true;
      var id = await Preferences.getUserID();
      print("My id $id");
      var result = await favoriteService.getFavoriteServices(id: id , page: pageKey);
      print("Property result ${result}");

      if (result['status'] == true) {
        final List<FavoriteProperty> newItems = (result['favorite_properties']['data'] as List)
            .map((json) => FavoriteProperty.fromJson(json))
            .toList();


        final isLastPage = result["favorite_properties"]['current_page'] == result['favorite_properties']['last_page'];

        if (isLastPage) {
          propertyPagingController.appendLastPage(newItems);
        } else {
          final nextPageKey = pageKey + 1;
          propertyPagingController.appendPage(newItems, nextPageKey);
        }
      } else {
        propertyPagingController.error = Exception('Failed to fetch favorite');
      }
    } catch (error) {
      isLoading.value = false;
      print("My Error $error");

      final errorMessage = error.toString();
      propertyPagingController.error = errorMessage;
      rethrow;
    }
  }

  final ServiceProviderServices favoriteService = ServiceProviderServices();
  RxList<FavoriteService> favoriteServiceProviders = <FavoriteService>[].obs;
  RxList<FavoriteProperty> favoriteProperties = <FavoriteProperty>[].obs;

  Future<void> getFavoriteServices() async {
    isLoading.value = true;
    try {
      var id  = await Preferences.getUserID();
      var result = await favoriteService.getFavoriteServices(id: id, page: 2);
      print("result $result");
      if (result['status'] == true) {
        Favorite providerFavorite = Favorite.fromJson(result);
        favoriteServiceProviders.value = providerFavorite.favoriteServices;
        favoriteProperties.value = providerFavorite.favoriteProperties;
      } else {
        print(result['message']);
      }
    } catch (e) {
      print(e);
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> toggleFavoriteStatus({required String serviceId, required bool isFavorite}) async {
    int favFlag = isFavorite ? 1 : 2; // Assuming 1 is favorite, 0 is not

    var userId = await Preferences.getUserID();
    var token = await Preferences.getToken();
    final response = await http.post(
      Uri.parse(AppUrls.addFavouriteService),
      headers: getHeader(userToken: token),
      body: json.encode({
        'user_id': userId, // Assuming the user ID is static for now
        'service_id': serviceId,
        'fav_flag': 2,
      }),
    );
    print(response.body);
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
     // pagingController.refresh();
     // getFavorite(1);
     } else {
    }
  }

  Future<void> toggleFavoritePropertyStatus({required String propertyId, required bool isFavorite}) async {
    int favFlag = isFavorite ? 1 : 2; // Assuming 1 is favorite, 0 is not

    var userId = await Preferences.getUserID();
    var token = await Preferences.getToken();
    final response = await http.post(
      Uri.parse(AppUrls.addFavoriteProperty),
      headers: getHeader(userToken: token),
      body: json.encode({
        'user_id': userId, // Assuming the user ID is static for now
        'property_id': propertyId,
        'fav_flag': 2,
      }),
    );
    print(response.body);
    if (response.statusCode == 200) {
      //favoriteServiceProviders.refresh();
      var jsonData = jsonDecode(response.body);
     print(jsonData["message"]);
     // getFavoriteServices();
      // Handle response, update your local state to reflect the new favorite status
      // You may need to update your UI accordingly, for example, by setting a state or updating a list
    } else {
      // var jsonData = jsonDecode(response.body);
      // print(jsonData["message"]);
      // Handle error, e.g., show a toast or message to the user
    }
  }



}