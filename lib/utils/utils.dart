import 'dart:ui';

import 'package:get/get.dart';

import '../app_constants/color_constants.dart';

class AppUtils{
  static void getSnackBarNoInternet(){
    Get.snackbar("No Internet", "Please Connect to Internet",
        colorText: whiteColor,
        backgroundColor: const Color(0xffFF6B72),
        duration: const Duration(seconds: 1));
  }

  static void getSnackBar(String title, String message, {Color? backgroundColor}){
    Get.snackbar(title, message,
        colorText: whiteColor,
        backgroundColor: const Color(0xff04D182),
        duration: const Duration(seconds: 3));
  }

  static void errorSnackBar(String title, String message, {Color? backgroundColor}){
    Get.snackbar(title, message,
        colorText: whiteColor,
        backgroundColor: const Color(0xffFF6B72),
        duration: const Duration(seconds: 3));
  }

}