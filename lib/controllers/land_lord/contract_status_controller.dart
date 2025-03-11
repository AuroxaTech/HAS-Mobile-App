import 'package:get/get.dart';

import '../../models/propert_model/contract_model.dart';
import '../../services/property_services/add_services.dart';
import '../../utils/utils.dart';

class ContractStatusScreenController extends GetxController {
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
    getServices();
    super.onInit();
  }

  List<Contracts> getFilteredContractList(String status) {
    return getContractList.where((contract) => contract.status == status).toList();
  }

  Future<void> getServices() async {
    List<Contracts>  list  = <Contracts>[];
    print("we are in get services");
    isLoading.value = true;
    var result = await servicesService.getLandLordContracts();
    print("Service result : $result" );
    if(result["success"] == true){
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

  Future<void> acceptContractRequest({required int contractId, required String status,}) async {
    isLoading.value = true;

    try {
      var result = await servicesService.acceptContractRequest(
        contractId: contractId,
        status: status,
      );
      print(result);
      if (result['status'] == true) {
        Get.back();
        AppUtils.getSnackBar("Success", result['message']);
      } else {
        AppUtils.errorSnackBar("Error", result['message']);
      }
    } catch (e) {
      // Get.back();
      // Handle general errors
      print(e);
      AppUtils.errorSnackBar("Error", "Failed to decline service request");
    } finally {
      // Get.back();
      isLoading.value = false;
    }
  }



}