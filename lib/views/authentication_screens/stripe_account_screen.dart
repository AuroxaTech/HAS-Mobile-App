import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_app/app_constants/app_icon.dart';
import 'package:property_app/app_constants/app_sizes.dart';
import 'package:property_app/app_constants/color_constants.dart';
import 'package:property_app/constant_widget/constant_widgets.dart';
import 'package:property_app/controllers/authentication_controller/stripe_account_controller.dart';
import 'package:property_app/custom_widgets/custom_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../app_constants/animations.dart';
import '../../constant_widget/drawer.dart';
import '../../route_management/constant_routes.dart';
import '../../utils/shared_preferences/preferences.dart';

class StripeAccountScreen extends StatelessWidget {
  const StripeAccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(StripeAccountController());

    return Scaffold(
      backgroundColor: whiteColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            physics: bouncingScrollPhysic,
            child: Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  h50,
                  Center(child: Image.asset(AppIcons.homeImage)),
                  h30,
                  Center(
                    child: headingText(
                      text: "Stripe Account Setup",
                      fontSize: 28,
                    ),
                  ),
                  h20,
                  Center(
                    child: customText(
                      text:
                          "Set up your Stripe account to receive payments from users",
                      textAlign: TextAlign.center,
                      fontSize: 16,
                      color: greyColor,
                    ),
                  ),
                  h40,
                  _buildInfoCard(),
                  h40,
                  CustomButton(
                    onTap: () {
                      controller.getStripeConnectUrl();
                    },
                    isLoading: controller.isLoading.value,
                    width: double.infinity,
                    text: "Set Up Stripe Account",
                  ),
                  h20,
                  CustomButton(
                    onTap: () {
                      controller.checkStripeAccountStatus();
                    },
                    isLoading: controller.isLoading2.value,
                    width: double.infinity,
                    text: "Go to Home",
                    btnColor: Colors.white,
                    borderColor: primaryColor,
                  ),
                  h20,
                  CustomButton(
                    onTap: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      await updateUserStatus(false);
                      bool? userData = await Preferences.getBiometricEnabled();
                      if (userData == true) {
                        Get.offAllNamed(kLoginScreen);
                      } else {
                        await prefs.remove("token");
                        await prefs.remove("role");
                        await prefs.remove("user_id").then((value) {
                          Get.offAllNamed(kLoginScreen);
                        });
                      }
                    },
                    isLoading: controller.isLoading2.value,
                    width: double.infinity,
                    text: "Back to Login",
                    btnColor: Colors.white,
                    borderColor: primaryColor,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.info_outline, color: primaryColor),
              w10,
              Expanded(
                child: customText(
                  text: "Why do I need a Stripe account?",
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          h10,
          customText(
            text:
                "As a service provider, you need a Stripe account to receive payments from users for your services. Setting up your account will enable you to get paid seamlessly through our platform.",
            fontSize: 14,
            color: Colors.grey[700],
          ),
        ],
      ),
    );
  }
}
