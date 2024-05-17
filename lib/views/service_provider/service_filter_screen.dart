import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:property_app/controllers/services_provider_controller/service_listing_screen_controller.dart';
import '../../app_constants/app_sizes.dart';
import '../../app_constants/color_constants.dart';
import '../../constant_widget/constant_widgets.dart';
import '../../custom_widgets/custom_button.dart';
import '../../custom_widgets/custom_text_field.dart';

class ServiceFilterScreen extends GetView<ServiceListingScreenController> {
  const ServiceFilterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: titleAppBar("Service Filter"),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 5),
          child: SingleChildScrollView(
            child:  Form(
              key: controller.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  labelText("Service Name"),
                  h10,
                  CustomBorderTextField(
                    hintText: "Plumber",
                    controller: controller.serviceNameController,
                    keyboaredtype: TextInputType.number,
                    // maxLength: 10,
                  ),

                  h15,
                  labelText("City Name"),
                  h10,
                  CustomBorderTextField(
                    hintText: "Islamabad",
                    controller: controller.cityController,
                    keyboaredtype: TextInputType.number,
                    // maxLength: 10,

                  ),
                  h15,
                  labelText("Country Name"),
                  h10,
                  CustomBorderTextField(
                    hintText: "Pakistan",
                    controller: controller.countryController,
                    keyboaredtype: TextInputType.number,
                    // maxLength: 10,
                  ),

                  h15,
                  labelText("Price Range"),
                  h10,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: CustomBorderTextField(
                          hintText: "\$0",
                          controller: controller.minPriceController,
                          keyboaredtype: TextInputType.number,
                          maxLength: 10,
                          // validator: (value) {
                          //   if (value == null || value.isEmpty || value.length < 1) {
                          //     return 'Min Price Required';
                          //   }
                          //   return null;
                          // },
                        ),
                      ),
                      w20,
                      customText(
                          text: "TO",
                          fontSize: 18
                      ),
                      w20,
                      Expanded(
                        child: CustomBorderTextField(
                          hintText: "\$8000",
                          keyboaredtype: TextInputType.number,
                          maxLength: 10,
                          controller: controller.maxPriceController,
                          // validator: (value) {
                          //   if (value == null || value.isEmpty || value.length < 1) {
                          //     return 'Max Price Required';
                          //   }
                          //   return null;
                          // },
                        ),
                      ),
                    ],
                  ),
                  h20,
                  CustomButton(
                    width: double.infinity,
                    text: "Apply",
                    onTap: (){
                      if(controller.formKey.currentState!.validate()){
                        Map<String, dynamic> filters = {
                          "minPrice": controller.minPriceController.text,
                          "maxPrice": controller.maxPriceController.text,
                          "service_name": controller.serviceNameController.text.toString(),
                          "country": controller.countryController.text.toString(),
                          "city": controller.cityController.text,
                        };
                        Get.back(result: filters);
                      }
                    },
                  ),
                  h20,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
