import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:property_app/app_constants/color_constants.dart';
import 'package:property_app/constant_widget/constant_widgets.dart';
import 'package:property_app/custom_widgets/custom_button.dart';
import '../../app_constants/animations.dart';
import '../../app_constants/app_icon.dart';
import '../../app_constants/app_sizes.dart';
import '../../controllers/land_lord/contract_controller.dart';
import '../../custom_widgets/custom_text_field.dart';
import '../../route_management/constant_routes.dart';

class ContractScreen extends GetView<ContractController> {
  const ContractScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: titleAppBar("Contract"),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Obx(() => controller.isLoadingGet.value ?
          const Center(child: CircularProgressIndicator()) :
          SingleChildScrollView (
              physics: bouncingScrollPhysic,
              child: Form(
                key: controller.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    headingText(
                      text: "Property Information :",
                      fontSize: 18,
                    ),
                    h15,
                    labelText("Landlord Name"),
                    h10,
                    CustomTextField(
                      hintText: "John",
                       readOnly: true,
                       controller: controller.landLordNameController,
                       validator: (val){
                          if(val.isEmpty || val.length < 3){
                            return "Please enter land lord name";
                          }
                       },
                    ),
                    h10,
                    labelText("Landlord Address"),
                    h10,
                    CustomTextField(
                      hintText: "Email",
                      readOnly: true,
                      controller: controller.landLordEmailController,
                      validator: (val){
                        if(val.isEmpty || val.length < 3){
                          return "Please enter land lord address";
                        }
                      },
                      prefixConstraints: BoxConstraints(
                        minWidth: Get.width * 0.12,
                        minHeight: Get.width * 0.038,
                      ),
                      prefix: SvgPicture.asset(AppIcons.city),
                    ),
                    h10,
                    labelText("Landlord Phone"),
                    h10,
                    CustomTextField(
                      hintText: "0323439323",
                      readOnly: true,
                      controller: controller.landLordPhoneController,
                      keyboaredtype: TextInputType.number,
                      validator: (val) {
                        if(val.isEmpty || val.length < 3){
                          return "Please enter land lord phone";
                        }
                      },
                    ),
                    h10,
                    labelText("Tenant Name"),
                    h10,
                    CustomTextField(
                      hintText: "Tenant Name",
                      readOnly: true,
                      controller: controller.tenantNameController,
                      validator: (val){
                        if(val.isEmpty || val.length < 3){
                          return "Please enter tenant name";
                        }
                      },
                    ),
                    h10,
                    labelText("Tenant Email"),
                    h10,
                    CustomTextField(
                      hintText: "Tenant Email",
                      readOnly: true,
                      controller: controller.tenantEmailController,
                      validator: (val){
                        if(val.isEmpty || val.length < 3){
                          return "Please enter tenant email";
                        }
                      },
                    ),
                    h10,
                    labelText("Tenant Phone"),
                    h10,
                    CustomTextField(
                      hintText: "Tenant Phone",
                      readOnly: true,
                      controller: controller.tenantPhoneController,
                      keyboaredtype: TextInputType.number,
                      validator: (val){
                        if(val.isEmpty || val.length < 3){
                          return "Please enter tenant phone";
                        }
                      },
                    ),
                    h10,

                    labelText("Tenant Address"),
                    h10,
                    CustomTextField(
                      hintText: "Tenant Address",

                      controller: controller.tenantAddressController,
                      validator: (val){
                        if(val.isEmpty || val.length < 3){
                          return "Please enter tenant address";
                        }
                      },
                    ),
                    h10,
                    labelText("Occupants"),
                    h10,
                    CustomTextField(
                      hintText: "Occupants",
                      controller: controller.occupantsController,
                      validator: (val){
                        if(val.isEmpty || val.length < 3){
                          return "Please enter occupants";
                        }
                      },
                    ),
                    h10,
                    labelText("Premises Address"),
                    h10,
                    CustomTextField(
                      hintText: "Premises Address",
                      controller: controller.premisesAddressController,
                      validator: (val){
                        if(val.isEmpty || val.length < 3){
                          return "Please enter premises address ";
                        }
                      },
                    ),
                    h10,
                    labelText("Property Types :"),
                    h10,
                    CustomDropDown(
                      value: controller.propertyType.value,
                      onChange: (value){
                        controller.propertyType.value  = value;
                      },items: ['Property Type', "Apartment", "House" , "Condo", "Townhouse" , "Other"  ]
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        onTap: (){},
                        value: value,
                        child: customText(
                            text: value,
                            fontSize: 16,
                            color: hintColor
                        ),
                      );
                    }).toList(),),
                    h10,
                    labelText("Lease start date"),
                    h10,
                    CustomTextField(
                      hintText: "11-3-2024",
                      controller: controller.leasedStartDateController,
                      validator: (val){
                        if(val.isEmpty || val.length < 3){
                          return "Please enter start date";
                        }
                      },
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: controller.selectedDate.value,
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2050),
                        );
                        if (picked != null && picked != controller.selectedDate.value) {
                          controller.selectedDate.value = picked;
                          controller.leasedStartDateController.text = DateFormat("d-M-yyyy").format(controller.selectedDate.value);
                        }
                      },
                      readOnly: true,
                    ),
                    h10,
                    labelText("Lease end date"),
                    h10,
                    CustomTextField(
                      hintText: "11-3-2025",
                      controller: controller.leaseEndDateController,
                      validator: (val){
                        if(val.isEmpty || val.length < 3){
                          return "Please enter end date";
                        }
                      },
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: controller.selectedDate.value,
                          firstDate: controller.selectedDate.value,
                          lastDate: DateTime(2050),
                        );
                        if (picked != null && picked != controller.endDate.value) {
                          controller.endDate.value = picked;
                          controller.leaseEndDateController.text = DateFormat("d-M-yyyy").format(controller.endDate.value);
                        }
                      },
                      readOnly: true,
                    ),
                    h10,
                    labelText("Leased Type"),
                    h10,
                    CustomDropDown(
                      value: controller.leasedType.value,
                      onChange: (value){
                        controller.leasedType.value  = value;
                      },items: ['Leased Type', "year-to-year" , "month-to-month" , "week-to-week" , "fixed-term"  ]
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        onTap: (){},
                        value: value,
                        child: customText(
                            text: value,
                            fontSize: 16,
                            color: hintColor
                        ),
                      );
                    }).toList(),),
                    h10,
                    labelText("Rent Amount"),
                    h10,
                    CustomTextField(
                      prefix: const IconButton(onPressed: null, icon: Icon(Icons.attach_money)),
                      hintText: "00",
                      keyboaredtype: TextInputType.number,
                      controller: controller.rentAmountController,
                      validator: (val){
                        if(val.isEmpty || val.length < 2){
                          return "Please enter amount";
                        }
                      },
                    ),
                    h10,
                    labelText("Rent Due Date"),
                    h10,
                    CustomTextField(
                      hintText: "12-4-2024",
                      controller: controller.rentDueDateController,
                      validator: (val){
                        if(val.isEmpty || val.length < 2){
                          return "Please enter rent due date";
                        }
                      },
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: controller.rentDate.value,
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2050),
                        );
                        if (picked != null && picked != controller.endDate.value) {
                          controller.endDate.value = picked;
                          controller.rentDueDateController.text = DateFormat("d-M-yyyy").format(controller.endDate.value);
                        }
                      },
                      readOnly: true,
                    ),
                    h10,
                    labelText("Rent Payment Method"),
                    h10,
                    CustomDropDown(
                      value: controller.paymentType.value,
                      onChange: (value){
                        controller.paymentType.value  = value;
                      },items: ['Payment Method', "Check", "Online Transfer" , "Cash", "Other"  ]
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        onTap: (){},
                        value: value,
                        child: customText(
                            text: value,
                            fontSize: 16,
                            color: hintColor
                        ),
                      );
                    }).toList(),),
                    h10,
                    labelText("Security Deposit Amount"),
                    h10,
                    CustomTextField(
                      prefix: const IconButton(onPressed: null, icon: Icon(Icons.attach_money)),
                      hintText: "00",
                      controller: controller.securityDepositAmountController,
                      keyboaredtype: TextInputType.number,
                      validator: (val){
                        if(val.isEmpty || val.length < 2){
                          return "Please enter security deposit amount";
                        }
                      },
                    ),
                    h10,
                    labelText("Included Utilities :"),
                    h10,
                    MultiSelectDropdown(
                      options: const ['Water', 'Gas', 'Electricity', 'Internet', 'All'],
                      onSelectionChanged: controller.handleUtilitySelection,
                    ),
                    h10,
                    labelText("Tenant Responsibilities :"),
                    h10,
                    MultiSelectDropdown(
                      options: const ['Snow Removal', 'Lawn Maintenance', 'Repairs', 'Other', ],
                      onSelectionChanged: controller.handleResponsibilitySelection,
                    ),
                    h10,
                    labelText("Emergency ContactName"),
                    h10,
                    CustomTextField(
                      hintText: "Emergency ContactName",
                      controller: controller.emergencyContactNameController,
                      validator: (val){
                        if(val.isEmpty || val.length < 2){
                          return "Please enter emergency contact";
                        }
                      },
                    ),
                    h10,
                    labelText("Emergency Contact Phone"),
                    h10,
                    CustomTextField(
                      hintText: "Emergency Contact Phone",
                      controller: controller.emergencyContactPhoneController,
                      validator: (val){
                        if(val.isEmpty || val.length < 2){
                          return "Please enter emergency contact";
                        }
                      },
                      keyboaredtype: TextInputType.number,
                    ),
                    h10,
                    labelText("Emergency Contact Address"),
                    h10,
                    CustomTextField(
                      hintText: "Emergency Contact Address",
                      controller: controller.emergencyContactAddressController,
                      validator: (val){
                        if(val.isEmpty || val.length < 2){
                          return "Please enter emergency contact address";
                        }
                      },
                    ),
                    h10,
                    labelText("Building Superintendent Name"),
                    h10,
                    CustomTextField(
                      hintText: "Superintendent Name",
                      controller: controller.buildingSuperintendentNameController,
                      validator: (val){
                        if(val.isEmpty || val.length < 2){
                          return "Please enter superintendent name";
                        }
                      },
                    ),
                    h10,
                    labelText("Building Superintendent Address"),
                    h10,
                    CustomTextField(
                      hintText: "Superintendent Address",
                      controller: controller.buildingSuperintendentAddressController,
                      validator: (val){
                        if(val.isEmpty || val.length < 2){
                          return "Please enter superintendent address";
                        }
                      },
                    ),
                    h10,
                    labelText("Building Superintendent Phone"),
                    h10,
                    CustomTextField(
                      hintText: "Superintendent Phone",
                      keyboaredtype: TextInputType.number,
                      controller: controller.buildingSuperintendentPhoneController,
                      validator: (val){
                        if(val.isEmpty || val.length < 2){
                          return "Please enter superintendent phone";
                        }
                      },
                    ),
                    h10,
                    labelText("Rent Increase Notice Period"),
                    h10,
                    CustomTextField(
                      hintText: "Notice Period",
                      controller: controller.rentIncreaseNoticePeriodPhoneController,
                      validator: (val){
                        if(val.isEmpty || val.length < 2){
                          return "Please enter rent notice period";
                        }
                      },
                    ),
                    h10,
                    labelText("Notice period for termination"),
                    h10,
                    CustomTextField(
                      hintText: "Notice Period termination",
                      controller: controller.noticePeriodForTerminationController,
                      validator: (val){
                        if(val.isEmpty || val.length < 2){
                          return "Please enter period termination";
                        }
                      },
                    ),
                    h10,
                    labelText("Late Payment fee"),
                    h10,
                    CustomTextField(
                      hintText: "Payment fee",
                      prefix: const IconButton(onPressed: null, icon: Icon(Icons.attach_money)),
                      controller: controller.latePaymentFeeController,
                      keyboaredtype: TextInputType.number,
                      validator: (val){
                        if(val.isEmpty || val.length < 2){
                          return "Please enter late payment fee";
                        }
                      },
                    ),
                    h10,
                    labelText("Rental Incentives"),
                    h10,
                    CustomTextField(
                      maxLines: 4,
                      minLines: 3,
                      hintText: "Rental Incentives",
                      controller: controller.rentalIncentivesFeeController,
                      validator: (val){
                        if(val.isEmpty || val.length < 2){
                          return "Please enter additional term";
                        }
                      },
                      // controller: controller.newYorkController,
                      //errorText: controller.newYorkField.value ? null : "Please enter city name",
                    ),
                    h10,
                    labelText("Additional Terms:"),
                    h10,
                    CustomTextField(
                      maxLines: 4,
                      minLines: 3,
                      hintText: "Additional term",
                      controller: controller.additionalTermsController,
                      validator: (val){
                        if(val.isEmpty || val.length < 2){
                          return "Please enter additional term";
                        }
                      },
                      // controller: controller.newYorkController,
                      //errorText: controller.newYorkField.value ? null : "Please enter city name",
                    ),
                    h10,
                    // labelText("Utilities :"),
                    // h10,
                    // uploadImageContainer(),
                    // h10,
                    // labelText("Type"),
                    // h10,
                    // CustomDropDown(
                    //   value: controller.type.value,
                    //   onChange: (value){
                    //     controller.type.value  = value;
                    //   },items: ['type',  ]
                    //     .map<DropdownMenuItem<String>>((String value) {
                    //   return DropdownMenuItem<String>(
                    //     onTap: (){},
                    //     value: value,
                    //     child: customText(
                    //         text: value,
                    //         fontSize: 16,
                    //         color: hintColor
                    //     ),
                    //   );
                    // }).toList(),),
                    // h10,
                    // headingText(
                    //   text: "Terms and Condition :",
                    //   fontSize: 18,
                    // ),
                    // Row(
                    //   crossAxisAlignment: CrossAxisAlignment.end,
                    //   children: [
                    //     Obx(() =>
                    //         Checkbox(
                    //         // fillColor: MaterialStateProperty.all(Colors.white),
                    //         value: controller.check.value,
                    //         side: const BorderSide(
                    //           color: blackColor, //your desire colour here
                    //           width: 1.5,
                    //         ),
                    //         onChanged: (val) {
                    //          controller.check.value = val!;
                    //         },
                    //       ),
                    //     ),
                    //     Expanded(
                    //       child: customText(
                    //         text: 'I agree to the terms and conditions of\n'
                    //             'the rental agreement',
                    //         fontWeight: FontWeight.w400,
                    //         fontSize: 14,
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    // h10,
                    // Row(
                    //   children: [
                    //     Expanded(
                    //       child: Obx(() => RadioListTile(
                    //           title: customText(
                    //             text: 'Furnished',
                    //             fontWeight: FontWeight.w400,
                    //             fontSize: 14,
                    //           ),
                    //           value: 1,
                    //           groupValue: controller.selectedPropertyType.value,
                    //           onChanged: (value) {
                    //             controller.setSelectedOption(value!);
                    //           },
                    //         ),
                    //       ),
                    //     ),
                    //     Expanded(
                    //       child: Obx(() => RadioListTile(
                    //           title: customText(
                    //             text: 'Unfurnished',
                    //             fontWeight: FontWeight.w400,
                    //             fontSize: 14,
                    //           ),
                    //           value: 2,
                    //           groupValue: controller.selectedPropertyType.value,
                    //           onChanged: (value) {
                    //             controller.setSelectedOption(value!);
                    //           },
                    //         ),
                    //       ),
                    //     ),
                    //
                    //   ],
                    // ),
                    // h10,
                    // Row(
                    //   children: [
                    //
                    //     customText(
                    //       text: "Pet Friendly",
                    //       fontWeight: FontWeight.w400,
                    //       fontSize: 16,
                    //     ),
                    //     w15,
                    //     const CircleAvatar(
                    //       radius: 8,
                    //       backgroundColor: blackColor,
                    //     ),
                    //
                    //   ],
                    // ),
                    // h10,
                    // Row(
                    //   children: [
                    //
                    //     customText(
                    //       text: "Parking Space",
                    //       fontWeight: FontWeight.w400,
                    //       fontSize: 16,
                    //     ),
                    //     w15,
                    //     const Icon(Icons.check, color: secondaryColor,)
                    //
                    //   ],
                    // ),

                    h50,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: CustomButton(
                            height: screenHeight(context) * 0.06,
                            text: "Cancel",
                            fontSize: 20,
                            gradientColor: redGradient(),
                            width: screenWidth(context) * 0.5,
                            onTap: (){
                              Get.back();
                            },
                          ),
                        ),
                        w15,
                        Expanded(
                           child: Obx(() => CustomButton(
                              height: screenHeight(context) * 0.06,
                              text: "Send",
                              fontSize: 20,
                              isLoading: controller.isLoading.value,
                              width: screenWidth(context) * 0.5,
                              onTap: (){
                                if(controller.formKey.currentState!.validate()){
                                  print("taped");
                                  controller.postContract();
                                }
                               // Get.toNamed(kContractScreen);
                              },
                                                       ),
                           ),
                        ),
                      ],
                    ),

                    h50,

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
