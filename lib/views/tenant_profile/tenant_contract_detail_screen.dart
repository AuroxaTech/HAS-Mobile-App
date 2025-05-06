import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:property_app/app_constants/app_sizes.dart';
import 'package:property_app/constant_widget/constant_widgets.dart';
import 'package:property_app/custom_widgets/custom_button.dart';

import '../../app_constants/app_icon.dart';
import '../../app_constants/color_constants.dart';
import '../../controllers/land_lord/contract_detail_controller.dart';

class TenantContractDetailScreen extends GetView<ContractDetailController> {
  const TenantContractDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //   print(AppUrls.profileImageBaseUrl + controller.getContractOne.value!.tenant!.profileimage);
    return Scaffold(
      backgroundColor: whiteColor,
      body: SafeArea(
        child: Obx(
          () => controller.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Get.back();
                                      },
                                      child: CircleAvatar(
                                        backgroundColor: whiteColor,
                                        child:
                                            SvgPicture.asset(AppIcons.backIcon),
                                      ),
                                    ),
                                    CircleAvatar(
                                      radius: 50,
                                      backgroundImage: controller.getContractOne
                                                  .value!.user.profileImage ==
                                              ""
                                          ? const AssetImage(AppIcons.appLogo)
                                          : CachedNetworkImageProvider(
                                                  controller
                                                      .getContractOne
                                                      .value!
                                                      .user
                                                      .profileImage!)
                                              as ImageProvider,
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
                                    text: controller
                                        .getContractOne.value!.landlordName,
                                    fontSize: 20,
                                    color: whiteColor,
                                  ),
                                ),
                                // h10,
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
                              text: "Contract Details",
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                            ),
                            h10,
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 20, right: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      customText(
                                        text: "Landlord Name :",
                                        color: greyColor,
                                        fontSize: 15,
                                      ),
                                      customText(
                                          text: controller.getContractOne.value!
                                              .landlordName,
                                          color: blackColor,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500),
                                      Divider(
                                        color: Colors.grey.shade200,
                                      ),
                                      h5,
                                      customText(
                                        text: "Landlord Email :",
                                        color: greyColor,
                                        fontSize: 15,
                                      ),
                                      const SizedBox(
                                        height: 2,
                                      ),
                                      // customText(
                                      //     text: controller.getContractOne.value!
                                      //             .property?.user?.email ??
                                      //         "",
                                      //     color: blackColor,
                                      //     fontSize: 18,
                                      //     fontWeight: FontWeight.w500),
                                      Divider(
                                        color: Colors.grey.shade200,
                                      ),
                                      h5,
                                      customText(
                                        text: "Premised Address",
                                        color: greyColor,
                                        fontSize: 15,
                                      ),
                                      customText(
                                          text: controller.getContractOne.value!
                                              .premisesAddress,
                                          color: blackColor,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500),
                                      Divider(
                                        color: Colors.grey.shade200,
                                      ),
                                      h5,
                                      customText(
                                        text: "Tenant Address",
                                        color: greyColor,
                                        fontSize: 15,
                                      ),
                                      customText(
                                          text: controller.getContractOne.value!
                                              .tenantAddress,
                                          color: blackColor,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500),
                                      Divider(
                                        color: Colors.grey.shade200,
                                      ),
                                      h5,
                                    ],
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          customText(
                                            text: "Phone No :",
                                            color: greyColor,
                                            fontSize: 15,
                                          ),
                                          customText(
                                              text: controller.getContractOne
                                                  .value!.user.phoneNumber
                                                  .toString(),
                                              color: blackColor,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500),
                                          Divider(
                                            color: Colors.grey.shade200,
                                          ),
                                          h5,
                                          customText(
                                            text: "Occupants :",
                                            color: greyColor,
                                            fontSize: 15,
                                          ),
                                          customText(
                                              text: controller.getContractOne
                                                  .value!.occupants
                                                  .toString(),
                                              color: blackColor,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Divider(
                                    color: Colors.grey.shade200,
                                  ),
                                  h5,
                                  customText(
                                    text: "propertyType :",
                                    color: greyColor,
                                    fontSize: 15,
                                  ),
                                  h5,
                                  customText(
                                      text: controller
                                          .getContractOne.value!.propertyType,
                                      color: blackColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                  Divider(
                                    color: Colors.grey.shade200,
                                  ),
                                  h5,
                                  customText(
                                    text: "Leased start date :",
                                    color: greyColor,
                                    fontSize: 15,
                                  ),
                                  customText(
                                      text: controller
                                          .getContractOne.value!.leaseStartDate
                                          .toString(),
                                      color: blackColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                  Divider(
                                    color: Colors.grey.shade200,
                                  ),
                                  h5,
                                  customText(
                                    text: "Leased end date :",
                                    color: greyColor,
                                    fontSize: 15,
                                  ),
                                  customText(
                                      text: controller
                                          .getContractOne.value!.leaseEndDate
                                          .toString(),
                                      color: blackColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                  Divider(
                                    color: Colors.grey.shade200,
                                  ),
                                  h5,
                                  customText(
                                    text: "Lease Type :",
                                    color: greyColor,
                                    fontSize: 15,
                                  ),
                                  h5,
                                  customText(
                                      text: controller
                                          .getContractOne.value!.leaseType
                                          .toString(),
                                      color: blackColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                  Divider(
                                    color: Colors.grey.shade200,
                                  ),
                                  h5,
                                  customText(
                                    text: "Rent Amount :",
                                    color: greyColor,
                                    fontSize: 15,
                                  ),
                                  h5,
                                  customText(
                                      text:
                                          "\$${controller.getContractOne.value!.rentAmount}",
                                      color: blackColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                  Divider(
                                    color: Colors.grey.shade200,
                                  ),
                                  h5,
                                  customText(
                                    text: "Rent Due Date :",
                                    color: greyColor,
                                    fontSize: 15,
                                  ),
                                  h5,
                                  customText(
                                      text: controller
                                          .getContractOne.value!.rentDueDate,
                                      color: blackColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                  Divider(
                                    color: Colors.grey.shade200,
                                  ),
                                  h5,
                                  customText(
                                    text: "Rent Payment Method :",
                                    color: greyColor,
                                    fontSize: 15,
                                  ),
                                  h5,
                                  customText(
                                      text: controller.getContractOne.value!
                                          .rentPaymentMethod,
                                      color: blackColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                  Divider(
                                    color: Colors.grey.shade200,
                                  ),
                                  h5,
                                  customText(
                                    text: "Security Deposit Amount :",
                                    color: greyColor,
                                    fontSize: 15,
                                  ),
                                  h5,
                                  customText(
                                      text:
                                          "\$${controller.getContractOne.value!.securityDepositAmount}",
                                      color: blackColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                  Divider(
                                    color: Colors.grey.shade200,
                                  ),
                                  h5,
                                  customText(
                                    text: "Included Utilities : ",
                                    color: greyColor,
                                    fontSize: 15,
                                  ),
                                  h5,
                                  Builder(builder: (context) {
                                    return customText(
                                        text: controller.getContractOne.value!
                                            .includedUtilities,
                                        color: blackColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500);
                                  }),
                                  Divider(
                                    color: Colors.grey.shade200,
                                  ),
                                  h5,
                                  customText(
                                    text: "Tenant Responsibility : ",
                                    color: greyColor,
                                    fontSize: 15,
                                  ),
                                  h5,
                                  Builder(builder: (context) {
                                    return customText(
                                        text: controller.getContractOne.value!
                                            .tenantResponsibilities,
                                        color: blackColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500);
                                  }),
                                  Divider(
                                    color: Colors.grey.shade200,
                                  ),
                                  h5,
                                  customText(
                                    text: "Emergency Contact Name :",
                                    color: greyColor,
                                    fontSize: 15,
                                  ),
                                  h5,
                                  customText(
                                      text: controller.getContractOne.value!
                                          .emergencyContactName,
                                      color: blackColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                  Divider(
                                    color: Colors.grey.shade200,
                                  ),
                                  h5,
                                  customText(
                                    text: "Emergency Contact Phone :",
                                    color: greyColor,
                                    fontSize: 15,
                                  ),
                                  h5,
                                  customText(
                                      text: controller.getContractOne.value!
                                          .emergencyContactPhone,
                                      color: blackColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                  Divider(
                                    color: Colors.grey.shade200,
                                  ),
                                  h5,
                                  customText(
                                    text: "Emergency Contact Address :",
                                    color: greyColor,
                                    fontSize: 15,
                                  ),
                                  h5,
                                  customText(
                                      text: controller.getContractOne.value!
                                          .emergencyContactAddress,
                                      color: blackColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                  Divider(
                                    color: Colors.grey.shade200,
                                  ),
                                  h5,
                                  customText(
                                    text: "Building Superintendent Name :",
                                    color: greyColor,
                                    fontSize: 15,
                                  ),
                                  h5,
                                  customText(
                                      text: controller.getContractOne.value!
                                          .buildingSuperintendentName,
                                      color: blackColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                  Divider(
                                    color: Colors.grey.shade200,
                                  ),
                                  customText(
                                    text: "Building Superintendent Phone :",
                                    color: greyColor,
                                    fontSize: 15,
                                  ),
                                  h5,
                                  customText(
                                      text: controller.getContractOne.value!
                                          .buildingSuperintendentPhone,
                                      color: blackColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                  Divider(
                                    color: Colors.grey.shade200,
                                  ),
                                  h5,
                                  customText(
                                    text: "Building Superintendent Address :",
                                    color: greyColor,
                                    fontSize: 15,
                                  ),
                                  h5,
                                  customText(
                                      text: controller.getContractOne.value!
                                          .buildingSuperintendentAddress,
                                      color: blackColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                  Divider(
                                    color: Colors.grey.shade200,
                                  ),
                                  h5,
                                  customText(
                                    text: "Rent Increase Notice Period:",
                                    color: greyColor,
                                    fontSize: 15,
                                  ),
                                  h5,
                                  customText(
                                      text: controller.getContractOne.value!
                                          .rentIncreaseNoticePeriod
                                          .toString(),
                                      color: blackColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                  Divider(
                                    color: Colors.grey.shade200,
                                  ),
                                  h5,
                                  customText(
                                    text: "Notice Period for termination :",
                                    color: greyColor,
                                    fontSize: 15,
                                  ),
                                  h5,
                                  customText(
                                      text: controller.getContractOne.value!
                                          .noticePeriodForTermination
                                          .toString(),
                                      color: blackColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                  Divider(
                                    color: Colors.grey.shade200,
                                  ),
                                  h5,
                                  customText(
                                    text: "Late payment fee :",
                                    color: greyColor,
                                    fontSize: 15,
                                  ),
                                  h5,
                                  customText(
                                      text: controller
                                          .getContractOne.value!.latePaymentFee,
                                      color: blackColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                  Divider(
                                    color: Colors.grey.shade200,
                                  ),
                                  h5,
                                  customText(
                                    text: "Rental Incentives:",
                                    color: greyColor,
                                    fontSize: 15,
                                  ),
                                  h5,
                                  customText(
                                      text: controller.getContractOne.value!
                                          .rentalIncentives,
                                      color: blackColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                  Divider(
                                    color: Colors.grey.shade200,
                                  ),
                                  h5,
                                  customText(
                                    text: "Additional Terms :",
                                    color: greyColor,
                                    fontSize: 15,
                                  ),
                                  h5,
                                  customText(
                                      text: controller.getContractOne.value!
                                          .additionalTerms,
                                      color: blackColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                  Divider(
                                    color: Colors.grey.shade200,
                                  ),
                                  h30,
                                  Row(
                                    children: [
                                      // Expanded(
                                      //   child: CustomButton(
                                      //     height: 45,
                                      //     text: "Contract",
                                      //     fontSize: 18,
                                      //     gradientColor: greenGradient(),
                                      //   ),
                                      // ),
                                      // w15,
                                      Expanded(
                                        child: CustomButton(
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          height: 45,
                                          text: "Back",
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
