import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../models/propert_model/contract_model.dart';
import '../../services/property_services/add_services.dart';

class TenantContractController extends GetxController {
 // RxBool messages = true.obs;
  RxBool approved = true.obs;
  RxBool pending = false.obs;

  ServiceProviderServices servicesService = ServiceProviderServices();
  Rx<bool> isLoading = false.obs;
  RxList<Contracts> getContractList = <Contracts>[].obs;


  final selectedStatus = "1".obs; // Default to approved
  final approvedContractsCount = 0.obs;
  final pendingContractsCount = 0.obs;


  @override
  void onInit() {
    var data = Get.arguments;
    print("Hello");
  //  getContracts();
    pagingController.addPageRequestListener((pageKey) {
      Future.microtask(() => fetchContracts(pageKey));
    });

   // _countFilteredContracts();
    super.onInit();
  }
  List<Contracts> getFilteredContractList(String status) {
    return getContractList.where((contract) => contract.status == status).toList();
  }

  Future<void> getContracts() async {
    List<Contracts>  list  = <Contracts>[];
    print("we are in get services");
    isLoading.value = true;
    var result = await servicesService.getTenantContracts(1);
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


  final PagingController<int, Contracts> pagingController =
  PagingController(firstPageKey: 1);

  Future<void> fetchContracts(int pageKey) async {
    try {
      final result = await servicesService.getTenantContracts(pageKey);
      print("API Response: $result"); // Debugging line

      if (result['success'] == true) {
        final List<dynamic> contractsJson = result['payload']['data'] ?? [];

        if (contractsJson.isEmpty) {
          pagingController.appendLastPage([]);
          return;
        }

        final List<Contracts> newContracts = contractsJson.map((json) => Contracts.fromJson(json)).toList();

        final int lastPage = result['payload']['last_page'] ?? result['payload']['current_page'];
        final bool isLastPage = result['payload']['current_page'] >= lastPage;

        if (isLastPage) {
          pagingController.appendLastPage(newContracts);
        } else {
          final int nextPageKey = pageKey + 1;
          pagingController.appendPage(newContracts, nextPageKey);
        }

        _countFilteredContracts();
        print("Contracts Loaded: ${newContracts.length}");
      } else {
        print("Error fetching contracts: ${result['message']}");
        pagingController.error = Exception('Failed to fetch contracts');
      }
    } catch (error, stackTrace) {
      print("Error in fetchContracts: $error");
      print(stackTrace);
      pagingController.error = error;
    }
  }


  void _countFilteredContracts() {
    if (pagingController.itemList == null) {
      approvedContractsCount.value = 0;
      pendingContractsCount.value = 0;
      return; // No items loaded yet, or error occurred
    }

    approvedContractsCount.value = pagingController.itemList!
        .where((contract) => contract.status == "1")
        .length;
    pendingContractsCount.value = pagingController.itemList!
        .where((contract) => contract.status == "0")
        .length;
  }


}