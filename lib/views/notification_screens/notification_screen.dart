import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_app/app_constants/app_icon.dart';
import 'package:property_app/app_constants/color_constants.dart';
import 'package:property_app/constant_widget/constant_widgets.dart';

import '../../controllers/notification_conroller/notificatio_screens_controller.dart';

class NotificationScreen extends GetView<NotificationScreenController> {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: notificationAppbar(context, text: "Notifications"),
      body: SafeArea(
        child: Column(
          children: [

            ListView.builder(
                itemCount: 3,
                shrinkWrap: true,
                itemBuilder: (context, index){
                return  Column(
                  children: [
                    ListTile(
                      leading: Image.asset(index == 1 ?AppIcons.blueTik : index == 2 ?AppIcons.crossTik :  AppIcons.greenTik),
                      title: customText(
                          text: "Professional house cleaning",
                          fontWeight: FontWeight.w500,
                          fontSize: 15
                      ),
                    ),
                    Divider(
                      height: 2,
                      thickness: 1,
                    )
                  ],
                );
            })
          ],
        ),
      ),
    );
  }
}
