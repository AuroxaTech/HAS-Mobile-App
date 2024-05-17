import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:property_app/app_constants/color_constants.dart';
import 'package:property_app/constant_widget/constant_widgets.dart';
import 'package:property_app/controllers/dasboard_controller/all_property_controller.dart';
import 'package:property_app/controllers/land_lord/my_property_controller.dart';
import 'package:property_app/custom_widgets/custom_button.dart';

import '../../app_constants/app_icon.dart';
import '../../app_constants/app_sizes.dart';
import '../../custom_widgets/custom_text_field.dart';

class PropertyFilterScreen extends GetView<AllPropertyController> {
  const PropertyFilterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: titleAppBar("Property Filter"),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 5),
          child: SingleChildScrollView(
            child: Obx(() => Form(
              key: controller.formKey,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    labelText("Area Range"),
                    h10,
                    SizedBox(
                      height: 35,
                      child: ListView.builder(
                        itemCount: controller.areaRange.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Obx(
                                () => Row(
                                children: [
                                 roundedSmallButton(
                                  text: controller.areaRange[index],
                                  subTitle: "",
                                  isSecondText: true,
                                  isSelected:
                                  controller.selectedArea.value == index,
                                  onTap: () =>
                                  controller.selectedArea.value = index,
                                ),
                                const SizedBox(width: 15),
                              ],
                            ),
                          );
                        },
                      ),
                    ),

                    h15,
                    Row(
                      children: [
                        labelText("Bedrooms"),
                        w15,
                        SvgPicture.asset(AppIcons.bedroom),
                      ],
                    ),
                    h10,
                    SizedBox(
                      height: 35,

                      child: ListView.builder(
                        itemCount: 8,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          index += 1;
                          return Obx(
                                () => Row(
                              children: [
                                roundedSmallButton(
                                  text: "$index",
                                  isSelected:
                                  controller.selectedBedroom.value == index,
                                  onTap: () =>
                                  controller.selectedBedroom.value = index,
                                ),
                                const SizedBox(width: 15),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    h15,
                    Row(
                      children: [
                        labelText("Bathrooms"),
                        w15,
                        SvgPicture.asset(AppIcons.bathroom),
                      ],
                    ),
                    h10,
                    SizedBox(
                      height: 35,
                      child: ListView.builder(
                        itemCount: 8,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          index += 1;
                          return Obx(
                                () => Row(
                              children: [
                                roundedSmallButton(
                                  text: "$index",
                                  isSelected:
                                  controller.selectedBathrooms.value == index,
                                  onTap: () =>
                                  controller.selectedBathrooms.value = index,
                                ),
                                const SizedBox(width: 15),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    // h15,
                    // labelText("Description"),
                    // h10,
                    // CustomTextField(
                    //   maxLines: 5,
                    //   minLines: 3,
                    //   validator: (value) {
                    //     if (value == null || value.isEmpty || value.length < 3) {
                    //       return 'Description Required';
                    //     }
                    //     return null;
                    //   },
                    //   controller: controller.description,
                    //   hintText: "Clean and Minimalistic House , with modern interior and exterior built in the centre of city with modern facilities",
                    // ),
                    h15,
                    labelText("Property Type"),
                    h10,
                    Obx(() => Container(
                      height: 45,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: whiteColor,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: (){
                                controller.home.value = true;
                                controller.plots.value = false;
                                controller.commercial.value = false;
                              },
                              child: Container(
                                decoration:   BoxDecoration(
                                    color:  controller.home.value ? secondaryColor : whiteColor,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      bottomLeft: Radius.circular(15),
                                    )
                                ),
                                child: Center(
                                  child: customText(
                                      text: "Homes",
                                      color: controller.home.value ? whiteColor : blackColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: (){
                                controller.plots.value = true;
                                controller.home.value = false;
                                controller.commercial.value = false;
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: controller.plots.value ? secondaryColor : whiteColor,
                                ),
                                child: Center(
                                  child: customText(
                                      text: "Plots",
                                      color: controller.plots.value ? whiteColor : blackColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: (){
                                controller.commercial.value = true;
                                controller.home.value = false;
                                controller.plots.value = false;

                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: controller.commercial.value ? secondaryColor : whiteColor,
                                    borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(15),
                                      bottomRight: Radius.circular(15),
                                    )
                                ),
                                child: Center(
                                  child: customText(
                                      text: "Commercial",
                                      color: controller.commercial.value ? whiteColor : blackColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    ),
                    h15,

                    controller.home.value ?   Obx(() => Wrap(
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
                          backgroundColor: Colors.white,
                          onSelected: (bool selected) {
                            controller.toggleHome(key);
                          },
                        );
                      }).toList(),
                    )) : const SizedBox(),
                    controller.plots.value ?  Obx(() => Wrap(
                      spacing: 8,
                      children: controller.selectedPlots.keys.map((String key) {
                        bool isSelected = controller.selectedPlots[key]!;
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
                          backgroundColor: Colors.white,
                          onSelected: (bool selected) {
                            controller.togglePlots(key);
                          },
                        );
                      }).toList(),
                    )) : const SizedBox(),
                    controller.commercial.value ?  Obx(() => Wrap(
                      spacing: 8,
                      children: controller.selectedCommercial.keys.map((String key) {
                        bool isSelected = controller.selectedCommercial[key]!;
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
                          backgroundColor: Colors.white,
                          onSelected: (bool selected) {
                            controller.toggleCommercial(key);
                          },
                        );
                      }).toList(),
                    )) : const SizedBox(),


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
                            //   if (value == null || value.isEmpty || value.length < 3) {
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
                            //   if (value == null || value.isEmpty || value.length < 3) {
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

                          String propertyType = '1';
                          if(controller.home.value) {
                            propertyType = '1';
                          } else if(controller.plots.value) {
                            propertyType = '2';
                          } else if(controller.commercial.value) {
                            propertyType = '3';
                          }
                          //  String propertySubType = controller.getSelectedSubType();
                          int selectedSubType = 1;
                          if (controller.home.value) {
                            selectedSubType = controller.getSelectedHomeSubTypeIndex();
                          } else if (controller.plots.value) {
                            selectedSubType = controller.getSelectedPlotsSubTypeIndex();
                          } else if (controller.commercial.value) {
                            selectedSubType = controller.getSelectedCommercialSubTypeIndex();
                          }
                          print(selectedSubType);
                          print(propertyType);

                          Map<String, dynamic> filters = {
                            "property_type": propertyType,
                            "min_amount": controller.minPriceController.text,
                            "max_amount": controller.maxPriceController.text,
                            "sub_type": selectedSubType,
                            "bedroom": controller.selectedBedroom.value.toString(),
                            "bathroom": controller.selectedBathrooms.value.toString(),
                          //  "description": controller.description.text,
                            "area_range": controller.selectedArea.value
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
      ),
    );
  }

  Widget choiceChip({required String text, required Function(bool)? onSelected, required bool selected }){
    return  FilterChip(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      avatar: null,
      pressElevation: 0.0,
      selectedColor: blackColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      backgroundColor: greyColor,
      labelStyle: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
      iconTheme: const IconThemeData(color: Colors.white),
      side: const BorderSide(color: primaryColor),
      label: customText(
        text: text
      ),
     // selected: controller.homeChip.value == 0,
      selected: selected,
      onSelected: onSelected
    );
  }

}
