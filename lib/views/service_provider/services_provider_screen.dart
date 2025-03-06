import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:property_app/constant_widget/delete_widgets.dart';
import 'package:property_app/constant_widget/drawer.dart';
import 'package:property_app/controllers/services_provider_controller/service_provide_controller.dart';
import 'package:property_app/views/service_provider/rating_screen.dart';

import '../../app_constants/animations.dart';
import '../../app_constants/app_sizes.dart';
import '../../app_constants/color_constants.dart';
import '../../constant_widget/constant_widgets.dart';
import '../../route_management/constant_routes.dart';
import '../chat_screens/HomeScreen.dart';

class ServiceProviderScreen extends GetView<ServiceProviderController> {
  ServiceProviderScreen({Key? key}) : super(key: key);
  @override
  final controller = Get.put(ServiceProviderController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: controller.key,
      backgroundColor: whiteColor,
      appBar: homeAppBar(context,
          text: "Service Provider",
          showNotification: true,
          isBack: true,
          menuOnTap: () => controller.key.currentState!.openDrawer(),
          back: false),
      drawer: providerDrawer(context, onDeleteAccount: () {
        deleteFunction(context, controller);
      }),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          // if (controller.getServiceOne.value == null) {
          //   return Center(
          //     child: Column(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: [
          //         const Icon(
          //           Icons.pending_actions,
          //           size: 64,
          //           color: primaryColor,
          //         ),
          //         const SizedBox(height: 16),
          //         Text(
          //           "Your profile is pending approval",
          //           style: TextStyle(
          //               fontSize: 18,
          //               fontWeight: FontWeight.w500,
          //               color: Colors.grey[800]),
          //         ),
          //         const SizedBox(height: 8),
          //         Text(
          //           "Please wait while we review your profile",
          //           style: TextStyle(color: Colors.grey[600]),
          //         ),
          //       ],
          //     ),
          //   );
          // }

          return RefreshIndicator(
            onRefresh: () async {
              await controller.getUserState();
            },
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      child: ClipOval(
                        child: controller.getServiceOne.value?.user.profileimage
                                    .isNotEmpty ==
                                true
                            ? CachedNetworkImage(
                                fit: BoxFit.cover,
                                width: 60,
                                height: 60,
                                imageUrl: controller
                                    .getServiceOne.value!.user.profileimage,
                                errorWidget: (context, e, b) =>
                                    _buildDefaultAvatar(),
                              )
                            : _buildDefaultAvatar(),
                      ),
                    ),
                    title: headingText(
                        text: controller.getServiceOne.value?.user.fullname ??
                            "Loading...",
                        fontSize: 24),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        customText(
                            text: controller.getServiceOne.value?.services
                                        .isNotEmpty ==
                                    true
                                ? controller.getServiceOne.value!.services.first
                                    .serviceName
                                : "No services added",
                            fontSize: 14),
                        RatingWidget(
                          maxRating: 5,
                          isRating: false,
                          initialRating:
                              controller.getServiceOne.value?.rate ?? 0,
                          onRatingChanged: (rating) {
                            print('Selected rating: $rating');
                          },
                        ),
                      ],
                    ),
                  ),
                  h10,
                  Container(
                    height: screenHeight(context) * 1,
                    decoration: const BoxDecoration(color: Colors.white),
                    child: Stack(
                      children: [
                        midStackContainer(context),
                        Positioned.fill(
                          top: screenHeight(context) * 0.13,
                          child: Container(
                            decoration: const BoxDecoration(
                              color: whiteColor,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(56),
                                topRight: Radius.circular(56),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 35, right: 35, top: 30),
                              child: Column(
                                children: [
                                  rowMainAxis(children: [
                                    dashboardContainer(
                                        onTap: () {
                                          Get.toNamed(kServiceRequestScreen);
                                        },
                                        title: "Service Requests",
                                        icon: FontAwesomeIcons.clipboardList),
                                    dashboardContainer(
                                        onTap: () {
                                          Get.toNamed(kCalendarScreen);
                                        },
                                        title: "Job calendar",
                                        icon: FontAwesomeIcons.calendar)
                                  ]),
                                  h20,
                                  rowMainAxis(children: [
                                    dashboardContainer(
                                        onTap: () {
                                          Get.toNamed(kRatingScreen);
                                        },
                                        title: "Rating & reviews",
                                        icon: FontAwesomeIcons.star),
                                    dashboardContainer(
                                      onTap: () {
                                        Get.to(() => const ChatListing(),
                                            transition: routeTransition);
                                      },
                                      title: "Messages",
                                      icon: FontAwesomeIcons.solidComments,
                                    ),
                                  ]),
                                  h20,
                                  rowMainAxis(children: [
                                    dashboardContainer(
                                        onTap: () {
                                          Get.toNamed(kMyServicesScreen);
                                        },
                                        title: "My services",
                                        icon: FontAwesomeIcons.briefcase),
                                    dashboardContainer(
                                        onTap: () {
                                          Get.toNamed(kAddServiceScreen);
                                        },
                                        title: "Add service",
                                        icon: FontAwesomeIcons.plus),
                                  ]),
                                  h20,
                                  rowMainAxis(children: [
                                    dashboardContainer(
                                        onTap: () {
                                          Get.toNamed(kMyFavouriteScreen);
                                        },
                                        title: "My Favourites",
                                        icon: FontAwesomeIcons.heart),
                                  ]),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget midStackContainer(context) {
    return Container(
      width: double.infinity,
      height: screenHeight(context) * 0.2,
      decoration: const BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(45),
          topRight: Radius.circular(45),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                dashboardSmallContainer(
                  context,
                  title: controller.getServiceOne.value?.totalJobs.toString() ??
                      "0",
                  subTitle: "Total",
                  thirdTitle: "Jobs",
                ),
                w25,
                dashboardSmallContainer(
                  context,
                  title:
                      controller.getServiceOne.value?.totalPrice.toString() ??
                          "0",
                  subTitle: "Total",
                  thirdTitle: "earning",
                ),
                w25,
                dashboardSmallContainer(
                  context,
                  title:
                      controller.getServiceOne.value?.totalService.toString() ??
                          "0",
                  subTitle: "Total",
                  thirdTitle: "services",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: primaryColor,
          width: 2,
        ),
      ),
      child: const Center(
        child: FaIcon(
          FontAwesomeIcons.user,
          size: 35,
          color: primaryColor,
        ),
      ),
    );
  }
}
