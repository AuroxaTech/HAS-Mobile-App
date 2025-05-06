import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:property_app/controllers/land_lord/my_property_detail_controller.dart';

import '../../app_constants/animations.dart';
import '../../app_constants/app_icon.dart';
import '../../app_constants/app_sizes.dart';
import '../../app_constants/color_constants.dart';
import '../../constant_widget/constant_widgets.dart';
import '../../custom_widgets/custom_button.dart';
import '../../custom_widgets/custom_text_field.dart';
import '../../utils/utils.dart';

class EditMyPropertyScreen extends GetView<MyPropertyDetailController> {
  const EditMyPropertyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: titleAppBar("Edit Details"),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: Obx(
            () => controller.isLoading.value
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    physics: bouncingScrollPhysic,
                    child: Form(
                      key: controller.formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              imageButton(
                                padding:
                                    const EdgeInsets.only(top: 5, bottom: 5),
                                onTap: () {
                                  controller.isSale.value = false;
                                },
                                borderColor: controller.isSale.value
                                    ? bluishWhite
                                    : primaryColor,
                                textColor: controller.isSale.value
                                    ? blackColor
                                    : primaryColor,
                                imageColor: controller.isSale.value
                                    ? blackColor
                                    : primaryColor,
                                width: 100,
                                text: "Sale",
                                image: AppIcons.sale,
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              imageButton(
                                  padding:
                                      const EdgeInsets.only(top: 5, bottom: 5),
                                  onTap: () {
                                    controller.isSale.value = true;
                                  },
                                  width: 100,
                                  text: "Rent",
                                  borderColor: controller.isSale.value
                                      ? primaryColor
                                      : bluishWhite,
                                  textColor: controller.isSale.value
                                      ? primaryColor
                                      : blackColor,
                                  imageColor: controller.isSale.value
                                      ? primaryColor
                                      : blackColor,
                                  image: AppIcons.rent),
                            ],
                          ),
                          h15,
                          if (controller.pickedImages.isEmpty)
                            uploadImageContainer(
                              onTap: () {
                                controller.pickImages();
                              },
                            )
                          else
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  SizedBox(
                                    height: 100,
                                    child: ListView.builder(
                                      itemCount: controller.pickedImages.length,
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        final image =
                                            controller.pickedImages[index];
                                        return fileImage(
                                            image: image.path,
                                            onTap: () {
                                              controller.removeImage(index);
                                            });
                                      },
                                    ),
                                  ),
                                  // Add your additional button here
                                  InkWell(
                                    onTap: () {
                                      controller.pickImages();
                                    },
                                    child: Container(
                                        width: 90,
                                        height: 90,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          border: Border.all(color: blackColor),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        child: Center(
                                            child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Icon(
                                              Icons.add,
                                              size: 25,
                                            ),
                                            customText(
                                                text: "Add",
                                                fontWeight: FontWeight.w500,
                                                fontSize: 22),
                                          ],
                                        ))),
                                  ),
                                ],
                              ),
                            ),
                          h15,
                          labelText("Enter City"),
                          h10,
                          CustomTextField(
                            hintText: "New York",
                            controller: controller.newYorkController,
                            prefixConstraints: BoxConstraints(
                              minWidth: Get.width * 0.12,
                              minHeight: Get.width * 0.038,
                            ),
                            prefix: SvgPicture.asset(AppIcons.city),
                          ),
                          h15,
                          labelText("Enter Amount"),
                          h10,
                          CustomTextField(
                            hintText: "97898",
                            controller: controller.amountController,
                            errorText: controller.amountField.value
                                ? null
                                : "Please enter amount",
                            prefixConstraints: BoxConstraints(
                              minWidth: Get.width * 0.12,
                              minHeight: Get.width * 0.038,
                            ),
                            prefix: SvgPicture.asset(AppIcons.amount),
                          ),
                          h15,
                          labelText("Enter Street Address"),
                          h10,
                          CustomTextField(
                            controller: controller.streetController,
                            errorText: controller.streetField.value
                                ? null
                                : "Please enter street",
                            hintText: "Main Canadian street",
                            suffixIcon: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SvgPicture.asset(AppIcons.location),
                            ),
                          ),
                          h15,
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
                                        isSecondText: true,
                                        isSelected:
                                            controller.selectedArea.value ==
                                                index,
                                        onTap: () => controller
                                            .selectedArea.value = index,
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
                                            controller.selectedBedroom.value ==
                                                index,
                                        onTap: () => controller
                                            .selectedBedroom.value = index,
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
                                        isSelected: controller
                                                .selectedBathrooms.value ==
                                            index,
                                        onTap: () => controller
                                            .selectedBathrooms.value = index,
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
                          //   hintText: "Clean and Minimalistic House , with modern interior and exterior built in the centre of city with modern facilities",
                          // ),

                          h15,
                          labelText("Property Type"),
                          h10,
                          Obx(
                            () => Container(
                              height: 45,
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                color: whiteColor,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        controller.home.value = true;
                                        controller.plots.value = false;
                                        controller.commercial.value = false;
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: controller.home.value
                                                ? secondaryColor
                                                : whiteColor,
                                            borderRadius:
                                                const BorderRadius.only(
                                              topLeft: Radius.circular(15),
                                              bottomLeft: Radius.circular(15),
                                            )),
                                        child: Center(
                                          child: customText(
                                              text: "Homes",
                                              color: controller.home.value
                                                  ? whiteColor
                                                  : blackColor,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        controller.plots.value = true;
                                        controller.home.value = false;
                                        controller.commercial.value = false;
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: controller.plots.value
                                              ? secondaryColor
                                              : whiteColor,
                                        ),
                                        child: Center(
                                          child: customText(
                                              text: "Plots",
                                              color: controller.plots.value
                                                  ? whiteColor
                                                  : blackColor,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        controller.commercial.value = true;
                                        controller.home.value = false;
                                        controller.plots.value = false;
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: controller.commercial.value
                                                ? secondaryColor
                                                : whiteColor,
                                            borderRadius:
                                                const BorderRadius.only(
                                              topRight: Radius.circular(15),
                                              bottomRight: Radius.circular(15),
                                            )),
                                        child: Center(
                                          child: customText(
                                              text: "Commercial",
                                              color: controller.commercial.value
                                                  ? whiteColor
                                                  : blackColor,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          h15,
                          controller.home.value
                              ? Obx(() => Wrap(
                                    spacing: 8,
                                    children: controller.selectedHome.keys
                                        .map((String key) {
                                      bool isSelected =
                                          controller.selectedHome[key]!;
                                      return ChoiceChip(
                                        label: customText(
                                            text: key,
                                            color: isSelected
                                                ? whiteColor
                                                : blackColor,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 10),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        selected: isSelected,
                                        selectedColor: blackColor,
                                        backgroundColor: Colors.white,
                                        onSelected: (bool selected) {
                                          controller.toggleHome(key);
                                        },
                                      );
                                    }).toList(),
                                  ))
                              : const SizedBox(),
                          controller.plots.value
                              ? Obx(() => Wrap(
                                    spacing: 8,
                                    children: controller.selectedPlots.keys
                                        .map((String key) {
                                      bool isSelected =
                                          controller.selectedPlots[key]!;
                                      return ChoiceChip(
                                        label: customText(
                                            text: key,
                                            color: isSelected
                                                ? whiteColor
                                                : blackColor,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 10),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        selected: isSelected,
                                        selectedColor: blackColor,
                                        backgroundColor: Colors.white,
                                        onSelected: (bool selected) {
                                          controller.togglePlots(key);
                                        },
                                      );
                                    }).toList(),
                                  ))
                              : const SizedBox(),
                          controller.commercial.value
                              ? Obx(() => Wrap(
                                    spacing: 8,
                                    children: controller.selectedCommercial.keys
                                        .map((String key) {
                                      bool isSelected =
                                          controller.selectedCommercial[key]!;
                                      return ChoiceChip(
                                        label: customText(
                                            text: key,
                                            color: isSelected
                                                ? whiteColor
                                                : blackColor,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 10),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        selected: isSelected,
                                        selectedColor: blackColor,
                                        backgroundColor: Colors.white,
                                        onSelected: (bool selected) {
                                          controller.toggleCommercial(key);
                                        },
                                      );
                                    }).toList(),
                                  ))
                              : const SizedBox(),
                          h15,
                          if (controller.electBill.value == null)
                            uploadImageContainer(
                                onTap: () {
                                  controller.pickElectImage();
                                },
                                text: "Upload electricity bill")
                          else
                            SizedBox(
                                height: 100,
                                child: fileImage(
                                    image: controller.electBill.value!.path,
                                    onTap: () {
                                      controller.removeElect();
                                    })),
                          h50,
                          CustomButton(
                            text: "Continue",
                            width: double.infinity,
                            borderRadius: BorderRadius.circular(50),
                            onTap: () {
                              if (controller.formKey.currentState!.validate()) {
                                if (controller.pickedImages.isEmpty) {
                                  AppUtils.errorSnackBar(
                                      "Error", "Please add property images");
                                } else if (controller.electBill.value == null) {
                                  AppUtils.errorSnackBar(
                                      "Error", "Please add electricity image");
                                } else {
                                  String propertyType = '';
                                  if (controller.home.value) {
                                    propertyType = 'Home';
                                  } else if (controller.plots.value) {
                                    propertyType = 'Plots';
                                  } else if (controller.commercial.value) {
                                    propertyType = 'Commercial';
                                  }
                                  //  String propertySubType = controller.getSelectedSubType();
                                  String selectedSubType = '';
                                  if (controller.home.value) {
                                    selectedSubType =
                                        controller.getSelectedHomeSubType();
                                  } else if (controller.plots.value) {
                                    selectedSubType =
                                        controller.getSelectedPlotsSubType();
                                  } else if (controller.commercial.value) {
                                    selectedSubType = controller
                                        .getSelectedCommercialSubType();
                                  }
                                  double? amount = double.tryParse(
                                      controller.amountController.text);
                                  controller.updateProperty(
                                    type: "Sale",
                                    city: controller.newYorkController.text,
                                    amount: amount!,
                                    address: controller.streetController.text,
                                    lat: 43.651070,  // Default Toronto latitude
                                    long: -79.347015, // Default Toronto longitude
                                    areaRange: controller.selectedArea.value
                                        .toString(),
                                    bedroom: controller.selectedBedroom.value,
                                    bathroom:
                                        controller.selectedBathrooms.value,
                                    electricityBill:
                                        controller.electBill.value!,
                                    propertyImages: controller.pickedImages,
                                    description: controller.description.text,
                                    propertyType: propertyType,
                                    propertySubType: selectedSubType,
                                  );
                                }
                              }
                            },
                          ),
                          h50,
                        ],
                      ),
                    ),
          ),)
        ),
      ),
    );
  }
}
