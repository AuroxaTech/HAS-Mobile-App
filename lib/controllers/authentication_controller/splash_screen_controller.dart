import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:property_app/route_management/constant_routes.dart';
import 'package:property_app/utils/shared_preferences/preferences.dart';
import 'package:property_app/views/main_bottom_bar/main_bottom_bar.dart';
import 'package:property_app/views/main_bottom_bar/service_provider_bottom_ar.dart';
import 'package:property_app/views/main_bottom_bar/tenant_bottom_bar.dart';
import 'package:property_app/views/main_bottom_bar/visitor_bottom_bar.dart';

class SplashScreenController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    goto();
  }

  // goto() async {
  //   // 1 landlord
  //   // 2 tenant
  //   // 3 service
  //   // 4 visitor
  //   bool isCheck = await Preferences.getIntroSP() ?? false;
  //   var token = await Preferences.getToken();
  //   //var roleId = await Preferences.getRoleID();
  //   var role = await Preferences.getRoleID();
  //   var userId = await Preferences.getUserID();
  //   print("Check Intro $isCheck");
  //   print("Token  $token");
  //   print("Role ID $role");
  //   print("User ID $userId");
  //   await Future.delayed(const Duration(seconds: 3), () {
  //     if (isCheck == true) {
  //       if (token != null) {
  //         if (role == "1") {
  //           Get.offAll(const MainBottomBar());
  //         } else if (role == "2") {
  //           Get.offAll(const TenantBottomBar());
  //         } else if (role == "3") {
  //           Get.offAll(const ServiceProviderBottomBar());
  //         } else if (role == "4") {
  //           Get.offAll(const VisitorBottomBar());
  //         } else {
  //           Get.offNamed(kLoginScreen);
  //         }
  //       } else {
  //         Get.offNamed(kLoginScreen);
  //       }
  //       // if (token != null) {
  //       //   if (role == "landlord") {
  //       //     Get.offAll(const MainBottomBar());
  //       //   } else if (role == "tenant") {
  //       //     Get.offAll(const TenantBottomBar());
  //       //   } else if (role == "service_provider") {
  //       //     Get.offAll(const ServiceProviderBottomBar());
  //       //   } else if (role == "visitor") {
  //       //     Get.offAll(const VisitorBottomBar());
  //       //   } else {}
  //       // } else {
  //       //   Get.offNamed(kLoginScreen);
  //       // }
  //     } else {
  //       Get.offNamed(kIntroScreen);
  //     }
  //   });
  //
  //
  //   final LocalAuthentication auth = LocalAuthentication();
  //   //  try {
  //   final bool didAuthenticate = await auth.authenticate(
  //     /*authMessages: [
  //             AndroidAuthMessages(
  //               signInTitle: 'Oops! Biometric authentication required!',
  //               cancelButton: 'No thanks',
  //             ),
  //
  //             IOSAuthMessages(
  //               cancelButton: 'No thanks',
  //             ),
  //           ],*/
  //       localizedReason: 'Please authenticate to login account',
  //       options: const AuthenticationOptions(
  //           useErrorDialogs: true, biometricOnly: true));
  //   if (didAuthenticate) {
  //
  //   }else{
  //     //Utils.pushTo(context, const SetUserNamePage());
  //   }
  // }

  goto() async {
    bool isCheck = await Preferences.getIntroSP() ?? false;
    var token = await Preferences.getToken();
    var role = await Preferences.getRoleID();
    var userId = await Preferences.getUserID();
    bool isBiometricEnabled = await Preferences.getBiometricEnabled() ?? false;

    print("Check Intro $isCheck");
    print("Token  $token");
    print("Role ID $role");
    print("User ID $userId");
    print("Biometric Enabled: $isBiometricEnabled");

    if (!isCheck) {
      Get.offNamed(kIntroScreen);
      return;
    }

    bool? userData = await Preferences.getBiometricEnabled();

    print("user data ${userData}");
    if(userData == true){
      // Get.offAllNamed(kLoginScreen);
    }else{
      if (token == null) {
        Get.offNamed(kLoginScreen);
        return;
      }
    }


    if (isBiometricEnabled) {
      final LocalAuthentication auth = LocalAuthentication();
      final bool didAuthenticate = await auth.authenticate(
        localizedReason: 'Please authenticate to access your account',
        options: const AuthenticationOptions(
            useErrorDialogs: true, biometricOnly: true),
      );

      if (!didAuthenticate) {
        Get.offNamed(kLoginScreen);
        return;
      }
    }

    switch (role) {
      case "1":
        Get.offAll(const MainBottomBar());
        break;
      case "2":
        Get.offAll(const TenantBottomBar());
        break;
      case "3":
        Get.offAll(const ServiceProviderBottomBar());
        break;
      case "4":
        Get.offAll(const VisitorBottomBar());
        break;
      default:
        Get.offNamed(kLoginScreen);
    }
  }

  @override
  void onReady() {
    super.onReady();
    goto();
  }

  @override
  void onClose() {
    print("close");
    super.onClose();
  }
}
