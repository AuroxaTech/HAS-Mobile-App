import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:property_app/controllers/services_provider_controller/service_listing_screen_controller.dart';
import '../../app_constants/app_sizes.dart';
import '../../app_constants/color_constants.dart';
import '../../constant_widget/constant_widgets.dart';
import '../../custom_widgets/custom_button.dart';
import '../../custom_widgets/custom_text_field.dart';

class ServiceFilterScreen extends GetView<ServiceListingScreenController> {
  const ServiceFilterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold (
      backgroundColor: whiteColor,
      appBar: titleAppBar("Service Filter"),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 5),
          child: SingleChildScrollView(
            child:  Form(
              key: controller.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  labelText("Service Name"),
                  h10,
                  CustomBorderTextField(
                    hintText: "Plumber",
                    controller: controller.serviceNameController,
                    keyboaredtype: TextInputType.text,
                    // maxLength: 10,
                  ),

                  h15,
                  labelText("City Name"),
                  h10,
                  CustomBorderTextField(
                    hintText: "Islamabad",
                    controller: controller.cityController,
                    keyboaredtype: TextInputType.text,
                    // maxLength: 10,

                  ),
                  h15,
                  labelText("Country Name"),
                  h10,
                  CustomBorderTextField(
                    hintText: "Pakistan",
                    controller: controller.countryController,
                    keyboaredtype: TextInputType.text,
                    // maxLength: 10,
                  ),

                  h15,
                  labelText("Price Range"),
                  h10,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: CustomBorderTextField(
                          hintText: "\$0",
                          controller: controller.minPriceController,
                          keyboaredtype: TextInputType.number,
                          maxLength: 10,
                          // validator: (value) {
                          //   if (value == null || value.isEmpty || value.length < 1) {
                          //     return 'Min Price Required';
                          //   }
                          //   return null;
                          // },
                        ),
                      ),
                      w20,
                      customText(
                          text: "TO",
                          fontSize: 18
                      ),
                      w20,
                      Expanded(
                        child: CustomBorderTextField(
                          hintText: "\$8000",
                          keyboaredtype: TextInputType.number,
                          maxLength: 10,
                          controller: controller.maxPriceController,
                          // validator: (value) {
                          //   if (value == null || value.isEmpty || value.length < 1) {
                          //     return 'Max Price Required';
                          //   }
                          //   return null;
                          // },
                        ),
                      ),
                    ],
                  ),
                  h10,
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

                  h20,
                  CustomButton(
                    width: double.infinity,
                    text: "Apply",
                    onTap: (){
                      if(controller.formKey.currentState!.validate()){
                        Map<String, dynamic> filters = {
                          "minPrice": controller.minPriceController.text,
                          "maxPrice": controller.maxPriceController.text,
                          "service_name": controller.serviceNameController.text.toString(),
                          "country": controller.countryController.text.toString(),
                          "city": controller.cityController.text,
                          "category_id" : controller.selectedCategoryId.value
                        };
                        Get.back(result: filters);
                      }
                    },
                  ),
                  h20,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
