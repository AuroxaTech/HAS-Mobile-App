import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../app_constants/app_icon.dart';
import '../../app_constants/app_sizes.dart';
import '../../app_constants/color_constants.dart';
import '../../constant_widget/constant_widgets.dart';
import '../../controllers/land_lord/contract_status_controller.dart';
import '../../custom_widgets/custom_button.dart';
import '../../models/propert_model/contract_model.dart';
import '../../route_management/constant_routes.dart';

class ContractStatusScreen extends GetView<ContractStatusScreenController> {
  const ContractStatusScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
       appBar: titleAppBar("Contracts", action: [],
      ),
      body:  SafeArea(
        child: Obx(() =>  controller.isLoading.value ?
        const Center(child: CircularProgressIndicator()) :Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: RefreshIndicator(
            onRefresh: ()async{
             await controller.getServices();
            },
            child: Column(
              children: [
                Row(
                  children: [
                    // Expanded(
                    //   child: topContainer(
                    //     onTap: (){
                    //     //  controller.messages.value = true;
                    //       controller.landlord.value = false;
                    //       controller.service.value = false;
                    //     },
                    //     text: "All Contracts",
                    //     textColor: controller.messages.value ? primaryColor : greyColor,
                    //     borderColor: controller.messages.value ? primaryColor : greyColor,
                    //   ),
                    // ),
                    w10,
                    Expanded(
                      child: topContainer(
                        onTap: (){
                          // controller.messages.value = false;
                          controller.approved.value = true;
                          controller.pending.value = false;
                          controller.getServices();
                        },
                        text: "Approved(${controller.getFilteredContractList('1').length})",
                        textColor: controller.approved.value ? primaryColor : greyColor,
                        borderColor: controller.approved.value ? primaryColor : greyColor,
                      ),
                    ),
                    w10,
                    Expanded(
                      child: topContainer(
                        onTap: (){
                        //  controller.messages.value = false;
                          controller.getServices();
                          controller.approved.value = false;
                          controller.pending.value = true;
                        },
                        text: "Pending(${controller.getFilteredContractList('0').length})",
                        textColor: controller.pending.value ? primaryColor : greyColor,
                        borderColor:  controller.pending.value ? primaryColor : greyColor,
                      ),
                    ),
                  ],
                ),
                h20,
               controller.approved.value ? controller.getFilteredContractList('1').isEmpty ?
                   customText(
                     text: "No Approved contract here"
                   )
                   :  ListView.builder(
                   itemCount: controller.getFilteredContractList('1').length,
                   shrinkWrap: true,
                   itemBuilder: (context, index){
                    Contracts contracts = controller.getFilteredContractList('1')[index];
                    print(contracts.status);
                    return Column(
                      children: [
                        const SizedBox(
                          height: 15,
                        ),
                        InkWell(
                          onTap: () {
                            Get.toNamed(kContractDetailScreen , arguments: contracts.id);
                          },

                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: whiteColor,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 1.0,
                                ),
                              ],
                            ),

                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10, top: 12),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SvgPicture.asset(AppIcons.homeContract),
                                          w15,
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              customText(
                                                text: contracts.tenantName,
                                                fontSize: 22,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              customText(
                                                text: contracts.tenantAddress,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w300,
                                              ),

                                            ],
                                          ),
                                        ],
                                      ),
                                    ),

                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Container(
                                          decoration:  BoxDecoration(
                                            color: greenColor,
                                              border: Border.all(color: greenColor, ),
                                              borderRadius: BorderRadius.circular(8,)
                                          ),
                                          padding: const EdgeInsets.only(top: 5, bottom: 5, left: 8, right: 8),
                                          child: Center(
                                            child: customText(
                                                text: "Approved",
                                                color: Colors.white,
                                                fontSize: 10
                                            ),
                                          ),
                                        ),
                                      ),
                                    )

                                  ],
                                ) ,
                                h20,
                                // Padding(
                                //   padding: const EdgeInsets.all(12.0),
                                //   child: Row(
                                //     children: [
                                //       Expanded(
                                //         child: CustomButton(
                                //           borderRadius: BorderRadius.circular(40),
                                //            height: screenHeight(context) * 0.05,
                                //           text: "Accept?",
                                //           fontSize: 16,
                                //           onTap: (){
                                //             animatedDialog(context,
                                //                 title: "Accept Contract",
                                //                 subTitle: "Are you sure to accept this contract",
                                //                 yesButtonText: "Accept",
                                //                 yesTap: (){
                                //                   controller.acceptContractRequest(
                                //                       contractId: controller.getContractList[index].id,
                                //                       status: 1,
                                //                     ).then((value) {
                                //                   //  controller.getServicesRequest();
                                //                   });
                                //                 }
                                //             );
                                //           },
                                //           gradientColor: gradient( ),
                                //         ),
                                //       ),
                                //       const SizedBox(
                                //         width: 15,
                                //       ),
                                //       Expanded(
                                //         child: CustomButton(
                                //           borderRadius: BorderRadius.circular(40),
                                //           height: screenHeight(context) * 0.05,
                                //           text: "Decline?",
                                //           fontSize: 16,
                                //           gradientColor: redGradient(),
                                //           onTap: (){
                                //             animatedDialog(context,
                                //                 title: "Decline Contract",
                                //                 subTitle: "Are you sure to accept this contract",
                                //                 yesButtonText: "Decline",
                                //                 yesTap: (){
                                //                   controller.acceptContractRequest(
                                //                     contractId: controller.getContractList[index].id,
                                //                     status: 2,
                                //                   ).then((value) {
                                //                     //  controller.getServicesRequest();
                                //                   });
                                //                 }
                                //             );
                                //           },
                                //         ),
                                //       ),
                                //     ],
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ) : const SizedBox(),

                controller.pending.value ? controller.getFilteredContractList('0').isEmpty ?
                customText(
                    text: "No Pending contract here"
                )
                    :   ListView.builder(
                  itemCount: controller.getFilteredContractList('0').length,
                  shrinkWrap: true,
                  itemBuilder: (context, index){
                    Contracts contracts = controller.getFilteredContractList('0')[index];
                    print("Pending status :${contracts.status}a");
                    return Column(
                      children: [
                        const SizedBox(
                          height: 15,
                        ),
                        InkWell(
                          onTap: (){
                            Get.toNamed(kContractDetailScreen , arguments: contracts.id);
                          },
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: whiteColor,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 1.0,
                                ),
                              ],
                            ),

                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 15, top: 12),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SvgPicture.asset(AppIcons.homeContract),
                                          w15,
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              customText(
                                                text: contracts.tenantName,
                                                fontSize: 22,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              customText(
                                                text: contracts.tenantAddress,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w300,
                                              ),

                                            ],
                                          ),
                                        ],
                                      ),
                                    ),


                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Container(
                                        decoration:  BoxDecoration(
                                          color: CupertinoColors.systemYellow,
                                            border: Border.all(color: CupertinoColors.systemYellow ),
                                            borderRadius: BorderRadius.circular(8,)
                                        ),
                                        padding: const EdgeInsets.only(top: 5, bottom: 5, left: 12, right: 12),
                                        child: Center(
                                          child: customText(
                                              text: "Active",
                                              color: Colors.black,
                                              fontSize: 10
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ) ,
                                h20,
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: CustomButton(
                                          borderRadius: BorderRadius.circular(40),
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
                                                    contractId: controller.getContractList[index].id,
                                                    status: "1",
                                                  ).then((value) {
                                                      controller.getServices();
                                                  });
                                                }
                                            );
                                          },
                                          gradientColor: gradient( ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      Expanded(
                                        child: CustomButton(
                                          borderRadius: BorderRadius.circular(40),
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
                                                    contractId: controller.getContractList[index].id,
                                                    status: "2",
                                                  ).then((value) {
                                                    controller.getServices();
                                                  });
                                                }
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ) : const SizedBox(),
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
      borderRadius: BorderRadius.circular(30),
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
}
