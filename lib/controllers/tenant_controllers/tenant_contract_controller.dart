import 'package:get/get.dart';

import '../../models/propert_model/contract_model.dart';
import '../../services/property_services/add_services.dart';

class TenantContractController extends GetxController {
 // RxBool messages = true.obs;
  RxBool approved = true.obs;
  RxBool pending = false.obs;

  ServiceProviderServices servicesService = ServiceProviderServices();
  Rx<bool> isLoading = false.obs;
  RxList<Contracts> getContractList = <Contracts>[].obs;

  @override
  void onInit() {
    var data = Get.arguments;
    print("Hello");
    getContracts();
    super.onInit();
  }
  List<Contracts> getFilteredContractList(String status) {
    return getContractList.where((contract) => contract.status == status).toList();
  }

  Future<void> getContracts() async {
    List<Contracts>  list  = <Contracts>[];
    print("we are in get services");
    isLoading.value = true;
    var result = await servicesService.getTenantContracts();
    print("Service result : $result" );
    if(result["status"] == true){
      isLoading.value = false;
      for (var data in result['data']["data"]) {
        print("Service List :: $data");
        list.add(Contracts.fromJson(data));
      }
      getContractList.value = list;
    }else {
      isLoading.value = false;
    }
  }




}