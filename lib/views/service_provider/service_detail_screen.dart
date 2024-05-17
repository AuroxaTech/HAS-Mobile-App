import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:property_app/app_constants/app_sizes.dart';
import 'package:property_app/constant_widget/constant_widgets.dart';
import 'package:property_app/controllers/services_provider_controller/service_listing_detail_controller.dart';
import 'package:property_app/custom_widgets/custom_button.dart';
import 'package:property_app/utils/api_urls.dart';
import 'package:property_app/views/service_provider/rating_screen.dart';

import '../../app_constants/app_icon.dart';
import '../../app_constants/color_constants.dart';
import '../../route_management/constant_routes.dart';

class ServiceListingDetailScreen extends GetView<ServiceListingDetailScreenController> {
  const ServiceListingDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: SafeArea(
        child: Obx(() => controller.isLoading.value ? const Center(child: CircularProgressIndicator()) :
         SingleChildScrollView(
          child: Column(
              children: [
                InkWell(
                  onTap: () {},
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: FractionalOffset(0.0, 0.0),
                        end: FractionalOffset(0.0, 1.0),
                        colors: [
                          primaryColor,
                          whiteColor,
                        ],
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InkWell(
                                onTap: () {
                                  Get.back();
                                },
                                child: CircleAvatar(
                                  backgroundColor: whiteColor,
                                  child: SvgPicture.asset(AppIcons.backIcon),
                                ),
                              ),
                               CircleAvatar(
                                radius: 60,
                                child: Center(
                                  child: CachedNetworkImage(
                                    imageUrl: AppUrls.mediaImages + controller.images[0],
                                    errorWidget: (context, e ,b ){
                                      return Image.asset(AppIcons.appLogo);
                                    },
                                  ),
                                ),
                              ),



                              Obx(() => IconButton(
                                  icon: Icon(
                                    controller.getServiceOne.value!.isFavorite == true ? Icons.favorite : Icons.favorite_border,
                                    color: controller.getServiceOne.value!.isFavorite == true ? Colors.red : greyColor,
                                  ),
                                  onPressed: () {
                                    // controller.getServices();
                                    controller.toggleFavorite1(controller.getServiceOne.value!.id);
                                  },

                                ),
                              )
                            ],
                          ),
                          h10,
                          Center(
                            child: customText(
                              text:  controller.getServiceOne.value!.serviceName,
                              fontSize: 20,
                              color: whiteColor,
                            ),
                          ),
                          h10,
                          Center(
                            child: RatingWidget(
                              maxRating: 5,
                              isRating: false,
                              initialRating: controller.getServiceOne.value!.averageRate,
                              onRatingChanged: (rating) {
                                print('Selected rating: $rating');
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: whiteColor,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.08),
                          blurRadius: 4,
                          spreadRadius: 0.05,
                          offset: const Offset(0,
                              -4), // Shadow goes upward by setting a negative Y value
                        ),
                      ],
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(35),
                        topLeft: Radius.circular(35),
                      )),
                  child: Column(
                    children: [
                      h15,
                      customText(
                        text: "Service Details",
                        fontSize: 24,
                        color: greyColor,
                        fontWeight: FontWeight.w500,
                      ),
                      h10,
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                customText(
                                  text: "Main service offer :",
                                  color: Colors.black54,
                                  fontSize: 15,
                                ),
                                customText(
                                  text: "${controller.getServiceOne.value!.serviceName} ." ?? "",
                                  color: blackColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500
                                ),
                                Divider(color: Colors.grey.shade200,),
                                h5,
                                customText(
                                  text: "Availability :",
                                  color: Colors.black54,
                                  fontSize: 15,
                                ),

                                const SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    Image.asset(
                                      AppIcons.calendar,
                                      width: 20,
                                      height: 20,
                                    ),
                                    w5,
                                    customText(
                                      text: "Date : ",
                                      color: Colors.black54,
                                      fontSize: 15,
                                    ),
                                    customText(
                                      text: "${controller.getServiceOne.value!.startTime} ${controller.getServiceOne.value!.startTime}",
                                      color: blackColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ],
                                ),
                                Divider(color: Colors.grey.shade200,),
                                // h5,
                                // customText(
                                //   text: "Year of Experience :",
                                //   color: Colors.black54,
                                //   fontSize: 15,
                                // ),
                                // h5,
                                // customText(
                                //   text: controller.getServiceOne.value!.country,
                                //   color: blackColor,
                                //   fontSize: 16,
                                //   fontWeight: FontWeight.w500,
                                // ),
                                h5,
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                customText(
                                  text: "Service Area :",
                                  color: Colors.black54,
                                  fontSize: 15,
                                ),
                                h5,
                                customText(
                                  text: controller.getServiceOne.value!.location.toString(),
                                  color: blackColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500
                                ),
                                Divider(color: Colors.grey.shade200,),
                                h5,
                                customText(
                                  text: "Price Range :",
                                  color: Colors.black54,
                                  fontSize: 15,
                                ),
                               h5,
                                customText(
                                  text: "\$${controller.getServiceOne.value!.pricing}",
                                  color: blackColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500
                                ),
                                Divider(color: Colors.grey.shade200,),
                              ],
                            ),
                            h5,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                customText(
                                  text: "Phone No :",
                                  color: Colors.black54,
                                  fontSize: 15,
                                ),
                                customText(
                                  text: controller.getServiceOne.value!.user == null ? "" : controller.getServiceOne.value!.user!.phoneNumber.toString(),
                                  color: blackColor,
                                  fontSize: 15,
                                ),
                                Divider(color: Colors.grey.shade200,),
                              ],
                            ),
                            h5,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                customText(
                                  text: "Email ID :",
                                  color: Colors.black54,
                                  fontSize: 15,
                                ),
                                h5,
                                customText(
                                  text: controller.getServiceOne.value!.user == null ? "" : controller.getServiceOne.value!.user!.email.toString(),
                                  color: blackColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500
                                ),
                                Divider(color: Colors.grey.shade200,),
                              ],
                            ),
                            h5,
                            customText(
                              text: "Description :",
                              color: Colors.black54,
                              fontSize: 15,
                            ),
                            h5,
                            customText(
                              text: controller.getServiceOne.value!.description,
                              color: blackColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w500
                            ),
                            Divider(color: Colors.grey.shade200,),

                            h5,
                            customText(
                              text: "Gallery :",
                              color: Colors.black54,
                              fontSize: 15,
                            ),
                            h10,
                            SizedBox(
                              height: 80,
                              child: ListView.builder(
                                itemCount: controller.images.length,
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return Row(
                                    children: [
                                      Container(
                                        width: 80,
                                        height: 80,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          borderRadius: BorderRadius.circular(15),
                                          image:  DecorationImage(
                                            image: CachedNetworkImageProvider(AppUrls.mediaImages + controller.images[index]),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                    ],
                                  );
                                }
                              ),
                            ),
                            Divider(color: Colors.grey.shade200,),
                            h10,
                            customText(
                              text: "Country :",
                              color: Colors.black54,
                              fontSize: 15,
                            ),
                            h5,
                            customText(
                              text: controller.getServiceOne.value!.country,
                              color: blackColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w500
                            ),

                            Divider(color: Colors.grey.shade200,),
                            h10,
                            customText(
                              text: "City :",
                              color: Colors.black54,
                              fontSize: 15,
                            ),
                            h5,
                            customText(
                              text: controller.getServiceOne.value!.city,
                              color: blackColor, fontSize: 16,
                                fontWeight: FontWeight.w500
                            ),
                            Divider(color: Colors.grey.shade200,),
                            h10,
                            Row(
                              children: [
                                customText(
                                  text: "Duration : ",
                                  color: Colors.black54,
                                  fontSize: 15,
                                ),
                                customText(
                                  text: "${controller.getServiceOne.value!.startTime} ${controller.getServiceOne.value!.endTime}",
                                  color: blackColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500
                                ),
                                Divider(color: Colors.grey.shade200,),
                                // w15,
                                // customText(
                                //   text: "Price  : ",
                                //   color: Colors.black54,
                                //   fontSize: 15,
                                // ),
                                // customText(
                                //   text: "\$500",
                                //   color: blackColor,
                                //   fontSize: 15,
                                // ),
                              ],
                            ),
                            h10,
                            customText(
                              text: "Certification:",
                              color: Colors.black54,
                              fontSize: 15,
                            ),
                            h5,
                            Container(
                              width: double.infinity,
                              height: 150,
                              decoration:BoxDecoration(
                                borderRadius: BorderRadius.circular(18),
                                image:  const DecorationImage(
                                  image: AssetImage(AppIcons.appLogo),
                                  fit: BoxFit.cover
                                )
                              ),
                           ),
                            h10,
                            customText(
                              text: "Reviews :",
                              color: greyColor,
                              fontSize: 15,
                            ),
                            h5,
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: whiteColor,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 1.0,
                                ),
                              ]
                          ),
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          child: ListTile(
                            leading:  Container(
                              width: 50,
                              decoration:  BoxDecoration(
                                  image: DecorationImage(
                                      image:  controller.getServiceOne.value!.user == null ?  const AssetImage(AppIcons.personIcon) : controller.getServiceOne.value!.user!.profileimage == "" ? const AssetImage(AppIcons.personIcon) : NetworkImage(AppUrls.profileImageBaseUrl + controller.getServiceOne.value!.user!.profileimage)  as ImageProvider,
                                  )
                              ),
                            ),
                            title: headingText(
                                text: controller.getServiceOne.value!.user == null ? "No Name" : controller.getServiceOne.value!.user!.fullname.toString(),
                                fontSize: 20,
                              color: Colors.black54,
                            ),
                            subtitle: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RatingWidget(
                                  maxRating: 5,
                                  isRating: false,
                                  initialRating: controller.getServiceOne.value!.totalRate,
                                  onRatingChanged: (rating) {
                                    print('Selected rating: $rating');
                                  },
                                ),
                                // customText(
                                //     text: " I must say, it's a game-changer! The user interface is sleek and intuitive a breeze.",
                                //     fontSize: 10
                                // )

                              ],
                            ),
                          ),
                        ),
                            h30,
                            Row(
                              children: [
                                Expanded(
                                  child: CustomButton(
                                    height: 45,
                                    text: "Contact",
                                    fontSize: 18,
                                    gradientColor: greenGradient(),
                                    onTap: (){
                                      Get.toNamed(kChatConversionScreen);
                                    },
                                  ),
                                ),
                                w15,
                                Expanded(
                                  child: CustomButton(
                                    onTap: (){
                                      Get.toNamed(kNewServiceRequestScreen, arguments: [
                                        (controller.getServiceOne.value!.serviceName),
                                         controller.getServiceOne.value!.user!.email,
                                         (controller.getServiceOne.value!.description) ,
                                         controller.getServiceOne.value!.userId,
                                         controller.getServiceOne.value!.id,
                                         controller.images[0],
                                      ]);
                                    },
                                    height: 45,
                                    text: "Book Service",
                                    fontSize: 18,
                                    gradientColor: gradient(),
                                  ),
                                )
                              ],
                            ),
                            h50
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
        ),
        ),
      ),
    );
  }
}
