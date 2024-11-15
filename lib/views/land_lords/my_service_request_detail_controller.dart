import 'package:cached_network_image/cached_network_image.dart';
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
import '../../controllers/land_lord/my_service_request_detail_controller.dart';
import '../../custom_widgets/custom_button.dart';
import '../../utils/api_urls.dart';

class MyServiceRequestDetailScreen
    extends GetView<MyServiceRequestDetailController> {
  const MyServiceRequestDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(
          () => controller.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : controller.getServiceOne.value == null
                  ? Center(
                      child: customText(
                        text: "No Data found",
                      ),
                    )
                  : Stack(
                      children: [
                        PageView.builder(
                          itemCount: controller.images.length,
                          scrollDirection: Axis.horizontal,
                          controller: controller.pageController,
                          itemBuilder: (context, index) {
                            String imagesString =
                                controller.getServiceOne.value == null
                                    ? ""
                                    : controller.getServiceOne.value!.request
                                        .service!.media
                                  ..toString();
                            List<String> imageList = imagesString.split(',');
                            controller.images = imageList;
                            return InkWell(
                              onTap: () {
                                Get.to(
                                    () => ViewImage(
                                          photo: AppUrls.mediaImages +
                                              imageList[index],
                                        ),
                                    transition: routeTransition);
                              },
                              child: CachedNetworkImage(
                                width: double.infinity,
                                height: screenHeight(context) * 0.5,
                                imageUrl:
                                    AppUrls.mediaImages + imageList[index],
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
                                count: controller.images.length,
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

class MyDraggable extends GetView<MyServiceRequestDetailController> {
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
          DateTime? createdAt = controller.getServiceOne.value!.createdAt;
          String requestDate = createdAt != null
              ? DateFormat('dd-M-yy').format(createdAt!)
              : 'N/A'; // Adjust the pattern as needed
          String requestTime = createdAt != null
              ? DateFormat('h:mm a').format(createdAt)
              : 'N/A';

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
                                        text: controller.getServiceOne.value!
                                                    .request ==
                                                null
                                            ? ""
                                            : controller.getServiceOne.value!
                                                .request.service!.serviceName,
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
                                                          .getServiceOne
                                                          .value!
                                                          .provider!
                                                          .fullname,
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
                                                            .getServiceOne
                                                            .value!
                                                            .provider!
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
                                              text: controller.getServiceOne
                                                  .value!.request.description,
                                              color: blackColor,
                                              fontSize: 14),
                                          h5,
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
                                                      text: "Location :",
                                                      color: greyColor,
                                                      fontSize: 16),
                                                  h5,
                                                  customText(
                                                      text: controller
                                                          .getServiceOne
                                                          .value!
                                                          .request
                                                          .address,
                                                      color: blackColor,
                                                      fontSize: 16),
                                                ],
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
                                                  text: controller.getServiceOne
                                                      .value!.request.date,
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
                                                  text: controller.getServiceOne
                                                      .value!.request.time,
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
                                SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: CustomButton(
                                          onTap: () {
                                            Get.back();
                                          },
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          height: screenHeight(context) * 0.05,
                                          text: "Back",
                                          fontSize: 12,
                                          gradientColor: detailGradient(),
                                        ),
                                      ),
                                      w10,
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
}
