import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../app_constants/animations.dart';
import '../../app_constants/app_icon.dart';
import '../../app_constants/app_sizes.dart';
import '../../app_constants/color_constants.dart';
import '../../constant_widget/constant_widgets.dart';
import '../../constant_widget/view_photo.dart';
import '../../controllers/services_provider_controller/service_request_detail_screen_controller.dart';
import '../../custom_widgets/custom_button.dart';
import '../../utils/api_urls.dart';
import '../../utils/shared_preferences/preferences.dart';
import '../chat_screens/chat_conversion_screen.dart';

class ServiceRequestDetailScreen
    extends GetView<ServiceRequestDetailScreenController> {
  String? reciverId;
  ServiceRequestDetailScreen({Key? key, required this.reciverId})
      : super(key: key);

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
                      itemCount: controller.getServiceRequestOne
                          .value!.serviceImages.length,
                      scrollDirection: Axis.horizontal,
                      controller: controller.pageController,
                      itemBuilder: (context, index) {

                        // List<String> imageList = imagesString.split(',');
                        // controller.images = controller.getServiceRequestOne
                        //     .value!.serviceImages;
                        return InkWell(
                          onTap: () {
                            Get.to(
                                () => ViewImagesModel(
                                      photo: controller.getServiceRequestOne
                                          .value!.serviceImages,
                                  index: index,
                                    ),
                                transition: routeTransition);
                          },
                          child: CachedNetworkImage(
                            width: double.infinity,
                            height: screenHeight(context) * 0.5,
                            imageUrl: controller.getServiceRequestOne
                                .value!.serviceImages[index].imagePath,
                            fit: BoxFit.cover,
                            errorWidget: (context, e, b) {
                              return Image.asset(AppIcons.appLogo);
                            },
                          ),
                        );
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
                            controller: controller
                                .pageController, // Connect the indicator to the controller
                            count: controller.getServiceRequestOne
                                .value!.serviceImages.length,
                            effect: const WormEffect(
                              dotColor: whiteColor,
                              dotHeight: 10,
                              dotWidth: 10,
                            ), // Feel free to choose any effect
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

class MyDraggable extends GetView<ServiceRequestDetailScreenController> {
  const MyDraggable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return DraggableScrollableSheet(
        key: controller.sheet,
        initialChildSize: 0.58,
        maxChildSize: 0.58, // Set maxChildSize to the same value (0.5)
        minChildSize: 0.58,
        // expand: true,
        // snap: true,
        // snapSizes: const [
        //   0.5,  // Set the first snap size to the minimum size (0.2)
        //   0.95,
        // ],
        controller: controller.controller,
        builder: (BuildContext context, ScrollController scrollController) {
          DateTime? createdAt =
              controller.getServiceRequestOne.value!.createdAt;
          String requestDate = DateFormat('dd-M-yy')
              .format(createdAt!); // Adjust the pattern as needed
          String requestTime = DateFormat('h:mm a').format(createdAt);
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
                                        text: controller.getServiceRequestOne
                                                    .value ==
                                                null
                                            ? ""
                                            : controller.getServiceRequestOne
                                                .value!.serviceName,
                                        fontSize: 24,
                                      ),
                                    ),
                                    h5,
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, right: 20),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
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
                                                          .getServiceRequestOne
                                                          .value!
                                                          .user
                                                          .fullName,
                                                      color: blackColor,
                                                      fontSize: 16),
                                                ],
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  customText(
                                                      text: "Contact Details :",
                                                      color: greyColor,
                                                      fontSize: 15),
                                                  customText(
                                                      text: controller
                                                          .getServiceRequestOne
                                                          .value!
                                                          .user!
                                                          .email,
                                                      color: blackColor,
                                                      fontSize: 16),
                                                ],
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
                                              text: controller
                                                  .getServiceRequestOne
                                                  .value!
                                                  .description,
                                              color: blackColor,
                                              fontSize: 14),
                                          h5,
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    customText(
                                                        text: "Location :",
                                                        color: greyColor,
                                                        fontSize: 16),
                                                    // h5,
                                                    // customText(
                                                    //     text: controller
                                                    //         .getServiceRequestOne
                                                    //         .value!
                                                    //         .address,
                                                    //     color: blackColor,
                                                    //     fontSize: 16),
                                                  ],
                                                ),
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  customText(
                                                      text: "Request Status :",
                                                      color: greyColor,
                                                      fontSize: 16),
                                                  h5,
                                                  Image.asset(
                                                    AppIcons.newBanner,
                                                    height: 25,
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                          h5,
                                          customText(
                                              text: "Request Date & Time : ",
                                              color: greyColor,
                                              fontSize: 16),
                                          h5,
                                          Row(
                                            children: [
                                              Image.asset(
                                                AppIcons.calendar,
                                                width: 12,
                                                height: 12,
                                              ),
                                              customText(
                                                  text: " Date :",
                                                  color: greyColor,
                                                  fontSize: 12),
                                              w10,
                                              customText(
                                                  text: requestDate,
                                                  color: blackColor,
                                                  fontSize: 12),
                                            ],
                                          ),
                                          h5,
                                          Row(
                                            children: [
                                              Image.asset(
                                                AppIcons.clockDuration,
                                                width: 12,
                                                height: 12,
                                              ),
                                              customText(
                                                  text: " Time :",
                                                  color: greyColor,
                                                  fontSize: 12),
                                              w10,
                                              customText(
                                                  text: requestTime,
                                                  color: blackColor,
                                                  fontSize: 12),
                                            ],
                                          ),
                                          h5,
                                          customText(
                                              text: "Client Date & Time : ",
                                              color: greyColor,
                                              fontSize: 16),
                                          h5,
                                          Row(
                                            children: [
                                              Image.asset(
                                                AppIcons.calendar,
                                                width: 12,
                                                height: 12,
                                              ),
                                              customText(
                                                  text: " Date :",
                                                  color: greyColor,
                                                  fontSize: 12),
                                              w10,
                                              customText(
                                                  text: controller
                                                      .getServiceRequestOne
                                                      .value!
                                                      .duration,
                                                  color: blackColor,
                                                  fontSize: 12),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Image.asset(
                                                AppIcons.clockDuration,
                                                width: 12,
                                                height: 12,
                                              ),
                                              customText(
                                                  text: " Time :",
                                                  color: greyColor,
                                                  fontSize: 12),
                                              w10,
                                              customText(
                                                  text:
                                                      "${controller.getServiceRequestOne.value!.startTime} ${controller.getServiceRequestOne.value!.endTime}",
                                                  color: blackColor,
                                                  fontSize: 12),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                // h10,
                                // Center(
                                //   child: CustomButton(
                                //     height: screenHeight(context) * 0.05,
                                //     borderRadius: BorderRadius.circular(50),
                                //     text: "Contract",
                                //     fontSize: 20,
                                //     width: screenWidth(context) * 0.4,
                                //     onTap: (){
                                //       Get.toNamed(kContractScreen);
                                //     },
                                //   ),
                                // ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: CustomButton(
                                          onTap: () {
                                            if (controller.getServiceRequestOne
                                                    .value!.status ==
                                                "accepted") {
                                              null;
                                            } else if (controller
                                                    .getServiceRequestOne
                                                    .value!
                                                    .status ==
                                                "rejected") {
                                              Get.snackbar(
                                                'This request has been declined. Cannot accept now.',
                                                '',
                                                backgroundColor:
                                                    redColor.withOpacity(0.8),
                                                colorText: Colors.white,
                                                snackPosition:
                                                    SnackPosition.BOTTOM,
                                              );
                                            } else {
                                              controller
                                                  .acceptServiceRequest(
                                                      requestId: controller
                                                          .getServiceRequestOne
                                                          .value!
                                                          .id,
                                                      userId: controller
                                                          .getServiceRequestOne
                                                          .value!
                                                          .userId
                                                          .toString(),
                                                      providerId: controller
                                                          .getServiceRequestOne
                                                          .value!
                                                          .providerId
                                                          .toString())
                                                  .then((value) {
                                                controller.getServiceRequest(
                                                    id: controller.id.value);
                                              });
                                            }
                                          },
                                          height: screenHeight(context) * 0.04,
                                          text: "Accept",
                                          fontSize: 12,
                                          gradientColor: acceptGradient(
                                              color: controller
                                                          .getServiceRequestOne
                                                          .value!
                                                          .status ==
                                                      "accepted"
                                                  ? const Color(0xff14C034)
                                                      .withOpacity(0.3)
                                                  : const Color(0xff14C034)),
                                        ),
                                      ),
                                      w10,
                                      Expanded(
                                        child: CustomButton(
                                          onTap: () {
                                            if (controller.getServiceRequestOne
                                                    .value!.status ==
                                                "rejected") {
                                              null;
                                            } else if (controller
                                                    .getServiceRequestOne
                                                    .value!
                                                    .status ==
                                                "accepted") {
                                              Get.snackbar(
                                                'This request has been accepted. Cannot decline now.',
                                                '',
                                                backgroundColor:
                                                    redColor.withOpacity(0.8),
                                                colorText: Colors.white,
                                                snackPosition:
                                                    SnackPosition.BOTTOM,
                                              );
                                            } else {
                                              animatedDialog(context,
                                                  title: "Decline Request",
                                                  subTitle:
                                                      "Are you sure to decline this request",
                                                  yesButtonText: "Decline",
                                                  yesTap: () {
                                                controller
                                                    .declineServiceRequest(
                                                        requestId: controller
                                                            .getServiceRequestOne
                                                            .value!
                                                            .id,
                                                        providerId: controller
                                                            .getServiceRequestOne
                                                            .value!
                                                            .providerId!,

                                                )
                                                    .then((value) {
                                                  controller.getServiceRequest(
                                                      id: controller.id.value);
                                                });
                                              });
                                            }
                                          },
                                          gradientColor: redGradient(
                                              color: controller
                                                          .getServiceRequestOne
                                                          .value!
                                                          .status ==
                                                      "rejected"
                                                  ? redColor.withOpacity(0.3)
                                                  : redColor),
                                          height: screenHeight(context) * 0.04,
                                          text: "Decline",
                                          fontSize: 12,
                                        ),
                                      ),
                                      w10,
                                      Expanded(
                                        child: CustomButton(
                                          onTap: () {
                                            if (controller.getServiceRequestOne
                                                    .value!.status ==
                                                "rejected") {
                                              Get.snackbar(
                                                'This request has been declined. No chats available.',
                                                '',
                                                backgroundColor:
                                                    redColor.withOpacity(0.8),
                                                colorText: Colors.white,
                                                snackPosition:
                                                    SnackPosition.BOTTOM,
                                              );
                                            } else {
                                              print(
                                                  "Reciver Id ==> ${controller.getServiceRequestOne.value!.user.id.toString()}");
                                              print(
                                                  "Reciver name ==> ${controller.getServiceRequestOne.value!.user.fullName.toString()}");
                                              print(
                                                  "Reciver Image ==> ${controller.getServiceRequestOne.value!.user.profileImage.toString()}");
                                              createConversation(
                                                  controller
                                                          .getServiceRequestOne
                                                          .value!
                                                          .user
                                                          .fullName ??
                                                      "",
                                                  controller
                                                      .getServiceRequestOne
                                                      .value!
                                                      .user
                                                      .profileImage,
                                                  controller
                                                      .getServiceRequestOne
                                                      .value!
                                                      .userId
                                                      .toString(),
                                                  context);
                                            }
                                          },
                                          height: screenHeight(context) * 0.04,
                                          text: "Contact",
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
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
      String name, String profilePicture, String id, context)
  async {
    print("user.Id =>${id.toString()}");
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
