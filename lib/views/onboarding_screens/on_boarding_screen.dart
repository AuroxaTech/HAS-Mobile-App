import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_app/app_constants/app_sizes.dart';
import 'package:property_app/app_constants/color_constants.dart';
import 'package:property_app/constant_widget/constant_widgets.dart';
import 'package:property_app/controllers/authentication_controller/on_boarding_screen_controller.dart';

import '../../app_constants/animations.dart';
import 'onboarding_pages.dart';

class OnBoardingScreen extends GetView<OnBoardingScreenController> {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: Obx(
        () => Padding(
          padding: const EdgeInsets.all(15.0),
          child: Stack(
            children: [
              PageView.builder(
                  controller: controller.pageController,
                  onPageChanged: (value) {
                    controller.currentIndex.value = value;
                  },
                  itemCount: controller.introModelList.length,
                  itemBuilder: (context, index) {
                    return PageBuilderWidget(
                        title: controller.introModelList[index].title,
                        description:
                            controller.introModelList[index].description,
                        imageUrl: controller.introModelList[index].image);
                  }),

              Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.18,

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            controller.introModelList.length,
                            (index) => buildDot(index: index),
                          ),
                        ),

                        h30,
                        controller.currentIndex.value <
                                controller.introModelList.length - 1
                            ? Container(
                                margin: const EdgeInsets.only(top: 25),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: (){
                                        controller.gotoLang();
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(color: greyColor),
                                          borderRadius: BorderRadius.circular(45),
                                        ),
                                        padding: const EdgeInsets.only(
                                            top: 3,
                                            bottom: 3,
                                            right: 20,
                                            left: 20),
                                        child: customText(
                                            text: "Skip",
                                            fontWeight: FontWeight.w300,
                                            fontSize: 20),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: (){
                                        controller.pageController!.nextPage(duration: const Duration(microseconds: 300), curve: Curves.easeInOut);
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          gradient: gradient(),
                                          borderRadius: BorderRadius.circular(45),
                                        ),
                                        padding: const EdgeInsets.only(
                                            top: 4,
                                            bottom: 4,
                                            right: 20,
                                            left: 20),
                                        child: customText(
                                            text: "Next",
                                            fontWeight: FontWeight.w300,
                                            fontSize: 20,
                                            color: whiteColor),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.only(top: 25),
                                child: GestureDetector(
                                  onTap: (){
                                    controller.gotoLang();
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: gradient(),
                                      borderRadius: BorderRadius.circular(45),
                                    ),
                                    padding: const EdgeInsets.only(
                                        top: 5, bottom: 5, right: 25, left: 25),
                                    child: customText(
                                        text: "Get Started",
                                        fontWeight: FontWeight.w300,
                                        fontSize: 20,
                                        color: whiteColor),
                                  ),
                                ),
                              ),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  AnimatedContainer buildDot({int? index}) {
    return AnimatedContainer(
      duration: kAnimationDuration,
      margin: const EdgeInsets.only(right: 5),
      height: 6,
      width: controller.currentIndex.value == index ? 20 : 6,
      decoration: BoxDecoration(
        color: controller.currentIndex.value == index
            ? const Color(0xFF3784EE)
            : const Color(0xFFD8D8D8),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}
