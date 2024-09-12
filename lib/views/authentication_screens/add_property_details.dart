import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:property_app/app_constants/app_icon.dart';
import 'package:property_app/app_constants/app_sizes.dart';
import 'package:property_app/app_constants/color_constants.dart';
import 'package:property_app/constant_widget/constant_widgets.dart';
import 'package:property_app/controllers/authentication_controller/sign_up_controller.dart';
import 'package:property_app/custom_widgets/custom_button.dart';
import 'package:property_app/custom_widgets/custom_text_field.dart';
import 'package:property_app/utils/utils.dart';
import 'package:property_app/views/locations/location_screen.dart';

import '../../app_constants/animations.dart';

class AddPropertyDetailScreen extends GetView<SignUpController> {
  const AddPropertyDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: titleAppBar("Add Property Details", ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: Obx(
            () => SingleChildScrollView(
              physics: bouncingScrollPhysic,
              child: Form(
                key: controller.formKeyDetail,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        imageButton(
                            padding:const EdgeInsets.only(top: 5, bottom: 5),
                            onTap: () {
                              controller.isSale.value = false;
                            },
                            borderColor: controller.isSale.value ? bluishWhite : primaryColor,
                            textColor: controller.isSale.value ? blackColor : primaryColor,
                            imageColor: controller.isSale.value ? blackColor : primaryColor,
                            width: 100,
                            text: "Sale",
                            image: AppIcons.sale),
                        const SizedBox(
                          width: 20,
                        ),
                        imageButton(
                            padding:const EdgeInsets.only(top: 5, bottom: 5),
                            onTap: () {
                              controller.isSale.value = true;
                            },
                            width: 100,
                            text: "Rent",
                            borderColor: controller.isSale.value ? primaryColor : bluishWhite,
                            textColor: controller.isSale.value ? primaryColor : blackColor,
                            imageColor: controller.isSale.value ? primaryColor : blackColor,
                            image: AppIcons.rent),
                      ],
                    ),
                    h15,
                    if (controller.images.isEmpty)
                      uploadImageContainer(onTap: (){
                        controller.pickImages();
                      },)
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
                                  return fileImage(image: image.path, onTap: () {
                                    controller.removeImage(index);
                                  });
                                },
                              ),
                            ),
                            // Add your additional button here
                            InkWell(
                              onTap: (){
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
                                  child: Center(child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.add, size: 25,),
                                      customText(
                                          text: "Add",
                                          fontWeight: FontWeight.w500,
                                          fontSize: 22
                                      ),

                                    ],
                                  ))
                              ),
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
                      errorText: controller.newYorkField.value ? null : "Please enter city name",
                      validator: (value) {
                        if (value == null || value.isEmpty || value.length < 3) {
                          return 'Please enter city name';
                        }
                        return null;
                      },
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

                      keyboaredtype: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty || value.length < 1) {
                          return 'Please enter amount';
                        }
                        return null;
                      },
                      controller: controller.amountController,
                      errorText: controller.amountField.value ? null : "Please enter amount",
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
                      validator: (value) {
                        if (value == null || value.isEmpty || value.length < 1) {
                          return 'Please enter street';
                        }
                        return null;
                      },
                      readOnly: true,
                      onTap: ()async{
                        var result = await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const LocationScreen()),
                        );
                        if (result != null) {
                            controller.selectedAddress = result['address'];
                            controller.selectedLat = result['latitude'];
                            controller.selectedLng = result['longitude'];
                            controller.addressPostalCode = result['postalCode'];
                            controller.streetController.text =  controller.selectedAddress;
                            controller.postalAddressController.text =  controller.addressPostalCode;

                            print(controller.selectedAddress);
                            print(controller.selectedLat);
                            print(controller.selectedLng);
                            print( "Postal Code  ${controller.addressPostalCode}");
                        }
                      },
                      controller: controller.streetController,
                      errorText: controller.streetField.value ? null : "Please enter street",
                      hintText: "Main Canadian street",
                      suffixIcon: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SvgPicture.asset(AppIcons.location),
                      ),
                    ),
                   controller.addressPostalCode == "" ?  const SizedBox() : h15,
                    controller.addressPostalCode == "" ?  const SizedBox() :  labelText("Postal Code"),
                    controller.addressPostalCode == "" ?  const SizedBox() :   h10,
                    controller.addressPostalCode == "" ?  const SizedBox() :
                    CustomTextField(
                      hintText: "Postal Code",
                      keyboaredtype: TextInputType.number,
                      controller: controller.postalAddressController,
                      prefixConstraints: BoxConstraints(
                        minWidth: Get.width * 0.12,
                        minHeight: Get.width * 0.038,
                      ),
                      suffixIcon: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SvgPicture.asset(AppIcons.location),
                      ),
                    ),
                    h15,
                    labelText("Area Range"),
                    h10,
                    Obx(() => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: CustomBorderTextField(
                            keyboaredtype: TextInputType.number,
                            labelText: 'Min Area (sq ft)',
                            labelStyle: const TextStyle(fontSize: 15,color: Colors.black),
                            initialValue: controller.currentRange.value.start.round().toString(),
                            onChanged: (value) {
                              double? minValue = double.tryParse(value);
                              if (minValue != null && minValue >= 1 && minValue <= controller.currentRange.value.end) {
                                controller.currentRange.value = RangeValues(minValue, controller.currentRange.value.end);
                                print("Min Range ${controller.currentRange.value.start}");
                              } else {
                                // Handle invalid input if necessary
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: CustomBorderTextField(
                            keyboaredtype: TextInputType.number,
                            labelText: 'Max Area (sq ft)',
                            labelStyle: const TextStyle(fontSize: 15,color: Colors.black),
                            initialValue: controller.currentRange.value.end.round().toString(),
                            onChanged: (value) {
                              double? maxValue = double.tryParse(value);
                              if (maxValue != null && maxValue >= controller.currentRange.value.start && maxValue <= 1000) {
                                controller.currentRange.value = RangeValues(controller.currentRange.value.start, maxValue);
                                controller.selectedRange.value = maxValue.toString();
                                print("Max Range ${controller.currentRange.value.end}");
                              } else {
                                // Handle invalid input if necessary
                              }
                            },
                          ),
                        ),
                      ],
                    )),


                    // h10,
                    // SizedBox(
                    //   height: 35,
                    //   child: ListView.builder(
                    //     itemCount: controller.areaRange.length,
                    //     shrinkWrap: true,
                    //     scrollDirection: Axis.horizontal,
                    //     itemBuilder: (context, index) {
                    //       return Obx(
                    //         () => Row(
                    //           children: [
                    //             roundedSmallButton(
                    //               text: controller.areaRange[index],
                    //               isSecondText: true,
                    //               isSelected:
                    //                   controller.selectedArea.value == index,
                    //               onTap: () {
                    //                 controller.selectedArea.value = index;
                    //                 controller.selectedRange.value = controller.areaRange[index];
                    //               }
                    //             ),
                    //             const SizedBox(width: 15),
                    //           ],
                    //         ),
                    //       );
                    //     },
                    //   ),
                    // ),
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
                        itemCount: controller.bathroomsList.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Obx(
                                () => Row(
                              children: [
                                roundedSmallButton(
                                    text:controller.bathroomsList[index],
                                    isSelected:
                                    controller.selectedBathrooms.value == index,
                                    onTap: () {
                                      controller.selectedBathrooms.value = index;
                                      controller.selectedBothList.value = controller.bathroomsList[index];
                                    }
                                ),
                                const SizedBox(width: 15),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    h15,
                    labelText("Description"),
                    h10,
                    CustomTextField(
                      maxLines: 5,
                      minLines: 3,
                      validator: (value) {
                        if (value == null || value.isEmpty || value.length < 3) {
                          return 'Description Required';
                        }
                        return null;
                      },
                      controller: controller.description,
                      hintText: "Clean and Minimalistic House , with modern interior and exterior built in the centre of city with modern facilities",
                    ),
                    h50,
                    CustomButton(
                      width: double.infinity,
                      text: "Register",
                      isLoading: controller.isLoading.value,
                      onTap: (){
                        if(controller.formKeyDetail.currentState!.validate()){
                          if(controller.images.length > 4){
                            double amount = double.parse(controller.amountController.text);
                            int nofProp = int.parse(controller.noOfPropertiesValue.value);
                            if(controller.profileImage.value == null){
                              controller.registerProperty(
                                fullName: controller.nameController.text,
                                userName: controller.userNameController.text,
                                email: controller.emailController.text,
                                phoneNumber: controller.phoneController.text,
                                password: controller.passwordController.text,
                                cPassword: controller.confirmPasswordController.text,
                                roleId: 1,
                                type: controller.isSale.value ? 1 : 2,
                                city: controller.newYorkController.text,
                                amount: amount,
                                address: controller.addressController.text.isEmpty ? "Test" : controller.addressController.text,
                                postalCode:  controller.postalCode.text.isEmpty ? "00000" : controller.postalCode.text,
                                lat: controller.selectedLat,
                                long: controller.selectedLng,
                                areaRange: controller.selectedRange.value,
                                bedroom: controller.selectedBedroom.value,
                                bathroom: controller.selectedBothList.value,
                                electricityBill: controller.images[0],
                                propertyImages: controller.images,
                                noOfProperty: nofProp,
                                propertyType: controller.propertyTypeIndex.value.toString(),
                                availabilityStartTime: controller.startTime.value.format(context),
                                availabilityEndTime: controller.endTime.value.format(context),
                                description: controller.description.text,
                                subType: 1.toString(),

                              );
                            }
                            else{
                              controller.registerProperty(
                                fullName: controller.nameController.text,
                                userName: controller.userNameController.text,
                                email: controller.emailController.text,
                                phoneNumber: controller.phoneController.text,
                                password: controller.passwordController.text,
                                cPassword: controller.confirmPasswordController.text,
                                roleId: 1,
                                profileImage: controller.profileImage.value!,
                                type: controller.isSale.value ? 1 : 2,
                                city: controller.newYorkController.text,
                                amount: amount,
                                address: controller.addressController.text.isEmpty ? "Test" : controller.addressController.text,
                                postalCode:  controller.postalCode.text.isEmpty ? "00000" : controller.postalCode.text,
                                lat: controller.selectedLat,
                                long: controller.selectedLng,
                                areaRange: "${controller.selectedRange.value} sq ft",
                                bedroom: controller.selectedBedroom.value,
                                bathroom: controller.selectedBothList.value,
                                electricityBill: controller.profileImage.value!,
                                propertyImages: controller.images,
                                noOfProperty: nofProp,
                                propertyType: controller.propertyTypeIndex.value.toString(),
                                availabilityStartTime: controller.startTime.value.toString(),
                                availabilityEndTime: controller.endTime.value.toString(),
                                description: controller.description.text,
                                subType: 1.toString(),

                              );
                            }
                          }else{
                            AppUtils.errorSnackBar("Select Images", "Minimum 5 images upload");
                          }
                        }
                      },
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

  // Service Provider

}
