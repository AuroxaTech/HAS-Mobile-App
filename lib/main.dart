import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_app/app_constants/color_constants.dart';
import 'package:property_app/app_constants/theme.dart';
import 'package:property_app/controllers/authentication_controller/splash_screen_controller.dart';
import 'package:property_app/route_management/routes.dart';
import 'package:property_app/services/notification_services/notification_services.dart';
import 'package:property_app/views/authentication_screens/splash_screen.dart';

import 'route_management/constant_routes.dart';
import 'route_management/screen_bindings.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message)async {
  await Firebase.initializeApp();
}


void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  Get.put(SplashScreenController());
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
  FirebaseAnalyticsObserver(analytics: analytics);
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: ScreenBindings(),
      initialRoute: kSplashScreen,
      navigatorObservers: <NavigatorObserver>[observer],
      getPages: Routes.getPages(),
      title: 'HAS',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme

    );
  }
}
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

//MUX_TOKEN_ID=15d0fe63-213f-443d-abf1-847edde2b710
// MUX_TOKEN_SECRET=gaHuGszH71j1pT210WIMa3OGSfWvqCXxSARBObQAeFeYOUG/qQr9R4AA+T36bUsV6Hzmky/YlHi


//  h25,
//                 Center(
//                   child: customText(
//                       text: "- or sign in with -",
//                       fontSize: 14
//                   ),
//                 ),
//                 h25,
//                 imageButton(
//                   image: AppIcons.google,
//                   text: "Sign in with google",
//                 ),
//                 h30,
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     customText(
//                         text: "Already have an account? ",
//                         fontSize: 14
//                     ),
//                     GestureDetector(
//                       onTap: (){
//                         Get.back();
//                       },
//                       child: headingText(
//                           text: "Login",
//                           color: primaryColor,
//                           fontSize: 14
//                       ),
//                     ),
//                   ],
//                 ),