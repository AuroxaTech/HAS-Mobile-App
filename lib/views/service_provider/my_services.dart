import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_app/app_constants/color_constants.dart';
import 'package:property_app/constant_widget/constant_widgets.dart';
import 'package:property_app/route_management/constant_routes.dart';

import '../../app_constants/animations.dart';
import '../../app_constants/app_sizes.dart';
import '../../controllers/services_provider_controller/my_services_cotroller.dart';
import '../../models/service_provider_model/get_services.dart';

class MyServicesScreen extends GetView<MyServicesController> {
  const MyServicesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: homeAppBar(
        context,
        text: "My services",
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Obx(() {
            print(
                "Building MyServicesScreen - isLoading: ${controller.isLoading.value}");
            print("ServicesList length: ${controller.getServicesList.length}");

            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.getServicesList.isEmpty) {
              return Center(
                child: customText(
                    text: "No Services yet", fontWeight: FontWeight.w500),
              );
            }

            return SingleChildScrollView(
                physics: bouncingScrollPhysic,
                child: Column(children: [
                  ListView.separated(
                    itemCount: controller.getServicesList.length,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      Services service = controller.getServicesList[index];
                      String imageUrl = service.serviceImages.isNotEmpty 
                          ? service.serviceImages[0].imagePath 
                          : "";

                      return myServicesWidget(
                        context,
                        image: imageUrl,
                        onTap: () {
                          Get.toNamed(kMyServicesScreenDetailScreen,
                              arguments: controller.getServicesList[index].id);
                        },
                        onTapDetail: () {
                          Get.toNamed(kMyServicesScreenDetailScreen,
                              arguments: controller.getServicesList[index].id);
                        },
                        deleteTap: () {
                          animatedDialog(
                            context,
                            title: "Delete",
                            isLoading: controller.isLoading.value,
                            subTitle: "Are you sure to want delete this!",
                            yesButtonText: "Delete",
                            yesTap: () {
                              Navigator.pop(context);
                              controller.deleteService(id: service.id);
                            },
                            cancelTap: () {
                              Navigator.pop(context);
                            },
                          );
                        },
                        editTap: () {
                          Get.toNamed(kEditServiceScreen,
                              arguments: controller.getServicesList[index].id);
                        },
                        title: service.serviceName,
                        price: service.pricing,
                        description: service.description,
                        bedroom: "2",
                        bathroom: "2",
                        marla: "5",
                        rent: "Rent",
                        serviceArea: service.location,
                        pricing: service.pricing,
                        duration: service.duration,
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return h15;
                    },
                  )
                ]));
          }),
        ),
      ),
    );
  }
}
