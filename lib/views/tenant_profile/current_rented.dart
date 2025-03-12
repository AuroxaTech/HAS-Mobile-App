import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:property_app/models/propert_model/ladlord_property_model.dart';

import '../../app_constants/color_constants.dart';
import '../../constant_widget/constant_widgets.dart';
import '../../controllers/tenant_controllers/current_reneted.dart';
import '../../route_management/constant_routes.dart';
import '../../utils/api_urls.dart';

class CurrentRented extends GetView<CurrentRantedPropertiesController> {
  const CurrentRented({super.key});
  @override
  Widget build(BuildContext context) {
    // final Map<String, dynamic>? filters = Get.arguments;
    // if (filters != null) {
    // controller.refreshPropertiesWithFilters(filters);
    // }

    return Scaffold(
      backgroundColor: whiteColor,
      appBar: titleAppBar("Rented Properties", action: [
        // IconButton(onPressed: (){
        //   Get.toNamed(kPropertyFilterScreen)?.then((result) {
        //     if (result != null) {
        //       controller.pagingController.value.itemList!.clear();
        //       return controller.getProperties(1, result);
        //     }
        //   });
        // }, icon: const Icon(Icons.filter_list)),
      ]),
      body: SafeArea(
        child: Stack(
          children: [
            RefreshIndicator(
              onRefresh: () async {
                controller.pagingController.itemList!.clear();
                return controller.getProperty(1);
              },
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: PagedListView<int, Property>(
                  shrinkWrap: true,
                  pagingController: controller.pagingController,
                  builderDelegate: PagedChildBuilderDelegate<Property>(
                      firstPageErrorIndicatorBuilder: (context) =>
                          MaterialButton(
                            child:
                                const Text("No Data Found, Tap to try again."),
                            onPressed: () =>
                                controller.pagingController.refresh(),
                          ),
                      newPageErrorIndicatorBuilder: (context) => MaterialButton(
                            child: const Text(
                                "Failed to load more items. Tap to try again."),
                            onPressed: () => controller.pagingController
                                .retryLastFailedRequest(),
                          ),
                      noItemsFoundIndicatorBuilder: (context) => MaterialButton(
                            child: const Text("No Data found. Tap to reset"),
                            onPressed: () => controller.getProperty(1),
                          ),
                      itemBuilder: (context, item, index) {
                        // Get the image URL
                        String imageUrl = "";

                        // First try to get from propertyImages if it exists and is not empty
                        if (item.propertyImages.isNotEmpty) {
                          imageUrl = item.propertyImages.first;
                        }
                        // Fallback to images field if propertyImages is empty
                        else if (item.images.isNotEmpty) {
                          // Check if the image path is a full URL or a relative path
                          if (item.images.startsWith('http')) {
                            imageUrl = item.images;
                          } else {
                            imageUrl = AppUrls.propertyImages + item.images;
                          }
                        }

                        print("Property ${item.id} image URL: $imageUrl");

                        return Column(
                          children: [
                            myPropertyWidget(context, onTap: () {
                              Get.toNamed(kAllPropertyDetailScreen,
                                  arguments: item.id);
                            },
                                title: item.city,
                                image: imageUrl,
                                price: "\$${item.amount}",
                                description: item.description,
                                bedroom: item.bedroom,
                                bathroom: item.bathroom,
                                marla: item.areaRange,
                                rent: item.type == "1" ? "Rent" : "Sale"),
                            const SizedBox(
                              height: 20,
                            )
                          ],
                        );
                      }),
                ),
              ),
            ),
            // Obx(() => Positioned(
            //     left: 0,
            //     right: 0,
            //     top: 0,
            //     bottom: 0,
            //     child:  controller.isLoading.value ? const Center(child: CircularProgressIndicator()) : const SizedBox.shrink()),
            // ),
          ],
        ),
      ),
    );
  }
}
