import 'package:get/get.dart';
import 'package:property_app/route_management/constant_routes.dart';
import 'package:property_app/utils/shared_preferences/preferences.dart';
import 'package:property_app/views/authentication_screens/login_screen.dart';
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


  goto() async {
    // 1 landlord
    // 2 tenant
    // 3 service
    // 4 visitor
    bool isCheck = await Preferences.getIntroSP() ?? false;
    var token = await Preferences.getToken();
    var roleId = await Preferences.getRoleID();
    print("Check Intro $isCheck");
    print("Token  $token");
    print("Role ID $roleId");
    await Future.delayed(const Duration(seconds: 3), (){
     if(isCheck == true){
        if(token != null){
          if(roleId == 1){
            Get.offAll(const MainBottomBar());
          }else if(roleId == 2){
            Get.offAll(const TenantBottomBar());
          }else if(roleId == 3){
            Get.offAll(const ServiceProviderBottomBar());
          }else if(roleId == 4){
            Get.offAll(const VisitorBottomBar());
          }else{

          }
        }else{
          Get.offNamed(kLoginScreen);
        }
     }else{
       Get.offNamed(kIntroScreen);
     }
    });
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