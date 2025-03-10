import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:property_app/app_constants/animations.dart';
import 'package:property_app/app_constants/app_sizes.dart';
import 'package:property_app/app_constants/color_constants.dart';
import 'package:property_app/constant_widget/constant_widgets.dart';
import 'package:property_app/constant_widget/delete_widgets.dart';
import 'package:property_app/controllers/dasboard_controller/dashoard_controller.dart';
import 'package:property_app/models/stat_models/landlord_stat.dart';

import '../../constant_widget/drawer.dart';
import '../../route_management/constant_routes.dart';
import '../chat_screens/HomeScreen.dart';

class DashBoardScreen extends GetView<DashboardController> {
  const DashBoardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: controller.key,
      backgroundColor: whiteColor,
      appBar: homeAppBar(context,
          isBack: true,
          menuOnTap: () => controller.key.currentState!.openDrawer(),
          back: false),
      drawer: customDrawer(context, onDeleteAccount: () {
        deleteFunction(context, controller);
      }),
      body: SafeArea(
        child: Obx(
          () => RefreshIndicator(
            onRefresh: () async {
              controller.getLandLordState();
            },
            child: controller.getLandlord.value == null ||
                    controller.isLoading.value
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        ListTile(
                          leading: CircleAvatar(
                            radius: 30,
                            child: ClipOval(
                              child: CachedNetworkImage(
                                fit: BoxFit.cover,
                                width: 60,
                                height: 60,
                                imageUrl: controller.getLandlord.value!.landlord
                                    .user!.profileimage,
                                errorWidget: (context, e, b) {
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
                                },
                              ),
                            ),
                          ),
                          title: headingText(
                              text: controller.getLandlord.value!.landlord.user
                                      ?.fullname ??
                                  "",
                              fontSize: 24),
                          subtitle: customText(text: "Landlord", fontSize: 14),
                        ),
                        h10,
                        Container(
                          height: screenHeight(context) * 0.8,
                          decoration: const BoxDecoration(color: Colors.white),
                          child: Stack(
                            children: [
                              midStackContainer(
                                  context, controller.getLandlord.value!),
                              Positioned.fill(
                                top: screenHeight(context) * 0.13,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: whiteColor,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(45),
                                      topRight: Radius.circular(45),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 40, right: 40, top: 30),
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          rowMainAxis(children: [
                                            dashboardContainer(
                                                onTap: () {
                                                  Get.toNamed(kMyProperties);
                                                },
                                                title: "My properties",
                                                icon:
                                                    FontAwesomeIcons.building),
                                            dashboardContainer(
                                                onTap: () {
                                                  Get.toNamed(kAddProperties);
                                                },
                                                title: "Add property",
                                                icon:
                                                    FontAwesomeIcons.plusSquare)
                                          ]),
                                          h20,
                                          rowMainAxis(children: [
                                            dashboardContainer(
                                                title: "Messages",
                                                icon: FontAwesomeIcons
                                                    .solidComments,
                                                onTap: () {
                                                  Get.to(
                                                      () => const ChatListing(),
                                                      transition:
                                                          routeTransition);
                                                }),
                                            dashboardContainer(
                                                title: "Tenant",
                                                icon: FontAwesomeIcons.users,
                                                onTap: () {
                                                  Get.toNamed(
                                                      kContractStatusScreen);
                                                })
                                          ]),
                                          h20,
                                          rowMainAxis(children: [
                                            dashboardContainer(
                                                onTap: () {
                                                  Get.toNamed(
                                                      kMyServiceRequestScreen);
                                                },
                                                title: "Request service",
                                                icon: FontAwesomeIcons.wrench),
                                            dashboardContainer(
                                                onTap: () {
                                                  Get.toNamed(kJobScreen);
                                                },
                                                title: "Jobs",
                                                icon:
                                                    FontAwesomeIcons.briefcase),
                                          ]),
                                          h20,
                                          rowMainAxis(children: [
                                            dashboardContainer(
                                                onTap: () {
                                                  Get.toNamed(
                                                      kMyFavouriteScreen);
                                                },
                                                title: "MY Favourite",
                                                icon: FontAwesomeIcons.heart),
                                            w80,
                                          ]),
                                          h80,
                                          h80,
                                        ],
                                      ),
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
          ),
        ),
      ),
    );
  }

  Widget midStackContainer(context, LandLordData landlord) {
    return Container(
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
                  title: landlord.pendingContract.toString(),
                  subTitle: "Pending",
                  thirdTitle: "contracts",
                ),
                w25,
                dashboardSmallContainer(
                  context,
                  title: landlord.totalProperties.toString(),
                  subTitle: "Total",
                  thirdTitle: "properties",
                ),
                w25,
                dashboardSmallContainer(
                  context,
                  title: landlord.totalSpend.toString(),
                  subTitle: "Total",
                  thirdTitle: "spent",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
