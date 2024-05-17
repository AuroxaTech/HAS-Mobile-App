import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_app/app_constants/app_sizes.dart';
import 'package:property_app/app_constants/color_constants.dart';
import 'package:property_app/constant_widget/constant_widgets.dart';
import 'package:property_app/custom_widgets/custom_button.dart';
import 'package:property_app/custom_widgets/custom_text_field.dart';
import 'package:property_app/utils/utils.dart';
import 'package:property_app/views/service_provider/rating_screen.dart';

import '../../controllers/services_provider_controller/rate_expereince_controller.dart';

class RateExperience extends GetView<RateExperienceController> {
  const RateExperience({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: backAppBar(text: "FeedBack", isTitle: true),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: SingleChildScrollView(
            child: Form(
              key: controller.formKey,
              child: Obx(() => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customText(
                      text: "Rate Your Experience",
                      fontWeight: FontWeight.w500,
                      fontSize: 25,
                      color: Colors.grey.shade600
                    ),
                    h5,
                    customText(
                      text: "Are you Satisfied with service!",
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      color: Colors.grey.shade600
                    ),
                    h15,
                    RatingWidget(
                      maxRating: 5,
                      isRating: true,
                      initialRating: controller.rating.value,
                      size: 50,
                      onRatingChanged: (rating) {
                        print('Selected rating: $rating');
                        controller.rating.value = rating;
                      },
                    ),
                    h15,
                    customText(
                        text: "Tell us what can be improved?",
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: blackColor
                    ),
                    h15,
                    Obx(() => Wrap(
                      spacing: 8,
                      children: controller.selectedHome.keys.map((String key) {
                        bool isSelected = controller.selectedHome[key]!;
                        return ChoiceChip(
                          label: customText(
                              text: key,
                              color: isSelected ? whiteColor : blackColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          selected: isSelected,
                          selectedColor: blackColor,
                          backgroundColor: Colors.grey.shade100,
                          onSelected: (bool selected) {
                            controller.toggleHome(key);
                          },
                        );
                      }).toList(),
                    )),
                    h20,
                    CustomBorderTextField(
                      controller: controller.descriptionController,
                      hintText: "Tell us on about service",
                      minLines: 4,
                      maxLines: 5,
                      validator: (value){
                        if (value == null || value.isEmpty) {
                          return 'Tell us about services';
                        }
                        return null;
                      },
                    ),
                    h50,
                    CustomButton(
                        width: double.infinity,
                        text: "Submit",
                        isLoading: controller.isLoading.value,
                        onTap: (){
                          if(controller.formKey.currentState!.validate()){
                            if(controller.rating.value == 0){
                              AppUtils.errorSnackBar("Rating", "Please add rating");
                            }else{
                              controller.sendFeedback(
                                  serviceId: 48, rate: controller.rating.value,
                                  description: controller.descriptionController.text,
                                  propertySubTypeId: controller.selectedIndex.value,
                                 );
                              }
                           }
                        },
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
