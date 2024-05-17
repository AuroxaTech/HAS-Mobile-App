import 'package:get/get.dart';
import 'package:property_app/utils/shared_preferences/preferences.dart';

import '../../models/service_provider_model/service_request_model.dart';
import '../../services/property_services/add_services.dart';

class MyServiceRequestController extends GetxController {

  RxBool pending = true.obs;
  RxBool completed = false.obs;
  RxBool reject = false.obs;

  ServiceProviderServices servicesService = ServiceProviderServices();
  Rx<bool> isLoading = false.obs;
  RxList<ServiceRequestUser> getServicesRequestList = <ServiceRequestUser>[].obs;

  @override
  void onInit() {
    var data = Get.arguments;
    print("IDDDDDD $data");
    print("Hello");
    getServicesRequest();
    super.onInit();
  }

  Future<void> getServicesRequest() async {
    List<ServiceRequestUser>  list  = <ServiceRequestUser>[];
    print("we are in get services");
    isLoading.value = true;
    var uId = await Preferences.getUserID();
    var result = await servicesService.getServiceUserRequest(userId: uId);
    print("Service result : $result" );
    if(result["status"] == true){
      isLoading.value = false;
      for (var data in result['data']["data"]) {
        print("Service List :: $data");
        list.add(ServiceRequestUser.fromJson(data));
      }
      getServicesRequestList.value = list;
    }else {
      isLoading.value = false;
    }
  }
}