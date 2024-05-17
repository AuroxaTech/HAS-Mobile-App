import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:property_app/models/propert_model/contract_model.dart';
import 'package:property_app/route_management/constant_routes.dart';
import '../../app_constants/app_icon.dart';
import '../../app_constants/app_sizes.dart';
import '../../app_constants/color_constants.dart';
import '../../constant_widget/constant_widgets.dart';
import '../../controllers/tenant_controllers/tenant_contract_controller.dart';
import '../../custom_widgets/custom_button.dart';

class TenantContractScreen extends GetView<TenantContractController> {
  const TenantContractScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: whiteColor,
       appBar: titleAppBar("Contracts", action: []),
      // drawer: const Drawer(),
      body:  SafeArea(
        child: Obx(() =>  controller.isLoading.value ?
         const Center(child: CircularProgressIndicator()) :Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: SingleChildScrollView(
              child: RefreshIndicator(
                onRefresh: ()async{
                  await controller.getContracts();
                },
                child: Column(
                children: [
                  Row(
                    children: [
                      // Expanded(
                      //   child: topContainer(
                      //     onTap: (){
                      //       /controller.messages.value = true;
                      //       controller.approved.value = false;
                      //       controller.pending.value = false;
                      //     },
                      //     text: "All Contracts",
                      //     textColor: controller.messages.value ? primaryColor : greyColor,
                      //     borderColor: controller.messages.value ? primaryColor : greyColor,
                      //   ),
                      // ),
                      // w10,
                      Expanded(
                        child: topContainer(
                          onTap: (){
                            //controller.messages.value = false;
                            controller.approved.value = true;
                            controller.pending.value = false;
                            controller.getContracts();
                          },
                          text: "Approved(${controller.getFilteredContractList("1").length})",
                          textColor: controller.approved.value ? primaryColor : greyColor,
                          borderColor: controller.approved.value ? primaryColor : greyColor,
                        ),
                      ),

                      w10,
                      Expanded(
                        child: topContainer(
                          onTap: (){
                           // controller.messages.value = false;
                            controller.approved.value = false;
                            controller.pending.value = true;
                            controller.getContracts();
                          },
                          text: "Pending(${controller.getFilteredContractList("0").length})",
                          textColor: controller.pending.value ? primaryColor : greyColor,
                          borderColor:  controller.pending.value ? primaryColor : greyColor,
                        ),
                      ),
                    ],
                  ),
                  h20,
                  controller.approved.value ?  ListView.builder(
                    itemCount: controller.getFilteredContractList("1").length,
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index){
                      Contracts contracts = controller.getFilteredContractList("1")[index];
                      return Column(
                        children: [
                          InkWell(
                            onTap: (){
                              Get.toNamed(kTenantContractDetailScreen , arguments: contracts.id);
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
                                                  text: contracts.landlordName,
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.w500,

                                                ),
                                                customText(
                                                  text: contracts.landlordAddress,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w300,
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Center(
                                                  child: CustomButton(
                                                    borderRadius: BorderRadius.circular(40),
                                                    height: screenHeight(context) * 0.045,
                                                    width: screenWidth(context) * 0.3,
                                                    text: "Detail",
                                                    fontSize: 16,
                                                    onTap: (){
                                                      Get.toNamed(kTenantContractDetailScreen , arguments: contracts.id);
                                                    },
                                                    gradientColor: gradient(),
                                                  ),
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
                                            color: greenColor,
                                              border: Border.all(color: greenColor, ),
                                              borderRadius: BorderRadius.circular(8,)
                                          ),
                                          padding: const EdgeInsets.only(top: 5, bottom: 5, left: 12, right: 12),
                                          child: Center(
                                            child: customText(
                                                text: "Approved",
                                                color: Colors.white,
                                                fontSize: 10
                                            ),
                                          ),
                                        ),
                                      )

                                    ],
                                  ) ,
                                  h20,

                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          )
                        ],
                      );
                    },
                  ) : const SizedBox(),
                  controller.pending.value ?  ListView.builder(
                    itemCount: controller.getFilteredContractList("0").length,
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index){
                      Contracts contracts = controller.getFilteredContractList("0")[index];
                      return Column(
                        children: [
                          InkWell(
                            onTap: (){
                              Get.toNamed(kTenantContractDetailScreen , arguments: contracts.id);
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
                                                  text: contracts.landlordName,
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.w500,

                                                ),
                                                customText(
                                                  text: contracts.landlordAddress,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w300,
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Center(
                                                  child: CustomButton(
                                                    borderRadius: BorderRadius.circular(40),
                                                    height: screenHeight(context) * 0.045,
                                                    width: screenWidth(context) * 0.3,
                                                    text: "Detail",
                                                    fontSize: 16,
                                                    onTap: (){
                                                      Get.toNamed(kTenantContractDetailScreen , arguments: contracts.id);
                                                    },
                                                    gradientColor: gradient(),
                                                  ),
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
                                            color: CupertinoColors.systemYellow ,
                                              border: Border.all(color: CupertinoColors.systemYellow, ),
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

                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          )
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
