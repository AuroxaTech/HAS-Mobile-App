import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:property_app/utils/shared_preferences/preferences.dart';

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

  static Future<void> dialog(BuildContext context)async{
    showDialog(context: context,
        builder: (context){
          return AlertDialog(
            surfaceTintColor: Colors.white,
            backgroundColor: Colors.white,
            title: const Text("Exit App"),
            content: const Text("Are you sure you want to exit the app?"),
            actions: [

              MaterialButton(onPressed: (){
                Navigator.pop(context);
              },
                color: Colors.red,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)
                ),
                child:  const Text("No", style: TextStyle(
                    color: Colors.white
                ),),
              ),

              MaterialButton(onPressed: ()async{
                 updateUserStatus(false);
                SystemChannels.platform.invokeMethod('SystemNavigator.pop');
              },
                color: greenColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)
                ),
                child:  const Text("Yes", style: TextStyle(
                    color: Colors.white
                ),),
              ),
            ],
          );
        });
  }
}

void updateUserStatus(bool isOnline) async{
  var userId = await Preferences.getUserID();
  if (userId != null) {
    FirebaseFirestore.instance.collection('users').doc(userId.toString()).update({
      'online': isOnline,
      'lastSeen': FieldValue.serverTimestamp(),
    });
    print(isOnline);
  }
}