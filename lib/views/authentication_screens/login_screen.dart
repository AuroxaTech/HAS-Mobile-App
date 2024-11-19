import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_app/app_constants/app_icon.dart';
import 'package:property_app/app_constants/app_sizes.dart';
import 'package:property_app/app_constants/color_constants.dart';
import 'package:property_app/constant_widget/constant_widgets.dart';
import 'package:property_app/controllers/authentication_controller/login_screen_controller.dart';
import 'package:property_app/custom_widgets/custom_button.dart';
import 'package:property_app/custom_widgets/custom_text_field.dart';

import '../../app_constants/animations.dart';
import '../../route_management/constant_routes.dart';

class LoginScreen extends GetView<LoginScreenController> {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            physics: bouncingScrollPhysic,
            child: Obx(
              () => Form(
                key: controller.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    h50,
                    Center(child: Image.asset(AppIcons.homeImage)),
                    h30,
                    Center(
                        child: headingText(
                            text: "Access Your Account", fontSize: 28)),
                    h40,
                    CustomTextField(
                      validator: (value) =>
                          GetUtils.isEmail(value) ? null : 'Email is incorrect',
                      controller: controller.emailController,
                      hintText: "Email",
                      prefix: const Icon(
                        Icons.email_outlined,
                        color: greyColor,
                      ),
                    ),
                    h20,
                    CustomTextField(
                      controller: controller.passwordController,
                      isObscureText: controller.passwordObscure.value,
                      prefix: const Icon(
                        Icons.password_outlined,
                        color: greyColor,
                      ),
                      suffixIcon: IconButton(
                          onPressed: () {
                            controller.passwordObscure.value =
                                !controller.passwordObscure.value;
                          },
                          icon: Icon(
                            controller.passwordObscure.value
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: greyColor,
                          )),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.length < 8) {
                          return 'Invalid password. Must be at least 8 characters,\ncontain 1 uppercase letter, and 1 number.';
                        }
                        return null;
                      },
                      hintText: "Password",
                    ),
                    h20,
                    InkWell(
                      onTap: () {
                        Get.toNamed(kForgotPasswordScreen);
                      },
                      child: Center(
                        child: customText(
                            text: "Forgot Password?",
                            color: primaryColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 16),
                      ),
                    ),
                    h20,
                    CustomButton(
                      onTap: () {
                        if (controller.formKey.currentState!.validate()) {
                          //Get.to(() => MainBottomBar());
                          //  Get.toNamed(kServiceProvider);
                          controller.login(
                              context,
                              controller.emailController.text,
                              controller.passwordController.text);
                        }
                      },
                      isLoading: controller.isLoading.value,
                      width: double.infinity,
                      text: "Next",
                    ),
                    h85,
                    Center(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 1.5,
                          width: 100,
                          color: primaryColor,
                        ),
                        customText(
                            text: "   Or   ",
                            color: primaryColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 25),
                        Container(
                          height: 1.5,
                          width: 100,
                          color: primaryColor,
                        ),
                      ],
                    )),

                    h85,

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        customText(
                            text: "Don’t have an account? ",
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                        GestureDetector(
                          onTap: () {
                            Get.toNamed(kSignupScreen);
                          },
                          child: customText(
                              text: "Sign up",
                              color: primaryColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),

                    // TextButton(onPressed: (){
                    //
                    //   NotificationServices().getDeviceToken().then((value)async{
                    //
                    //     var data = {
                    //       'to' : value.toString(),
                    //       'notification' : {
                    //         'title' : 'new notification' ,
                    //         'body' : 'Hello' ,
                    //         //"sound": "jetsons_doorbell.mp3"
                    //       },
                    //       'android': {
                    //         'notification': {
                    //           'notification_count': 23,
                    //         },
                    //       },
                    //       'data' : {
                    //         'type' : 'msj' ,
                    //         'id' : 'Aayaz'
                    //       }
                    //     };
                    //
                    //     var response = await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
                    //         body: jsonEncode(data) ,
                    //
                    //         headers: {
                    //           'Content-Type': 'application/json; charset=UTF-8',
                    //           'Authorization' : 'key=AAAAwG3fBRY:APA91bGswE_GtChlZU3fq5A6iLypoG90MsPnx7TRTzAhM3HuPgKiL9RbHhAFNw0QmZFUSbj6vMXEZ1YtNNweKYvmt3BNm5VK-hmbBCYxU6llDzU-5Mh_Vyp2_uhCHHtvE3TgsswxdJTL'
                    //         }
                    //
                    //
                    //     ).then((value){
                    //
                    //       if (kDebugMode) {
                    //         print(value.body.toString());
                    //       }
                    //
                    //     }).onError((error, stackTrace){
                    //       if (kDebugMode) {
                    //         print(error);
                    //       }
                    //     });
                    //     print(response);
                    //     NotificationServices().firebaseInit(context);
                    //   });
                    // }, child: Text("Hell")),

                    // Center(
                    //   child: GestureDetector(
                    //     onTap: (){
                    //       Get.to(() => const ServiceProviderBottomBar());
                    //     },
                    //     child: headingText(
                    //         text: "Sign up",
                    //         color: primaryColor,
                    //         fontSize: 14
                    //     ),
                    //   ),
                    // ),
                    h20,

                    // Center(
                    //   child: GestureDetector(
                    //     onTap: (){
                    //     Navigator.push(context, MaterialPageRoute(builder: (context) => LocationScreen()));
                    //     },
                    //     child: customText(
                    //         text: "Location",
                    //         color: primaryColor,
                    //         fontSize: 14
                    //     ),
                    //   ),
                    // ),
                    SizedBox(
                      height: 50,
                    ),
                    h20,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
