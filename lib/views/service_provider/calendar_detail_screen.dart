import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:property_app/controllers/services_provider_controller/calendar_controller.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../app_constants/animations.dart';
import '../../app_constants/app_icon.dart';
import '../../app_constants/app_sizes.dart';
import '../../app_constants/color_constants.dart';
import '../../constant_widget/constant_widgets.dart';
import '../../constant_widget/view_photo.dart';
import '../../custom_widgets/custom_button.dart';
import '../../utils/shared_preferences/preferences.dart';
import '../chat_screens/chat_conversion_screen.dart';

class CalendarDetailScreen extends GetView<CalendarDetailController> {
  const CalendarDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(
          () => controller.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : Stack(
                  children: [
                    PageView.builder(
                      itemCount: controller
                              .getCalendarOne.value!.serviceImages.isNotEmpty
                          ? controller
                              .getCalendarOne.value!.serviceImages.length
                          : 1, // Ensure we have at least 1 item to avoid errors
                      scrollDirection: Axis.horizontal,
                      controller: controller.pageController,
                      itemBuilder: (context, index) {
                        // Ensure getCalendarOne and service data exist
                        if (controller.getCalendarOne.value != null) {
                          return InkWell(
                              onTap: () {
                                Get.to(
                                  () => ViewImagesModel(
                                    photo: controller
                                        .getCalendarOne.value!.serviceImages,
                                    index:
                                        index, // Assuming images in controller.images are relative paths
                                  ),
                                  transition: routeTransition,
                                );
                              },
                              child: controller.getCalendarOne.value!
                                      .serviceImages.isNotEmpty
                                  ? CachedNetworkImage(
                                      width: double.infinity,
                                      height: screenHeight(context) * 0.5,
                                      imageUrl: controller.getCalendarOne.value!
                                          .serviceImages[index].imagePath,
                                      fit: BoxFit.cover,
                                      errorWidget: (context, e, b) {
                                        return Image.asset(AppIcons.appLogo);
                                      },
                                    )
                                  : Image.asset(
                                      AppIcons.appLogo,
                                      fit: BoxFit.none,
                                    ));
                        } else {
                          // Return a fallback widget when service data is missing
                          return SizedBox();
                        }
                      },
                    ),
                    Positioned(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                Get.back();
                              },
                              child: CircleAvatar(
                                backgroundColor: whiteColor,
                                child: SvgPicture.asset(AppIcons.backIcon),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 290.0),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: SmoothPageIndicator(
                            controller: controller.pageController,
                            count: controller.images.isNotEmpty
                                ? controller.images.length
                                : 1, // Ensure the count is valid
                            effect: const WormEffect(
                                dotColor: whiteColor,
                                dotHeight: 10,
                                dotWidth: 10), // Choose any effect
                          ),
                        ),
                      ),
                    ),
                    const MyDraggable(),
                  ],
                ),
        ),
      ),
    );
  }
}

class MyDraggable extends GetView<CalendarDetailController> {
  const MyDraggable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return DraggableScrollableSheet(
        key: controller.sheet,
        initialChildSize: 0.5,
        maxChildSize: 0.5, // Set maxChildSize to the same value (0.5)
        minChildSize: 0.5,
        //expand: true,
        // snap: true,
        // snapSizes: const [
        //   0.5,  // Set the first snap size to the minimum size (0.2)
        //   0.95,
        // ],
        controller: controller.controller,
        builder: (BuildContext context, ScrollController scrollController) {
          return DecoratedBox(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 15),
              child: CustomScrollView(
                controller: scrollController,
                slivers: [
                  SliverList.list(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom,
                            left: 10,
                            right: 10),
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Center(
                                      child: headingText(
                                        text: controller
                                            .getCalendarOne.value!.serviceName,
                                        fontSize: 24,
                                      ),
                                    ),
                                    h15,
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, right: 20),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  customText(
                                                      text: "Client Name :",
                                                      color: greyColor,
                                                      fontSize: 15),
                                                  customText(
                                                      text: controller
                                                          .getCalendarOne
                                                          .value!
                                                          .user
                                                          .fullName,
                                                      color: blackColor,
                                                      fontSize: 16),
                                                ],
                                              ),
                                              const SizedBox(
                                                width: 30,
                                              ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    customText(
                                                        text:
                                                            "Contact Details :",
                                                        color: greyColor,
                                                        fontSize: 15),
                                                    customText(
                                                        text: controller
                                                            .getCalendarOne
                                                            .value!
                                                            .user
                                                            .email,
                                                        color: blackColor,
                                                        fontSize: 16),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          h5,
                                          customText(
                                              text: "Description :",
                                              color: greyColor,
                                              fontSize: 15),
                                          h5,
                                          customText(
                                              text: controller.getCalendarOne
                                                  .value!.description,
                                              color: blackColor,
                                              fontSize: 14),
                                          h5,
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  customText(
                                                      text: "Property Type: ",
                                                      color: greyColor,
                                                      fontSize: 16),
                                                  w5,
                                                  customText(
                                                      text: controller
                                                          .getCalendarOne
                                                          .value!
                                                          .propertyType,
                                                      color: blackColor,
                                                      fontSize: 15),
                                                  h5,
                                                ],
                                              ),
                                            ],
                                          ),
                                          h5,
                                          Row(
                                            children: [
                                              customText(
                                                  text: "Price: ",
                                                  color: greyColor,
                                                  fontSize: 16),
                                              w5,
                                              customText(
                                                  text:
                                                      "\$${controller.getCalendarOne.value!.pricing}",
                                                  color: blackColor,
                                                  fontSize: 18),
                                            ],
                                          ),
                                          h5,
                                          Row(
                                            children: [
                                              customText(
                                                  text: "Location: ",
                                                  color: greyColor,
                                                  fontSize: 16),
                                              w5,
                                              customText(
                                                  text:
                                                      "\$${controller.getCalendarOne.value!.location}",
                                                  color: blackColor,
                                                  fontSize: 18),
                                            ],
                                          ),
                                          h5,
                                          Row(
                                            children: [
                                              Image.asset(
                                                AppIcons.clockDuration,
                                                width: 20,
                                                height: 20,
                                              ),
                                              w5,
                                              customText(
                                                  text: "Service Time : ",
                                                  color: greyColor,
                                                  fontSize: 16),
                                              customText(
                                                  text:
                                                      "${controller.getCalendarOne.value!.startTime} - ${controller.getCalendarOne.value!.endTime}",
                                                  color: blackColor,
                                                  fontSize: 14),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                h50,
                                Center(
                                  child: CustomButton(
                                    height: screenHeight(context) * 0.06,
                                    borderRadius: BorderRadius.circular(50),
                                    text: "Contact",
                                    fontSize: 20,
                                    width: screenWidth(context) * 0.4,
                                    onTap: () {
                                      //     createConversation(controller.getCalendarOne.value!.request., profilePicture, id, context)
                                      //Get.toNamed(kChatConversionScreen);
                                      createConversation(
                                          controller.getCalendarOne.value!.user
                                                  .fullName ??
                                              "",
                                          controller.getCalendarOne.value!.user
                                              .profileImage,
                                          controller
                                              .getCalendarOne.value!.userId
                                              .toString(),
                                          context);
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
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
