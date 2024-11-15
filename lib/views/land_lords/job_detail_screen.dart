import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:property_app/controllers/jobs_controller/job_detail_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../app_constants/animations.dart';
import '../../app_constants/app_icon.dart';
import '../../app_constants/app_sizes.dart';
import '../../app_constants/color_constants.dart';
import '../../constant_widget/constant_widgets.dart';
import '../../constant_widget/view_photo.dart';
import '../../controllers/stripe_payment_controller/stripe_payment_controller.dart';
import '../../custom_widgets/custom_button.dart';
import '../../stripe_payment_screen/stripe_payment_screen.dart';
import '../../utils/api_urls.dart';

class JobDetailScreen extends GetView<JobDetailController> {
  const JobDetailScreen({Key? key}) : super(key: key);

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
                      itemCount: controller.images.length,
                      scrollDirection: Axis.horizontal,
                      controller: controller.pageController,
                      itemBuilder: (context, index) {
                        String imagesString =
                            controller.getServiceRequestOne.value!.request ==
                                    null
                                ? ""
                                : controller.getServiceRequestOne.value!.request
                                    .service!.media;
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
                            imageUrl: AppUrls.mediaImages + imageList[index],
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
                    controller.images.isNotEmpty
                        ? Positioned(
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
                          )
                        : SizedBox(),
                    const MyDraggable(),
                  ],
                ),
        ),
      ),
    );
  }
}

class MyDraggable extends GetView<JobDetailController> {
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
              controller.getServiceRequestOne.value?.createdAt;
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
                                        text: controller
                                                .getServiceRequestOne
                                                .value
                                                ?.request
                                                ?.service
                                                ?.serviceName ??
                                            "", // Null-aware access with fallback
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
                                                            .getServiceRequestOne
                                                            .value
                                                            ?.provider
                                                            ?.fullname ??
                                                        "No Name", // Use null-aware access and a fallback value
                                                    color: blackColor,
                                                    fontSize: 16,
                                                  ),
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
                                                                .getServiceRequestOne
                                                                .value
                                                                ?.provider
                                                                ?.email ??
                                                            "No Email",
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
                                              text: controller
                                                      .getServiceRequestOne
                                                      .value
                                                      ?.request
                                                      ?.description ??
                                                  "No Description",
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
                                                              .getServiceRequestOne
                                                              .value
                                                              ?.request
                                                              ?.address ??
                                                          "",
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
                                                  text: controller
                                                          .getServiceRequestOne
                                                          .value
                                                          ?.request
                                                          ?.date ??
                                                      "",
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
                                                  text: controller
                                                          .getServiceRequestOne
                                                          .value
                                                          ?.request
                                                          ?.time ??
                                                      "",
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
                                            animatedDialog(context,
                                                title: "Job Completed",
                                                subTitle:
                                                    "Are you sure to complete this job",
                                                yesButtonText: "Complete",
                                                yesTap: () {
                                              Get.find<
                                                      StripePaymentScreenController>()
                                                  .initializePaymentDetails(
                                                serviceId: controller
                                                    .getServiceRequestOne
                                                    .value!
                                                    .request
                                                    .serviceId,
                                                serviceProviderId: controller
                                                    .getServiceRequestOne
                                                    .value!
                                                    .request
                                                    .service!
                                                    .userId,
                                                price: double.parse(controller
                                                    .getServiceRequestOne
                                                    .value!
                                                    .request!
                                                    .service!
                                                    .pricing),
                                              );
                                              Get.off(StripePaymentScreen(
                                                jobId: controller
                                                    .getServiceRequestOne
                                                    .value!
                                                    .id,
                                                id: controller.id.value,
                                                serviceProviderName: controller
                                                    .getServiceRequestOne
                                                    .value
                                                    ?.provider
                                                    ?.fullname,
                                                serviceProviderEmail: controller
                                                    .getServiceRequestOne
                                                    .value
                                                    ?.provider
                                                    ?.email,
                                              ));
                                              // controller
                                              //     .acceptServiceRequest(
                                              //         jobId: controller
                                              //             .getServiceRequestOne
                                              //             .value!
                                              //             .id,
                                              //         status: 1)
                                              //     .then((value) {
                                              //   controller.getJobRequest(
                                              //       id: controller.id.value);
                                              // });
                                            });
                                          },
                                          borderRadius:
                                              BorderRadius.circular(40),
                                          height: screenHeight(context) * 0.055,
                                          text: "Job Completed?",
                                          fontSize: 16,
                                          gradientColor: acceptGradient(),
                                        ),
                                      ),
                                      w10,
                                      Expanded(
                                        child: CustomButton(
                                          onTap: () {
                                            animatedDialog(context,
                                                title: "Decline Request",
                                                subTitle:
                                                    "Are you sure to decline this request",
                                                yesButtonText: "Decline",
                                                isLoading: controller.isLoading
                                                    .value, yesTap: () {
                                              controller
                                                  .acceptServiceRequest(
                                                      jobId: controller
                                                          .getServiceRequestOne
                                                          .value!
                                                          .id,
                                                      status: 2)
                                                  .then((value) {
                                                controller.getJobRequest(
                                                    id: controller.id.value);
                                              });
                                            });
                                          },
                                          gradientColor: redGradient(),
                                          borderRadius:
                                              BorderRadius.circular(40),
                                          height: screenHeight(context) * 0.055,
                                          text: "Reject Job?",
                                          fontSize: 16,
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
}
