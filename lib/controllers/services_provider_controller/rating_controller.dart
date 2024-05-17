import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:property_app/models/service_provider_model/rating_review.dart';

import '../../models/service_provider_model/rating.dart';
import '../../services/property_services/add_services.dart';
class RatingController extends GetxController {
  ServiceProviderServices servicesService = ServiceProviderServices();
  Rx<bool> isLoading = false.obs;
  RxList<RatingDatum> allFeedBackList = <RatingDatum>[].obs;

  // Add RxInt properties for storing the feedback scores
  RxInt oneRate = 0.obs;
  RxInt twoRate = 0.obs;
  RxInt threeRate = 0.obs;
  RxInt fourRate = 0.obs;
  RxInt fiveRate = 0.obs;



  @override
  void onInit() {
   // getRating();
    pagingController.addPageRequestListener((pageKey) {
      Future.microtask(() =>  getProviderRating(pageKey));
    });
    super.onInit();
  }

  Future<void> getRating() async {
    List<RatingDatum> list = <RatingDatum>[];
    print("we are in get job");
    isLoading.value = true;
    try {
      var result = await servicesService.getAllServiceFeedBack(1);
      print("Service result : $result");
      if (result["status"] == true) {
        var dataRating = Data.fromJson(result['data']);

        // Store the feedback scores
        oneRate.value = dataRating.oneRate;
        twoRate.value = dataRating.twoRate;
        threeRate.value = dataRating.threeRate;
        fourRate.value = dataRating.fourRate;
        fiveRate.value = dataRating.fiveRate;

        for (var data in dataRating.ratingData.data) {
          print("Rating List :: $data");
          list.add(data);
        }
        allFeedBackList.value = list;
      } else {
        print("Service returned false status");
      }
    } catch (e) {
      print("An error occurred: $e");
    } finally {
      isLoading.value = false;
    }
  }


  final PagingController<int, RatingDatum> pagingController = PagingController(firstPageKey: 1);
  Future<void> getProviderRating(int pageKey) async {
    try {
      isLoading.value = true;
      var result = await servicesService.getAllServiceFeedBack(pageKey); // Ensure your API supports pagination
      print(result);
      isLoading.value = false;
      if (result["status"] == true) {
        var dataRating = Data.fromJson(result['data']);

        // Store the feedback scores
        oneRate.value = dataRating.oneRate;
        twoRate.value = dataRating.twoRate;
        threeRate.value = dataRating.threeRate;
        fourRate.value = dataRating.fourRate;
        fiveRate.value = dataRating.fiveRate;

        // Optionally, update your feedback scores here or handle them separately if they don't change per page

        final List<RatingDatum> newItems = dataRating.ratingData.data;

        final isLastPage = dataRating.ratingData.currentPage == dataRating.ratingData.lastPage; // Adjust these properties based on your actual API response

        if (isLastPage) {
          pagingController.appendLastPage(newItems);
        } else {
          final nextPageKey = pageKey + 1;
          pagingController.appendPage(newItems, nextPageKey);
        }
      } else {
        pagingController.error = Exception('Failed to fetch ratings');
      }
    } catch (error) {
      isLoading.value = false;
      pagingController.error = error;
      rethrow;
    }
  }


}