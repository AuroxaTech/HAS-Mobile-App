import 'package:get/get.dart';
import 'package:property_app/utils/shared_preferences/preferences.dart';
import 'package:property_app/utils/utils.dart';

import '../../models/service_provider_model/service_request_model.dart';
import '../../services/property_services/add_services.dart';
import '../../utils/base_api_service.dart';

class MyServiceRequestController extends GetxController {
  RxBool pending = true.obs;
  RxBool completed = false.obs;
  RxBool reject = false.obs;

  ServiceProviderServices servicesService = ServiceProviderServices();
  Rx<bool> isLoading = false.obs;
  RxList<ServiceRequestUser> getServicesRequestList =
      <ServiceRequestUser>[].obs;

  @override
  void onInit() {
    var data = Get.arguments;
    print("IDDDDDD $data");
    print("Hello");
    getServicesRequest();
    super.onInit();
  }

  Future<void> getServicesRequest() async {
    try {
      isLoading.value = true;
      var uId = await Preferences.getUserID();
      var result = await servicesService.getServiceUserRequest(userId: uId);
      print("Service result : $result");

      if (result["status"] == true && result["data"] != null) {
        List<ServiceRequestUser> list = <ServiceRequestUser>[];
        
        var serviceRequests = result['data']['data'] as List;
        for (var data in serviceRequests) {
          print("Service List :: $data");
          list.add(ServiceRequestUser.fromJson(data));
        }
        getServicesRequestList.value = list;
      } else {
        AppUtils.errorSnackBar("Error", result["message"] ?? "Failed to load service requests");
      }
    } catch (e) {
      print("Error in getServicesRequest: $e");
      String errorMessage = "Failed to load service requests";
      
      if (e is ApiException) {
        errorMessage = e.message;
      }
      
      AppUtils.errorSnackBar("Error", errorMessage);
    } finally {
      isLoading.value = false;
    }
  }
}
