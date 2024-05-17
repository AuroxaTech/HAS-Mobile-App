import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_app/controllers/land_lord/my_service_request_controller.dart';
import 'package:property_app/route_management/constant_routes.dart';

import '../../app_constants/app_icon.dart';
import '../../app_constants/app_sizes.dart';
import '../../app_constants/color_constants.dart';
import '../../constant_widget/constant_widgets.dart';
import '../../controllers/jobs_controller/jobs_screen_controller.dart';
import '../../custom_widgets/custom_button.dart';
import '../../utils/api_urls.dart';
class MyServiceRequest extends GetView<MyServiceRequestController> {
  const MyServiceRequest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: homeAppBar(context, text: "My Service Request"),
      body: SafeArea(
        child: Obx(() => controller.isLoading.value ?
        const Center(child: CupertinoActivityIndicator(
          radius: 30,
        )) : controller.getServicesRequestList.isEmpty ? Center(
          child: customText(
              text: "No request here",
          ),
        ) : SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              children: [

                ListView.builder(
                    itemCount: controller.getServicesRequestList.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      String imagesString =   controller.getServicesRequestList[index].service!.media.toString();
                      List<String> imageList = imagesString.split(',');
                      return Column(
                        children: [
                          jobWidget(
                            context,
                            image:  AppUrls.mediaImages + imageList[0],
                            onTap: (){
                              Get.toNamed(kMyServiceRequestDetailScreen, arguments: controller.getServicesRequestList[index].id);
                            },
                            detailOnTap: (){
                              Get.toNamed(kMyServiceRequestDetailScreen, arguments: controller.getServicesRequestList[index].id);
                            },
                            title: controller.getServicesRequestList[index].service!.serviceName,
                            contactDetail: controller.getServicesRequestList[index].user.email,
                            clientName: controller.getServicesRequestList[index].user.fullname,
                            location:  controller.getServicesRequestList[index].address,
                            description: controller.getServicesRequestList[index].description,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      );
                    }
                  ),
                ],
              ),
          ),
          ),
        ),
      ),
    );
  }
  Widget topContainer({String? text, Color? textColor, Color? borderColor, VoidCallback? onTap}){
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: borderColor!),
          borderRadius: BorderRadius.circular(30),
        ),
        padding: const EdgeInsets.only(top: 8, bottom: 8, left: 8, right: 8),
        child: Center(
          child: customText(
              text: text,
              color: textColor,
              fontSize: 12
          ),
        ),
      ),
    );
  }



  Widget jobWidget(context,{VoidCallback? onTap, String? title,String? clientName,
    String? contactDetail,String? description, String? location, String? status,
    String? requestTime, String? clientDate, VoidCallback? detailOnTap, String? image}){
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 1.0,
            ),
          ],
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(25),
                topLeft: Radius.circular(25),
              ),
              child: Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl: image!,
                    width: double.infinity,
                    height: screenHeight(context) *0.15,
                    fit: BoxFit.cover,
                    errorWidget: (context, d , g){
                      return Image.asset(AppIcons.appLogo);
                    },
                  ),
                ],
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(top: 15, right: 15, left: 15),
                child: Column(
                  children: [
                    headingText(
                      text: title ?? "",
                      fontSize: 20,
                    ),
                  ],
                )
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      customText(
                          text: "Client Name :",
                          color: greyColor,
                          fontSize: 10
                      ) ,
                      h5,
                      customText(
                          text: clientName ?? "",
                          color: blackColor,
                          fontSize: 8
                      ),
                      h10,
                      customText(
                          text: "Description :",
                          color: greyColor,
                          fontSize: 10
                      ) ,
                      h5,
                      SizedBox(
                        width: screenHeight(context) * 0.2,
                        child: customText(
                            text: description ??"",
                            color: blackColor,
                            fontSize: 8
                        ),
                      ),
                      h15,
                      customText(
                          text: "Request Date & Time : ",
                          color: greyColor,
                          fontSize: 10
                      ) ,
                      h5,
                      Row(
                        children: [
                          Image.asset(AppIcons.calendar, width: 12, height: 12,),
                          customText(
                              text: " Date :",
                              color: greyColor,
                              fontSize: 10
                          ) ,
                          w10,
                          customText(
                              text: "15-2-24",
                              color: blackColor,
                              fontSize: 8
                          ),
                        ],
                      ),
                      h5,
                      Row(
                        children: [
                          Image.asset(AppIcons.clockDuration, width: 12, height: 12,),
                          customText(
                              text: " Time :",
                              color: greyColor,
                              fontSize: 10
                          ) ,
                          w10,
                          customText(
                              text: "5.00pm",
                              color: blackColor,
                              fontSize: 8
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      customText(
                          text: "Contact Details :",
                          color: greyColor
                      ),
                      h5,
                      customText(
                          text: contactDetail ?? "",
                          color: blackColor,
                          fontSize: 8
                      ),
                      h5,
                      customText(
                          text: "Location :",
                          color: greyColor,
                          fontSize: 10
                      ) ,
                      h5,
                      customText(
                          text: location ?? "",
                          color: blackColor,
                          fontSize: 8
                      ),
                      h5,
                      customText(
                          text: "Request Status :",
                          color: greyColor,
                          fontSize: 10
                      ) ,
                      h5,
                      Row(
                        children: [
                          Image.asset(AppIcons.progress),
                          customText(
                              text: " In Progress",
                              color: blackColor,
                              fontSize: 8
                          ),
                        ],
                      ),
                      h10,
                      customText(
                          text: "Client Date & Time : ",
                          color: greyColor,
                          fontSize: 10
                      ) ,
                      h5,
                      Row(
                        children: [
                          Image.asset(AppIcons.calendar, width: 12, height: 12,),
                          customText(
                              text: " Date :",
                              color: greyColor,
                              fontSize: 10
                          ) ,
                          w10,
                          customText(
                              text: "15-2-24",
                              color: blackColor,
                              fontSize: 8
                          ),
                        ],
                      ),
                      h5,
                      Row(
                        children: [
                          Image.asset(AppIcons.clockDuration, width: 12, height: 12,),
                          customText(
                              text: " Time :",
                              color: greyColor,
                              fontSize: 10
                          ),
                          w10,
                          customText(
                              text: "5.00pm",
                              color: blackColor,
                              fontSize: 8
                          ),
                        ],
                      )
                    ],
                  ),

                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      onTap: detailOnTap,
                      height: screenHeight(context) * 0.05,
                      text: "Details",
                      fontSize: 12,
                      gradientColor: detailGradient(),
                    ),
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}
