import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:property_app/app_constants/color_constants.dart';
import 'package:property_app/constant_widget/constant_widgets.dart';
import 'package:property_app/controllers/payment_controller/payment_screen_controller.dart';

import '../../app_constants/app_sizes.dart';

class PaymentsScreen extends GetView<PaymentScreenController> {
  const PaymentsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: titleAppBar("Payments"),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.providerPayments.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.payment_outlined,
                    size: 80, color: Colors.grey),
                h20,
                customText(
                  text: "No payment history found",
                  fontSize: 18,
                  color: Colors.grey[600],
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  customText(
                    text: "Total Earnings (After Commission)",
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                  h10,
                  customText(
                    text:
                        "\$${controller.totalPaymentsReceived.toStringAsFixed(2)}",
                    fontSize: 28,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  h5,
                  customText(
                    text: "2% commission is deducted from all payments",
                    fontSize: 12,
                    color: Colors.white70,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  customText(
                    text: "Transaction History",
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  await controller.fetchProviderPayments();
                },
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: controller.providerPayments.length,
                  itemBuilder: (context, index) {
                    final payment = controller.providerPayments[index];
                    final originalAmount = (payment['amount'] is int)
                        ? (payment['amount'] as int).toDouble()
                        : (payment['amount'] ?? 0.0);
                    final finalAmount =
                        controller.calculateFinalAmount(originalAmount);
                    final commissionAmount =
                        controller.calculateCommission(originalAmount);

                    // Parse the created date
                    String createdDate = payment['created'] ?? '';
                    DateTime? dateTime;
                    try {
                      dateTime = DateTime.parse(createdDate);
                    } catch (e) {
                      print("Error parsing date: $e");
                    }

                    // Format the date
                    final formattedDate = dateTime != null
                        ? DateFormat('MMM dd, yyyy').format(dateTime)
                        : 'Unknown date';

                    // Format the time
                    final formattedTime = dateTime != null
                        ? DateFormat('h:mm a').format(dateTime)
                        : '';

                    return Card(
                      color: Colors.white,
                      elevation: 2,
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.account_balance_wallet,
                                color: primaryColor,
                              ),
                            ),
                            w15,
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  customText(
                                    text: "Payment Received",
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  h5,
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.calendar_today_outlined,
                                        size: 14,
                                        color: Colors.grey[600],
                                      ),
                                      w5,
                                      customText(
                                        text: formattedDate,
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                      ),
                                    ],
                                  ),
                                  h5,
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.access_time,
                                        size: 14,
                                        color: Colors.grey[600],
                                      ),
                                      w5,
                                      customText(
                                        text: formattedTime,
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                customText(
                                  text: "\$${finalAmount.toStringAsFixed(2)}",
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green[700],
                                ),
                                h5,
                                Row(
                                  children: [
                                    customText(
                                      text:
                                          "Original: \$${originalAmount.toStringAsFixed(2)}",
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                    w5,
                                    customText(
                                      text:
                                          "(-\$${commissionAmount.toStringAsFixed(2)})",
                                      fontSize: 12,
                                      color: Colors.red[400],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
