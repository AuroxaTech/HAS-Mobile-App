import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:property_app/app_constants/app_icon.dart';
import 'package:property_app/app_constants/app_sizes.dart';
import 'package:property_app/app_constants/color_constants.dart';
import 'package:property_app/constant_widget/constant_widgets.dart';
import 'package:property_app/custom_widgets/custom_button.dart';
import 'package:property_app/route_management/constant_routes.dart';

import '../../controllers/services_provider_controller/service_listing_screen_controller.dart';
import '../../models/service_provider_model/all_services.dart';
import '../../utils/shared_preferences/preferences.dart';
import '../chat_screens/chat_conversion_screen.dart';

class ServicesListingScreen extends GetView<ServiceListingScreenController> {
  ServicesListingScreen({Key? key}) : super(key: key);
  @override
  final controller = Get.put(ServiceListingScreenController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: controller.key,
      backgroundColor: whiteColor,
      appBar: titleAppBar(
        "Service Listing",
        action: [
          IconButton(
              onPressed: () {
                Get.toNamed(kServiceFilterScreen)?.then((result) {
                  if (result != null) {
                    controller.pagingController.value.itemList!.clear();
                    return controller.getServices(1, result);
                  }
                });
              },
              icon: const Icon(Icons.filter_list)),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            RefreshIndicator(
              onRefresh: () async {
                controller.pagingController.itemList!.clear();
                return controller.getServices(1);
              },
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: PagedListView<int, AllService>(
                  shrinkWrap: true,
                  pagingController: controller.pagingController,
                  builderDelegate: PagedChildBuilderDelegate<AllService>(
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
                            onPressed: () => controller.getServices(1),
                          ),
                      itemBuilder: (context, item, index) {
                        print("Screen - Building item for service ID: ${item.id}");
                        print("Screen - isApplied value: ${item.isApplied}");
                        print("Screen - Raw isApplied type: ${item.isApplied.runtimeType}");
                        print("Screen - Condition check: item.isApplied == 1 is ${item.isApplied == 1}");
                        print("Favourite = ${item.isFavorite}");
                        print("is Applied => ${item.isApplied}");

                        int? isApplied;
                        // int? isDeclined;
                        // int? isApproved;

                        // // If serviceProviderRequests exists, print the latest request details
                        // if (item.serviceProviderRequests != null &&
                        //     item.serviceProviderRequests!.isNotEmpty) {
                        //   var latestRequest = item.serviceProviderRequests!
                        //       .reduce((curr, next) =>
                        //           curr.id > next.id ? curr : next);
                        //   isApplied = latestRequest.isApplied ?? 0;
                        //   isDeclined = latestRequest.decline ?? 0;
                        //   isApproved = latestRequest.approved ?? 0;
                        // }

                        String imageUrl = AppIcons.appLogo;
                        if (item.serviceImages.isNotEmpty) {
                          imageUrl = item.serviceImages[0].imagePath;
                        }

                        return Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: InkWell(
                            onTap: () {
                              Get.toNamed(
                                kServiceListingScreenDetail,
                                arguments: [
                                  item.id,
                                  item.serviceImages
                                      .map((img) => img.imagePath)
                                      .toList()
                                ],
                              );
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.2),
                                      spreadRadius: 1,
                                      blurRadius: 6,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                width: 60,
                                                height: 70,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  // Optionally add a box shadow, background color, etc.
                                                ),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: CachedNetworkImage(
                                                    imageUrl: imageUrl,
                                                    width: 60,
                                                    height: 70,
                                                    fit: BoxFit.cover,
                                                    errorWidget: (context, url,
                                                            error) =>
                                                        Image.asset(
                                                            AppIcons.appLogo),
                                                  ),
                                                ),
                                              ),
                                              w20,
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    width: 150,
                                                    child: customText(
                                                      text: item.serviceName,
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      const Icon(Icons.star,
                                                          color: Colors.amber,
                                                          size: 20),
                                                      const SizedBox(width: 4),
                                                      customText(
                                                          text:
                                                              "${item.averageRate} (${item.countOfService})")
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              item.isFavorite == 1
                                                  ? Icons.favorite
                                                  : Icons.favorite_border,
                                              color: item.isFavorite == 1
                                                  ? Colors.red
                                                  : greyText,
                                            ),
                                            onPressed: () {
                                              // controller.getServices();
                                              controller.toggleFavorite1(
                                                  index, item.id);
                                            },
                                          )
                                        ],
                                      ),
                                      h15,
                                      customText(
                                          text: "Main Services Offered :",
                                          fontSize: 16,
                                          color: Colors.black54),
                                      h5,
                                      customText(
                                        text: "${item.additionalInformation}" ??
                                            "",
                                        fontSize: 16,
                                      ),
                                      h10,
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              customText(
                                                  text: "Available  ",
                                                  fontSize: 16,
                                                  color: Colors.black54),
                                              Image.asset(
                                                  AppIcons.clockDuration),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              customText(
                                                  text: "Service  ",
                                                  fontSize: 16,
                                                  color: Colors.black54),
                                              SvgPicture.asset(
                                                  AppIcons.locationRed),
                                            ],
                                          ),
                                          w30
                                        ],
                                      ),
                                      h10,
                                      customText(
                                          text:
                                              "${item.startTime}  ${item.endTime}",
                                          fontSize: 16,
                                          color: blackColor),
                                      h10,
                                      customText(
                                          text: item.location,
                                          fontSize: 16,
                                          color: blackColor),
                                      h10,
                                      customText(
                                          text: "Description :",
                                          fontSize: 16,
                                          color: Colors.black54),
                                      h10,
                                      customText(
                                          text: item.description,
                                          fontSize: 14,
                                          color: Colors.black54),
                                      h10,
                                      Row(
                                        children: [
                                          Expanded(
                                            child: CustomButton(
                                              height:
                                                  screenHeight(context) * 0.06,
                                              text: "Contact",
                                              fontSize: 18,
                                              gradientColor: yellowGradient(),
                                              onTap: () {
                                                createConversation(
                                                    item.user!.fullname
                                                        .toString(),
                                                    item.user!.profileimage,
                                                    item.user!.id.toString(),
                                                    context);
                                                //Get.toNamed(kChatConversionScreen);
                                              },
                                            ),
                                          ),
                                          w15,
                                          Expanded(
                                            child: item.isApplied == 1
                                                ? CustomButton(
                                                    gradientColor:
                                                        detailGradient(),
                                                    height:
                                                        screenHeight(context) *
                                                            0.06,
                                                    text: "Pending",
                                                    fontSize: 18,
                                                    onTap: () {
                                                      print("Service ${item.id} is already applied (isApplied=${item.isApplied})");
                                                    },
                                                  )
                                                : CustomButton(
                                                    height:
                                                        screenHeight(context) *
                                                            0.06,
                                                    text: "Book Service",
                                                    fontSize: 18,
                                                    gradientColor: gradient(),
                                                    onTap: () {
                                                      print("Booking service ${item.id} (isApplied=${item.isApplied})");
                                                      Get.toNamed(
                                                          kNewServiceRequestScreen,
                                                          arguments: [
                                                            item.serviceName,
                                                            item.user == null
                                                                ? ""
                                                                : item.user!
                                                                    .email,
                                                            item.description,
                                                            item.userId,
                                                            item.id,
                                                            imageUrl,
                                                            item.country,
                                                            item.city,
                                                            item.yearExperience,
                                                            item.cnicFrontPic,
                                                            item.cnicBackPic,
                                                            item.certification,
                                                            item.resume,
                                                            item.pricing,
                                                            item.serviceImages
                                                          ]);
                                                    },
                                                  ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                )),
                          ),
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

  bool _shouldShowBookService(
      int? isApplied, int? isDeclined, int? isApproved) {
    if (isApplied == null || isDeclined == null || isApproved == null) {
      return true;
    }
    return (isApplied == 0 && isDeclined == 0) || (isDeclined == 1);
  }

  createConversation(
      String name, String profilePicture, String id, context) async {
    try {
      var userId = await Preferences.getUserID();
      var userName = await Preferences.getUserName();

      // Query Firestore to check if a conversation already exists
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('conversationListing')
          .where('user1', isEqualTo: userId.toString())
          .where('user2', isEqualTo: id)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        print("EXIST");
        // Conversation already exists, navigate to chat screen
        DocumentSnapshot conversationSnapshot = querySnapshot.docs.first;
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatScreen1(
                      group: false,
                      image: profilePicture,
                      name: name,
                      data: conversationSnapshot,
                      id: id.toString(),
                      userId: userId.toString(),
                    )));
        // Navigator.pushAndRemoveUntil(
        //   context,
        //   MaterialPageRoute(
        //       builder: (context) => ChatScreen1(
        //           group: false,
        //           image: profilePicture,
        //           name: name,
        //           data: conversationSnapshot)),
        //       (Route<dynamic> route) => false,
        // );
      } else {
        print("Not EXIST");
        // Conversation doesn't exist, create new conversation
        Map<String, dynamic> conversationData = {
          'group': false,
          'profilePictureUrl': profilePicture,
          "members": [
            {
              'userId': userId.toString(),
              'userName': userName,
              'profilePictureUrl': id == userId.toString()
                  ? profilePicture
                  : await Preferences.getToken(),
            },
            {
              'userId': id,
              'userName': name,
              'profilePictureUrl': profilePicture
            },
          ],
          "created": DateTime.now(),
          "user1": userId.toString(),
          "user2": id,
          "user": [userId.toString(), id],
          "lastMessage": {
            "message": "",
            "time": null,
            "seen": false,
          },
        };
        DocumentReference conversationRef = await FirebaseFirestore.instance
            .collection('conversationListing')
            .add(conversationData);
        DocumentSnapshot conversationSnapshot = await conversationRef.get();
        // Navigator.pushAndRemoveUntil(
        //   context,
        //   MaterialPageRoute(
        //       builder: (context) => ChatScreen1(
        //           group: false,
        //           image: profilePicture,
        //           name: name,
        //           data: conversationSnapshot)),
        //       (Route<dynamic> route) => false,
        // );

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatScreen1(
                      group: false,
                      image: profilePicture,
                      name: name,
                      data: conversationSnapshot,
                      id: id.toString(),
                      userId: userId.toString(),
                    )));
      }
    } catch (e) {
      print('Error creating or navigating to conversation: $e');
    }
  }
}
