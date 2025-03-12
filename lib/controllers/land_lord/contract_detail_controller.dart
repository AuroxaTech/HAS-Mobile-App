import 'package:get/get.dart';
import 'package:property_app/models/propert_model/contract_model.dart';
import 'package:property_app/services/property_services/add_services.dart';

import '../../utils/utils.dart';

class ContractDetailController extends GetxController {
  ServiceProviderServices servicesService = ServiceProviderServices();
  Rx<bool> isLoading = false.obs;
  Rx<ContractDetail?> getContractOne = Rx<ContractDetail?>(null);
  List<String> images = [];
  @override
  void onInit() {
    var data = Get.arguments;
    print("IDDDDDD $data");
    print("Hello");
    getContractDetail(id: data);
    super.onInit();
  }

  Future<void> getContractDetail({required int id}) async {
    print("we are in get contract");
    isLoading.value = true;
    try {
      // Fetch the service data
      var result = await servicesService.getContractDetail(id: id);
      print("contract Result : ${result['payload']}");

      // Check if 'data' is not null
      if (result['payload'] != null) {
        // Handling both Map and List cases
        var data = result['payload'];

        print("Data :: $data");
        if (getContractOne != null) {
          getContractOne.value = ContractDetail.fromJson(data);
        } else {
          print("contract is null");
        }
      } else {
        print("Invalid or null data format");
        // Handle other cases if necessary
      }
    } catch (e) {
      // Handle exceptions from service calls or data parsing
      print("Error occurred: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> acceptContractRequest({
    required int contractId,
    required String status,
  }) async {
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
