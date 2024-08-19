import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_app/app_constants/theme.dart';
import 'package:property_app/controllers/authentication_controller/splash_screen_controller.dart';
import 'package:property_app/route_management/routes.dart';
import 'firebase_options.dart';
import 'route_management/constant_routes.dart';
import 'route_management/screen_bindings.dart';

// key id :  ZF877N5RJQ

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message)async {
  await Firebase.initializeApp();
}


void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
      theme: AppTheme.theme,
      builder: (_, child) => TextScaleFactorClamper(
        minTextScaleFactor: 1.0,
        maxTextScaleFactor: 1.0,
        child: child!
      ),
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

// MUX_TOKEN_ID=15d0fe63-213f-443d-abf1-847edde2b710
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

class TextScaleFactorClamper extends StatelessWidget {
  /// {@macro text_scale_factor_clamper}
  const TextScaleFactorClamper({
    super.key,
    required this.child,
    this.minTextScaleFactor,
    this.maxTextScaleFactor,
  }) : assert(
  minTextScaleFactor == null ||
      maxTextScaleFactor == null ||
      minTextScaleFactor <= maxTextScaleFactor,
  'minTextScaleFactor must be less than maxTextScaleFactor',
  ),
        assert(
        maxTextScaleFactor == null ||
            minTextScaleFactor == null ||
            maxTextScaleFactor >= minTextScaleFactor,
        'maxTextScaleFactor must be greater than minTextScaleFactor',
        );

  /// Child widget.
  final Widget child;

  /// Min text scale factor.
  final double? minTextScaleFactor;

  /// Max text scale factor.
  final double? maxTextScaleFactor;

  @override
  Widget build(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);

    final constrainedTextScaleFactor = mediaQueryData.textScaler.clamp(
      minScaleFactor: minTextScaleFactor ?? 1,
      maxScaleFactor: maxTextScaleFactor ?? 1.3,
    );

    return MediaQuery(
      data: mediaQueryData.copyWith(
        textScaler: constrainedTextScaleFactor,
      ),
      child: child,
    );
  }
}