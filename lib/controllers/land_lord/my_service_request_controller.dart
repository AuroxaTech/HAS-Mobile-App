import 'package:get/get.dart';
import 'package:property_app/utils/shared_preferences/preferences.dart';
import 'package:property_app/utils/utils.dart';

import '../../models/service_provider_model/service_request_model.dart';
import '../../services/property_services/add_services.dart';

class MyServiceRequestController extends GetxController {
  RxBool pending = true.obs;
  RxBool completed = false.obs;
  RxBool reject = false.obs;

  ServiceProviderServices servicesService = ServiceProviderServices();
  final isLoading = false.obs;
  final getServicesRequestList = <ServiceRequestUser>[].obs;

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
      var userId = await Preferences.getUserID();
      final response =
          await ServiceProviderServices().getServiceUserRequest(userId: userId);

      if (response['status'] == true && response['data'] != null) {
        final paginatedData = response['data'];
        if (paginatedData['data'] != null && paginatedData['data'] is List) {
          final List<dynamic> data = paginatedData['data'];
          getServicesRequestList.value =
              data.map((item) => ServiceRequestUser.fromJson(item)).toList();
        } else {
          AppUtils.errorSnackBar('Error', 'No service requests found');
        }
      } else {
        AppUtils.errorSnackBar(
            'Error', response['message'] ?? 'Failed to load service requests');
      }
    } catch (e) {
      AppUtils.errorSnackBar(
          'Error', 'Failed to load service requests: ${e.toString()}');
      print("Error: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }
}
