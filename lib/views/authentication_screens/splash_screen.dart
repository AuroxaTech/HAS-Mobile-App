import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_app/app_constants/app_icon.dart';
import 'package:property_app/app_constants/app_sizes.dart';
import 'package:property_app/app_constants/color_constants.dart';
import 'package:property_app/constant_widget/constant_widgets.dart';
import 'package:property_app/controllers/authentication_controller/splash_screen_controller.dart';
import 'package:property_app/route_management/constant_routes.dart';

class SplashScreen extends GetView<SplashScreenController> {
  const SplashScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: SafeArea(
        child: InkWell(
          onTap: (){
            Get.toNamed(kIntroScreen);
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(child: Image.asset(AppIcons.appLogo)),
              h30,
              headingText(
                text: "RoyalRoost Properties",
                fontSize: 28,
                color: blackColor
              ),
              h20,
              customText(
                text: "Where Elegance Meets Exceptional Living",
                fontSize: 18,
                textAlign: TextAlign.center,
                color: blackColor
              ),
            ],
          ),
        ),
      ),
    );
  }

}




//   Container(
//                 height: 50,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(100),
//                   border: Border.all(
//                     color:  borderColor,
//                   ),
//                   color: tabMidColor
//                 ),
//                 child: Obx(() =>
//                    TabBar(
//                     indicatorColor: Colors.transparent,
//                     controller: controller.tabController.value,
//                     tabs: [
//                       Tab(
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             controller.tabController.value!.index == 1 ?   const CircleAvatar(
//                               backgroundColor: primaryColor,
//                               radius: 3,
//                             ) : const SizedBox(),
//                             customText(
//                               text: "House",
//                               fontSize: 14,
//                               color:   controller.tabController.value!.index == 1 ? blackColor : hintColor
//                             ),
//                           ],
//                         ),
//                       ),
//                        Tab(
//                          child: Column(
//                            mainAxisAlignment: MainAxisAlignment.center,
//                            children: [
//                              controller.tabController.value!.index == 2 ?   const CircleAvatar(
//                                backgroundColor: primaryColor,
//                                radius: 3,
//                              ) : const SizedBox(),
//                              customText(
//                                  text: "Second",
//                                  fontSize: 14,
//                                  color:   controller.tabController.value!.index == 2 ? blackColor : hintColor
//                              ),
//                            ],
//                          ),
//                       ),
//                       Tab(
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             controller.tabController.value!.index == 3 ?   const CircleAvatar(
//                               backgroundColor: primaryColor,
//                               radius: 3,
//                             ) : const SizedBox(),
//                             customText(
//                                 text: "Third",
//                                 fontSize: 14,
//                                 color:   controller.tabController.value!.index == 3 ? blackColor : hintColor
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               )