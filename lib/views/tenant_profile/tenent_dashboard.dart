import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_app/constant_widget/delete_widgets.dart';
import 'package:property_app/constant_widget/drawer.dart';
import 'package:property_app/controllers/tenant_controllers/tenant_dashboard_controller.dart';
import 'package:property_app/models/stat_models/tenant_stat.dart';
import '../../app_constants/animations.dart';
import '../../app_constants/app_icon.dart';
import '../../app_constants/app_sizes.dart';
import '../../app_constants/color_constants.dart';
import '../../constant_widget/constant_widgets.dart';
import '../../route_management/constant_routes.dart';
import '../../utils/api_urls.dart';
import '../chat_screens/HomeScreen.dart';

class TenantDashboard extends GetView<TenantDashboardController> {
  const TenantDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: controller.key,
      backgroundColor: whiteColor,
      appBar: homeAppBar(context,
          isBack: true,
          text: "Tenant Profile",
          menuOnTap: () => controller.key.currentState!.openDrawer(),
          back: false),
      drawer: providerDrawer(context, onDeleteAccount: () {
        deleteFunction(context, controller);
      }),
      body: SafeArea(
        child: Obx(
          () => RefreshIndicator(
            onRefresh: () async {
              await controller.getTenantState();
            },
            child: controller.getTenant.value == null ||
                    controller.isLoading.value
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    physics: bouncingScrollPhysic,
                    child: Column(
                      children: [
                        ListTile(
                          leading: CircleAvatar(
                            radius:
                                30, // This sets the size of the CircleAvatar
                            backgroundColor:
                                Colors.transparent, // Optional background color
                            child: ClipOval(
                              child: CachedNetworkImage(
                                fit: BoxFit.cover,
                                width:
                                    60, // Ensure these dimensions are sufficient to fill the CircleAvatar without stretching
                                height: 60,
                                imageUrl: AppUrls.profileImageBaseUrl +
                                    controller.getTenant.value!.tenant.user
                                        .profileimage,
                                errorWidget: (context, e, b) {
                                  return Image.asset(AppIcons.personIcon);
                                },
                              ),
                            ),
                          ),
                          title: headingText(
                              text: controller
                                  .getTenant.value!.tenant.user.fullname,
                              fontSize: 24),
                          subtitle: customText(
                            text: controller.getTenant.value!.tenant.occupation,
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
                                  context, controller.getTenant.value!),
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
                                        rowMainAxis(children: [
                                          dashboardContainer(
                                              onTap: () {
                                                Get.toNamed(
                                                    kTenantContractScreen);
                                              },
                                              title: "Contracts",
                                              image: AppIcons.tenant),
                                          dashboardContainer(
                                              onTap: () {
                                                Get.toNamed(
                                                    kCurrentRentedScreen);
                                              },
                                              title: "Current rented ",
                                              image: AppIcons.rentHouse),
                                        ]),
                                        h20,
                                        rowMainAxis(children: [
                                          dashboardContainer(
                                              title: "Messages",
                                              image: AppIcons.messages,
                                              onTap: () {
                                                Get.to(
                                                    () => const ChatListing(),
                                                    transition:
                                                        routeTransition);
                                              }),
                                          dashboardContainer(
                                              onTap: () {
                                                Get.toNamed(
                                                    kMyServiceRequestScreen);
                                              },
                                              title: "Request service",
                                              image: AppIcons.service),
                                        ]),
                                        h20,
                                        rowMainAxis(children: [
                                          dashboardContainer(
                                              onTap: () {
                                                Get.toNamed(kJobScreen);
                                              },
                                              title: "Jobs",
                                              image: AppIcons.job),
                                          dashboardContainer(
                                              onTap: () {
                                                Get.toNamed(kMyFavouriteScreen);
                                              },
                                              title: "MY Favourite",
                                              image: AppIcons.favourite),
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

  Widget midStackContainer(context, TenantData tenant) {
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
                  title: tenant.pendingContract.toString(),
                  subTitle: "Pending",
                  thirdTitle: "contracts",
                ),
                w25,
                dashboardSmallContainer(
                  context,
                  title: tenant.totalRented.toString(),
                  subTitle: "Total",
                  thirdTitle: "rented",
                ),
                w25,
                dashboardSmallContainer(
                  context,
                  title: tenant.totalSpend.toString(),
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
