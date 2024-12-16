import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:property_app/app_constants/color_constants.dart';
import 'package:property_app/constant_widget/constant_widgets.dart';
import 'package:property_app/route_management/constant_routes.dart';

import '../../controllers/services_provider_controller/service_request_cotroller.dart';
import '../../models/service_provider_model/service_request_model.dart';
import '../../utils/api_urls.dart';
import '../../utils/shared_preferences/preferences.dart';
import '../chat_screens/chat_conversion_screen.dart';

class ServiceRequestScreen extends GetView<ServiceRequestController> {
  const ServiceRequestScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        leading: Builder(builder: (context) {
          return IconButton(
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 18,
                color: backIconColor,
              ),
              onPressed: () {
                Navigator.pop(context);
                //Scaffold.of(context).openDrawer(),
              });
        }),
        title: headingText(text: "Service Requests", fontSize: 20),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            controller.pagingController.itemList!.clear();
            await controller.getServicesRequests(1);
          },
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: PagedListView<int, ServiceRequestProvider>(
              shrinkWrap: true,
              pagingController: controller.pagingController,
              builderDelegate: PagedChildBuilderDelegate<
                      ServiceRequestProvider>(
                  firstPageErrorIndicatorBuilder: (context) => MaterialButton(
                        child: const Text("No Data Found, Tap to try again."),
                        onPressed: () => controller.pagingController.refresh(),
                      ),
                  newPageErrorIndicatorBuilder: (context) => MaterialButton(
                        child: const Text(
                            "Failed to load more items. Tap to try again."),
                        onPressed: () => controller.pagingController
                            .retryLastFailedRequest(),
                      ),
                  itemBuilder: (context, item, index) {
                    print('Service Request ID: ${item.id}');
                    String imagesString = item.service == null
                        ? ""
                        : item.service!.media.toString();
                    List<String> imageList = imagesString.split(',');
                    DateTime createdAt = item.createdAt;
                    String requestDate = DateFormat('dd-M-yy')
                        .format(createdAt); // Adjust the pattern as needed
                    String requestTime = DateFormat('h:mm a').format(createdAt);
                    return Column(
                      children: [
                        serviceRequestWidget(context,
                            image: AppUrls.mediaImages + imageList[0],
                            title: item.service == null
                                ? ""
                                : item.service!.serviceName,
                            contactDetail: item.user.email,
                            clientName: item.user.fullname,
                            location: item.address,
                            postalCode: item.postalCode,
                            description: item.description,
                            requestDate: requestDate,
                            requestTime: requestTime,
                            status: item.description,
                            time: item.time,
                            date: item.date,
                            contactTap: () {
                              if (item.decline == 1) {
                                Get.snackbar(
                                  'This request has been declined. No chats available',
                                  '',
                                  backgroundColor: redColor.withOpacity(0.8),
                                  colorText: Colors.white,
                                  snackPosition: SnackPosition.BOTTOM,
                                );
                              } else {
                                createConversation(
                                  item.user.fullname ?? "",
                                  item.user.profileimage,
                                  item.user.id.toString(),
                                  context,
                                );
                              }
                            },
                            acceptTap: () {
                              if (item.decline == 1) {
                                Get.snackbar(
                                  'This request has been declined. You cannot accept it',
                                  '',
                                  backgroundColor: redColor.withOpacity(0.8),
                                  colorText: Colors.white,
                                  snackPosition: SnackPosition.BOTTOM,
                                );
                              } else {
                                animatedDialog(context,
                                    title: "Accept Request",
                                    subTitle:
                                        "Are you sure to accept this request",
                                    yesButtonText: "Accept", yesTap: () {
                                  controller
                                      .acceptServiceRequest(
                                          requestId: item.id,
                                          userId: item.userId.toString(),
                                          providerId:
                                              item.serviceproviderId.toString())
                                      .then((value) {
                                    controller.getServicesRequests(1);
                                  });
                                });
                              }
                            },
                            acceptColor: item.approved == 1
                                ? const Color(0xff14C034).withOpacity(0.3)
                                : const Color(0xff14C034),
                            declineColor: item.decline == 1
                                ? redColor.withOpacity(0.3)
                                : redColor,
                            onTap: () {
                              Get.toNamed(
                                kServiceRequestDetailScreen,
                                arguments: item.id,
                              );
                            },
                            detailTap: () {
                              Get.toNamed(kServiceRequestDetailScreen,
                                  arguments: item.id);
                            },
                            declineTap: () {
                              if (item.decline == 1) {
                                null;
                              } else if (item.approved == 1) {
                                Get.snackbar(
                                  'This request has been accepted. Cannot decline now.',
                                  '',
                                  backgroundColor: redColor.withOpacity(0.8),
                                  colorText: Colors.white,
                                  snackPosition: SnackPosition.BOTTOM,
                                );
                              } else {
                                animatedDialog(context,
                                    title: "Decline Request",
                                    subTitle:
                                        "Are you sure to decline this request",
                                    yesButtonText: "Decline", yesTap: () {
                                  controller
                                      .declineServiceRequest(requestId: item.id)
                                      .then((value) {
                                    controller.getServicesRequests(1);
                                  });
                                });
                              }
                            }),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    );
                  }),
            ),
          ),
        ),
      ),
    );
  }

  createConversation(
      String name, String profilePicture, String id, context) async {
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
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatScreen1(
                      group: false,
                      image: profilePicture,
                      name: name,
                      data: conversationSnapshot,
                      id: id.toString(),
                      userId: userId.toString(),
                    )));
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
          'group': false,
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
          "user1": userId.toString(),
          "user2": id,
          "user": [userId.toString(), id],
          "lastMessage": {
            "message": "",
            "time": null,
            "seen": false,
          },
        };
        DocumentReference conversationRef = await FirebaseFirestore.instance
            .collection('conversationListing')
            .add(conversationData);
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

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatScreen1(
                      group: false,
                      image: profilePicture,
                      name: name,
                      data: conversationSnapshot,
                      id: id.toString(),
                      userId: userId.toString(),
                    )));
      }
    } catch (e) {
      print('Error creating or navigating to conversation: $e');
    }
  }
}
