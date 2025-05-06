import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../app_constants/app_icon.dart';
import '../../app_constants/app_sizes.dart';
import '../../app_constants/color_constants.dart';
import '../../constant_widget/constant_widgets.dart';
import '../../controllers/tenant_controllers/tenant_contract_controller.dart';
import '../../custom_widgets/custom_button.dart';
import '../../models/propert_model/contract_model.dart';
import '../../route_management/constant_routes.dart';

class TenantContractScreen extends GetView<TenantContractController> {
  const TenantContractScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: titleAppBar("Contracts", action: []),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Obx(() => topContainer(
                      onTap: () {
                        controller.approved.value = true;
                        controller.pending.value = false;
                        controller.pagingController.refresh();
                      },
                      text:
                      "Approved (${controller.approvedContractsCount.value})",
                      textColor:
                      controller.approved.value ? primaryColor : greyColor,
                      borderColor:
                      controller.approved.value ? primaryColor : greyColor,
                    )),
                  ),
                  w10,
                  Expanded(
                    child: Obx(() => topContainer(
                      onTap: () {
                        controller.approved.value = false;
                        controller.pending.value = true;
                        controller.pagingController.refresh();
                      },
                      text:
                      "Pending (${controller.pendingContractsCount.value})",
                      textColor:
                      controller.pending.value ? primaryColor : greyColor,
                      borderColor:
                      controller.pending.value ? primaryColor : greyColor,
                    )),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PagedListView<int, Contracts>(
                pagingController: controller.pagingController,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 15),
                builderDelegate: PagedChildBuilderDelegate<Contracts>(
                  itemBuilder: (context, contract, index) {
                    return ContractItem(contract: contract);
                  },
                  firstPageProgressIndicatorBuilder: (context) =>
                  const Center(child: CircularProgressIndicator()),
                  newPageProgressIndicatorBuilder: (context) =>
                  const Center(child: CircularProgressIndicator()),
                  newPageErrorIndicatorBuilder: (context){
                    print("error ${controller.pagingController.error}");
                    return Container();
                  }
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget topContainer({
    required String text,
    required Color textColor,
    required Color borderColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(30),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(30),
        ),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: Center(
          child: customText(text: text, color: textColor, fontSize: 12),
        ),
      ),
    );
  }
}

class ContractItem extends StatelessWidget {
  final Contracts contract;

  const ContractItem({Key? key, required this.contract}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            Get.toNamed(kTenantContractDetailScreen, arguments: contract.id);
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
                                text: contract.landlordName,
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                              ),
                              customText(
                                text: contract.landlordAddress,
                                fontSize: 18,
                                fontWeight: FontWeight.w300,
                              ),
                              const SizedBox(height: 5),
                              Center(
                                child: CustomButton(
                                  borderRadius: BorderRadius.circular(40),
                                  height: screenHeight(context) * 0.045,
                                  width: screenWidth(context) * 0.3,
                                  text: "Detail",
                                  fontSize: 16,
                                  onTap: () {
                                    Get.toNamed(kTenantContractDetailScreen,
                                        arguments: contract.id);
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
                        decoration: BoxDecoration(
                          color: contract.status == "1"
                              ? greenColor
                              : CupertinoColors.systemYellow,
                          border: Border.all(
                            color: contract.status == "1"
                                ? greenColor
                                : CupertinoColors.systemYellow,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 12),
                        child: Center(
                          child: customText(
                              text: contract.status == "1"
                                  ? "Approved"
                                  : "Pending",
                              color:
                              contract.status == "1" ? Colors.white : Colors.black,
                              fontSize: 10),
                        ),
                      ),
                    )
                  ],
                ),
                h20,
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
