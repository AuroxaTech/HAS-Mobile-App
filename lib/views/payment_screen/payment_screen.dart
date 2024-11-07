import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:property_app/app_constants/color_constants.dart';
import 'package:property_app/constant_widget/constant_widgets.dart';
import 'package:property_app/controllers/payment_controller/payment_screen_controller.dart';

import '../../app_constants/app_icon.dart';
import '../../app_constants/app_sizes.dart';

class PaymentsScreen extends GetView<PaymentScreenController> {
  const PaymentsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: titleAppBar("Payments", action: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
      ]),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
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
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SvgPicture.asset(AppIcons.homeContract),
                              w15,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  customText(
                                    text: "Oakwood",
                                    fontSize: 22,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  customText(
                                    text: "123 Main St, Cityville",
                                    fontSize: 18,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.green.shade100,
                                borderRadius: BorderRadius.circular(8)),
                            padding: EdgeInsets.only(
                                left: 10, right: 10, top: 3, bottom: 3),
                            child: Center(
                              child: customText(
                                text: "Paid",
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          )
                        ],
                      ),
                      h10,
                      Row(
                        children: [
                          customText(
                            text: "Rent Payment :",
                            fontSize: 18,
                            fontWeight: FontWeight.w300,
                          ),
                          w15,
                          Image.asset(AppIcons.paid),
                        ],
                      ),
                      h10,
                      customText(
                        text: "Payment Status :  \$950 ",
                        fontSize: 18,
                        fontWeight: FontWeight.w300,
                      ),
                      h10,
                      customText(
                        text: "Last Payment: Jan 15,2023 ",
                        fontSize: 18,
                        fontWeight: FontWeight.w300,
                      ),
                      h10,
                    ],
                  ),
                ),
                h10,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
