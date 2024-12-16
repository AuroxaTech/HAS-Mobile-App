import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_app/controllers/dasboard_controller/all_property_controller.dart';
import 'package:property_app/views/dashoard_screens/all_property_screen.dart';
import 'package:property_app/views/dashoard_screens/propert_map.dart';

import '../../app_constants/app_sizes.dart';
import '../../app_constants/color_constants.dart';
import '../../constant_widget/constant_widgets.dart';
import '../../route_management/constant_routes.dart';

class PropertyTabsScreen extends StatefulWidget {
  const PropertyTabsScreen({Key? key}) : super(key: key);

  @override
  _PropertyTabsScreenState createState() => _PropertyTabsScreenState();
}

class _PropertyTabsScreenState extends State<PropertyTabsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final AllPropertyController controller = Get.put(AllPropertyController());

  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: controller.selectedIndex.value,
    );

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        controller.selectedIndex.value = _tabController.index;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
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
                    color: Colors.grey[100],
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
                              _tabController.animateTo(i); // Change tab
                              controller.selectedIndex.value =
                                  i; // Update index
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
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
                controller: _tabController,
                children: [AllPropertyScreen(), PropertyMap()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
