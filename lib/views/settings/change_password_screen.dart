import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app_constants/app_sizes.dart';
import '../../app_constants/color_constants.dart';
import '../../constant_widget/constant_widgets.dart';
import '../../controllers/authentication_controller/change_password_controller.dart';
import '../../custom_widgets/custom_button.dart';
import '../../custom_widgets/custom_text_field.dart';

class ChangePassword extends GetView<ChangePasswordController> {
  const ChangePassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: homeAppBar(context, text: "Change Password"),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Obx(() => Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                key: controller.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    h5,
                    customText(
                      text: "Current Password :",
                      fontSize: 16,
                      color: blackColor,
                    ),
                    h10,
                    CustomTextField(
                      hintText: "Current Password :",
                      controller: controller.currentPassword,
                      validator: (value) {
                        if (value == null || value.isEmpty ) {
                          return 'Current password required';
                        }
                        return null;
                      },
                    ),
                    h10,
                    customText(
                      text: "New Password :",
                      fontSize: 16,
                      color: blackColor,
                    ),
                    h10,
                    CustomTextField(
                      hintText: "New Password :",
                      controller: controller.newPassword,
                      validator: (value) {
                        if (value == null || value.isEmpty || value.length < 8) {
                          return 'Invalid password. Must be at least 8 characters,\ncontain 1 uppercase letter, and 1 number.';
                        }
                        return null;
                      },
                    ),
                    h10,
                    customText(
                      text: "Confirm Password :",
                      fontSize: 16,
                      color: blackColor,
                    ),
                    h10,
                    CustomTextField(
                      hintText: "Confirm Password",
                      controller: controller.confirmPassword,
                      validator: (value) {
                        if (value == null || value.isEmpty  || value != controller.newPassword.text) {
                          return 'Confirm Password does not match';
                        }
                        return null;
                      },
                    ),

                    h30,
                    Center(child: CustomButton(
                      width: double.infinity,
                      text: "Save",
                      isLoading: controller.isLoading.value,
                      onTap: (){
                        if(controller.formKey.currentState!.validate()){
                          controller.updateDataAndImage(
                              currentPassword: controller.currentPassword.text,
                              password: controller.newPassword.text,
                              conPassword: controller.confirmPassword.text,
                          );
                        }
                      },
                    )),
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
