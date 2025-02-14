import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_app/controllers/authentication_controller/sign_up_controller.dart';
import 'package:property_app/route_management/constant_routes.dart';

import '../../app_constants/animations.dart';
import '../../app_constants/app_icon.dart';
import '../../app_constants/app_sizes.dart';
import '../../app_constants/color_constants.dart';
import '../../constant_widget/constant_widgets.dart';
import '../../custom_widgets/custom_button.dart';
import '../../custom_widgets/custom_text_field.dart';
import '../../utils/utils.dart';

class SignUpScreen extends GetView<SignUpController> {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: whiteColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: blackColor),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: Obx(() => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: SingleChildScrollView(
                physics: bouncingScrollPhysic,
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Enhanced Header
                      Center(
                        child: Column(
                          children: [
                            headingText(
                              text: "Create Account",
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                            h10,
                            customText(
                              text: "Please fill in the form to continue",
                              fontSize: 16,
                              color: greyColor,
                            ),
                          ],
                        ),
                      ),
                      h30,

                      // Enhanced Profile Image Picker
                      Center(
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: primaryColor, width: 2),
                                boxShadow: [
                                  BoxShadow(
                                    color: primaryColor.withOpacity(0.2),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: CircleAvatar(
                                radius: 60,
                                backgroundColor: Colors.white,
                                backgroundImage:
                                    controller.profileImage.value == null
                                        ? const AssetImage(AppIcons.personIcon)
                                        : FileImage(File(controller.profileImage
                                            .value!.path)) as ImageProvider,
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: () => controller.pickProfileImage(),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: primaryColor,
                                    shape: BoxShape.circle,
                                    border:
                                        Border.all(color: whiteColor, width: 2),
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt,
                                    color: whiteColor,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      h40,

                      // Enhanced Form Fields
                      FullNameTextField(
                        controller: controller.nameController,
                      ),
                      h15,

                      CustomTextField(
                        controller: controller.userNameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Username is required';
                          }
                          return null;
                        },
                        prefix:
                            const Icon(Icons.alternate_email, color: greyColor),
                        hintText: "Username",
                      ),
                      h15,

                      CustomTextField(
                        controller: controller.emailController,
                        validator: (value) => GetUtils.isEmail(value)
                            ? null
                            : 'Please enter a valid email',
                        prefix:
                            const Icon(Icons.email_outlined, color: greyColor),
                        hintText: "Email",
                      ),
                      h15,

                      PhoneNumberInput(
                        controller: controller.phoneController,
                        label: "Phone number",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a valid phone number';
                          }
                          return null;
                        },
                        onChange: (value) {
                          controller.phone = value.completeNumber;
                        },
                        onCountryChange: (country) {
                          controller.countryCode = country.dialCode;
                        },
                      ),
                      h15,

                      CustomTextField(
                        controller: controller.addressController,
                        prefix: const Icon(Icons.location_on_outlined,
                            color: greyColor),
                        hintText: "Address (Optional)",
                      ),
                      h15,

                      CustomTextField(
                        controller: controller.postalCode,
                        prefix: const Icon(Icons.local_post_office_outlined,
                            color: greyColor),
                        hintText: "Postal code (Optional)",
                      ),
                      h15,

                      CustomTextField(
                        controller: controller.passwordController,
                        isObscureText: controller.passwordObscure.value,
                        prefix:
                            const Icon(Icons.lock_outline, color: greyColor),
                        suffixIcon: IconButton(
                            onPressed: () {
                              controller.passwordObscure.value =
                                  !controller.passwordObscure.value;
                            },
                            icon: Icon(
                              controller.passwordObscure.value
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: greyColor,
                            )),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.length < 8) {
                            return 'Password must be at least 8 characters';
                          }
                          return null;
                        },
                        hintText: "Password",
                      ),
                      h15,

                      CustomTextField(
                        controller: controller.confirmPasswordController,
                        isObscureText: controller.cPasswordObscure.value,
                        prefix:
                            const Icon(Icons.lock_outline, color: greyColor),
                        suffixIcon: IconButton(
                            onPressed: () {
                              controller.cPasswordObscure.value =
                                  !controller.cPasswordObscure.value;
                            },
                            icon: Icon(
                              controller.cPasswordObscure.value
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: greyColor,
                            )),
                        validator: (value) {
                          if (value != controller.passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                        hintText: "Confirm Password",
                      ),
                      h20,

                      // Enhanced Role Selection
                      CustomDropDown(
                        value: controller.userRoleValue.value,
                        validator: (value) {
                          if (value == null || value == "Select Role") {
                            return 'Please select a role';
                          }
                          return null;
                        },
                        onChange: (value) {
                          controller.userRoleValue.value = value;
                        },
                        items: [
                          'Select Role',
                          'Landlord',
                          'Tenant',
                          'Service Provider',
                          'Visitor'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: customText(
                                text: value, fontSize: 16, color: hintColor),
                          );
                        }).toList(),
                      ),
                      h20,

                      // Role specific widgets
                      if (controller.userRoleValue.value == "Landlord")
                        landLard(context)
                      else if (controller.userRoleValue.value == "Tenant")
                        tenant(context)
                      else if (controller.userRoleValue.value ==
                          "Service Provider")
                        servicesProvider(context)
                      else if (controller.userRoleValue.value == "Visitor")
                        _buildVisitorSection(controller, context)
                      else
                        _buildDefaultSection(controller),

                      h50,
                    ],
                  ),
                ),
              ),
            )),
      ),
    );
  }

  Widget _buildVisitorSection(
      SignUpController controller, BuildContext context) {
    return Column(
      children: [
        h30,
        CustomButton(
          width: double.infinity,
          text: "Create Account",
          isLoading: controller.isLoading.value,
          btnColor: primaryColor,
          onTap: controller.isLoading.value
              ? null
              : () {
                  print("Phone Number ==> ${controller.phoneController.text}");
                  if (controller.formKey.currentState!.validate()) {
                    controller.registerVisitor(
                      context,
                      controller.nameController.text,
                      controller.userNameController.text,
                      controller.emailController.text,
                      controller.phoneController.text,
                      controller.addressController.text.isEmpty
                          ? "Test"
                          : controller.addressController.text,
                      controller.postalCode.text.isEmpty
                          ? "00000"
                          : controller.postalCode.text,
                      controller.passwordController.text,
                      controller.confirmPasswordController.text,
                      profileImage: controller.profileImage.value,
                    );
                  }
                },
        ),
      ],
    );
  }

  Widget _buildDefaultSection(SignUpController controller) {
    return Column(
      children: [
        h30,
        CustomButton(
          width: double.infinity,
          text: "Create Account",
          btnColor: primaryColor,
          onTap: () {
            if (controller.formKey.currentState!.validate()) {
              // Handle default registration
            }
          },
        ),
      ],
    );
  }

  Widget landLard(BuildContext context) {
    return Column(
      children: [
        CustomDropDown(
          validator: (value) {
            if (value == null || value == "No of Properties") {
              return 'No of Properties';
            }
            return null;
          },
          value: controller.noOfPropertiesValue.value,
          onChange: (value) {
            controller.noOfPropertiesValue.value = value;
          },
          items: [
            'No of Properties',
            "1",
            "2",
            "3",
            "4",
            "5",
            "6",
            "7",
            "8",
            "9",
            "10",
            "11",
            "12",
            "13",
            "14",
            "15"
          ].map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: customText(text: value, fontSize: 16, color: hintColor),
            );
          }).toList(),
        ),
        h15,
        CustomDropDown(
          value: controller.propertiesTypeValue.value,
          validator: (value) {
            if (value == null || value == "Choose Property Type") {
              return 'Choose property type';
            }
            return null;
          },
          onChange: (value) {
            int index = controller.items.indexOf(value) - 0;
            controller.propertiesTypeValue.value = value;
            controller.propertyTypeIndex.value = index;
          },
          items: controller.items.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: customText(text: value, fontSize: 16, color: hintColor),
            );
          }).toList(),
        ),
        h15,
        Obx(() => CustomTextField(
              readOnly: true,
              hintText:
                  '${controller.selectedWeekdayRange.value.isEmpty ? 'Select range' : controller.selectedWeekdayRange.value}, ${controller.startTime.value.format(context)} - ${controller.endTime.value.format(context)}',
              suffixIcon: IconButton(
                  onPressed: () {
                    controller.selectDateTime(context);
                  },
                  icon: const Icon(Icons.calendar_month)),
            )),
        h30,
        CustomButton(
          width: double.infinity,
          text: "Next",
          btnColor: primaryColor,
          onTap: () {
            if (controller.formKey.currentState!.validate()) {
              Get.toNamed(kAddDetailScreen);
            }
          },
        ),
      ],
    );
  }

  Widget tenant(BuildContext context) {
    return Column(
      children: [
        CustomDropDown(
          value: controller.onRentValue.value,
          validator: (value) {
            if (value == null || value == "Select last status") {
              return 'Select last status';
            }
            return null;
          },
          onChange: (value) {
            controller.onRentValue.value = value;
          },
          items: ['Select last status', 'own house', 'on rent']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: customText(text: value, fontSize: 16, color: hintColor),
            );
          }).toList(),
        ),
        h15,
        CustomTextField(
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Occupation required';
            }
            return null;
          },
          controller: controller.occupationController,
          errorText:
              controller.occupationField.value ? null : "Occupation required",
          hintText: "Occupation",
          prefix: const Icon(Icons.work_outline, color: greyColor),
        ),
        h15,
        CustomDropDown(
          value: controller.leasedDuration.value,
          validator: (value) {
            if (value == null || value == "Select Leased Duration") {
              return 'Select Leased Duration';
            }
            return null;
          },
          onChange: (value) {
            controller.leasedDuration.value = value;
          },
          items: [
            'Select Leased Duration',
            '1 to 3 months',
            '1 to 6 months',
            '1 to 9 month',
            "1 to 12 month",
            "1 to 3 year",
            "1 to 6 year"
          ].map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: customText(text: value, fontSize: 16, color: hintColor),
            );
          }).toList(),
        ),
        h15,
        CustomDropDown(
          value: controller.noOfOccupant.value,
          validator: (value) {
            if (value == null || value == "Number of Occupant") {
              return 'Number of Occupant';
            }
            return null;
          },
          onChange: (value) {
            controller.noOfOccupant.value = value;
          },
          items: [
            'Number of Occupant',
            '1 to 5',
            '1 to 10',
            '1 to 15',
            "1 to 20"
          ].map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: customText(text: value, fontSize: 16, color: hintColor),
            );
          }).toList(),
        ),
        h50,
        CustomButton(
          width: double.infinity,
          text: "Register",
          isLoading: controller.isLoading.value,
          onTap: controller.isLoading.value
              ? null
              : () async {
                  if (controller.formKey.currentState!.validate()) {
                    String occupant = controller.noOfOccupant.value;
                    if (controller.profileImage.value == null) {
                      if (controller.onRentValue.value ==
                              "Select last status" ||
                          controller.onRentValue.value == "own house") {
                        print("own house");
                        await controller.registerTenant(
                          fullName: controller.nameController.text,
                          userName: controller.userNameController.text,
                          address: controller.addressController.text.isEmpty
                              ? "Test"
                              : controller.addressController.text,
                          postalCode: controller.postalCode.text.isEmpty
                              ? "00000"
                              : controller.postalCode.text,
                          email: controller.emailController.text,
                          phoneNumber: controller.phoneController.text,
                          password: controller.passwordController.text,
                          cPassword: controller.confirmPasswordController.text,
                          role: "",
                          lastStatus: 1, // or 2 based on your scenario
                          occupation: controller.occupationController
                              .text, // provide value based on your scenario
                          leasedDuration: controller.leasedDuration
                              .value, // provide value based on your scenario
                          noOfOccupants:
                              occupant, // provide value based on your scenario
                        );
                      } else {
                        print("own rent");
                        await controller.registerTenant(
                          fullName: controller.nameController.text,
                          userName: controller.userNameController.text,
                          address: controller.addressController.text.isEmpty
                              ? "Test"
                              : controller.addressController.text,
                          postalCode: controller.postalCode.text.isEmpty
                              ? "00000"
                              : controller.postalCode.text,
                          phoneNumber: controller.phoneController.text,
                          email: controller.emailController.text,
                          password: controller.passwordController.text,
                          cPassword: controller.confirmPasswordController.text,
                          role: "",
                          lastStatus: 2,
                          // lastLandlordName: controller.lastLandLordController.text, // provide value based on your scenario
                          // lastTenancy: controller.lastTenancyController.text, // provide value based on your scenario
                          // lastLandlordContact: controller.lastLandLordContactController.text, // provide value based on your scenario
                          occupation: controller.occupationController
                              .text, // provide value based on your scenario
                          leasedDuration: controller.leasedDuration
                              .value, // provide value based on your scenario
                          noOfOccupants:
                              occupant, // provide value based on your scenario
                        );
                      }
                    } else {
                      print("tenenat profile image");
                      if (controller.onRentValue.value ==
                              "Select last status" ||
                          controller.onRentValue.value == "own house") {
                        print("own house");
                        await controller.registerTenant(
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
                          cPassword: controller.confirmPasswordController.text,
                          role: "",
                          profileImage: controller.profileImage.value!,
                          lastStatus: 2, // or 2 based on your scenario
                          occupation: controller.occupationController
                              .text, // provide value based on your scenario
                          leasedDuration: controller.leasedDuration
                              .value, // provide value based on your scenario
                          noOfOccupants:
                              occupant, // provide value based on your scenario
                        );
                      } else {
                        print("own rent");
                        await controller.registerTenant(
                          address: controller.addressController.text.isEmpty
                              ? "Test"
                              : controller.addressController.text,
                          postalCode: controller.postalCode.text.isEmpty
                              ? "00000"
                              : controller.postalCode.text,
                          fullName: controller.nameController.text,
                          userName: controller.userNameController.text,
                          phoneNumber: controller.phoneController.text,
                          email: controller.emailController.text,
                          password: controller.passwordController.text,
                          cPassword: controller.confirmPasswordController.text,
                          role: "",
                          profileImage: controller.profileImage.value!,
                          lastStatus: 1,
                          // lastLandlordName: controller.lastLandLordController.text, // provide value based on your scenario
                          // lastTenancy: controller.lastTenancyController.text, // provide value based on your scenario
                          // lastLandlordContact: controller.lastLandLordContactController.text, // provide value based on your scenario
                          occupation: controller.occupationController
                              .text, // provide value based on your scenario
                          leasedDuration: controller.leasedDuration
                              .value, // provide value based on your scenario
                          noOfOccupants:
                              occupant, // provide value based on your scenario
                        );
                      }
                    }
                  }

                  //Get.toNamed(kTenantDashboard);
                },
        ),
        h30,
      ],
    );
  }

  Widget servicesProvider(context) {
    return Column(
      children: [
        CustomDropDown(
          value: controller.electricalValue.value,
          validator: (value) {
            if (value == null || value == "Choose service") {
              return 'Please Choose service';
            }
            return null;
          },
          onChange: (value) {
            controller.electricalValue.value = value;
          },
          items: [
            'Choose service',
            'Electrician',
            'Plumber',
            'Tailor',
            "Cleaner"
          ].map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              onTap: () {},
              value: value,
              child: customText(text: value, fontSize: 16, color: hintColor),
            );
          }).toList(),
        ),
        controller.electricalValue.value == "Choose service"
            ? const SizedBox()
            : h15,
        controller.electricalValue.value == "Choose service"
            ? const SizedBox()
            : CustomTextField(
                controller: controller.experienceController,
                keyboaredtype: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter experience';
                  }
                  return null;
                },
                errorText: controller.experienceField.value
                    ? null
                    : "Experience Required",
                hintText: "Years of Experience",
              ),
        controller.electricalValue.value == "Choose service"
            ? const SizedBox()
            : h15,
        controller.electricalValue.value == "Choose service"
            ? const SizedBox()
            : CustomTextField(
                readOnly: true,
                onTap: () {
                  controller.selectDateTime(context);
                },
                hintText:
                    'Weekdays, ${controller.startTime.value.format(context)} - ${controller.endTime.value.format(context)}',
                suffixIcon: IconButton(
                    onPressed: () {
                      controller.selectDateTime(context);
                    },
                    icon: const Icon(Icons.calendar_month)),
              ),
        h15,
        CustomDropDown(
          value: controller.yesValue.value,
          onChange: (value) {
            controller.yesValue.value = value;
          },
          items: ['Any Certificate ?', 'Yes', 'No']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              onTap: () {},
              value: value,
              child: customText(text: value, fontSize: 16, color: hintColor),
            );
          }).toList(),
        ),
        h15,
        controller.yesValue.value == "Any Certificate ?" ||
                controller.yesValue.value == "No"
            ? const SizedBox()
            : Align(
                alignment: Alignment.bottomLeft,
                child: customText(
                  text: "Any Certificate ? (optional)",
                  fontSize: 12,
                  color: blackColor,
                ),
              ),
        controller.yesValue.value == "Any Certificate ?" ||
                controller.yesValue.value == "No"
            ? const SizedBox()
            : h15,
        controller.yesValue.value == "Any Certificate ?" ||
                controller.yesValue.value == "No"
            ? const SizedBox()
            : controller.certificateImage.value == null
                ? uploadImageContainer(
                    onTap: () {
                      controller.pickCertificate();
                    },
                    text: "Upload File")
                : Container(
                    width: double.infinity,
                    height: 130,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                            image: FileImage(
                              File(controller.certificateImage.value!.path),
                            ),
                            fit: BoxFit.fill)),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {
                                controller.certificateImage.value = null;
                              },
                              child: Container(
                                width: 35,
                                height: 35,
                                decoration: BoxDecoration(
                                    color: whiteColor,
                                    borderRadius: BorderRadius.circular(10)),
                                child: const Icon(Icons.delete),
                              ),
                            ),
                            w5,
                            InkWell(
                              onTap: () {
                                controller.pickCertificate();
                              },
                              child: Container(
                                width: 35,
                                height: 35,
                                decoration: BoxDecoration(
                                    color: whiteColor,
                                    borderRadius: BorderRadius.circular(10)),
                                child: const Icon(Icons.edit),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
        h15,
        Align(
          alignment: Alignment.bottomLeft,
          child: customText(
            text: "Select CNIC Front Image",
            fontSize: 12,
            color: blackColor,
          ),
        ),
        h15,
        controller.frontCNICImage.value == null
            ? uploadImageContainer(
                onTap: () {
                  controller.frontCNIC();
                },
                text: "CNIC Front")
            : Container(
                width: double.infinity,
                height: 130,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                        image: FileImage(
                          File(controller.frontCNICImage.value!.path),
                        ),
                        fit: BoxFit.fill)),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {
                            controller.frontCNICImage.value = null;
                          },
                          child: Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                                color: whiteColor,
                                borderRadius: BorderRadius.circular(10)),
                            child: const Icon(Icons.delete),
                          ),
                        ),
                        w5,
                        InkWell(
                          onTap: () {
                            controller.pickCertificate();
                          },
                          child: Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                                color: whiteColor,
                                borderRadius: BorderRadius.circular(10)),
                            child: const Icon(Icons.edit),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
        h15,
        Align(
          alignment: Alignment.bottomLeft,
          child: customText(
            text: "Select CNIC Back Image",
            fontSize: 12,
            color: blackColor,
          ),
        ),
        h15,
        controller.backCNICImage.value == null
            ? uploadImageContainer(
                onTap: () {
                  controller.backCNIC();
                },
                text: "CNIC Back")
            : Container(
                width: double.infinity,
                height: 130,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                        image: FileImage(
                          File(controller.backCNICImage.value!.path),
                        ),
                        fit: BoxFit.fill)),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {
                            controller.backCNICImage.value = null;
                          },
                          child: Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                                color: whiteColor,
                                borderRadius: BorderRadius.circular(10)),
                            child: const Icon(Icons.delete),
                          ),
                        ),
                        w5,
                        InkWell(
                          onTap: () {
                            controller.pickCertificate();
                          },
                          child: Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                                color: whiteColor,
                                borderRadius: BorderRadius.circular(10)),
                            child: const Icon(Icons.edit),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
        h15,
        Align(
          alignment: Alignment.bottomLeft,
          child: customText(
            text: "Upload a Resume",
            fontSize: 12,
            color: blackColor,
          ),
        ),
        h15,
        controller.pickFile.value == null
            ? uploadImageContainer(
                onTap: () {
                  controller.pickFiles();
                },
                text: "Upload Resume")
            : Container(
                width: double.infinity,
                height: 130,
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 1.0,
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {
                                controller.pickFile.value = null;
                              },
                              child: Container(
                                width: 35,
                                height: 35,
                                decoration: BoxDecoration(
                                    color: whiteColor,
                                    borderRadius: BorderRadius.circular(10)),
                                child: const Icon(Icons.delete),
                              ),
                            ),
                            w5,
                            InkWell(
                              onTap: () {
                                controller.pickFiles();
                              },
                              child: Container(
                                width: 35,
                                height: 35,
                                decoration: BoxDecoration(
                                    color: whiteColor,
                                    borderRadius: BorderRadius.circular(10)),
                                child: const Icon(Icons.edit),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned.fill(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                            child: controller
                                .getFileIcon(controller.pickFile.value!.name)),
                        h10,
                        Center(
                          child: customText(
                              text: controller.pickFile.value!.name,
                              fontSize: 18),
                        ),
                      ],
                    ))
                  ],
                ),
              ),
        h50,
        CustomButton(
          width: double.infinity,
          text: "Register",
          isLoading: controller.isLoading.value,
          onTap: controller.isLoading.value
              ? null
              : () async {
                  if (controller.formKey.currentState!.validate()) {
                    if (controller.frontCNICImage.value == null) {
                      AppUtils.errorSnackBar(
                          "Please Select", "Please Select CNIC Front Image");
                    } else if (controller.backCNICImage.value == null) {
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
                              services: controller.electricalValue.value,
                              yearExperience:
                                  controller.experienceController.text,
                              availabilityStartTime: controller
                                      .selectedWeekdayRange.value +
                                  controller.startTime.value.format(context),
                              availabilityEndTime:
                                  controller.endTime.value.format(context),
                              cnicFront: controller.frontCNICImage.value!,
                              cnicBack: controller.backCNICImage.value!,
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
                              services: controller.electricalValue.value,
                              yearExperience:
                                  controller.experienceController.text,
                              availabilityStartTime: controller
                                      .selectedWeekdayRange.value +
                                  controller.startTime.value.format(context),
                              availabilityEndTime:
                                  controller.endTime.value.format(context),
                              cnicFront: controller.frontCNICImage.value!,
                              cnicBack: controller.backCNICImage.value!,
                              certification: controller.yesValue.value,
                              certificationFile:
                                  controller.certificateImage.value!,
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
                              profileImage: controller.profileImage.value!,
                              services: controller.electricalValue.value,
                              yearExperience: experience.toString(),
                              availabilityStartTime:
                                  controller.startTime.value.format(context),
                              availabilityEndTime:
                                  controller.endTime.value.format(context),
                              cnicFront: controller.frontCNICImage.value!,
                              cnicBack: controller.backCNICImage.value!,
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
                              profileImage: controller.profileImage.value!,
                              services: controller.electricalValue.value,
                              yearExperience:
                                  controller.experienceController.text,
                              availabilityStartTime:
                                  controller.startTime.value.format(context),
                              availabilityEndTime:
                                  controller.endTime.value.format(context),
                              cnicFront: controller.frontCNICImage.value!,
                              cnicBack: controller.backCNICImage.value!,
                              certification: controller.yesValue.value,
                              certificationFile:
                                  controller.certificateImage.value!,
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
                },
        ),
        h50,
      ],
    );
  }
}
