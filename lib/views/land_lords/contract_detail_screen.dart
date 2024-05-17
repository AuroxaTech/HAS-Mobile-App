import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:property_app/app_constants/app_sizes.dart';
import 'package:property_app/constant_widget/constant_widgets.dart';
import 'package:property_app/custom_widgets/custom_button.dart';
import 'package:property_app/utils/api_urls.dart';
import '../../app_constants/app_icon.dart';
import '../../app_constants/color_constants.dart';
import '../../controllers/land_lord/contract_detail_controller.dart';

class ContractDetailScreen extends GetView<ContractDetailController> {
  const ContractDetailScreen({Key? key}) : super(key: key);

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
                              radius: 50,
                              backgroundImage: controller.getContractOne.value!.tenant!.profileimage == "" ? const AssetImage(AppIcons.appLogo) : CachedNetworkImageProvider(AppUrls.profileImageBaseUrl + controller.getContractOne.value!.tenant!.profileimage) as ImageProvider,
                            ),
                            // const Icon(
                            //   Icons.favorite_border,
                            //   color: Colors.red,
                            // ),
                            const CircleAvatar(
                              backgroundColor: Colors.transparent,
                             // child: SvgPicture.asset(AppIcons.backIcon),
                            ),
                          ],
                        ),
                        h10,
                        Center(
                          child: customText(
                            text:  controller.getContractOne.value!.tenantName,
                            fontSize: 20,
                            color: whiteColor,
                          ),
                        ),
                        h10,
                        // Center(
                        //   child: RatingWidget(
                        //     maxRating: 5,
                        //     isRating: true,
                        //     initialRating: 3,
                        //     onRatingChanged: (rating) {
                        //       print('Selected rating: $rating');
                        //     },
                        //   ),
                        // ),
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
                        offset: const Offset(0, -4),
                        // Shadow goes upward by setting a negative Y value
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
                      text: "Contract Details",
                      fontSize: 24,
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
                                text: "Tenant Name :",
                                color: greyColor,
                                fontSize: 15,
                              ),
                              customText(
                                text: controller.getContractOne.value!.tenant!.fullname,
                                color: blackColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500
                              ),
                              Divider(color: Colors.grey.shade200,),

                              h5,
                              customText(
                                text: "Tenant Email :",
                                color: greyColor,
                                fontSize: 15,
                              ),
                              const SizedBox(
                                height: 2,
                              ),
                              customText(
                                text: controller.getContractOne.value!.tenant!.email,
                                color: blackColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500
                              ),
                              Divider(color: Colors.grey.shade200,),

                              h5,
                              customText(
                                text: "Tenant Address",
                                color: greyColor,
                                fontSize: 15,
                              ),
                              customText(
                                text: controller.getContractOne.value!.tenantAddress,
                                color: blackColor,
                                fontSize: 18,
                                fontWeight: FontWeight.w500
                              ),
                              Divider(color: Colors.grey.shade200,),

                              h5,
                              customText(
                                text: "Premised Address",
                                color: greyColor,
                                fontSize: 15,
                              ),
                              customText(
                                text: controller.getContractOne.value!.premisesAddress,
                                color: blackColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500
                              ),
                              Divider(color: Colors.grey.shade200,),

                              h5,
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  customText(
                                    text: "Phone No :",
                                    color: greyColor,
                                    fontSize: 15,
                                  ),
                                  customText(
                                    text: controller.getContractOne.value!.tenant!.phoneNumber.toString(),
                                    color: blackColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,


                                  ),
                                  Divider(color: Colors.grey.shade200,),

                                  h5,
                                  customText(
                                    text: "Occupants :",
                                    color: greyColor,
                                    fontSize: 15,
                                  ),
                                  customText(
                                      text: controller.getContractOne.value!.occupants,
                                      color: blackColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500
                                  ),
                                ],
                              ),


                            ],
                          ),
                          Divider(color: Colors.grey.shade200,),

                          h5,
                          customText(
                            text: "propertyType :",
                            color: greyColor,
                            fontSize: 15,
                          ),
                          h5,
                          customText(
                            text: controller.getContractOne.value!.propertyType,
                            color: blackColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w500
                          ),
                          Divider(color: Colors.grey.shade200,),

                          h5,
                          customText(
                            text: "Leased start date :",
                            color: greyColor,
                            fontSize: 15,
                          ),
                          customText(
                            text: controller.getContractOne.value!.leaseStartDate.toString(),
                            color: blackColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w500
                          ),
                          Divider(color: Colors.grey.shade200,),

                          h5,
                          customText(
                            text: "Leased end date :",
                            color: greyColor,
                            fontSize: 15,
                          ),
                          customText(
                            text: controller.getContractOne.value!.leaseEndDate.toString(),
                            color: blackColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w500
                          ),
                          Divider(color: Colors.grey.shade200,),

                          h5,
                          customText(
                            text: "Lease Type :",
                            color: greyColor,
                            fontSize: 15,
                          ),
                          h5,
                          customText(
                            text: controller.getContractOne.value!.leaseType.toString(),
                            color: blackColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w500
                          ),
                          Divider(color: Colors.grey.shade200,),

                          h5,
                          customText(
                            text: "Rent Amount :",
                            color: greyColor,
                            fontSize: 15,
                          ),
                          h5,
                          customText(
                            text: "\$${controller.getContractOne.value!.rentAmount}",
                            color: blackColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w500
                          ),
                          Divider(color: Colors.grey.shade200,),

                          h5,
                          customText(
                            text: "Rent Due Date :",
                            color: greyColor,
                            fontSize: 15,
                          ),
                          h5,
                          customText(
                            text: controller.getContractOne.value!.rentDueDate,
                            color: blackColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w500
                          ),
                          Divider(color: Colors.grey.shade200,),

                          h5,
                          customText(
                            text: "Rent Payment Method :",
                            color: greyColor,
                            fontSize: 15,
                          ),
                          h5,
                          customText(
                            text: controller.getContractOne.value!.rentPaymentMethod,
                            color: blackColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w500
                          ),
                          Divider(color: Colors.grey.shade200,),

                          h5,
                          customText(
                            text: "Security Deposit Amount :",
                            color: greyColor,
                            fontSize: 15,
                          ),
                          h5,
                          customText(
                            text: "\$${controller.getContractOne.value!.securityDepositAmount}",
                            color: blackColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w500
                          ),
                          Divider(color: Colors.grey.shade200,),

                          h5,
                          customText(
                            text: "Included Utilities : ",
                            color: greyColor,
                            fontSize: 15,
                          ),
                          h5,
                          Builder(
                              builder: (context) {
                                print(controller.getContractOne.value!.includedUtilities);

                                String includedUtilitiesJson = controller.getContractOne.value!.includedUtilities;
                                String includedUtilitiesString;

                                if (includedUtilitiesJson.startsWith('[') && includedUtilitiesJson.endsWith(']')) {
                                  try {
                                    List<dynamic> includedUtilities = jsonDecode(includedUtilitiesJson);
                                    includedUtilitiesString = includedUtilities.join(", ");
                                  } catch (e) {

                                    print('Error decoding JSON: $e');
                                    includedUtilitiesString = 'Error processing utilities';
                                  }
                                } else {
                                  includedUtilitiesString = includedUtilitiesJson;
                                }

                                return customText(
                                  text: includedUtilitiesString,
                                  color: blackColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500
                                );
                              }
                          ),

                          Divider(color: Colors.grey.shade200,),

                          h5,
                          customText(
                            text: "Tenant Responsibility : ",
                            color: greyColor,
                            fontSize: 15,
                          ),
                          h5,
                          Builder(
                              builder: (context) {
                                print(controller.getContractOne.value!.tenantResponsibilities);
                                String includedUtilitiesJson = controller.getContractOne.value!.tenantResponsibilities;

                                String includedUtilitiesString;

                                if (includedUtilitiesJson.startsWith('[') && includedUtilitiesJson.endsWith(']')) {
                                  try {
                                    List<dynamic> includedUtilities = jsonDecode(includedUtilitiesJson);
                                    includedUtilitiesString = includedUtilities.join(", ");
                                  } catch (e) {
                                    print('Error decoding JSON: $e');
                                    includedUtilitiesString = 'Error processing utilities';
                                  }
                                } else {
                                  includedUtilitiesString = includedUtilitiesJson;
                                }
                                return customText(
                                  text: includedUtilitiesString,
                                  color: blackColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500
                                );
                              }
                          ),
                          Divider(color: Colors.grey.shade200,),

                          h5,
                          customText(
                            text: "Emergency Contact Name :",
                            color: greyColor,
                            fontSize: 15,
                          ),
                          h5,
                          customText(
                            text: controller.getContractOne.value!.emergencyContactName,
                            color: blackColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w500
                          ),

                          Divider(color: Colors.grey.shade200,),

                          h5,
                          customText(
                            text: "Emergency Contact Phone :",
                            color: greyColor,
                            fontSize: 15,
                          ),
                          h5,
                          customText(
                            text: controller.getContractOne.value!.emergencyContactPhone,
                            color: blackColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w500
                          ),

                          Divider(color: Colors.grey.shade200,),

                          h5,
                          customText(
                            text: "Emergency Contact Address :",
                            color: greyColor,
                            fontSize: 15,
                          ),
                          h5,
                          customText(
                            text: controller.getContractOne.value!.emergencyContactAddress,
                            color: blackColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w500
                          ),

                           Divider(color: Colors.grey.shade200,),

                           h5,
                          customText(
                            text: "Building Superintendent Name :",
                            color: greyColor,
                            fontSize: 15,
                          ),
                          h5,
                          customText(
                            text: controller.getContractOne.value!.buildingSuperintendentName,
                            color: blackColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w500
                          ),
                          Divider(color: Colors.grey.shade200,),

                          h5,
                          customText(
                            text: "Building Superintendent Phone :",
                            color: greyColor,
                            fontSize: 15,
                          ),
                          h5,
                          customText(
                            text: controller.getContractOne.value!.buildingSuperintendentPhone,
                            color: blackColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w500
                          ),
                          Divider(color: Colors.grey.shade200,),
                          h5,
                          customText(
                            text: "Building Superintendent Address :",
                            color: greyColor,
                            fontSize: 15,
                          ),
                          h5,
                          customText(
                            text: controller.getContractOne.value!.buildingSuperintendentAddress,
                            color: blackColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w500
                          ),
                          Divider(color: Colors.grey.shade200,),
                          h5,
                          customText(
                            text: "Rent Increase Notice Period:",
                            color: greyColor,
                            fontSize: 15,
                          ),
                          h5,
                          customText(
                            text: controller.getContractOne.value!.rentIncreaseNoticePeriod,
                            color: blackColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w500
                          ),
                          Divider(color: Colors.grey.shade200,),
                          h5,
                          customText(
                            text: "Notice Period for termination :",
                            color: greyColor,
                            fontSize: 15,
                          ),
                          h5,
                          customText(
                            text: controller.getContractOne.value!.noticePeriodForTermination,
                            color: blackColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w500
                          ),
                          Divider(color: Colors.grey.shade200,),
                          h5,
                          customText(
                            text: "Late payment fee :",
                            color: greyColor,
                            fontSize: 15,
                          ),
                          h5,
                          customText(
                            text: controller.getContractOne.value!.latePaymentFee,
                            color: blackColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w500
                          ),
                          Divider(color: Colors.grey.shade200,),
                          h5,
                          customText(
                            text: "Rental Incentives:",
                            color: greyColor,
                            fontSize: 15,
                          ),
                          h5,
                          customText(
                            text: controller.getContractOne.value!.rentalIncentives,
                            color: blackColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w500
                          ),
                          Divider(color: Colors.grey.shade200,),
                          h5,
                          customText(
                            text: "Additional Terms :",
                            color: greyColor,
                            fontSize: 15,
                          ),
                          h5,
                          customText(
                            text: controller.getContractOne.value!.additionalTerms,
                            color: blackColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w500
                          ),
                          Divider(color: Colors.grey.shade200,),
                          h30,
                          controller.getContractOne.value!.status == "1" ? const SizedBox() :
                          Row(
                            children: [
                              Expanded(
                                child: CustomButton(
                                  borderRadius: BorderRadius.circular(10),
                                  height: screenHeight(context) * 0.05,
                                  text: "Accept?",
                                  fontSize: 16,
                                  onTap: (){
                                    animatedDialog(context,
                                        title: "Accept Contract",
                                        subTitle: "Are you sure to accept this contract",
                                        yesButtonText: "Accept",
                                        yesTap: (){
                                          controller.acceptContractRequest(
                                            contractId: controller.getContractOne.value!.id,
                                            status: "1",
                                          ).then((value) {
                                            controller.getContractDetail(id: controller.getContractOne.value!.id,);
                                          });
                                        }
                                        );
                                  },
                                  gradientColor: gradient(),
                                ),
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                child: CustomButton(
                                  borderRadius: BorderRadius.circular(10),
                                  height: screenHeight(context) * 0.05,
                                  text: "Decline?",
                                  fontSize: 16,
                                  gradientColor: redGradient(),
                                  onTap: (){
                                    animatedDialog(context,
                                        title: "Decline Contract",
                                        subTitle: "Are you sure to accept this contract",
                                        yesButtonText: "Decline",
                                        yesTap: (){
                                          controller.acceptContractRequest(
                                            contractId: controller.getContractOne.value!.id,
                                            status: "2",
                                          ).then((value) {
                                            controller.getContractDetail(id: controller.getContractOne.value!.id,);
                                          });
                                        }
                                    );
                                  },
                                ),
                              ),
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
