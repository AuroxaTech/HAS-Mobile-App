import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:property_app/constant_widget/constant_widgets.dart';
import 'package:property_app/custom_widgets/custom_text_field.dart';

import '../../app_constants/app_sizes.dart';
import '../../app_constants/color_constants.dart';
import '../../controllers/services_provider_controller/ew_service_request_controller.dart';
import '../../custom_widgets/custom_button.dart';

class NewServiceRequestScreen
    extends GetView<NewServiceRequestScreenController> {
  const NewServiceRequestScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: homeAppBar(
        context,
        text: "New Service Request",
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child: Form(
              key: controller.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  circleAvatar(
                      text: "Service Requests",
                      icon: FontAwesomeIcons.clipboardList),
                  h15,
                  ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(controller.data[5]),
                    ),
                    title: customText(
                        text: controller.data[0],
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                    subtitle: customText(
                      text: controller.data[2],
                      fontSize: 16,
                    ),
                  ),
                  h5,
                  customText(
                    text: "Requester Details :",
                    fontSize: 16,
                  ),
                  h10,
                  customText(
                    text: "Name :",
                    fontSize: 16,
                  ),
                  h10,
                  CustomTextField(
                    hintText: "James ",
                    controller: controller.nameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Name is required";
                      }
                      return null;
                    },
                  ),
                  h10,
                  customText(
                    text: "Contact no : ",
                    fontSize: 16,
                  ),
                  h10,
                  CustomTextField(
                    controller: controller.contactController,
                    hintText: "+1 23-6548-98",
                    keyboaredtype: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Contact is required";
                      }
                      return null;
                    },
                  ),
                  h10,
                  customText(
                    text: "Email Address :",
                    fontSize: 16,
                  ),
                  h10,
                  CustomTextField(
                    hintText: "James345@gmail.com",
                    controller: controller.emailController,
                    validator: (value) =>
                        emailValidation(controller.emailController.text)
                            ? null
                            : 'Email is incorrect',
                  ),

                  h10,
                  customText(
                    text: "Property Details :",
                    fontSize: 16,
                  ),
                  h10,
                  customText(
                    text: "Address :",
                    fontSize: 16,
                  ),
                  h10,
                  CustomTextField(
                    hintText: "Gunnersbury House , 1 Chapel Hill",
                    controller: controller.addressController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Address is required";
                      }
                      return null;
                    },
                  ),

                  h10,
                  h10,
                  customText(
                    text: "Postal Code :",
                    fontSize: 16,
                  ),
                  h10,
                  CustomTextField(
                    hintText: "Postal Code",
                    controller: controller.postalCodeController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Postal Code is required";
                      }
                      return null;
                    },
                  ),

                  h10,
                  labelText("Property type :"),
                  h10,
                  CustomDropDown(
                    value: controller.propertyType.value,
                    validator: (value) {
                      if (value == null || value == "Choose Property Type") {
                        return 'Choose property type';
                      }
                      return null;
                    },
                    onChange: (value) {
                      int index = controller.items.indexOf(value) - 0;

                      controller.propertyType.value = value;
                      controller.propertyTypeIndex.value = index;
                      print(controller.propertyType.value);
                    },
                    items: controller.items
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        onTap: () {},
                        value: value,
                        child: customText(
                            text: value, fontSize: 16, color: hintColor),
                      );
                    }).toList(),
                  ),

                  // h10,
                  // customText(
                  //   text: "Price :",
                  //   fontSize: 16,
                  // ),
                  // h10,
                  // CustomTextField(
                  //   hintText: "\$400",
                  //   controller: controller.priceController,
                  //   keyboaredtype: TextInputType.number,
                  //   validator: (value) {
                  //     if (value == null || value.isEmpty) {
                  //       return "Price is required";
                  //     }
                  //     return null;
                  //   },
                  // ),
                  h10,
                  customText(
                    text: "Description :",
                    fontSize: 16,
                  ),
                  h10,
                  CustomTextField(
                    minLines: 3,
                    maxLines: 4,
                    controller: controller.descriptionController,
                    hintText: "Description",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Description is required";
                      }
                      return null;
                    },
                  ),
                  h10,
                  labelText("Preferred  Date & Time :"),
                  h10,
                  Obx(
                    () => CustomTextField(
                      readOnly: true,
                      onTap: () {
                        controller.selectDateTime(context);
                      },
                      hintText: controller.selectedOption.value.isEmpty
                          ? 'Select days and time'
                          : controller.getSelectedTimeRangeText,
                      suffixIcon: IconButton(
                        onPressed: () {
                          controller.selectDateTime(context);
                        },
                        icon: const Icon(Icons.calendar_month),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                  // Obx(() {
                  //   return Text(
                  //     'Selected: ${controller.selectedWeekdayRange.value}, ${controller.startTime.value.format(context)} - ${controller.endTime.value.format(context)}',
                  //     style: TextStyle(fontSize: 16),
                  //   );
                  // }),
                  h10,
                  labelText("Additional Instructions: (Optional)"),
                  h10,
                  CustomTextField(
                    minLines: 3,
                    maxLines: 4,
                    controller: controller.instructionController,
                    hintText: "Instructions:",
                  ),
                  h10,
                  h30,
                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          height: 45,
                          text: "Cancel",
                          fontSize: 18,
                          gradientColor: redGradient(),
                          onTap: () {
                            Get.back();
                          },
                        ),
                      ),
                      w15,
                      Obx(
                        () => Expanded(
                          child: CustomButton(
                            isLoading: controller.isLoading.value,
                            onTap: () {
                              if (controller.formKey.currentState!.validate()) {
                                controller.newServiceRequest(
                                    serviceName: controller.data[0],
                                    serviceId: controller.data[4].toString(),
                                    providerId: controller.data[3].toString(),
                                    location: controller.addressController.text,
                                    lat: 33.3334,
                                    lng: 77.3843,
                                    propertyType: controller
                                        .propertyTypeIndex.value
                                        .toString(),
                                    duration:
                                        controller.selectedDays.join(', '),
                                    startTime: _formatTimeOfDay(
                                        controller.startTime.value),
                                    endTime: _formatTimeOfDay(
                                        controller.endTime.value),
                                    description:
                                        controller.descriptionController.text,
                                    additionalInfo: controller
                                            .instructionController.text.isEmpty
                                        ? ""
                                        : controller.instructionController.text,
                                    country: "Canada",
                                    city: controller.addressController.text
                                        .split(',')
                                        .last
                                        .trim(),
                                    yearExperience:
                                        controller.data[8].toString(),
                                    cnicFrontPic: controller.data[9].toString(),
                                    cnicBackPic: controller.data[10].toString(),
                                    certification:
                                        controller.data[11].toString(),
                                    resume: controller.data[12].toString(),
                                    price: controller.data[13],
                                    serviceImages: controller.data[14],
                                    isApplied: 1);
                              }
                            },
                            height: 45,
                            text: "Submit request",
                            fontSize: 18,
                            gradientColor: gradient(),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

String _formatTimeOfDay(TimeOfDay time) {
  final hour = time.hourOfPeriod;
  final minute = time.minute.toString().padLeft(2, '0');
  final period = time.period == DayPeriod.am ? 'AM' : 'PM';
  return '${hour == 0 ? 12 : hour}:$minute $period';
}
