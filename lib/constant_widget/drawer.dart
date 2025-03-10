import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:property_app/app_constants/animations.dart';
import 'package:property_app/app_constants/app_icon.dart';
import 'package:property_app/route_management/constant_routes.dart';
import 'package:property_app/utils/shared_preferences/preferences.dart';
import 'package:property_app/views/settings/privacy_policy.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../app_constants/color_constants.dart';
import 'constant_widgets.dart';

Widget customDrawer(context, {VoidCallback? onDeleteAccount}) {
  return Drawer(
      child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.only(left: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 130,
              child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Image.asset(
                    AppIcons.appLogo,
                    height: 80,
                  )),
            ),
            const SizedBox(
              height: 10,
            ),
            customText(
              text: "HAS Property",
              fontSize: 22,
              color: primaryColor,
              fontWeight: FontWeight.w600,
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
      const Divider(
        height: 2,
      ),
      const SizedBox(
        height: 10,
      ),

      // ListTile(
      //   onTap: () {
      //  //   shareToFacebook(snapshot.data["shareToFacebook"]);
      //   },
      //   leading: const Icon(Icons.share),
      //   title: customText(text: "Share to facebook"),
      // ),
      // ListTile(
      //   onTap: () async {
      //     // final InAppReview inAppReview = InAppReview.instance;
      //     // if (await inAppReview.isAvailable()) {
      //     //   inAppReview.requestReview();
      //     // } else {
      //     //   Fluttertoast.showToast(
      //     //       msg: "App not available on playstore");
      //     // }
      //   },
      //   leading: const Icon(Icons.star),
      //   title: customText(text: "Rate a review"),
      // ),
      // ListTile(
      // //  onTap: () => openEmailApp(snapshot.data["contactDeveloper"]),
      //   leading: const Icon(Icons.contact_support_outlined),
      //   title: customText(
      //     text: "Contact the developers",
      //   ),
      // ),

      ListTile(
        onTap: () {
          Get.back();
          Get.toNamed(kPaymentScreen);
        },
        leading: const Icon(
          Icons.wallet,
          color: primaryColor,
        ),
        title: customText(
          text: "Payments",
        ),
      ),
      ListTile(
        onTap: () {
          Get.back();
          Get.toNamed(kProfileSettingScreen);
          //  Navigator.push(context, customPageRoute(const AboutScreen()));
        },
        leading: const Icon(
          Icons.settings,
          color: primaryColor,
        ),
        title: customText(
          text: "Settings",
        ),
      ),
      ListTile(
        onTap: () {
          Navigator.pop(context);
          Get.toNamed(kContractStatusScreen);
          //  Navigator.push(context, customPageRoute(const AboutScreen()));
        },
        leading: const Icon(
          Icons.file_copy,
          color: primaryColor,
        ),
        title: customText(
          text: "Contracts",
        ),
      ),
      ListTile(
        onTap: () {
          Navigator.pop(context);
          Get.toNamed(kChangePasswordScreen);
          //  Navigator.push(context, customPageRoute(const AboutScreen()));
        },
        leading: const Icon(
          Icons.password,
          color: primaryColor,
        ),
        title: customText(
          text: "Change Password",
        ),
      ),

      ListTile(
        onTap: () {
          Navigator.pop(context);
          //  Get.toNamed(kChangePasswordScreen);
          Get.to(() => const PrivacyPolicy(), transition: routeTransition);
        },
        leading: const Icon(
          Icons.info_outline,
          color: primaryColor,
        ),
        title: customText(
          text: "Privacy Policy",
        ),
      ),

      ListTile(
        onTap: onDeleteAccount,
        leading: const Icon(
          Icons.delete_rounded,
          color: primaryColor,
        ),
        title: customText(
          text: "Delete Account",
        ),
      ),
      ListTile(
        onTap: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Container(
                    decoration: const BoxDecoration(),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Lottie.asset(
                          AppIcons.logoutAnimation,
                          width: 200,
                          height: 100,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        customText(
                            text: "Are you sure want to logout?",
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                            textAlign: TextAlign.center),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            MaterialButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  side: const BorderSide(color: Colors.black)),
                              child: customText(
                                text: "Cancel",
                              ),
                            ),
                            MaterialButton(
                              onPressed: () async {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                await updateUserStatus(false);
                                await prefs.remove("token");
                                await prefs.remove("role_id");
                                await prefs.remove("user_id").then((value) {
                                  Get.offAllNamed(kLoginScreen);
                                });
                                // prefs.clear().then((value) {
                                // });
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  side: const BorderSide(color: Colors.black)),
                              child: customText(
                                text: "Yes",
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              });
        },
        leading: const Icon(
          Icons.logout,
          color: primaryColor,
        ),
        title: customText(
          text: "Logout",
        ),
      ),
      const SizedBox(
        height: 50,
      ),
      Center(
        child: customText(text: "version : 1.0.0+1"),
      )
    ],
  ));
}

updateUserStatus(bool isOnline) async {
  var userId = await Preferences.getUserID();
  if (userId != null) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId.toString())
        .update({
      'online': isOnline,
      'lastSeen': FieldValue.serverTimestamp(),
    });
    print(isOnline);
  }
}

Widget providerDrawer(context, {VoidCallback? onDeleteAccount}) {
  return Drawer(
      child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.only(left: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 130,
              child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Image.asset(
                    AppIcons.appLogo,
                    height: 80,
                  )),
            ),
            const SizedBox(
              height: 10,
            ),
            customText(
              text: "HAS Property",
              fontSize: 22,
              color: primaryColor,
              fontWeight: FontWeight.w600,
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
      const Divider(
        height: 2,
      ),
      const SizedBox(
        height: 10,
      ),

      // ListTile(
      //   onTap: () {
      //  //   shareToFacebook(snapshot.data["shareToFacebook"]);
      //   },
      //   leading: const Icon(Icons.share),
      //   title: customText(text: "Share to facebook"),
      // ),
      // ListTile(
      //   onTap: () async {
      //     // final InAppReview inAppReview = InAppReview.instance;
      //     // if (await inAppReview.isAvailable()) {
      //     //   inAppReview.requestReview();
      //     // } else {
      //     //   Fluttertoast.showToast(
      //     //       msg: "App not available on playstore");
      //     // }
      //   },
      //   leading: const Icon(Icons.star),
      //   title: customText(text: "Rate a review"),
      // ),
      // ListTile(
      // //  onTap: () => openEmailApp(snapshot.data["contactDeveloper"]),
      //   leading: const Icon(Icons.contact_support_outlined),
      //   title: customText(
      //     text: "Contact the developers",
      //   ),
      // ),

      ListTile(
        onTap: () {
          Navigator.pop(context);
          Get.toNamed(kPaymentScreen);
        },
        leading: const Icon(
          Icons.wallet,
          color: primaryColor,
        ),
        title: customText(
          text: "Payments",
        ),
      ),
      ListTile(
        onTap: () {
          Navigator.pop(context);
          Get.toNamed(kProfileSettingScreen);
          //  Navigator.push(context, customPageRoute(const AboutScreen()));
        },
        leading: const Icon(
          Icons.settings,
          color: primaryColor,
        ),
        title: customText(
          text: "Settings",
        ),
      ),
      ListTile(
        onTap: () {
          Navigator.pop(context);
          Get.toNamed(kChangePasswordScreen);
          //  Navigator.push(context, customPageRoute(const AboutScreen()));
        },
        leading: const Icon(
          Icons.password,
          color: primaryColor,
        ),
        title: customText(
          text: "Change Password",
        ),
      ),
      ListTile(
        onTap: () {
          Navigator.pop(context);
          //  Get.toNamed(kChangePasswordScreen);
          Get.to(() => const PrivacyPolicy(), transition: routeTransition);
        },
        leading: const Icon(
          Icons.info_outline,
          color: primaryColor,
        ),
        title: customText(
          text: "Privacy Policy",
        ),
      ),
      ListTile(
        onTap: onDeleteAccount,
        leading: const Icon(
          Icons.delete_rounded,
          color: primaryColor,
        ),
        title: customText(
          text: "Delete Account",
        ),
      ),
      ListTile(
        onTap: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Container(
                    decoration: const BoxDecoration(),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Lottie.asset(
                          AppIcons.logoutAnimation,
                          width: 200,
                          height: 100,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        customText(
                            text: "Are you sure want to logout?",
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                            textAlign: TextAlign.center),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            MaterialButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  side: const BorderSide(color: Colors.black)),
                              child: customText(
                                text: "Cancel",
                              ),
                            ),
                            MaterialButton(
                              onPressed: () async {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                await updateUserStatus(false);
                                await prefs.remove("token");
                                await prefs.remove("role");
                                await prefs.remove("user_id").then((value) {
                                  Get.offAllNamed(kLoginScreen);
                                });
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  side: const BorderSide(color: Colors.black)),
                              child: customText(
                                text: "Yes",
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              });
        },
        leading: const Icon(
          Icons.logout,
          color: primaryColor,
        ),
        title: customText(
          text: "Logout",
        ),
      ),
      const SizedBox(
        height: 50,
      ),
      Center(
        child: customText(text: "version : 1.0.0+1"),
      )
    ],
  ));
}
