import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:property_app/app_constants/app_icon.dart';
import 'package:property_app/app_constants/app_sizes.dart';
import 'package:property_app/app_constants/color_constants.dart';
import 'package:property_app/constant_widget/constant_widgets.dart';
import 'package:property_app/controllers/land_lord/my_property_controller.dart';
import 'package:property_app/utils/api_urls.dart';
import 'package:property_app/views/land_lords/propert_detail_screen.dart';
import '../../app_constants/animations.dart';
import '../../route_management/constant_routes.dart';

class MyPropertyScreen extends GetView<MyPropertyController> {
  const MyPropertyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: titleAppBar("My Properties", action: [
        // IconButton(onPressed: (){
        //   Get.toNamed(kPropertyFilterScreen);
        // }, icon: const Icon(Icons.menu)),
      ]),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            physics: bouncingScrollPhysic,
             child: Obx(() => controller.isLoading.value ? const Center(child: CircularProgressIndicator()) :
             controller.getLandLordPropertiesList.isEmpty ?  Center(
               child: customText(
                 text: "No Property here",
                 fontSize: 18,
                 fontWeight: FontWeight.w500
               ),
             ) : Column(
                children: [
                  ListView.separated(
                    itemCount: controller.getLandLordPropertiesList.length,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index){
                       String imagesString = controller.getLandLordPropertiesList[index].images.toString();
                       List<String> imageList = imagesString.split(',');
                      return myPropertyWidget(context,
                          onTap: (){
                            Get.toNamed(kPropertyDetailScreen, arguments: controller.getLandLordPropertiesList[index].id);
                          },
                          title: controller.getLandLordPropertiesList[index].city.toString(),
                          image: AppUrls.propertyImages + imageList[0],
                          price: "\$${controller.getLandLordPropertiesList[index].amount.toString()}",
                          description: controller.getLandLordPropertiesList[index].description.toString(),
                          bedroom: controller.getLandLordPropertiesList[index].bedroom.toString(),
                          bathroom: controller.getLandLordPropertiesList[index].bathroom.toString(),
                          marla: controller.getLandLordPropertiesList[index].areaRange.toString(),
                          rent: controller.getLandLordPropertiesList[index].type == "1" ? "Rent" : "Sale");
                      }, separatorBuilder: (BuildContext context, int index) {
                      return h15;
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
