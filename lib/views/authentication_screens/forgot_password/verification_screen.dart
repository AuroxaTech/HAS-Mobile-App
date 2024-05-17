import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_app/controllers/authentication_controller/forgot_password_controller.dart';
import 'package:pinput/pinput.dart';
import '../../../app_constants/app_sizes.dart';
import '../../../app_constants/color_constants.dart';
import '../../../constant_widget/constant_widgets.dart';
import '../../../custom_widgets/custom_button.dart';
import '../../../route_management/constant_routes.dart';
class VerificationScreen extends GetView<ForgotPasswordController> {
  const VerificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: titleAppBar("Verification"),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            children: [
              h30,
              Center(
                child: customText(
                    text: "Enter Verification Code",
                    fontSize: 18,
                    fontWeight: FontWeight.w600
                ),
              ),
              h15,
              OTPPinInput(),
              h20,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  customText(
                    text: "If you didn’t receive a code, ",
                    fontSize: 14,
                    color: greyColor
                  ),
                  customText(
                    text: "Resend",
                    fontSize: 18,
                    color: primaryColor
                  ),
                ],
              ),
              h20,
              Center(
                child: customText(
                    text: "Back to sign in",
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: greyColor
                ),
              ),
              h20,
              CustomButton(
                text: "Verify",
                onTap: (){
                  Get.toNamed(kNewPasswordScreen);
                },

              ),
              h50,
              customText(
                  text: "or",
                  color: primaryColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 17
              ),
              h50,
              customText(
                  text: "Do you have an account?",
                  fontSize: 16,
                  color: greyColor,
                  fontWeight: FontWeight.w400
              ),

              h20,

              Container(
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
              )
            ],
          ),
        ),
      ),
    );
  }
}

class OTPPinInput extends StatelessWidget {
  final TextEditingController pinController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  final Color focusedBorderColor = blackColor; // Adjust color as needed
  final Color fillColor = whiteColor; // Adjust color as needed

  final defaultPinTheme = PinTheme(
    width: 56,
    height: 56,
    textStyle: const TextStyle(fontSize: 20, color: Color.fromRGBO(30, 60, 87, 1), fontWeight: FontWeight.w600),
    decoration: BoxDecoration(
      border: Border.all(color: const Color.fromRGBO(234, 239, 243, 1)),
      borderRadius: BorderRadius.circular(12),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Pinput(
      controller: pinController,
      focusNode: focusNode,
      androidSmsAutofillMethod: AndroidSmsAutofillMethod.smsUserConsentApi,
      listenForMultipleSmsOnAndroid: true,
      defaultPinTheme: defaultPinTheme,
      separatorBuilder: (index) => const SizedBox(width: 8),
      validator: (value) {
        return value == '2222' ? null : 'Pin is incorrect';
      },
      hapticFeedbackType: HapticFeedbackType.lightImpact,
      onCompleted: (pin) {
        debugPrint('onCompleted: $pin');
      },
      onChanged: (value) {
        debugPrint('onChanged: $value');
      },
      focusedPinTheme: defaultPinTheme.copyWith(
        decoration: defaultPinTheme.decoration!.copyWith(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: focusedBorderColor),
        ),
      ),
      submittedPinTheme: defaultPinTheme.copyWith(
        decoration: defaultPinTheme.decoration!.copyWith(
          color: fillColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: focusedBorderColor),
        ),
      ),
      errorPinTheme: defaultPinTheme.copyBorderWith(
        border: Border.all(color: Colors.redAccent),
      ),
    );
  }
}