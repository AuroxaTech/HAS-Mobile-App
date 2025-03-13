import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:property_app/app_constants/app_sizes.dart';
import 'package:property_app/app_constants/color_constants.dart';
import 'package:property_app/constant_widget/constant_widgets.dart';
import 'package:property_app/controllers/authentication_controller/sign_up_controller.dart';
import 'package:property_app/custom_widgets/custom_button.dart';
import 'package:property_app/custom_widgets/custom_text_field.dart';
import 'package:property_app/utils/shared_preferences/preferences.dart';
import 'package:property_app/utils/utils.dart';

import '../../app_constants/animations.dart';
import '../../controllers/services_provider_controller/add_service_controller.dart';

class AddServiceProvider extends GetView<SignUpController> {
  const AddServiceProvider({Key? key}) : super(key: key);

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
                key: controller.formKey1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: addServiceWidget(),
                    ),
                    h15,
                    // customText(
                    //   text: "Services Name : ",
                    //   fontSize: 16,
                    //   color: greyColor,
                    // ),
                    // h5,
                    // CustomTextField(
                    //   controller: controller.servicesNameController,
                    //   hintText: "Service name",
                    //   validator: (value) {
                    //     if (value == null || value.isEmpty) {
                    //       return 'Service name required';
                    //     }
                    //     return null;
                    //   },
                    // ),
                    h10,
                    customText(
                      text: "Description : ",
                      fontSize: 16,
                      color: greyColor,
                    ),
                    h5,
                    CustomTextField(
                      controller: controller.description,
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
                    // customText(
                    //   text: "City Name : ",
                    //   fontSize: 16,
                    //   color: greyColor,
                    // ),
                    // h5,
                    // CustomTextField(
                    //   controller: controller.cityNameController,
                    //   hintText: "City name",
                    //   validator: (value) {
                    //     if (value == null || value.isEmpty) {
                    //       return 'City name required';
                    //     }
                    //     return null;
                    //   },
                    // ),

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
                              if (controller.formKey1.currentState!.validate()) {
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
                                  if (controller.formKey1.currentState!.validate()) {
                                    if (controller.frontCNICImage.value == null) {
                                      AppUtils.errorSnackBar(
                                          "Please Select", "Please Select CNIC Front Image");
                                    } else if
                                    (controller.backCNICImage.value == null) {
                                      AppUtils.errorSnackBar(
                                          "Please Select", "Please Select CNIC Back Image");
                                    } else {
                                      int experience =
                                      int.parse(controller.experienceController.text);
                                      if (controller.profileImage.value == null) {
                                        if (controller.yesValue.value == "Any Certificate ?" ||
                                            controller.yesValue.value == "No") {
                                          // User has provided certification
                                          try {
                                            await controller.registerServiceProvider(
                                              fullName: controller.nameController.text,
                                              userName: controller.userNameController.text,
                                              email: controller.emailController.text,
                                              address: controller.addressController.text.isEmpty
                                                  ? "Test"
                                                  : controller.addressController.text,
                                              postalCode: controller.postalCode.text.isEmpty
                                                  ? "00000"
                                                  : controller.postalCode.text,
                                              phoneNumber: controller.phoneController.text,
                                              password: controller.passwordController.text,
                                              cPassword:
                                              controller.confirmPasswordController.text,
                                              city: controller.cityController.text,
                                              services: [controller.electricalValue.value],
                                              yearExperience:
                                              controller.experienceController.text,
                                              availabilityStartTime: formattedStartTime,
                                              availabilityEndTime: formattedStartTime,
                                              cnicFront: controller.frontCNICImage.value!,
                                              cnicBack: controller.backCNICImage.value!,
                                              description: controller.description.text,
                                              additionalInfo: controller.additionalInfo.text,
                                              serviceImages: controller.images,
                                              pricing: controller.pricingController.text, duration: controller.selectedWeekdayRange.value,
                                              country:  controller.selectedCountry.value.toString(),
                                              resume: controller.pickFile.value?.xFile,
                                            );
                                            // Registration successful, navigate or perform other actions
                                          } catch (e) {
                                            // Handle registration failure, show error message or take appropriate action
                                            print('Registration failed: $e');
                                          }
                                        } else {
                                          // User has not provided certification
                                          try {
                                            await controller.registerServiceProvider(
                                              fullName: controller.nameController.text,
                                              userName: controller.userNameController.text,
                                              email: controller.emailController.text,
                                              address: controller.addressController.text.isEmpty
                                                  ? "Test"
                                                  : controller.addressController.text,
                                              postalCode: controller.postalCode.text.isEmpty
                                                  ? "00000"
                                                  : controller.postalCode.text,
                                              phoneNumber: controller.phoneController.text,
                                              password: controller.passwordController.text,
                                              cPassword:
                                              controller.confirmPasswordController.text,
                                              city: controller.cityController.text,

                                              services: [controller.electricalValue.value],
                                              yearExperience:
                                              controller.experienceController.text,
                                              availabilityStartTime: formattedStartTime,
                                              availabilityEndTime: formattedStartTime,
                                              cnicFront: controller.frontCNICImage.value!,
                                              cnicBack: controller.backCNICImage.value!,
                                              certification: controller.yesValue.value,
                                              certificationFile:
                                              controller.certificateImage.value!,
                                              description: controller.description.text,
                                              additionalInfo: controller.additionalInfo.text,
                                              serviceImages: controller.images,
                                              pricing: controller.pricingController.text, duration: controller.selectedWeekdayRange.value,
                                              country:  controller.selectedCountry.value.toString(),
                                              resume: controller.pickFile.value?.xFile,
                                              // No certification information provided
                                            );

                                            // Registration successful, navigate or perform other actions
                                          } catch (e) {
                                            // Handle registration failure, show error message or take appropriate action
                                            print('Registration failed: $e');
                                          }
                                        }
                                      } else {
                                        if (controller.yesValue.value == "Any Certificate ?" ||
                                            controller.yesValue.value == "No") {
                                          // User has provided certification
                                          try {
                                            await controller.registerServiceProvider(
                                              address: controller.addressController.text.isEmpty
                                                  ? "Test"
                                                  : controller.addressController.text,
                                              postalCode: controller.postalCode.text.isEmpty
                                                  ? "00000"
                                                  : controller.postalCode.text,
                                              fullName: controller.nameController.text,
                                              userName: controller.userNameController.text,
                                              email: controller.emailController.text,
                                              phoneNumber: controller.phoneController.text,
                                              password: controller.passwordController.text,
                                              cPassword:
                                              controller.confirmPasswordController.text,
                                              city: controller.cityController.text,
                                              profileImage: controller.profileImage.value!,
                                              services: [controller.electricalValue.value],
                                              yearExperience: experience.toString(),
                                              availabilityStartTime: formattedStartTime,
                                              availabilityEndTime: formattedStartTime,
                                              cnicFront: controller.frontCNICImage.value!,
                                              cnicBack: controller.backCNICImage.value!,
                                              description: controller.description.text,
                                              serviceImages: controller.images,
                                              additionalInfo: controller.additionalInfo.text,
                                              pricing: controller.pricingController.text, duration: controller.selectedWeekdayRange.value,
                                              country:  controller.selectedCountry.value.toString(),
                                              resume: controller.pickFile.value?.xFile,
                                            );

                                            // Registration successful, navigate or perform other actions
                                          } catch (e) {
                                            // Handle registration failure, show error message or take appropriate action
                                            print('Registration failed: $e');
                                          }
                                        } else {
                                          // User has not provided certification
                                          try {
                                            await controller.registerServiceProvider(
                                              address: controller.addressController.text.isEmpty
                                                  ? "Test"
                                                  : controller.addressController.text,
                                              postalCode: controller.postalCode.text.isEmpty
                                                  ? "00000"
                                                  : controller.postalCode.text,
                                              fullName: controller.nameController.text,
                                              userName: controller.userNameController.text,
                                              email: controller.emailController.text,
                                              phoneNumber: controller.phoneController.text,
                                              password: controller.passwordController.text,
                                              cPassword:
                                              controller.confirmPasswordController.text,
                                              city: controller.cityController.text,

                                              profileImage: controller.profileImage.value!,
                                              services: [controller.electricalValue.value],
                                              yearExperience:
                                              controller.experienceController.text,
                                              availabilityStartTime: formattedStartTime,
                                              availabilityEndTime: formattedStartTime,

                                              cnicFront: controller.frontCNICImage.value!,
                                              cnicBack: controller.backCNICImage.value!,
                                              certification: controller.yesValue.value,
                                              certificationFile:
                                              controller.certificateImage.value!,
                                              description: controller.description.text,
                                              additionalInfo: controller.additionalInfo.text,
                                              serviceImages: controller.images,
                                              pricing: controller.pricingController.text, duration: controller.selectedWeekdayRange.value,
                                              country:  controller.selectedCountry.value.toString(),
                                              resume: controller.pickFile.value?.xFile,
                                              // No certification information provided
                                            );

                                            // Registration successful, navigate or perform other actions
                                          } catch (e) {
                                            // Handle registration failure, show error message or take appropriate action
                                            print('Registration failed: $e');
                                          }
                                        }
                                      }
                                    }
                                  }

                                }
                              }
                            },
                            height: screenHeight(context) * 0.06,
                            text: "Signup",
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
