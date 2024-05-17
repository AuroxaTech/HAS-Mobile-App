import 'package:cached_network_image/cached_network_image.dart';
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
import '../../controllers/services_provider_controller/my_service_screen_controller.dart';
import '../../custom_widgets/custom_button.dart';
import '../../route_management/constant_routes.dart';
import '../../utils/api_urls.dart';

class CalendarDetailScreen extends GetView<CalendarDetailController> {
  const CalendarDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(() =>
        controller.isLoading.value ?
        const Center(child: CircularProgressIndicator()) :
        Stack(
          children: [
            PageView.builder(
              itemCount: controller.images.length,
              scrollDirection: Axis.horizontal,
              controller: controller.pageController,
              itemBuilder: (context, index){
                String imagesString = controller.getCalendarOne.value!.request.service!.media.toString();
                List<String> imageList = imagesString.split(',');
                controller.images = imageList;
                return InkWell(
                  onTap: (){
                    Get.to(() => ViewImage(photo: AppUrls.mediaImages + imageList[0],), transition: routeTransition);
                  },
                  child: CachedNetworkImage(
                    width: double.infinity,
                    height: screenHeight(context) * 0.5,
                    imageUrl: AppUrls.mediaImages + imageList[0] ,
                    fit: BoxFit.cover,
                    errorWidget: (context, e , b){
                      return Image.asset(AppIcons.appLogo);
                    },
                  ),
                );
              },
            ),



            Positioned(child:   Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: (){
                      Get.back();
                    },
                    child: CircleAvatar(
                      backgroundColor: whiteColor,
                      child: SvgPicture.asset(AppIcons.backIcon),
                    ),
                  ),
                  // InkWell(
                  //   onTap: (){
                  //     //Get.toNamed(kEditPropertyScreen);
                  //   },
                  //   child: CircleAvatar(
                  //     backgroundColor: whiteColor,
                  //     child: SvgPicture.asset(AppIcons.editIcon),
                  //   ),
                  // )
                ],
              ),
            ),),
            Positioned(child:  Padding(
              padding: const EdgeInsets.only(top: 290.0),
              child: Align(
                alignment: Alignment.topCenter,
                child: SmoothPageIndicator(
                  controller: controller.pageController, // Connect the indicator to the controller
                  count: controller.images.length,
                  effect: const WormEffect(
                      dotColor: whiteColor,
                      dotHeight: 10,
                      dotWidth: 10
                  ), // Feel free to choose any effect
                ),
              ),
            ),),
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
    return LayoutBuilder(
        builder: (context, constraints) {
          return  DraggableScrollableSheet(
            key: controller.sheet,
            initialChildSize: 0.5,
            maxChildSize: 0.5,      // Set maxChildSize to the same value (0.5)
            minChildSize: 0.5,
            // expand: true,
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
                        children:  [
                          Padding(
                            padding: EdgeInsets.only(
                                bottom: MediaQuery.of(context).viewInsets.bottom, left: 10, right: 10),
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
                                            text: controller.getCalendarOne.value!.request.additionalInfo,
                                            fontSize: 24,
                                          ),
                                        ),
                                        h15,
                                        Padding(
                                          padding: const EdgeInsets.only(left: 20, right: 20),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      customText(
                                                          text: "Client Name :",
                                                          color: greyColor,
                                                          fontSize: 15
                                                      ),
                                                      customText(
                                                          text: controller.getCalendarOne.value!.provider.fullname,
                                                          color: blackColor,
                                                          fontSize: 16
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      customText(
                                                          text: "Contact Details :",
                                                          color: greyColor,
                                                          fontSize: 15
                                                      ),
                                                      customText(
                                                          text: controller.getCalendarOne.value!.provider.email,
                                                          color: blackColor,
                                                          fontSize: 16
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              h5,
                                              customText(
                                                  text: "Description :",
                                                  color: greyColor,
                                                  fontSize: 15
                                              ),
                                              h5,
                                              customText(
                                                  text: controller.getCalendarOne.value!.request.description,
                                                  color: blackColor,
                                                  fontSize: 14
                                              ),
                                              h5,
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Image.asset(AppIcons.clockDuration, width: 20, height: 20,),
                                                      customText(
                                                          text: " Duration  hour",
                                                          color: greyColor,
                                                          fontSize: 14
                                                      ) ,
                                                    ],
                                                  ),
                                                  customText(
                                                      text: "\$${controller.getCalendarOne.value!.request.price}",
                                                      color: blackColor,
                                                      fontSize: 18
                                                  ),
                                                ],
                                              ),

                                              h5,
                                              Row(
                                                children: [
                                                  Image.asset(AppIcons.serviceArea, width: 20, height: 20,),
                                                  customText(
                                                      text: " Service Area : ${controller.getCalendarOne.value!.request.description}",
                                                      color: greyColor,
                                                      fontSize: 15
                                                  ) ,
                                                ],
                                              ),

                                            ],
                                          ),
                                        ) ,
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
                                        onTap: (){
                                          Get.toNamed(kChatConversionScreen);
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
        }
    );
  }
}