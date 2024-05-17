import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:property_app/app_constants/app_icon.dart';
import 'package:property_app/app_constants/app_sizes.dart';
import 'package:property_app/app_constants/color_constants.dart';
import 'package:property_app/constant_widget/constant_widgets.dart';
import 'package:property_app/custom_widgets/custom_text_field.dart';

import '../../controllers/chat_screens_controller/chat_convertion_screen_controller.dart';

class ChatConversionScreen extends GetView<ChatConversionScreenController> {
  const ChatConversionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: homeAppBar(context , text: "David"),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: customText(
                  text: "Today",
                  fontSize: 18,
                  color: greyColor
                ),
              ),
              h10,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 200,
                    decoration: BoxDecoration(
                      color: greyColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10)
                    ),
                    padding: const EdgeInsets.all(10),
                    child: customText(
                      text: "Hey there! How's your day going?"
                    ),
                  ),
                  customText(
                    text: "6:10 AM ",
                    color: greyColor,
                    fontSize: 12
                  )
                ],
              ),
              h5,
              Align(
                alignment: Alignment.bottomRight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      width: 200,
                      decoration: BoxDecoration(
                          color: greyColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10)
                      ),
                      padding: const EdgeInsets.all(10),
                      child: customText(
                          text: "Hey there! How's your day going?"
                      ),
                    ),
                    customText(
                        text: "6:10 AM ",
                        color: greyColor,
                        fontSize: 12
                    )
                  ],
                ),
              ),

              Expanded(
                flex: 9,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(

                    ),
                    child: Row(
                      children: [
                        Expanded(
                            child: CustomBorderTextField(
                              inputBorder:  OutlineInputBorder(
                               borderRadius: BorderRadius.circular(8),
                               borderSide:  const BorderSide(color: greyColor)),
                              hintText:" Text message...",
                              suffixIcon: SizedBox(
                                width: 80,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(AppIcons.gallery),
                                    w5,
                                    // SvgPicture.asset(AppIcons.voice),
                                  ],
                                ),
                              ),
                            )),
                        w5,
                        CircleAvatar(
                          radius: 25,
                          child: Center(child: SvgPicture.asset(AppIcons.send),
                          )),
                      ],
                    ),
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
