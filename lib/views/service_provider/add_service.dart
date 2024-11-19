import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_app/app_constants/app_sizes.dart';
import 'package:property_app/app_constants/color_constants.dart';
import 'package:property_app/constant_widget/constant_widgets.dart';
import 'package:property_app/custom_widgets/custom_button.dart';
import 'package:property_app/custom_widgets/custom_text_field.dart';
import 'package:property_app/utils/shared_preferences/preferences.dart';
import 'package:property_app/utils/utils.dart';

import '../../app_constants/animations.dart';
import '../../controllers/services_provider_controller/add_service_controller.dart';

class AddServiceScreen extends GetView<AddServiceController> {
  const AddServiceScreen({Key? key}) : super(key: key);
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
                            title: customText(
                                text: country, fontSize: 16, color: blackColor),
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
      appBar: homeAppBar(context, text: "Add Service"),
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
                      hintText: "Service name",
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
                          '${controller.selectedWeekdayRange.value.isEmpty ? 'Select range' : controller.selectedWeekdayRange.value}, ${controller.startTime.value.format(context)} - ${controller.endTime.value.format(context)}',
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
                      text: "Address: ",
                      fontSize: 16,
                      color: greyColor,
                    ),
                    h5,
                    CustomTextField(
                      controller: controller.locationController,
                      minLines: 2,
                      maxLines: 3,
                      hintText: "Address",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Address required';
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
                    if (controller.images.isEmpty)
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
                                itemCount: controller.images.length,
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  final image = controller.images[index];
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
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: gradient(),
                                ),
                                child: const Center(
                                  child: FaIcon(
                                    FontAwesomeIcons.toolbox,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    h10,
                    customText(
                      text: "Optional :",
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
                            height: screenHeight(context) * 0.06,
                            text: "Cancel",
                            fontSize: 18,
                            gradientColor: redGradient(),
                            onTap: () {
                              Get.back();
                            },
                          ),
                        ),
                        w10,
                        Expanded(
                          child: CustomButton(
                            isLoading: controller.isLoading.value,
                            onTap: () async {
                              //   controller.uploadDataWithImages(
                              //   userId: "10",
                              //   serviceName: controller.servicesNameController.text,
                              //   description: controller.descriptionController.text,
                              //   categoryId: "1",
                              //   pricing: controller.pricingController.text,
                              //   durationId: controller.durationController.text,
                              //   startTime: "3 e",
                              //   endTime: "34",
                              //   location: controller.locationController.text,
                              //   lat: "2333.443",
                              //   long: "2334.344",
                              //   additionalInformation: controller.additionalInfoController.text,
                              //   mediaFiles: controller.images,
                              // );
                              if (controller.formKey.currentState!.validate()) {
                                if (controller.images.isEmpty) {
                                  AppUtils.errorSnackBar("Select images",
                                      "Please select at least one media image",
                                      backgroundColor: Colors.red);
                                } else {
                                  var id = await Preferences.getUserID();
                                  controller.addService(
                                    userId: id,
                                    serviceName:
                                        controller.servicesNameController.text,
                                    description:
                                        controller.descriptionController.text,
                                    pricing: controller.pricingController.text,
                                    startTime: controller.selectedWeekdayRange +
                                        controller.startTime.value
                                            .format(context),
                                    endTime: controller.endTime.value
                                        .format(context),
                                    location:
                                        controller.locationController.text,
                                    country: controller.selectedCountry.value
                                        .toString(),
                                    city: controller.cityNameController.text,
                                    lat: 223.33,
                                    long: 32.344,
                                    additionalInformation: controller
                                            .additionalInfoController
                                            .text
                                            .isEmpty
                                        ? ""
                                        : controller
                                            .additionalInfoController.text,
                                    mediaFiles: controller.images,
                                  );
                                }
                              }
                            },
                            height: screenHeight(context) * 0.06,
                            text: "Submit",
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

class SearchableDropdown extends StatefulWidget {
  @override
  _SearchableDropdownState createState() => _SearchableDropdownState();
}

class _SearchableDropdownState extends State<SearchableDropdown> {
  String? selectedCountry;

  final List<String> countries = [
    'Afghanistan',
    'Albania',
    'Algeria',
    'Andorra',
    'Angola',
    // Add more countries as needed
  ];
  void showSearchDialog() {
    // Temporary list to hold search results
    List<String> tempSearchList = List.from(countries);

    // Show the modal bottom sheet
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return StatefulBuilder(
          // This is used to update the modal's state
          builder: (BuildContext context, StateSetter setState) {
            return Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Search Country',
                      suffixIcon: Icon(Icons.search),
                    ),
                    onChanged: (value) {
                      // Update the search list based on the search query
                      setState(() {
                        tempSearchList = countries
                            .where((country) => country
                                .toLowerCase()
                                .contains(value.toLowerCase()))
                            .toList();
                      });
                    },
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: tempSearchList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: customText(
                            text: tempSearchList[index], color: blackColor),
                        onTap: () {
                          setState(() {
                            selectedCountry = tempSearchList[index];
                          });
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    ).then((value) {
      // Update the main state when the bottom sheet is closed
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: showSearchDialog,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            customText(
                text: selectedCountry ?? 'Select Country', color: blackColor),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }
}
