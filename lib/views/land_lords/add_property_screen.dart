import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:property_app/app_constants/color_constants.dart';
import 'package:property_app/constant_widget/constant_widgets.dart';
import 'package:property_app/utils/utils.dart';
import '../../app_constants/animations.dart';
import '../../app_constants/app_icon.dart';
import '../../app_constants/app_sizes.dart';
import '../../controllers/land_lord/add_property_controller.dart';
import '../../custom_widgets/custom_button.dart';
import '../../custom_widgets/custom_text_field.dart';
import '../locations/location_screen.dart';
class AddPropertyScreen extends GetView<AddPropertyController> {
  const AddPropertyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: whiteColor,
      appBar: titleAppBar("Add Details"),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: Obx(() => SingleChildScrollView(
                  physics: bouncingScrollPhysic,
              child: Form(
                key: controller.formKey,
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
                                  itemBuilder: (context, index){
                                    final image = controller.images[index];
                                    return fileImage(image: image.path, onTap: (){
                                      controller.removeImage(index);
                                    });
                                  }),
                            ),
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
                                      const Icon(Icons.add, size: 25,),
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
                      validator: (value){
                        if(value.isEmpty){
                          return "Please enter city name";
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
                      controller: controller.amountController,
                      validator: (value){
                        if(value.isEmpty){
                          return "Please enter amount";
                        }
                        return null;
                      },
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
                          controller.streetController.text =  controller.selectedAddress;

                          print(controller.selectedAddress);
                          print(controller.selectedLat);
                          print(controller.selectedLng);
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
                                    border: Border.all(color: Colors.white),
                                    borderRadius: BorderRadius.circular(20),
                                    color: controller.home.value ? secondaryColor : whiteColor,
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

                          const SizedBox(
                            width: 10,
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
                                  border: Border.all(color: Colors.white),
                                  borderRadius: BorderRadius.circular(20),
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
                                  border: Border.all(color: Colors.white),
                                  borderRadius: BorderRadius.circular(20),
                                  color: controller.commercial.value ? secondaryColor : whiteColor,

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
                          iconTheme: const IconThemeData(color: Colors.white),
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          selected: isSelected,
                          selectedColor: primaryColor,
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
                          selectedColor: primaryColor,
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
                          selectedColor: primaryColor,
                          backgroundColor: Colors.white,
                          onSelected: (bool selected) {
                            controller.toggleCommercial(key);
                          },
                        );
                      }).toList(),
                    )) : const SizedBox(),

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
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: (){
                              Navigator.pop(context);
                            },
                            child: Container(
                              height: screenHeight(context) * 0.07,
                              decoration: BoxDecoration(
                                border: Border.all(color: borderColor),
                                borderRadius: BorderRadius.circular(10)
                              ),
                              child: Center(child: SvgPicture.asset(AppIcons.reset, color: const Color(0xff47494C),)),
                            ),
                          ),
                        ),
                        w15,
                        Expanded(
                          flex: 3,
                          child: CustomButton(
                            isLoading: controller.isLoading.value,
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
                                if(controller.images.length > 4){
                                  double amount = double.parse(controller.amountController.text);
                                  controller.addProperty(
                                    type: controller.isSale.value ? 1 : 2,
                                    city: controller.newYorkController.text,
                                    amount: amount,
                                    address: controller.streetController.text,
                                    lat: controller.selectedLat,
                                    long: controller.selectedLng,
                                    areaRange: controller.areaRange[0],
                                    bedroom: controller.selectedBedroom.value,
                                    bathroom: controller.selectedBothList.value,
                                    electricityBill: controller.images[0],
                                    propertyImages: controller.images,
                                    description: controller.description.text,
                                    propertyType: propertyType,
                                    propertySubType: selectedSubType.toString(),
                                  );
                                } else {
                                  AppUtils.errorSnackBar("Select Images", "Minimum 5 images upload");
                                }
                              }
                            },
                            text: "Continue",
                            borderRadius: BorderRadius.circular(50),
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
