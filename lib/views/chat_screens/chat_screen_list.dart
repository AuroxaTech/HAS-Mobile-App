import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_app/app_constants/app_sizes.dart';
import 'package:property_app/app_constants/color_constants.dart';
import 'package:property_app/constant_widget/constant_widgets.dart';

import '../../controllers/chat_screens_controller/chat_screen_controller.dart';
import '../../route_management/constant_routes.dart';

class ChatScreenList extends GetView<ChatScreenListController> {
  const ChatScreenList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: whiteColor,
        appBar: titleAppBar("Chats", action: [
          IconButton(onPressed: (){},
              icon: const Icon(Icons.search))
        ],
       ),
        body:  SafeArea(
          child: Obx(() => Column(
              children: [
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Row(
                  children: [
                    Expanded(
                      child: topContainer(
                        onTap: (){
                          controller.messages.value = true;
                          controller.landlord.value = false;
                          controller.service.value = false;
                        },
                        text: "All Messages",
                        textColor: controller.messages.value ? primaryColor : greyColor,
                        borderColor: controller.messages.value ? primaryColor : greyColor,
                      ),
                    ),
                    w10,
                    Expanded(
                      child: topContainer(
                          onTap: (){
                            controller.messages.value = false;
                            controller.landlord.value = true;
                            controller.service.value = false;
                          },
                          text: "Landlord(3)",
                          textColor: controller.landlord.value ? primaryColor : greyColor,
                          borderColor: controller.landlord.value ? primaryColor : greyColor,
                      ),
                    ),
                    w10,
                    Expanded(
                      child: topContainer(
                          onTap: (){
                            controller.messages.value = false;
                            controller.landlord.value = false;
                            controller.service.value = true;
                          },
                          text: "Service Pro(4)",
                          textColor: controller.service.value ? primaryColor : greyColor,
                          borderColor:  controller.service.value ? primaryColor : greyColor,
                      ),
                    ),
                  ],
                ),
              ),
              ChatItem(name: "David", message: "Hello ! Tenant Here-Wanna", time: "11:00", unread: true,
                      onTap: (){
                        Get.toNamed(kChatConversionScreen);
                      },
              ),
                ChatItem(
                    onTap: (  ) {

                    },
                    name: "Mack", message: "Hello ! Tenant Here-Wanna", time: "11:00", unread: true),
                 ChatItem(
                     onTap: (){

                     },
                     name: "Stafeny", message: "Hello ! Tenant Here-Wanna", time: "11:00",unread:false),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget topContainer({String? text, Color? textColor, Color? borderColor, VoidCallback? onTap}){
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: borderColor!),
          borderRadius: BorderRadius.circular(30),
        ),
        padding: const EdgeInsets.only(top: 8, bottom: 8, left: 1, right: 1),
        child: Center(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: customText(
                text: text,
                color: textColor,
                fontSize: 11
            ),
          ),
        ),
      ),
    );
  }
}

class ChatItem extends StatelessWidget {
  final String name;
  final String message;
  final String time;
  final bool unread;
  final VoidCallback? onTap;

  const ChatItem({
    Key? key,
    required this.name,
    required this.message,
    required this.time,
    required this.unread,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: CircleAvatar(
          child: Text(name[0]), // Display the first letter of the name
        ),
        title: customText(text: name),
        subtitle: customText(text: message),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            customText(text: time),
            if (unread)
              CircleAvatar(
                radius: 10,
                child: customText(
                  text: "2",
                  fontSize: 12
                ),
              )
          ],
        ),
        onTap: onTap!
        );
    }
}
