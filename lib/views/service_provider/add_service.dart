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
                    Obx(() => CustomDropDown(
                      value: controller.selectedCategory.value.isNotEmpty &&
                          controller.categoriesList
                              .any((category) => category['name'] == controller.selectedCategory.value)
                          ? controller.selectedCategory.value
                          : "Choose Category",
                      validator: (value) {
                        if (value == null || value == "Choose Category") {
                          return 'Choose a category';
                        }
                        return null;
                      },
                      onChange: (value) {
                        controller.selectedCategory.value = value;
                        controller.updateSubCategories(value); // Fetch subcategories based on selection

                        var selectedCategory = controller.categoriesList.firstWhere(
                              (category) => category['name'] == value,
                          orElse: () => {'id': '', 'name': 'Choose Category'},
                        );
                        controller.selectedCategoryId.value = selectedCategory['id'].toString();

                        print("selectedid ${controller.selectedCategoryId.value}");
                        // Store category ID
                      },
                      items: [
                        DropdownMenuItem<String>(
                          value: "Choose Category",
                          child: customText(
                              text: "Choose Category",
                              fontSize: 16, color: Colors.grey),
                        ),
                        ...controller.categoriesList
                            .map<DropdownMenuItem<String>>((category) {
                          return DropdownMenuItem<String>(
                            value: category['name'],
                            child: customText(text: category['name'], fontSize: 16, color: Colors.black),
                          );
                        }).toList(),
                      ],
                    )),



                    h10,

                    // Subcategory Dropdown
                    Obx(() => CustomDropDown(
                      value: controller.selectedSubCategory.value.isNotEmpty &&
                          controller.subCategoriesList
                              .any((sub) => sub['name'] == controller.selectedSubCategory.value)
                          ? controller.selectedSubCategory.value
                          : "Choose a subcategory",
                      validator: (value) {
                        if (value == null || value == "Choose a subcategory") {
                          return 'Choose a subcategory';
                        }
                        return null;
                      },
                      onChange: (value) {
                        controller.selectedSubCategory.value = value;
                      },
                      items: [
                        DropdownMenuItem<String>(
                          value: "Choose a subcategory",
                          child: customText(text: "Choose a subcategory", fontSize: 16, color: Colors.grey),
                        ),
                        ...controller.subCategoriesList
                            .map<DropdownMenuItem<String>>((sub) {
                          return DropdownMenuItem<String>(
                            value: sub['name'],
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.7, // Dynamic width
                              child: customText(text: sub['name'], fontSize: 16, color: Colors.black,   overFlow: TextOverflow.ellipsis, // Truncate long text
                              ),
                            ),
                          );
                        }).toList(),
                      ],
                    )),
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
                              if (controller.formKey.currentState!.validate()) {
                                if (controller.images.isEmpty) {
                                  AppUtils.errorSnackBar(
                                    "Select images",
                                    "Please select at least one media image",
                                    backgroundColor: Colors.red
                                  );
                                } else {
                                  var id = await Preferences.getUserID();
                                  
                                  // Format the time properly
                                  String formattedStartTime = controller.formatTimeOfDay(controller.startTime.value);
                                  String formattedEndTime = controller.formatTimeOfDay(controller.endTime.value);
                                  
                                  controller.addService(
                                    userId: id,
                                    serviceName: controller.servicesNameController.text,
                                    description: controller.descriptionController.text,
                                    pricing: controller.pricingController.text,
                                    startTime: formattedStartTime,
                                    endTime: formattedEndTime,
                                    location: controller.locationController.text,
                                    country: controller.selectedCountry.value.toString(),
                                    city: controller.cityNameController.text,
                                    lat: 223.33,
                                    long: 32.344,
                                    additionalInformation: controller.additionalInfoController.text.isEmpty
                                        ? ""
                                        : controller.additionalInfoController.text,
                                    mediaFiles: controller.images,
                                    yearsExperience: controller.yearsExperienceController.text.isEmpty
                                        ? ""
                                        : controller.yearsExperienceController.text,
                                    weekdayRange: controller.selectedWeekdayRange.value,
                                    categoryId: controller.selectedCategoryId.value
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
