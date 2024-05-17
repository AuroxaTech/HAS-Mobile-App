import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_app/constant_widget/drawer.dart';
import 'package:property_app/controllers/services_provider_controller/service_provide_controller.dart';
import 'package:property_app/controllers/tenant_controllers/tenant_dashboard_controller.dart';
import 'package:property_app/utils/api_urls.dart';
import 'package:property_app/views/service_provider/rate_experience.dart';
import 'package:property_app/views/service_provider/rating_screen.dart';

import '../../app_constants/animations.dart';
import '../../app_constants/app_icon.dart';
import '../../app_constants/app_sizes.dart';
import '../../app_constants/color_constants.dart';
import '../../constant_widget/constant_widgets.dart';
import '../../route_management/constant_routes.dart';
import '../main_bottom_bar/service_provider_bottom_ar.dart';

class ServiceProviderScreen extends GetView<ServiceProviderController> {
  ServiceProviderScreen({Key? key}) : super(key: key);
  @override
  final controller = Get.put(ServiceProviderController());
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: controller.key,

      backgroundColor: whiteColor,
      appBar: homeAppBar(context, text: "Service Provider", showNotification: true, isBack: true,
        menuOnTap:  () => controller.key.currentState!.openDrawer(), back: false
      ),
      drawer: providerDrawer(context),
      body: SafeArea(
        child: Obx(() => controller.getServiceOne.value == null || controller.isLoading.value ?
        const Center(child: CircularProgressIndicator())  :
           RefreshIndicator(
             onRefresh: ()async{
               controller.getUserState();
             },
             child: SingleChildScrollView(
              //physics: bouncingScrollPhysic,
              child:   Column(
                  children: [
                    ListTile(
                      leading:  CircleAvatar(
                        radius: 30,
                        child: ClipOval(
                          child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            width: 60,  // Ensure these dimensions are sufficient to fill the CircleAvatar without stretching
                            height: 60,
                            imageUrl: AppUrls.servicesImages +  controller.getServiceOne.value!.serviceprovider.user.profileimage,
                            errorWidget: (context, e ,b) {
                              return Image.asset(AppIcons.personIcon);
                            },
                          ),
                        ),
                      ),
                      title: headingText(
                          text:controller.getServiceOne.value == null ? "User" : controller.getServiceOne.value!.serviceprovider.user.fullname,
                          fontSize: 24
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          customText(
                              text: controller.getServiceOne.value == null ? "Other" : controller.getServiceOne.value!.serviceprovider.providerService.name,
                              fontSize: 14
                          ),
                          RatingWidget(
                            maxRating: 5,
                            isRating: false,
                            initialRating: controller.getServiceOne.value == null ? 0 : controller.getServiceOne.value!.rate.toInt(),
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
                      decoration: const BoxDecoration(
                          color: Colors.white
                      ),
                      child: Stack(
                        children: [
                          midStackContainer(context),
                          Positioned.fill(
                            top:screenHeight(context) * 0.13,
                            child: Container(
                              decoration: const BoxDecoration(
                                color: whiteColor,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(56),
                                  topRight: Radius.circular(56),
                                ),
                              ),
                              child:  Padding(
                                padding: const EdgeInsets.only(left: 40, right: 40, top: 30),
                                child: Column(
                                  children: [
                                    rowMainAxis(
                                        children: [
                                          dashboardContainer(
                                              onTap: (){
                                                Get.toNamed(kServiceRequestScreen);
                                              },
                                              title: "Service Requests",
                                              image: AppIcons.tenant
                                          ),
                                          dashboardContainer(
                                              onTap: (){
                                                Get.toNamed(kCalendarScreen);
                                              },
                                              title: "Job calendar",
                                              image: AppIcons.calendar
                                          )
                                        ]
                                    ),
                                    h20,
                                    rowMainAxis(
                                        children: [
                                          // dashboardContainer(
                                          //   onTap: (){
                                          //     Get.toNamed(kCreateOfferScreen);
                                          //   },
                                          //   title: "Create offer",
                                          //   image: AppIcons.createOffer,
                                          // ),
                                          dashboardContainer(
                                            onTap: (){
                                              Get.toNamed(kRatingScreen);
                                            },
                                              title: "Rating & reviews",
                                              image: AppIcons.rating
                                          ),
                                          dashboardContainer(
                                            onTap: (){
                                              Get.toNamed(kRateExperienceScreen);

                                            },
                                            title: "Messages",
                                            image: AppIcons.messages,
                                          ),
                                        ]
                                    ),
                                    h20,
                                    rowMainAxis(
                                        children: [

                                          dashboardContainer(
                                            onTap: (){
                                              Get.toNamed(kMyServicesScreen);
                                            },
                                              title: "My services",
                                              image: AppIcons.myServices
                                          ),
                                          dashboardContainer(
                                              onTap: (){
                                                Get.toNamed(kAddServiceScreen);
                                              },
                                              title: "Add service",
                                              image: AppIcons.addServices
                                          ),
                                        ]
                                    ),
                                    h20,
                                    rowMainAxis(
                                        children: [


                                          dashboardContainer(
                                              onTap: (){
                                                Get.toNamed(kMyFavouriteScreen);
                                              },
                                              title: "My Favourites",
                                              image: AppIcons.favourite
                                          ),

                                        ]
                                    ),
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


  Widget midStackContainer(context){
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
                  title:  controller.getServiceOne.value == null ? "0" :  controller.getServiceOne.value!.totalJobs.toString(),
                  subTitle: "Total",
                  thirdTitle: "Jobs",
                ),
                w25,
                dashboardSmallContainer(
                  context,
                  title: controller.getServiceOne.value == null ? "0" : controller.getServiceOne.value!.totalPrice.toString(),
                  subTitle: "Total",
                  thirdTitle: "earning",
                ),
                w25,
                dashboardSmallContainer(
                  context,
                  title: controller.getServiceOne.value == null ? "0" : controller.getServiceOne.value!.totalService.toString(),
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
}
