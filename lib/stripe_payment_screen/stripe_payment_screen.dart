import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_app/app_constants/color_constants.dart';
import 'package:property_app/constant_widget/constant_widgets.dart';
import 'package:property_app/custom_widgets/custom_button.dart';

import '../controllers/jobs_controller/job_detail_screen.dart';
import '../controllers/stripe_payment_controller/stripe_payment_controller.dart';

class StripePaymentScreen extends StatelessWidget {
  int? jobId;
  int? id;
  String? serviceProviderName;
  String? serviceProviderEmail;
  final StripePaymentScreenController stripePaymentController =
      Get.put(StripePaymentScreenController());
  final JobDetailController jobDetailController =
      Get.find<JobDetailController>();

  StripePaymentScreen(
      {Key? key,
      this.jobId,
      this.id,
      this.serviceProviderName,
      this.serviceProviderEmail})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    print("Job Id ===> $jobId");
    print("Id ===> $id");
    print(
        'Payment : ${stripePaymentController.price} Service Id : ${stripePaymentController.serviceId} Service Provider Id : ${stripePaymentController.serviceProviderId}');
    return Scaffold(
      appBar: AppBar(
        title: customText(text: 'Add Payment Details'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() => stripePaymentController.isProcessing.value
            ? const Center(child: CircularProgressIndicator())
            : Center(
                child: SizedBox(
                  height: 450,
                  child: DecoratedBox(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            customText(
                                text: "Service Provider Details",
                                color: blackColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 24),
                            const SizedBox(
                              height: 40,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: customText(
                                      text: "Name :",
                                      color: blackColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                Expanded(
                                  child: customText(
                                    text: serviceProviderName ??
                                        "No Name", // Use null-aware access and a fallback value
                                    color: blackColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: customText(
                                      text: "Email :",
                                      color: blackColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                Expanded(
                                  child: customText(
                                      text: serviceProviderEmail ?? "No Email",
                                      color: blackColor,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: customText(
                                      text: "Job Price:",
                                      color: blackColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                Expanded(
                                  child: customText(
                                      text:
                                          "\$${stripePaymentController.price.value.toInt()}",
                                      color: blackColor,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16),
                                ),
                              ],
                            ),
                            const SizedBox(height: 60),
                            CustomButton(
                              gradientColor: greenGradient(),
                              text: "Payout",
                              btnTextColor: whiteColor,
                              onTap: () async {
                                String amount =
                                    (stripePaymentController.price.value * 100)
                                        .toInt()
                                        .toString(); // Convert price to cents
                                String currency = 'usd';
                                // Withdraw payment with Stripe PaymentSheet
                                await stripePaymentController.withdrawPayment(
                                    amount, currency);
                                //Get.back();
                                jobDetailController
                                    .acceptServiceRequest(
                                        jobId: jobId, status: 1)
                                    .then((value) {
                                  jobDetailController.getJobRequest(id: id);
                                });
                                //Get.off(() => JobsScreen(isBack: true));
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )),
      ),
    );
  }
}
