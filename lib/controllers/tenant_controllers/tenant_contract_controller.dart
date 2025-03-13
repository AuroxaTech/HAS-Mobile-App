import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../models/propert_model/contract_model.dart';
import '../../services/property_services/add_services.dart';

class TenantContractController extends GetxController {
  RxBool approved = true.obs;
  RxBool pending = false.obs;

  ServiceProviderServices servicesService = ServiceProviderServices();
  Rx<bool> isLoading = false.obs;
  RxList<Contracts> allContracts = <Contracts>[].obs;

  final approvedContractsCount = 0.obs;
  final pendingContractsCount = 0.obs;

  // Create separate paging controllers for each tab
  final PagingController<int, Contracts> pagingController =
      PagingController(firstPageKey: 1);

  @override
  void onInit() {
    super.onInit();
    print("Initializing TenantContractController");

    // Initialize the paging controller with the current status
    pagingController.addPageRequestListener((pageKey) {
      Future.microtask(() => fetchContracts(pageKey));
    });

    // Listen for changes in the tab selection
    ever(approved, (_) {
      print(
          "Tab changed: Approved=${approved.value}, Pending=${pending.value}");
      pagingController.refresh();
    });

    ever(pending, (_) {
      print(
          "Tab changed: Approved=${approved.value}, Pending=${pending.value}");
      pagingController.refresh();
    });
  }

  Future<void> fetchContracts(int pageKey) async {
    try {
      print(
          "Fetching contracts for page $pageKey, Approved=${approved.value}, Pending=${pending.value}");

      final result = await servicesService.getTenantContracts(pageKey);
      print("API Response received");

      if (result['success'] == true) {
        final List<dynamic> contractsJson = result['payload']['data'] ?? [];

        if (contractsJson.isEmpty) {
          pagingController.appendLastPage([]);
          return;
        }

        // Debug: Print the first contract to see its structure
        if (contractsJson.isNotEmpty) {
          print("First contract data: ${contractsJson[0]}");
          print("Status field type: ${contractsJson[0]['status'].runtimeType}");
          print("Status field value: ${contractsJson[0]['status']}");
        }

        final List<Contracts> newContracts =
            contractsJson.map((json) => Contracts.fromJson(json)).toList();

        // Store all contracts for counting
        if (pageKey == 1) {
          allContracts.value = newContracts;
        } else {
          allContracts.addAll(newContracts);
        }

        // Debug: Print the status of each contract
        for (var contract in newContracts) {
          print(
              "Contract ID: ${contract.id}, Status: ${contract.status}, Status Type: ${contract.status.runtimeType}");
        }

        // Filter contracts based on the current tab
        List<Contracts> filteredContracts = [];

        if (approved.value) {
          // For approved tab, include contracts with status "1"
          filteredContracts =
              newContracts.where((contract) => contract.status == "1").toList();
          print(
              "Filtering for APPROVED contracts, found: ${filteredContracts.length}");
        } else {
          // For pending tab, include contracts with status "0" or "2"
          filteredContracts =
              newContracts.where((contract) => contract.status == "0").toList();
          print(
              "Filtering for PENDING contracts, found: ${filteredContracts.length}");
        }

        print(
            "Total contracts: ${newContracts.length}, Filtered contracts: ${filteredContracts.length}");

        final int lastPage =
            result['payload']['last_page'] ?? result['payload']['current_page'];
        final bool isLastPage = result['payload']['current_page'] >= lastPage;

        if (isLastPage) {
          pagingController.appendLastPage(filteredContracts);
        } else {
          final int nextPageKey = pageKey + 1;
          pagingController.appendPage(filteredContracts, nextPageKey);
        }

        _countFilteredContracts();
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
    // Count from all contracts, not just the currently displayed ones
    approvedContractsCount.value =
        allContracts.where((contract) => contract.status == "1").length;

    // Count only status "0" as pending
    pendingContractsCount.value = 
        allContracts.where((contract) => contract.status == "0").length;

    print(
        "Counts updated - Approved: ${approvedContractsCount.value}, Pending: ${pendingContractsCount.value}");
  }
}
