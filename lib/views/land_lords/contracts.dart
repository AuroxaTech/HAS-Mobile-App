import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:property_app/app_constants/app_icon.dart';
import 'package:property_app/app_constants/app_sizes.dart';
import 'package:property_app/app_constants/color_constants.dart';
import 'package:property_app/constant_widget/constant_widgets.dart';
import 'package:property_app/custom_widgets/custom_button.dart';

class Contracts extends StatelessWidget {
  const Contracts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: titleAppBar("Contracts", action: [
        IconButton(onPressed: (){
        }, icon: const Icon(Icons.search))
      ]),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 1.0,
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SvgPicture.asset(AppIcons.homeContract),
                        w15,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            customText(
                              text: "Oakwood",
                              fontSize: 22,
                              fontWeight: FontWeight.w500,

                            ),  customText(
                              text: "123 Main St, Cityville",
                              fontSize: 18,
                              fontWeight: FontWeight.w300,

                            ),
                          ],
                        ),
                      ],
                    ) ,
                    h10,
                    customText(
                      text: "Type : Appartment Size :  872 sq.ft ",
                      fontSize: 18,
                      fontWeight: FontWeight.w300,
                    ),
                    h10,
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: whiteColor,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 1.0,
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(10),
                          child: Center(
                            child: customText(
                              text: "26/12/2023",
                              fontSize: 16
                            ),
                          ),
                        ),
                        customText(
                          text: "   -   ",
                          fontSize: 20
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: whiteColor,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 1.0,
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(10),
                          child: Center(
                            child: customText(
                                text: "26/12/2023",
                                fontSize: 16
                            ),
                          ),
                        ),
                      ],
                    ),
                    h15,
                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            height: 35,
                            text: "Cancel",
                            borderRadius: BorderRadius.circular(50),
                            borderColor: blackColor,
                            btnColor: whiteColor,
                            gradientColor: whiteGradient(),
                            btnTextColor: blackColor,
                            fontSize: 14,
                          ),
                        ),
                        w10,
                        Expanded(
                          child: CustomButton(
                            height: 35,
                            text: "Renew",
                            borderRadius: BorderRadius.circular(50),
                            borderColor: blackColor,
                            btnColor: whiteColor,
                            gradientColor: whiteGradient(),
                            btnTextColor: blackColor,
                            fontSize: 14,
                          ),
                        ),
                        w10,
                        Expanded(
                          child: CustomButton(
                            height: 37,
                            text: "Modify",
                            fontSize: 14,
                            borderRadius: BorderRadius.circular(50),
                            btnColor: whiteColor,
                            btnTextColor: whiteColor,
                          ),
                        ),
                      ],
                    ),
                    h10,
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
