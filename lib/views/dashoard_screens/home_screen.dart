import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:property_app/app_constants/app_icon.dart';
import 'package:property_app/app_constants/color_constants.dart';
import '../../app_constants/app_sizes.dart';
import '../../constant_widget/constant_widgets.dart';
import '../../controllers/dasboard_controller/home_screen_controller.dart';
import '../../route_management/constant_routes.dart';
import '../../utils/api_urls.dart';

class HomeScreen extends GetView<HomeScreenController> {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: titleAppBar("My Properties", action: [
        SvgPicture.asset(AppIcons.addCircle),
        w10,
      ]),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Obx(() => Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.grey[100], // Background color of the tab bar
                    borderRadius: BorderRadius.circular(50.0),
                    border: Border.all(color: borderColor)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (int i = 0; i < 2; i++)
                      Expanded(
                        child: InkWell(
                          highlightColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          onTap: () {
                            controller.tabController.animateTo(i);

                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10), // Padding for the tab
                            alignment: Alignment.center,
                            child: Column(
                              children: [
                                Container(
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: controller.selectedIndex.value == i ?   Colors.blue : Colors.transparent
                                  ),
                                ),
                                h5,
                                customText(
                                  text :  i == 0 ? 'List View' : 'Map View',
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: controller.selectedIndex.value == i
                                      ? FontWeight.w600 : FontWeight.w400,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              )),
              h20,
              Obx(() => Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.grey[100], // Background color of the tab bar
                    borderRadius: BorderRadius.circular(50.0),
                    border: Border.all(color: borderColor)
                ),
                child: Row(
                  children: [
                    for (int i = 0; i < 3; i++)
                      Expanded(
                        child: InkWell(
                          highlightColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          onTap: () {
                            controller.tabController1.animateTo(i);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10), // Padding for the tab
                            alignment: Alignment.center,
                            child: Column(
                              children: [
                                Container(
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: controller.selectedIndex1.value == i ?   Colors.blue : Colors.transparent
                                  ),
                                ),
                                h5,
                                customText(
                                  text :  i == 0 ? 'House' : i == 1 ?'Plots' : 'Commercial',
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: controller.selectedIndex1.value == i
                                      ? FontWeight.w600 : FontWeight.w400,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              )),
              h20,
              Expanded(
                child: TabBarView(
                  controller: controller.tabController1,
                  children: [
                    Obx(() => controller.isLoading.value ? const Center(child: CircularProgressIndicator()) :
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          ListView.separated(
                            itemCount: controller.getAllPropertiesList.length,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index){
                              String imagesString = controller.getAllPropertiesList[index].images.toString();
                              List<String> imageList = imagesString.split(',');
                              return myPropertyWidget(context,
                                  onTap: (){
                                    Get.toNamed(kPropertyDetailScreen);
                                  },
                                  title: controller.getAllPropertiesList[index].city.toString(),
                                  image: AppUrls.propertyImages + imageList[0],
                                  price: "\$${controller.getAllPropertiesList[index].amount.toString()}",
                                  description: controller.getAllPropertiesList[index].description.toString(),
                                  bedroom: controller.getAllPropertiesList[index].bedroom.toString(),
                                  bathroom: controller.getAllPropertiesList[index].bathroom.toString(),
                                  marla: controller.getAllPropertiesList[index].areaRange.toString(),
                                  rent: controller.getAllPropertiesList[index].type == "1" ? "Rent" : "Sale");
                            }, separatorBuilder: (BuildContext context, int index) {
                            return h15;
                          },
                          )
                        ],
                      ),
                    ),
                    ),
                    const Center(child: Text('Properties Content')),
                    const Center(child: Text('Properties Content')),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
