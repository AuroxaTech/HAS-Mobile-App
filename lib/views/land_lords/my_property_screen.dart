import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_app/app_constants/app_sizes.dart';
import 'package:property_app/app_constants/color_constants.dart';
import 'package:property_app/constant_widget/constant_widgets.dart';
import 'package:property_app/controllers/land_lord/my_property_controller.dart';
import 'package:property_app/utils/api_urls.dart';

import '../../app_constants/animations.dart';
import '../../route_management/constant_routes.dart';

class MyPropertyScreen extends GetView<MyPropertyController> {
  const MyPropertyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: titleAppBar("My Properties", action: [
        // IconButton(onPressed: (){
        //   Get.toNamed(kPropertyFilterScreen);
        // }, icon: const Icon(Icons.menu)),
      ]),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            physics: bouncingScrollPhysic,
            child: Obx(
              () => controller.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : controller.getLandLordPropertiesList.isEmpty
                      ? Center(
                          child: customText(
                              text: "No Property here",
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                        )
                      : Column(
                          children: [
                            ListView.separated(
                              itemCount:
                                  controller.getLandLordPropertiesList.length,
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                final property = controller.getLandLordPropertiesList[index];
                                
                                // Get the image URL
                                String imageUrl = "";
                                
                                // First try to get from propertyImages
                                if (property.propertyImages.isNotEmpty) {
                                  imageUrl = property.propertyImages.first;
                                } 
                                // Fallback to images field if propertyImages is empty
                                else if (property.images.isNotEmpty) {
                                  imageUrl = AppUrls.propertyImages + property.images;
                                }
                                
                                return myPropertyWidget(
                                  context, 
                                  onTap: () {
                                    Get.toNamed(
                                      kPropertyDetailScreen,
                                      arguments: property.id
                                    );
                                  },
                                  title: property.city,
                                  image: imageUrl,
                                  price: "\$${property.amount}",
                                  description: property.description,
                                  bedroom: property.bedroom,
                                  bathroom: property.bathroom,
                                  marla: property.areaRange,
                                  rent: property.type == "1" ? "Rent" : "Sale"
                                );
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return h15;
                              },
                            )
                          ],
                        ),
            ),
          ),
        ),
      ),
    );
  }
}
