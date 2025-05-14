import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_app/app_constants/color_constants.dart';
import 'package:property_app/constant_widget/constant_widgets.dart';
import 'package:property_app/custom_widgets/custom_button.dart';

import '../controllers/jobs_controller/job_detail_screen.dart';
import '../controllers/stripe_payment_controller/stripe_payment_controller.dart';
import '../utils/shared_preferences/preferences.dart';
import '../views/main_bottom_bar/main_bottom_bar.dart';
import '../views/main_bottom_bar/service_provider_bottom_ar.dart';
import '../views/main_bottom_bar/tenant_bottom_bar.dart';
import '../views/main_bottom_bar/visitor_bottom_bar.dart';

class StripePaymentScreen extends StatelessWidget {
  final int? jobId;
  final int? id;
  final String? serviceProviderName;
  final String? serviceId;

  StripePaymentScreen(
      {Key? key, this.jobId, this.id, this.serviceProviderName, this.serviceId})
      : super(key: key);

  final StripePaymentScreenController stripePaymentController =
      Get.find<StripePaymentScreenController>();
  final JobDetailController jobDetailController =
      Get.find<JobDetailController>();

  @override
  Widget build(BuildContext context) {
    print("Job Id ===> $jobId");
    print("Id ===> $id");
    print(
        'Payment: \$${stripePaymentController.price} | Service Id: ${stripePaymentController.serviceId} | Service Provider Id: ${stripePaymentController.serviceProviderId}');

    return Scaffold(
      appBar: AppBar(
        title: customText(
          text: 'Payment',
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() => stripePaymentController.isProcessing.value
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 20),
                    Text("Processing payment...")
                  ],
                ),
              )
            : Center(
                child: SizedBox(
                  height: 450,
                  child: DecoratedBox(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          customText(
                            text: "Payment Details",
                            color: blackColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 40),
                          _buildInfoRow(
                            label: "Service Name:",
                            value: serviceProviderName ?? "No Name",
                          ),
                          const SizedBox(height: 20),
                          _buildInfoRow(
                            label: "Amount:",
                            value:
                                "\$${stripePaymentController.price.value.toInt()}",
                            valueStyle: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),
                          const SizedBox(height: 60),
                          CustomButton(
                            gradientColor: greenGradient(),
                            text: "Pay Now",
                            btnTextColor: whiteColor,
                            onTap: () async {
                              var role = await Preferences.getRoleID();
                              bool paymentSuccess =
                                  await stripePaymentController
                                      .processPayment();

                              if (paymentSuccess && jobId != null) {
                                await jobDetailController.acceptServiceRequest(
                                  jobId: jobId,
                                  status: "completed",
                                );

                                if (id != null) {
                                  await jobDetailController.getJobRequest(
                                      id: id);
                                }

                                switch (role) {
                                  case "1":
                                    Get.offAll(const MainBottomBar());
                                    break;
                                  case "2":
                                    Get.offAll(const TenantBottomBar());
                                    break;
                                  case "3":
                                    await const ServiceProviderBottomBar();
                                    break;
                                  case "4":
                                    Get.offAll(const VisitorBottomBar());
                                    break;
                                  default:
                                    Get.back();
                                }
                              }
                            },
                          ),
                          const SizedBox(height: 20),
                          TextButton(
                            onPressed: () => Get.back(),
                            child: customText(
                              text: "Cancel",
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )),
      ),
    );
  }

  Widget _buildInfoRow({
    required String label,
    required String value,
    TextStyle? valueStyle,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: customText(
            text: label,
            color: blackColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Expanded(
          flex: 3,
          child: customText(
            text: value,
            color: blackColor,
            fontWeight: FontWeight.w600,
            fontSize: 16,
            style: valueStyle,
          ),
        ),
      ],
    );
  }
}
