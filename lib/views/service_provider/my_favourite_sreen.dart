import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:property_app/app_constants/app_sizes.dart';
import 'package:property_app/app_constants/color_constants.dart';
import 'package:property_app/constant_widget/constant_widgets.dart';
import 'package:property_app/services/property_services/get_property_services.dart';

import '../../app_constants/app_icon.dart';
import '../../controllers/services_provider_controller/my_favourite_screen_controller.dart';
import '../../models/service_provider_model/favorite_provider.dart';
import '../../route_management/constant_routes.dart';
import '../../services/property_services/add_services.dart';
import '../../utils/api_urls.dart';

class MyFavouriteScreen extends GetView<MyFavouriteScreenController> {
  const MyFavouriteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: whiteColor,
        appBar: homeAppBar(
          context,
          text: "My Favourites",
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color:
                          Colors.grey[100], // Background color of the tab bar
                      borderRadius: BorderRadius.circular(50.0),
                      border: Border.all(color: borderColor)),
                  child: Row(
                    children: [
                      for (int i = 0; i < 2; i++)
                        Expanded(
                          child: InkWell(
                            highlightColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            onTap: () {
                              controller.tabController.animateTo(i);
                              controller.selectedIndex.value = i;
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10), // Padding for the tab
                              alignment: Alignment.center,
                              child: Column(
                                children: [
                                  Container(
                                    width: 10,
                                    height: 10,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color:
                                            controller.selectedIndex.value == i
                                                ? Colors.blue
                                                : Colors.transparent),
                                  ),
                                  h5,
                                  customText(
                                    text: i == 0
                                        ? 'Service Providers'
                                        : 'Properties',
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight:
                                        controller.selectedIndex.value == i
                                            ? FontWeight.w600
                                            : FontWeight.w400,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                h20,
                Expanded(
                  child: TabBarView(
                    controller: controller.tabController,
                    children: [
                      Stack(
                        children: [
                          RefreshIndicator(
                            onRefresh: () async {
                              controller.pagingController.itemList!.clear();
                              return controller.getFavoriteServices(1);
                            },
                            child: PagedListView<int, FavoriteItem>(
                              shrinkWrap: true,
                              pagingController: controller.pagingController,
                              builderDelegate: PagedChildBuilderDelegate<
                                      FavoriteItem>(
                                  firstPageErrorIndicatorBuilder: (context) =>
                                      MaterialButton(
                                        child: const Text(
                                            "No Data Found, Tap to try again."),
                                        onPressed: () => controller
                                            .pagingController
                                            .refresh(),
                                      ),
                                  newPageErrorIndicatorBuilder: (context) =>
                                      MaterialButton(
                                        child: const Text(
                                            "Failed to load more items. Tap to try again."),
                                        onPressed: () => controller
                                            .pagingController
                                            .retryLastFailedRequest(),
                                      ),
                                  itemBuilder: (context, item, index) {
                                    // Get service data from the item
                                    final serviceData = item.service;
                                    if (serviceData == null) {
                                      return const SizedBox.shrink();
                                    }

                                    // Get the first image from service_images if available
                                    String imageUrl = AppIcons.appLogo;
                                    if (serviceData.serviceImages.isNotEmpty) {
                                      imageUrl = serviceData
                                          .serviceImages[0].imagePath;
                                    } else if (serviceData.media != null &&
                                        serviceData.media!.isNotEmpty) {
                                      // Fallback to media if service_images is empty
                                      imageUrl = AppUrls.mediaImages +
                                          serviceData.media!;
                                    }

                                    return Padding(
                                      padding: const EdgeInsets.only(top: 15),
                                      child: InkWell(
                                        onTap: () {
                                          Get.toNamed(
                                            kServiceListingScreenDetail,
                                            arguments: [
                                              serviceData.id,
                                              serviceData.serviceImages
                                                  .map((img) => img.imagePath)
                                                  .toList()
                                            ],
                                          );
                                        },
                                        child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.2),
                                                  spreadRadius: 1,
                                                  blurRadius: 6,
                                                  offset: const Offset(0, 3),
                                                ),
                                              ],
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(15.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Container(
                                                            width: 60,
                                                            height: 70,
                                                            child:
                                                                CachedNetworkImage(
                                                              imageUrl:
                                                                  imageUrl,
                                                              width: 60,
                                                              height: 70,
                                                              fit: BoxFit.cover,
                                                              errorWidget:
                                                                  (context,
                                                                      data, d) {
                                                                return Image.asset(
                                                                    AppIcons
                                                                        .appLogo);
                                                              },
                                                            ),
                                                          ),
                                                          w20,
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Container(
                                                                width: 150,
                                                                child:
                                                                    customText(
                                                                  text: serviceData
                                                                      .serviceName,
                                                                  fontSize: 20,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      IconButton(
                                                        icon: const Icon(
                                                          Icons.favorite,
                                                          color: Colors.red,
                                                        ),
                                                        onPressed: () async {
                                                          await ServiceProviderServices()
                                                              .removeFavoriteService(
                                                                  item.id)
                                                              .then((value) {
                                                            List<FavoriteItem>
                                                                newList =
                                                                List.from(controller
                                                                    .pagingController
                                                                    .itemList!);
                                                            newList.removeAt(
                                                                index);

                                                            // Update the pagination controller's item list
                                                            controller
                                                                .pagingController
                                                                .itemList = newList;
                                                          });
                                                        },
                                                      )
                                                    ],
                                                  ),
                                                  h15,
                                                  customText(
                                                      text:
                                                          "Main Services Offered :",
                                                      fontSize: 16,
                                                      color: Colors.black54),
                                                  h5,
                                                  customText(
                                                    text: serviceData
                                                            .additionalInformation ??
                                                        "",
                                                    fontSize: 16,
                                                  ),
                                                  h10,
                                                  Row(
                                                    children: [
                                                      // Available time section
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                customText(
                                                                    text:
                                                                        "Available  ",
                                                                    fontSize:
                                                                        16,
                                                                    color: Colors
                                                                        .black54),
                                                                Image.asset(AppIcons
                                                                    .clockDuration),
                                                              ],
                                                            ),
                                                            h5,
                                                            customText(
                                                                text:
                                                                    "${serviceData.startTime} - ${serviceData.endTime}",
                                                                fontSize: 14,
                                                                color:
                                                                    blackColor),
                                                          ],
                                                        ),
                                                      ),

                                                      // Service location section
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                customText(
                                                                    text:
                                                                        "Service  ",
                                                                    fontSize:
                                                                        16,
                                                                    color: Colors
                                                                        .black54),
                                                                SvgPicture.asset(
                                                                    AppIcons
                                                                        .locationRed),
                                                              ],
                                                            ),
                                                            h5,
                                                            customText(
                                                                text: serviceData
                                                                    .location,
                                                                fontSize: 14,
                                                                maxLines: 2,
                                                                color:
                                                                    blackColor),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  h10,
                                                  customText(
                                                      text: "Description :",
                                                      fontSize: 16,
                                                      color: Colors.black54),
                                                  h10,
                                                  customText(
                                                      text: serviceData
                                                          .description,
                                                      fontSize: 14,
                                                      color: Colors.black54),
                                                  h10,
                                                ],
                                              ),
                                            )),
                                      ),
                                    );
                                  }),
                            ),
                          ),
                        ],
                      ),
                      Stack(
                        children: [
                          RefreshIndicator(
                            onRefresh: () async {
                              controller.propertyPagingController.itemList!
                                  .clear();
                              return controller.getFavoriteProperties(1);
                            },
                            child: PagedListView<int, FavoriteItem>(
                              shrinkWrap: true,
                              pagingController:
                                  controller.propertyPagingController,
                              builderDelegate: PagedChildBuilderDelegate<
                                      FavoriteItem>(
                                  firstPageErrorIndicatorBuilder: (context) =>
                                      MaterialButton(
                                        child: const Text(
                                            "No Data Found, Tap to try again."),
                                        onPressed: () => controller
                                            .pagingController
                                            .refresh(),
                                      ),
                                  newPageErrorIndicatorBuilder: (context) =>
                                      MaterialButton(
                                        child: const Text(
                                            "Failed to load more items. Tap to try again."),
                                        onPressed: () => controller
                                            .pagingController
                                            .retryLastFailedRequest(),
                                      ),
                                  itemBuilder: (context, item, index) {
                                    // Get property data from the item
                                    final propertyData = item.property;
                                    if (propertyData == null) {
                                      return const SizedBox.shrink();
                                    }

                                    // Get the first image from property_images if available
                                    String imageUrl = AppIcons.appLogo;
                                    if (propertyData
                                        .propertyImages.isNotEmpty) {
                                      imageUrl = propertyData
                                          .propertyImages[0].imagePath;
                                    } else if (propertyData.images != null &&
                                        propertyData.images!.isNotEmpty) {
                                      // Fallback to images if property_images is empty
                                      imageUrl = AppUrls.propertyImages +
                                          propertyData.images!;
                                    }

                                    return Column(
                                      children: [
                                        myPropertyFav(context,
                                            onTap: () {
                                              Get.toNamed(
                                                  kAllPropertyDetailScreen,
                                                  arguments: propertyData.id);
                                            },
                                            title: propertyData.city,
                                            image: imageUrl,
                                            price: "\$${propertyData.amount}",
                                            description:
                                                propertyData.description ?? "",
                                            bedroom: propertyData.bedroom,
                                            bathroom: propertyData.bathroom,
                                            marla: propertyData.areaRange,
                                            rent: propertyData.type,
                                            isFavorite: true,
                                            onFavoriteTap: () async {
                                              await PropertyServices()
                                                  .removeFavoriteProperty(
                                                      item.id)
                                                  .then((value) {
                                                List<FavoriteItem> newList =
                                                    List.from(controller
                                                        .propertyPagingController
                                                        .itemList!);
                                                newList.removeAt(index);
                                                // Update the pagination controller's item list
                                                controller
                                                    .propertyPagingController
                                                    .itemList = newList;
                                              });
                                            }),
                                        const SizedBox(
                                          height: 20,
                                        )
                                      ],
                                    );
                                  }),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
