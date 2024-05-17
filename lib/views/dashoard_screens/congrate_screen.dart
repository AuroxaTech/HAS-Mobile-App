import 'package:flutter/material.dart';
import 'package:property_app/app_constants/app_icon.dart';
import 'package:property_app/app_constants/app_sizes.dart';
import 'package:property_app/constant_widget/constant_widgets.dart';
import 'package:property_app/custom_widgets/custom_button.dart';

class CongratsScreen extends StatelessWidget {
  const CongratsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage(AppIcons.congrats,), fit: BoxFit.contain),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: screenHeight(context) * 0.33,
            ),
            customText(
              text: "CONGRATS",
              fontSize: 45,
              fontWeight: FontWeight.bold
            ),
            customText(
              text: " You have a new job with tick",
              fontSize: 15,
              fontWeight: FontWeight.w600
            ),
            h10,
            CustomButton(
              text: "Confirm",
              height: 40,
              fontSize: 18,
            )
          ],
        ),
      ),
    );
  }
}
