import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_app/controllers/dasboard_controller/all_property_controller.dart';
import 'package:property_app/views/dashoard_screens/all_property_screen.dart';
import 'package:property_app/views/dashoard_screens/propert_map.dart';

import '../../app_constants/app_sizes.dart';
import '../../app_constants/color_constants.dart';
import '../../constant_widget/constant_widgets.dart';
import '../../route_management/constant_routes.dart';
import '../stripe_payment_screen/stripe_payment_screen.dart';

class PropertyTabsScreen extends GetView<AllPropertyController> {
  const PropertyTabsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 10.0, bottom: 30.0),
        child: SizedBox(
          width: 50,
          height: 50,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>  StripePaymentView()));
            },
            backgroundColor: Colors.white,
            elevation: 8.0,
            child: const Icon(Icons.add),
          ),
        ),
      ),
      appBar: titleAppBar("Properties", action: [
        IconButton(
            onPressed: () {
              Get.toNamed(kPropertyFilterScreen)?.then((result) {
                if (result != null) {
                  controller.pagingController.value.itemList!.clear();
                  return controller.getProperties(1, result);
                }
              });
            },
            icon: const Icon(Icons.filter_list)),
      ]),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.grey[100], // Background color of the tab bar
                    borderRadius: BorderRadius.circular(50.0),
                    border: Border.all(color: borderColor)),
                child: Row(
                  children: [
                    for (int i = 0; i < 2; i++)
                      Obx(
                        () => Expanded(
                          child: InkWell(
                            highlightColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            onTap: () {
                              controller.tabController.animateTo(i);
                              controller.selectedIndex.value = i;
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10), // Padding for the tab
                              alignment: Alignment.center,
                              child: Column(
                                children: [
                                  Container(
                                    width: 10,
                                    height: 10,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color:
                                            controller.selectedIndex.value == i
                                                ? Colors.blue
                                                : Colors.transparent),
                                  ),
                                  h5,
                                  customText(
                                    text: i == 0 ? 'Properties' : 'Map',
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight:
                                        controller.selectedIndex.value == i
                                            ? FontWeight.w600
                                            : FontWeight.w400,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            h20,
            Expanded(
              child: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                controller: controller.tabController,
                children: [AllPropertyScreen(), const PropertyMap()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
