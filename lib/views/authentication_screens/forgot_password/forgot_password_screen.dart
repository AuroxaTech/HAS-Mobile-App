import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_app/app_constants/app_sizes.dart';
import 'package:property_app/app_constants/color_constants.dart';
import 'package:property_app/constant_widget/constant_widgets.dart';
import 'package:property_app/controllers/authentication_controller/forgot_password_controller.dart';
import 'package:property_app/custom_widgets/custom_button.dart';
import 'package:property_app/custom_widgets/custom_text_field.dart';
import 'package:property_app/route_management/constant_routes.dart';
import 'package:property_app/utils/utils.dart';
class ForgotPassword extends GetView<ForgotPasswordController> {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: titleAppBar("Forgot Password"),
      body: SafeArea(
        child: Obx(() => Padding(
            padding: const EdgeInsets.all(18.0),
            child: Form(
              key: controller.formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    h30,
                    Center(
                      child: customText(
                        text: "Enter Email Address",
                        fontSize: 18,
                        fontWeight: FontWeight.w600
                      ),
                    ),
                    h15,
                    CustomTextField(
                      validator: (value) => GetUtils.isEmail(value)
                          ? null
                          : 'Email is incorrect',
                      controller: controller.emailController,
                      hintText: "Email",
                    ),

                    h20,
                    CustomButton(
                      text: "Send",
                      isLoading: controller.isLoading.value,
                      onTap: (){
                        if(controller.formKey.currentState!.validate()){
                          controller.sendPasswordResetEmail(controller.emailController.text);
                        }
                      },
                      width: double.infinity,
                    ),
                    h60,
                    customText(
                      text: "-Or-",
                      color: primaryColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 20
                    ),
                    h50,
                    customText(
                      text: "Don`t have an account?",
                      fontSize: 16,
                      color: greyColor,
                      fontWeight: FontWeight.w400
                    ),
                    h20,

                    InkWell(
                      onTap: (){
                        Get.toNamed(kSignupScreen);
                      },
                      child: Container(
                        width: 200,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: blackColor),
                        ),
                        child: Center(
                          child: customText(
                            text: "Sign up",
                            fontSize: 18,
                            fontWeight: FontWeight.w500
                          ),
                        ),
                      ),
                    )


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
