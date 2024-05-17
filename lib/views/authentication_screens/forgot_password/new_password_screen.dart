import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_app/app_constants/app_sizes.dart';
import 'package:property_app/custom_widgets/custom_text_field.dart';

import '../../../app_constants/color_constants.dart';
import '../../../constant_widget/constant_widgets.dart';
import '../../../controllers/authentication_controller/forgot_password_controller.dart';
import '../../../custom_widgets/custom_button.dart';

class NewPasswordScreen extends GetView<ForgotPasswordController>  {
  const NewPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: titleAppBar("New Password"),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              h20,
              customText(
                  text: "Enter New Password",
                  fontSize: 18,
                  fontWeight: FontWeight.w600
              ),
              h5,
              CustomTextField(
                hintText: "At least 8 digits",
              ),
              h20,
              customText(
                  text: "Confirm Password",
                  fontSize: 18,
                  fontWeight: FontWeight.w600
              ),
              h5,
              CustomTextField(
                hintText: "At least 8 digits",
              ),
              h50,
              CustomButton(
                text: "Send",
                onTap: (){
                 // Get.toNamed(kVerificationScreen);
                },
                width: double.infinity,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
