import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_app/controllers/services_provider_controller/my_service_screen_controller.dart';

import '../../app_constants/animations.dart';
import '../../app_constants/app_sizes.dart';
import '../../app_constants/color_constants.dart';
import '../../constant_widget/constant_widgets.dart';
import '../../custom_widgets/custom_button.dart';
import '../../custom_widgets/custom_text_field.dart';
import '../../utils/utils.dart';

class MyServiceEditScreen extends GetView<MyServicesDetailScreenController> {
  const MyServiceEditScreen({super.key});

  void showSearchDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30), topRight: Radius.circular(30))),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                CustomTextField(
                  hintText: "Search Country",
                  onChanged: (value) {
                    controller.searchCountry(value);
                  },
                ),
                Expanded(
                  child: Obx(() => ListView.builder(
                        itemCount: controller.countriesList.length,
                        itemBuilder: (context, index) {
                          var country = controller.countriesList[index];
                          return ListTile(
                            title: customText(text: country, fontSize: 16),
                            onTap: () {
                              controller.selectedCountry.value = country;
                              Navigator.pop(context);
                            },
                          );
                        },
                      )),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: homeAppBar(
        context,
        text: "Service Details",
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            physics: bouncingScrollPhysic,
            child: Obx(
              () => Form(
                key: controller.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: addServiceWidget(),
                    ),
                    h15,
                    customText(
                      text: "Services Name : ",
                      fontSize: 16,
                      color: greyColor,
                    ),
                    h5,
                    CustomTextField(
                      controller: controller.servicesNameController,
                      hintText: "House clean service",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Service name required';
                        }
                        return null;
                      },
                    ),
                    h10,
                    customText(
                      text: "Description : ",
                      fontSize: 16,
                      color: greyColor,
                    ),
                    h5,
                    CustomTextField(
                      controller: controller.descriptionController,
                      minLines: 4,
                      maxLines: 6,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Description required';
                        }
                        return null;
                      },
                      hintText: "Description",
                    ),
                    h10,
                    customText(
                      text: "Price : ",
                      fontSize: 16,
                      color: greyColor,
                    ),
                    h5,
                    CustomTextField(
                      controller: controller.pricingController,
                      keyboaredtype: TextInputType.number,
                      hintText: "\$4000",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Pricing required';
                        }
                        return null;
                      },
                    ),
                    h10,
                    customText(
                      text: "Select Country : ",
                      fontSize: 16,
                      color: greyColor,
                    ),
                    h5,
                    InkWell(
                      onTap: () => showSearchDialog(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 15),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade100)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Obx(() => Text(
                                  controller.selectedCountry.value ??
                                      'Select Country',
                                  style: GoogleFonts.poppins(
                                      color: blackColor,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16),
                                )),
                            const Icon(Icons.arrow_drop_down),
                          ],
                        ),
                      ),
                    ),
                    h10,
                    customText(
                      text: "City Name : ",
                      fontSize: 16,
                      color: greyColor,
                    ),
                    h5,
                    CustomTextField(
                      controller: controller.cityNameController,
                      hintText: "City name",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'City name required';
                        }
                        return null;
                      },
                    ),
                    h10,
                    customText(
                      text: "Availability :",
                      fontSize: 16,
                      color: greyColor,
                    ),
                    h5,
                    CustomTextField(
                      hintText:
                          "Weekdays, ${controller.startTime.value.format(context)} - ${controller.endTime.value.format(context)}",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Availability required';
                        }
                        return null;
                      },
                      controller: controller.availabilityController,
                      onTap: () {
                        controller.selectDateTime(context);
                      },
                      readOnly: true,
                    ),
                    h10,
                    customText(
                      text: "Location: ",
                      fontSize: 16,
                      color: greyColor,
                    ),
                    h5,
                    CustomTextField(
                      controller: controller.locationController,
                      minLines: 2,
                      maxLines: 3,
                      hintText: "Location",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Location required';
                        }
                        return null;
                      },
                    ),
                    h10,
                    customText(
                      text: "Years of Experience : ",
                      fontSize: 16,
                      color: greyColor,
                    ),
                    h5,
                    CustomTextField(
                      controller: controller.yearsExperienceController,
                      keyboaredtype: TextInputType.number,
                      hintText: "Enter years of experience",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Years of experience required';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                    ),
                    h10,
                    customText(
                      text: "Media:",
                      fontSize: 16,
                      color: greyColor,
                    ),
                    h5,
                    if (controller.pickedImages.isEmpty)
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            SizedBox(
                              height: 100,
                              child: ListView.builder(
                                itemCount: controller.images.length,
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  final image = controller.images[index];
                                  return networkImage(
                                      image: image,
                                      onTap: () {
                                        controller.removeNetWork(index);
                                      });
                                },
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                controller.pickImages();
                              },
                              child: Container(
                                width: 90,
                                height: 95,
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  border: Border.all(color: blackColor),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.add, size: 25),
                                      customText(
                                        text: "Add",
                                        fontWeight: FontWeight.w500,
                                        fontSize: 22,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
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
                                  final image = controller.pickedImages[index];
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
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Center(
                                      child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                    h10,
                    customText(
                      text: "Optional  :",
                      fontSize: 16,
                      color: greyColor,
                    ),
                    h5,
                    CustomTextField(
                      hintText: "Additional Information  :",
                      controller: controller.additionalInfoController,
                    ),
                    h30,
                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            height: screenHeight(context) * 0.06,
                            text: "Cancel",
                            fontSize: 18,
                            gradientColor: redGradient(),
                          ),
                        ),
                        w10,
                        Expanded(
                          child: CustomButton(
                            isLoading: controller.isLoading.value,
                            onTap: () async {
                              if (controller.formKey.currentState!.validate()) {
                                controller.isLoading.value = true;
                                try {
                                  String formattedStartTime =
                                      controller.formatTimeOfDay(
                                          controller.startTime.value);
                                  String formattedEndTime =
                                      controller.formatTimeOfDay(
                                          controller.endTime.value);

                                  // Get duration from weekday range or use a default value
                                  String duration =
                                      controller.selectedWeekdayRange.value
                                          .isNotEmpty
                                      ? controller.selectedWeekdayRange.value
                                      : "Full Week"; // Use default if not selected

                                  if (controller.pickedImages.isEmpty &&
                                      controller.images.isNotEmpty) {
                                    // If no new images picked but existing images present
                                    controller.updateService(
                                      id: controller.idService.toString(),
                                      serviceName: controller
                                          .servicesNameController.text,
                                      description:
                                          controller.descriptionController.text,
                                      pricing:
                                          controller.pricingController.text,
                                      startTime: formattedStartTime,
                                      endTime: formattedEndTime,
                                      location:
                                          controller.locationController.text,
                                      country:
                                          controller.selectedCountry.value ??
                                              "",
                                      city: controller.cityNameController.text,
                                      lat: "223.33",
                                      long: "32.344",
                                      additionalInformation: controller
                                          .additionalInfoController.text,
                                      yearsExperience: controller
                                          .yearsExperienceController.text,
                                      weekdayRange: duration,
                                      duration: duration,
                                    );
                                  } else {
                                    // If new images picked
                                    controller.updateService(
                                      id: controller.idService.toString(),
                                      serviceName: controller
                                          .servicesNameController.text,
                                      description:
                                          controller.descriptionController.text,
                                      pricing:
                                          controller.pricingController.text,
                                      startTime: formattedStartTime,
                                      endTime: formattedEndTime,
                                      location:
                                          controller.locationController.text,
                                      country:
                                          controller.selectedCountry.value ??
                                              "",
                                      city: controller.cityNameController.text,
                                      lat: "223.33",
                                      long: "32.344",
                                      additionalInformation: controller
                                          .additionalInfoController.text,
                                      yearsExperience: controller
                                          .yearsExperienceController.text,
                                      weekdayRange: duration,
                                      duration: duration,
                                      mediaFiles: controller.pickedImages,
                                    );
                                  }
                                } catch (e) {
                                  print("Error updating service: $e");
                                  AppUtils.errorSnackBar("Error", e.toString());
                                } finally {
                                  controller.isLoading.value = false;
                                }
                              }
                            },
                            height: screenHeight(context) * 0.06,
                            text: "Update",
                            fontSize: 18,
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
        ),
      ),
    );
  }
}
