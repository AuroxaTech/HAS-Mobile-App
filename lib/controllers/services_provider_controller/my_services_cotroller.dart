import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:property_app/utils/shared_preferences/preferences.dart';

import '../../models/service_provider_model/get_services.dart';
import '../../services/property_services/add_services.dart';
import '../../utils/utils.dart';

class MyServicesController extends GetxController {
  ServiceProviderServices servicesService = ServiceProviderServices();
  Rx<bool> isLoading = false.obs;
  RxList<Services> getServicesList = <Services>[].obs;
  Services? getServiceOne;

  @override
  void onInit() {
    var data = Get.arguments;
    print("IDDDDDD $data");
    print("Hello");
    getServices();
    // pagingController.addPageRequestListener((pageKey) {
    //   getMyServices(pageKey);
    // });
    //data == null ? null : getService(data);
    super.onInit();
  }

  final PagingController<int, Services> pagingController =
      PagingController(firstPageKey: 1);

  Future<void> getMyServices(int pageKey) async {
    try {
      isLoading.value = true;
      var result = await servicesService.getAllServices(pageKey);
      isLoading.value = false;
      print("My Service $result");
      if (result['status'] == true) {
        final List<Services> newItems = (result['data']['data'] as List)
            .map((json) => Services.fromJson(json))
            .toList();

        final isLastPage =
            result['data']['current_page'] == result['data']['last_page'];

        if (isLastPage) {
          pagingController.appendLastPage(newItems);
        } else {
          final nextPageKey = pageKey + 1;
          pagingController.appendPage(newItems, nextPageKey);
        }
      } else {
        pagingController.error = Exception('Failed to fetch services');
      }
    } catch (error) {
      isLoading.value = false;
      print(error);

      final errorMessage = error.toString();
      pagingController.error = errorMessage;
      rethrow;
    }
  }

  Future<void> getServices() async {
    try {
      print("we are in get services");
      isLoading.value = true;
      var id = await Preferences.getUserID();
      print("User ID ==> $id");
      var result = await servicesService.getServices(userId: id);
      //print("Service result : $result");

      // Add debug prints
      print("Success value: ${result["success"]}");
      print("Status value: ${result["status"]}");

      // Check both success and status
      if (result["success"] == true || result["status"] == true) {
        List<Services> list = <Services>[];

        // Try both payload and data paths
        var servicesData;
        if (result['payload'] != null && result['payload']['data'] != null) {
          servicesData = result['payload']['data'] as List;
        } else if (result['data'] != null && result['data']['data'] != null) {
          servicesData = result['data']['data'] as List;
        } else {
          throw Exception("Could not find services data in response");
        }

        print("Services data length: ${servicesData.length}");

        for (var data in servicesData) {
          print("Processing service: $data");
          list.add(Services.fromJson(data));
        }

        print("Final list length: ${list.length}");
        getServicesList.value = list;

        // Verify list was set
        print("getServicesList length: ${getServicesList.length}");
      } else {
        print("API call successful but status/success check failed");
        AppUtils.errorSnackBar("Error", "Failed to load services");
      }
    } catch (e) {
      print("Error loading services: $e");
      AppUtils.errorSnackBar(
          "Error", "Failed to load services: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getService(id) async {
    print("we are in get service");
    isLoading.value = true;
    var result = await servicesService.getService(id: id);
    print("Service : $result");

    isLoading.value = false;
    for (var data in result['data']) {
      print("Service :: $data");
      getServiceOne = Services.fromJson(data);
    }
  }

  Future<void> deleteService({required int id}) async {
    try {
      isLoading.value = true;
      var result = await servicesService.deleteService(id: id);

      if (result['success'] == true) {
        // Remove the deleted service from the list
        getServicesList.removeWhere((service) => service.id == id);
        Get.back();
        AppUtils.getSnackBar(
            "Success", result['messages'] ?? "Service deleted successfully");
      } else {
        AppUtils.errorSnackBar(
            "Error", result['messages'] ?? "Failed to delete service");
      }
    } catch (e) {
      print("Error deleting service: $e");
      AppUtils.errorSnackBar(
          "Error", "Failed to delete service. Please try again.");
    } finally {
      isLoading.value = false;
    }
  }
}
