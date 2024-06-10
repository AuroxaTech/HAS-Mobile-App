import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:property_app/app_constants/animations.dart';
import 'package:property_app/app_constants/app_icon.dart';
import 'package:property_app/app_constants/color_constants.dart';
import 'package:property_app/constant_widget/constant_widgets.dart';
import 'package:property_app/custom_widgets/custom_button.dart';
import 'package:property_app/utils/shared_preferences/preferences.dart';
import 'package:property_app/utils/utils.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../app_constants/app_sizes.dart';
import '../../constant_widget/view_photo.dart';
import '../../controllers/dasboard_controller/all_property_detail_controller.dart';
import '../../route_management/constant_routes.dart';
import '../../utils/api_urls.dart';
import '../chat_screens/chat_conversion_screen.dart';

class AllPropertyDetailScreen extends GetView<AllPropertyDetailController> {
  const AllPropertyDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(() => controller.isLoading.value ?
        const Center(child: CircularProgressIndicator()) :

        controller.getPropertyOne.value == null
        ? Center(
          child: customText(
            text: "No Detail Found",
            fontWeight: FontWeight.w500,
            fontSize: 18

          ),
        ) : Stack(
          children: [
            PageView.builder(
              itemCount: controller.images.length,
              scrollDirection: Axis.horizontal,
              controller: controller.pageController,
              itemBuilder: (context, index){
                String imagesString = controller.getPropertyOne.value!.images.toString();
                List<String> imageList = imagesString.split(',');
                controller.images = imageList;

                return InkWell(
                  onTap: (){
                    Get.to(() => ViewImage(photo: AppUrls.propertyImages + imageList[index],), transition: routeTransition);
                  },
                  child:
                    CachedNetworkImage(
                      width: double.infinity,
                      height: screenHeight(context) * 0.5,
                      imageUrl: AppUrls.propertyImages + imageList[index] ,
                      fit: BoxFit.cover,
                      errorWidget: (context, e , b){
                        return Image.asset(AppIcons.appLogo);
                      },
                    ),

                );
              },
            ),

            Positioned(child:   Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: (){
                      Get.back();
                    },
                    child: CircleAvatar(
                      backgroundColor: whiteColor,
                      child: SvgPicture.asset(AppIcons.backIcon),
                    ),
                  ),
                  // InkWell(
                  //   onTap: (){
                  //     Get.toNamed(kEditPropertyScreen);
                  //   },
                  //   child: CircleAvatar(
                  //     backgroundColor: whiteColor,
                  //     child: SvgPicture.asset(AppIcons.editIcon),
                  //   ),
                  // )
                ],
              ),
            ),),
            Positioned(child:  Padding(
              padding: const EdgeInsets.only(top: 290.0),
              child: Align(
                alignment: Alignment.topCenter,
                child: SmoothPageIndicator(
                  controller: controller.pageController, // Connect the indicator to the controller
                  count: controller.images.length,
                  effect: WormEffect(
                      dotColor: whiteColor,
                      dotHeight: 10,
                      dotWidth: 10
                  ), // Feel free to choose any effect
                ),
              ),
            ),),
            const MyDraggable(),
          ],
        ),
        ),
      ),
    );
  }
}


class MyDraggable extends GetView<AllPropertyDetailController> {
  const MyDraggable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints) {
          return  DraggableScrollableSheet(
            key: controller.sheet,
            initialChildSize: 0.55,
            maxChildSize: 0.55,      // Set maxChildSize to the same value (0.5)
            minChildSize: 0.55,
            // expand: true,
            // snap: true,
            // snapSizes: const [
            //   0.5,  // Set the first snap size to the minimum size (0.2)
            //   0.95,
            // ],
            controller: controller.controller,
            builder: (BuildContext context, ScrollController scrollController) {
              return DecoratedBox(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: CustomScrollView(
                    controller: scrollController,
                    slivers: [
                      SliverList.list(
                        children:  [
                          Padding(
                            padding: EdgeInsets.only(
                                bottom: MediaQuery.of(context).viewInsets.bottom, left: 10, right: 10),
                            child: SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        rowMainAxis(
                                            children: [
                                              Expanded(
                                                child: headingText(
                                                  text: controller.getPropertyOne.value!.city,
                                                  fontSize: 28,

                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.grey,
                                                      borderRadius: BorderRadius.circular(8),
                                                    ),
                                                    padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                                                    child: Center(
                                                      child: customText(
                                                          text:  controller.getPropertyOne.value!.type == "1" ? "Rent" : "Sale",
                                                          fontSize: 18,
                                                          color: whiteColor
                                                      ),
                                                    ),
                                                  ),
                                                  w5,
                                                ],
                                              ),
                                            ]
                                        ),
                                        customText(
                                          text: "\$${controller.getPropertyOne.value!.amount}",
                                          fontSize: 24,
                                        ),
                                        h5,
                                        customText(
                                          text: controller.getPropertyOne.value!.address,
                                          fontSize: 18,
                                        ),
                                        h10,
                                      ],
                                    ),
                                    h10,
                                    Row(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(30),
                                              border: Border.all(color: borderColor)
                                          ),
                                          padding: const EdgeInsets.only(top: 5, bottom: 5, right: 10, left: 10),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              customText(
                                                  text: controller.getPropertyOne.value!.bedroom,
                                                  fontSize: 10
                                              ),
                                              w10,
                                              SvgPicture.asset(AppIcons.bedroom, width: 13, height: 9, color: primaryColor,),
                                            ],
                                          ),
                                        ),
                                        w10,
                                        Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(30),
                                              border: Border.all(color: borderColor)
                                          ),
                                          padding: const EdgeInsets.only(top: 5, bottom: 5, right: 10, left: 10),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              customText(
                                                  text: controller.getPropertyOne.value!.bathroom,
                                                  fontSize: 10
                                              ),
                                              w10,
                                              SvgPicture.asset(AppIcons.bathroom, width: 13, height: 9, color: primaryColor,),
                                            ],
                                          ),
                                        ),
                                        w10,
                                        Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(30),
                                              border: Border.all(color: borderColor)
                                          ),
                                          padding: const EdgeInsets.only(top: 5, bottom: 5, right: 10, left: 10),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              customText(
                                                  text: controller.getPropertyOne.value!.areaRange,
                                                  fontSize: 10
                                              ),
                                              w5,
                                              customText(
                                                  text: "Marla",
                                                  fontSize: 10
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    h10,
                                    customText(
                                        text: controller.getPropertyOne.value!.description,
                                        fontSize: 16,
                                    ),
                                    h50,

                                   controller.uId.value == controller.getPropertyOne.value!.userId ? const SizedBox() :  Row(
                                       mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        controller.getPropertyOne.value!.type == "1" ?     Center(
                                          child: CustomButton(
                                            height: screenHeight(context) * 0.06,
                                            borderRadius: BorderRadius.circular(50),
                                            text: "Contract",
                                            fontSize: 20,
                                            width: screenWidth(context) * 0.4,
                                            onTap: ()async{
                                              var roleId = await Preferences.getRoleID();
                                              if(roleId == "3"){
                                                AppUtils.errorSnackBar("Oops", "You must login as tenant");
                                              } else if(roleId == "1"){
                                                AppUtils.errorSnackBar("Oops", "You must login as tenant");
                                              } else if(roleId == "4"){
                                                AppUtils.errorSnackBar("Oops", "You must login as tenant");
                                              } else {
                                                Get.toNamed(kContractScreen, arguments: [
                                                  controller.getPropertyOne.value!.id,
                                                  controller.getPropertyOne.value!.userId,
                                                  controller.getPropertyOne.value!.user.fullname,
                                                  controller.getPropertyOne.value!.user.email,
                                                  controller.getPropertyOne.value!.user.phoneNumber,
                                                ]);
                                              }
                                            },
                                          ),
                                        )
                                            : SizedBox(),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        CustomButton(
                                          height: screenHeight(context) * 0.06,
                                          borderRadius: BorderRadius.circular(50),
                                          text: "Contact",
                                          fontSize: 20,
                                          gradientColor: greenGradient(),
                                          width: screenWidth(context) * 0.4,
                                          onTap: ()async{

                                            print(controller.getPropertyOne.value!.user.fullname.toString());
                                            print(controller.getPropertyOne.value!.user.id.toString());
                                            print(controller.getPropertyOne.value!.user.profileimage.toString());

                                         //  Get.toNamed(kChatConversionScreen);
                                            var roleId = await Preferences.getRoleID();
                                            if(roleId == "3"){
                                              AppUtils.errorSnackBar("Oops", "You must login as tenant");
                                            }else{
                                              createConversation(controller.getPropertyOne.value!.user.fullname.toString(), controller.getPropertyOne.value!.user.profileimage.toString(), controller.getPropertyOne.value!.user.id.toString(), context);
                                              // Get.toNamed(kContractScreen, arguments: controller.getPropertyOne.value!.id);
                                            }
                                          },
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
    );
  }


   createConversation(
      String name,
      String profilePicture,
      String id,
      context
      ) async {
    try {

      var userId = await Preferences.getUserID();
      var userName = await Preferences.getUserName();

      // Query Firestore to check if a conversation already exists
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('conversationListing')
          .where('user1', isEqualTo: userId.toString())
          .where('user2', isEqualTo: id)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        print("EXIST");
        // Conversation already exists, navigate to chat screen
        DocumentSnapshot conversationSnapshot = querySnapshot.docs.first;
        Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen1(
            group: false,
            image: profilePicture,
            name: name,
            data: conversationSnapshot)));
        // Navigator.pushAndRemoveUntil(
        //   context,
        //   MaterialPageRoute(
        //       builder: (context) => ChatScreen1(
        //           group: false,
        //           image: profilePicture,
        //           name: name,
        //           data: conversationSnapshot)),
        //       (Route<dynamic> route) => false,
        // );
      } else {
        print("Not EXIST");
        // Conversation doesn't exist, create new conversation
        Map<String, dynamic> conversationData = {
          'group' : false,
          'profilePictureUrl': profilePicture,
          "members": [
             {
              'userId': userId.toString(),
              'userName': userName,
              'profilePictureUrl': id == userId.toString()
                  ? profilePicture
                  : await Preferences.getToken(),
            },

            {
              'userId': id,
              'userName': name,
              'profilePictureUrl': profilePicture
            },
          ],
          "created": DateTime.now(),
          "user1" : userId.toString(),
          "user2" : id,
          "user": [userId.toString(), id],
          "lastMessage": {
            "message": "",
            "time": null,
            "seen": false,
          },
        };
        DocumentReference conversationRef = await FirebaseFirestore.instance.collection('conversationListing').add(conversationData);
        DocumentSnapshot conversationSnapshot = await conversationRef.get();
        // Navigator.pushAndRemoveUntil(
        //   context,
        //   MaterialPageRoute(
        //       builder: (context) => ChatScreen1(
        //           group: false,
        //           image: profilePicture,
        //           name: name,
        //           data: conversationSnapshot)),
        //       (Route<dynamic> route) => false,
        // );

        Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen1(
            group: false,
            image: profilePicture,
            name: name,
            data: conversationSnapshot)));
      }
    } catch (e) {
      print('Error creating or navigating to conversation: $e');
    }
  }



}
