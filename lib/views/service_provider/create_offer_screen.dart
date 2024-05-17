import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_app/app_constants/animations.dart';
import 'package:property_app/app_constants/color_constants.dart';
import 'package:property_app/constant_widget/constant_widgets.dart';

import '../../app_constants/app_icon.dart';
import '../../app_constants/app_sizes.dart';
import '../../controllers/services_provider_controller/create_offer_controller.dart';
import '../../custom_widgets/custom_button.dart';
import '../../custom_widgets/custom_text_field.dart';
class CreateOfferScreen extends GetView<CreateOfferController> {
  const CreateOfferScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: homeAppBar(context, text: "New Offer"),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: SingleChildScrollView(
            physics: bouncingScrollPhysic,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                circleAvatar(
                    text: "Create offer",
                  image: AppIcons.createOffer,
                ),
                h10,
                labelText("Choose Services : "),
                h5,
                CustomDropDown(
                  value: controller.cleanService.value,
                  onChange: (value){
                    controller.cleanService.value  = value;
                  },items: ['House clean service',  ]
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    onTap: (){},
                    value: value,
                    child: customText(
                      text: value,
                        fontSize: 16,
                        color: hintColor
                    ),
                  );
                }).toList(),),
                h10,
                labelText("Description :"),
                h5,
                CustomTextField(
                  hintText: "Description",
                  maxLines: 4,
                  minLines: 3,
                ),
                h10,
                labelText("Custom Message :"),
                h5,
                CustomTextField(
                  hintText: "Custom Message :",
                  maxLines: 4,
                  minLines: 3,
                ),
                h10,
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment : CrossAxisAlignment.start,
                        children: [
                          labelText("Currency:"),
                          h5,
                          CustomDropDown(
                            value: controller.currency.value,
                            onChange: (value){
                              controller.currency.value  = value;
                            },items: ['\$',  ]
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              onTap: (){},
                              value: value,
                              child: customText(
                                text: value,
                                  fontSize: 16,
                                  color: hintColor
                              ),
                            );
                          }).toList(),),
                        ],
                      ),
                    ),
                    w15,
                    Expanded(
                      child: Column(
                        crossAxisAlignment : CrossAxisAlignment.start,
                        children: [
                          labelText("Pricing"),
                          h5,
                          CustomDropDown(
                            value: controller.pricing.value,
                            onChange: (value){
                              controller.pricing.value  = value;
                            },items: ['2500',  ]
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              onTap: (){},
                              value: value,
                              child: customText(
                                text: value,
                                  fontSize: 16,
                                  color: hintColor
                              ),
                            );
                          }).toList(),),
                        ],
                      ),
                    ),

                  ],
                ),
                h10,
                labelText("Offer Pricing :"),
                h5,
                CustomDropDown(
                  value: controller.offerPricing.value,
                  onChange: (value){
                    controller.offerPricing.value  = value;
                  },items: ['\$2000',  ]
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    onTap: (){},
                    value: value,
                    child: customText(
                      text: value,
                        fontSize: 16,
                        color: hintColor
                    ),
                  );
                }).toList(),),
                h10,
                labelText("Service Duration :"),
                h5,
                CustomDropDown(
                  value: controller.serviceDuration.value,
                  onChange: (value){
                    controller.serviceDuration.value  = value;
                  },items: ['hours',  ]
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    onTap: (){},
                    value: value,
                    child: customText(
                      text: value,
                        fontSize: 16,
                        color: hintColor
                    ),
                  );
                }).toList(),),
                h10,
                labelText("Offer Validity :"),
                h5,
                CustomDropDown(
                  value: controller.offerValid.value,
                  onChange: (value){
                    controller.offerValid.value  = value;
                  },items: ['Days',  ]
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    onTap: (){},
                    value: value,
                    child: customText(
                      text: value,
                        fontSize: 16,
                        color: hintColor
                    ),
                  );
                }).toList(),),
                h10,
                labelText("Select buyer"),
                h5,
                CustomDropDown(
                  value: controller.selectBuyer.value,
                  onChange: (value){
                    controller.selectBuyer.value  = value;
                  },items: ['James',  ]
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    onTap: (){},
                    value: value,
                    child: customText(
                      text: value,
                        fontSize: 16,
                        color: hintColor
                    ),
                  );
                }).toList(),),
                h30,
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        height: screenHeight(context) * 0.06,
                        text: "Cancel",
                        gradientColor: redGradient(),
                      ),
                    ),
                    w10,
                    Expanded(
                      child: CustomButton(
                        height: screenHeight(context) * 0.06,
                        text: "Send offer",
                      ),
                    ),
                  ],
                ),
                h30,
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget labelText(String text){
   return customText(
      text: text,
      fontSize: 16,
      color: greyColor,
    );

  }
}
