import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:property_app/models/propert_model/ladlord_property_model.dart';

import '../../app_constants/color_constants.dart';
import '../../constant_widget/constant_widgets.dart';
import '../../controllers/dasboard_controller/all_property_controller.dart';
import '../../route_management/constant_routes.dart';

class AllPropertyScreen extends GetView<AllPropertyController> {
  AllPropertyScreen({super.key});
  @override
  final controller = Get.put(AllPropertyController());

  @override
  Widget build(BuildContext context) {
    // final Map<String, dynamic>? filters = Get.arguments;
    // if (filters != null) {
    // controller.refreshPropertiesWithFilters(filters);
    // }

    return Scaffold(
      backgroundColor: whiteColor,
      // appBar: titleAppBar("Properties", action: [
      //   IconButton(onPressed: (){
      //     Get.toNamed(kPropertyFilterScreen)?.then((result) {
      //       if (result != null) {
      //         controller.pagingController.value.itemList!.clear();
      //         return controller.getProperties(1, result);
      //       }
      //     });
      //   }, icon: const Icon(Icons.filter_list)),
      // ]),
      body: SafeArea(
        child: Stack(
          children: [
            RefreshIndicator(
              onRefresh: () async {
                controller.pagingController.itemList!.clear();
                return controller.getProperties(1);
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
                            onPressed: () => controller.getProperties(1),
                          ),
                      itemBuilder: (context, item, index) {
                        String imagesString = item.images.toString();
                        List<String> imageList = imagesString.split(',');
                        print(
                          imageList[0],
                        );
                        return Column(
                          children: [
                            myPropertyWidget(context, onTap: () {
                              Get.toNamed(kAllPropertyDetailScreen,
                                  arguments: item.id);
                            },
                                title: item.city.toString(),
                                image: item.propertyImages!.isNotEmpty
                                    ? item.propertyImages!.first
                                    : imageList[0],
                                price: "\$${item.amount.toString()}",
                                description: item.description.toString(),
                                bedroom: item.bedroom.toString(),
                                bathroom: item.bathroom.toString(),
                                marla: item.areaRange.toString(),
                                index: index,
                                icon: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Align(
                                      alignment: Alignment.topRight,
                                      child: CircleAvatar(
                                        backgroundColor: Colors.white,
                                        child: IconButton(
                                          icon: Icon(
                                            item.isFavorite == 1
                                                ? Icons.favorite
                                                : Icons.favorite_border,
                                            color: item.isFavorite == 1
                                                ? Colors.red
                                                : greyText,
                                          ),
                                          onPressed: () {
                                            controller.toggleFavorite1(
                                                index, item.id);
                                          },
                                        ),
                                      )),
                                ),
                                rent: item.type),
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
