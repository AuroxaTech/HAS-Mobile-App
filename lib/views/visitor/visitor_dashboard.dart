import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:property_app/constant_widget/delete_widgets.dart';
import 'package:property_app/constant_widget/drawer.dart';
import 'package:property_app/models/stat_models/visitor_stat.dart';

import '../../app_constants/animations.dart';
import '../../app_constants/app_sizes.dart';
import '../../app_constants/color_constants.dart';
import '../../constant_widget/constant_widgets.dart';
import '../../controllers/visitor_controllers/visitor_dashboard_controller.dart';
import '../../route_management/constant_routes.dart';
import '../chat_screens/HomeScreen.dart';

class VisitorDashBoard extends GetView<VisitorDashboardController> {
  const VisitorDashBoard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: controller.key,
      backgroundColor: whiteColor,
      appBar: homeAppBar(context,
          isBack: true,
          text: "Visitor Profile",
          menuOnTap: () => controller.key.currentState!.openDrawer(),
          back: false),
      drawer: providerDrawer(context, onDeleteAccount: () {
        deleteFunction(context, controller);
      }),
      body: SafeArea(
        child: Obx(
          () => RefreshIndicator(
            onRefresh: () async {
              controller.getVisitorState();
            },
            child: controller.getVisitor.value == null ||
                    controller.isLoading.value
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    physics: bouncingScrollPhysic,
                    child: Column(
                      children: [
                        ListTile(
                          leading: CircleAvatar(
                            radius: 30,
                            child: ClipOval(
                              child: controller.getVisitor.value?.visitor
                                          .profileimage.isNotEmpty ==
                                      true
                                  ? CachedNetworkImage(
                                      fit: BoxFit.cover,
                                      width: 60,
                                      height: 60,
                                      imageUrl: controller.getVisitor.value!
                                          .visitor.profileimage,
                                      errorWidget: (context, e, b) =>
                                          _buildDefaultAvatar(),
                                    )
                                  : _buildDefaultAvatar(),
                            ),
                          ),
                          title: headingText(
                              text: controller
                                      .getVisitor.value?.visitor.fullname ??
                                  "Loading...",
                              fontSize: 24),
                          subtitle: customText(
                            text: "Visitor",
                            fontSize: 14,
                          ),
                        ),
                        h10,
                        Container(
                          height: screenHeight(context) * 0.8,
                          decoration: const BoxDecoration(color: Colors.white),
                          child: Stack(
                            children: [
                              midStackContainer(
                                  context, controller.getVisitor.value!),
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
                                        left: 40, right: 40, top: 30),
                                    child: Column(
                                      children: [
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
                                              title: "Request service",
                                              icon: FontAwesomeIcons.bell,
                                              onTap: () {
                                                Get.toNamed(
                                                    kMyServiceRequestScreen);
                                              }),
                                        ]),
                                        h20,
                                        rowMainAxis(children: [
                                          dashboardContainer(
                                              title: "Jobs",
                                              icon: FontAwesomeIcons.briefcase,
                                              onTap: () {
                                                Get.toNamed(kJobScreen);
                                              }),
                                          dashboardContainer(
                                              title: "MY Favourite",
                                              icon: FontAwesomeIcons.heart,
                                              onTap: () {
                                                Get.toNamed(kMyFavouriteScreen);
                                              }),
                                        ]),
                                        h20,
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
          ),
        ),
      ),
    );
  }

  Widget midStackContainer(context, VisitorData visitorData) {
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
                  title: visitorData.pendingJob.toString(),
                  subTitle: "Pending",
                  thirdTitle: "Jobs",
                ),
                w25,
                dashboardSmallContainer(
                  context,
                  title: visitorData.totalSpend,
                  subTitle: "Total",
                  thirdTitle: "Spent",
                ),
                w25,
                dashboardSmallContainer(
                  context,
                  title: visitorData.totalFavorite.toString(),
                  subTitle: "Total",
                  thirdTitle: "favorites",
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
