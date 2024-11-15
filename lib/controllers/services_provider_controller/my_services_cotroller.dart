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
    List<Services> list = <Services>[];
    print("we are in get services");
    isLoading.value = true;
    var id = await Preferences.getUserID();
    print("User ID ==> $id");
    var result = await servicesService.getServices(userId: id);
    print("Service result : $result");
    if (result["status"] == true) {
      isLoading.value = false;
      for (var data in result['data']["data"]) {
        print("Service List :: $data");
        list.add(Services.fromJson(data));
      }
      getServicesList.value = list;
    } else {
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
    print("we are in delete service");
    isLoading.value = true;
    var result = await servicesService.deleteService(id: id);
    print("Service Result : $result");

    isLoading.value = false;

    if (result['status'] == true) {
      isLoading.value = false;
      Get.back();
      Get.back();
      AppUtils.getSnackBar("Delete", result['messages']);
    } else {
      isLoading.value = false;
      print("getPropertyOne is null");
      AppUtils.errorSnackBar("Error", result['messages']);
    }
    isLoading.value = false;
  }
}
