import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_app/models/authentication_model/intro_model.dart';
import 'package:property_app/route_management/constant_routes.dart';
import 'package:property_app/utils/shared_preferences/preferences.dart';
import 'package:property_app/views/authentication_screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../app_constants/app_icon.dart';
class OnBoardingScreenController extends GetxController{
  RxInt currentIndex = 0.obs;
  PageController? pageController;
  SharedPreferences? sp;


  List<IntroModel> introModelList = [
    IntroModel(AppIcons.intro1,
        "Purchase, trade, or lease a home, effortlessly find it",
        "Retrieve full state details"),
    IntroModel(AppIcons.intro2,
        "Choose a Residence that Aligns with Your Preferences", "A Variety of Choices"),
    IntroModel(AppIcons.intro3,
        "Experience Unmatched Contentment: Our Guarantee,Your Satisfaction", "Reliable and Assured"),
  ];

  initSP() async {
    sp = await SharedPreferences.getInstance();
  }

  gotoLang() {
    Preferences.setIntroSP(true);
    Get.toNamed(kLoginScreen);
  }

  @override
  void onInit() {
    pageController = PageController(initialPage: 0);
    initSP();
    super.onInit();
  }

  @override
  void onClose() {
    pageController!.dispose();
    super.onClose();
  }

}