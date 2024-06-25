// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';
// import 'package:property_app/app_constants/app_icon.dart';
// import 'package:property_app/app_constants/app_sizes.dart';
// import 'package:property_app/app_constants/color_constants.dart';
// import 'package:property_app/constant_widget/constant_widgets.dart';
// import 'package:property_app/custom_widgets/custom_text_field.dart';
//
// import '../../controllers/chat_screens_controller/chat_convertion_screen_controller.dart';
//
// class ChatConversionScreen extends GetView<ChatConversionScreenController> {
//   const ChatConversionScreen({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: whiteColor,
//       appBar: homeAppBar(context , text: "David"),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(15.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Center(
//                 child: customText(
//                   text: "Today",
//                   fontSize: 18,
//                   color: greyColor
//                 ),
//               ),
//               h10,
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     width: 200,
//                     decoration: BoxDecoration(
//                       color: greyColor.withOpacity(0.2),
//                       borderRadius: BorderRadius.circular(10)
//                     ),
//                     padding: const EdgeInsets.all(10),
//                     child: customText(
//                       text: "Hey there! How's your day going?"
//                     ),
//                   ),
//                   customText(
//                     text: "6:10 AM ",
//                     color: greyColor,
//                     fontSize: 12
//                   )
//                 ],
//               ),
//               h5,
//               Align(
//                 alignment: Alignment.bottomRight,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: [
//                     Container(
//                       width: 200,
//                       decoration: BoxDecoration(
//                           color: greyColor.withOpacity(0.2),
//                           borderRadius: BorderRadius.circular(10)
//                       ),
//                       padding: const EdgeInsets.all(10),
//                       child: customText(
//                           text: "Hey there! How's your day going?"
//                       ),
//                     ),
//                     customText(
//                         text: "6:10 AM ",
//                         color: greyColor,
//                         fontSize: 12
//                     )
//                   ],
//                 ),
//               ),
//
//               Expanded(
//                 flex: 9,
//                 child: Align(
//                   alignment: Alignment.bottomCenter,
//                   child: Container(
//                     width: double.infinity,
//                     decoration: const BoxDecoration(
//
//                     ),
//                     child: Row(
//                       children: [
//                         Expanded(
//                             child: CustomBorderTextField(
//                               inputBorder:  OutlineInputBorder(
//                                borderRadius: BorderRadius.circular(8),
//                                borderSide:  const BorderSide(color: greyColor)),
//                               hintText:" Text message...",
//                               suffixIcon: SizedBox(
//                                 width: 80,
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     SvgPicture.asset(AppIcons.gallery),
//                                     w5,
//                                     // SvgPicture.asset(AppIcons.voice),
//                                   ],
//                                 ),
//                               ),
//                             )),
//                         w5,
//                         CircleAvatar(
//                           radius: 25,
//                           child: Center(child: SvgPicture.asset(AppIcons.send),
//                           )),
//                       ],
//                     ),
//                   ),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:intl/intl.dart';
import 'package:property_app/app_constants/color_constants.dart';
import 'package:property_app/controllers/theme_controller.dart';
import 'package:property_app/views/chat_screens/recieved_meesage_widget.dart';
import 'package:property_app/views/chat_screens/send_message_widget.dart';
import 'package:property_app/views/chat_screens/send_picture.dart';
import 'package:whatsapp_reactions/scr/models/emotions.dart';
import 'package:whatsapp_reactions/whatsapp_reactions.dart';

import '../../controllers/chat_screens_controller/chat_controller.dart';
import '../../custom_widgets/custom_button.dart';
import '../../services/notification_services/notification_services.dart';
import '../../utils/shared_preferences/preferences.dart';
import 'ToBeReplyMessageWidget.dart';


class ChatScreen1 extends StatefulWidget {
  final String name;
  final String image;
  final bool group;

  // final String userImage;
  final DocumentSnapshot data;

  static const String idScreen = "chatScreen";
  static late bool showSelectedMessages = false;

  const ChatScreen1(
      {super.key,
        required this.name,
        required this.image,
        required this.data,
        required this.group});

  @override
  State<ChatScreen1> createState() => _ChatScreen1State();
}

class _ChatScreen1State extends State<ChatScreen1> {
  late ChatController chatController;
  late Stream<QuerySnapshot> stream;

  String formatDate(DateTime lastSeen, bool isOnline) {
    if (isOnline) {
      return 'Online';
    }

    final DateTime now = DateTime.now();
    final Duration difference = now.difference(lastSeen);

    if (difference.inDays == 0) {
      if (difference.inMinutes < 60) {
        return 'Last seen ${difference.inMinutes} minutes ago';
      }
      return 'Last seen today at ${DateFormat('hh:mm a').format(lastSeen)}';
    } else if (difference.inDays == 1) {
      return 'Last seen yesterday at ${DateFormat('hh:mm a').format(lastSeen)}';
    } else if (difference.inDays < 30) {
      return 'Last seen ${difference.inDays} days ago';
    } else if (difference.inDays < 365) {
      return 'Last seen on ${DateFormat('MMMM dd').format(lastSeen)}';
    } else {
      return 'Last seen on ${DateFormat('MMMM dd, yyyy').format(lastSeen)}';
    }
  }

  String id = "";
  var userId;

 Future<void> getUserId() async {
    var id = await Preferences.getUserID();
    setState(() {
      userId = id;
    });
  }

  void setupStream()async {
    userId = await Preferences.getUserID();
    stream =   FirebaseFirestore.instance
        .collection('messagesListing')
        .doc(userId.toString())
        .collection('messages')
        .where('conversationId', isEqualTo: widget.data.id)
        .orderBy('created', descending: true) // Add this line
        .snapshots();

    print("my user id $userId");


    markAllMessagesAsSeen();

    String receiverId = widget.data["user1"].toString() == userId.toString()
        ? widget.data["user2"].toString()
        : widget.data["user1"].toString();

    setState(() {
      id = receiverId;
    });
    tappedStates = List<bool>.generate(10, (index) => false);
    print(widget.name);
    print(widget.data.id);
    print("user id ${receiverId}");

  }

  @override
  void initState() {
    getUserId();
    chatController = Get.put(ChatController());
    stream = Stream.empty();
    setupStream();
    // stream = FirebaseFirestore.instance
    //     .collection('messagesListing')
    //     .doc(userId.toString())
    //     .collection('messages')
    //     .where('conversationId', isEqualTo: widget.data.id)
    //     .orderBy('created', descending: true) // Add this line
    //     .snapshots();


    ChatScreen1.showSelectedMessages = false;
    super.initState();
  }
  late List<bool> tappedStates;
  Future<void> markAllMessagesAsSeen() async {
    userId = await Preferences.getUserID();
    final firestore = FirebaseFirestore.instance;

    String receiverId = widget.data["user1"].toString() == userId.toString()
        ? widget.data["user2"].toString()
        : widget.data["user1"].toString();
    try {
      // Retrieve all messages for the current user that are not yet marked as seen
      QuerySnapshot querySnapshot = await firestore
          .collection('messagesListing')
          .doc(receiverId)
          .collection('messages')
          .where('read', isEqualTo: false)
          .get();

      // Start a batch
      WriteBatch batch = firestore.batch();

      // Iterate through each message and update the status to 'seen'
      for (DocumentSnapshot doc in querySnapshot.docs) {
        if (doc.exists) {
          batch.update(doc.reference, {'read': true});
        }
      }

      // Commit the batch
      await batch.commit();
      print('All messages marked as seen.');
    } catch (e) {
      print('Error updating message status: $e');
    }
  }

  void _toggleColor(int index) {
    setState(() {
      // Toggle the tapped state for the specific index
      tappedStates[index] = !tappedStates[index];
    });
  }
  var themeController = Get.put(ThemeController());
  @override
  Widget build(BuildContext context) {
    print("Build called");
    print("reciver id $id");
    print("user id $userId");

    return PopScope(
      onPopInvoked: (v) {
      //  Get.offAll(const HomeScreen());
      },
      canPop: false,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(60),
            child: ChatScreen1.showSelectedMessages
                ? showSelectionPanel(themeController, chatController.index.value)
                : Container(
              decoration: const BoxDecoration(
                color: primaryColor,
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 30, bottom: 5, left: 8, right: 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    InkWell(
                        child: const Icon(
                          Icons.arrow_back_ios_new,
                          size: 20.0,
                          color: whiteColor,
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          // Navigator.pushReplacement(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) =>
                          //         const HomeScreen()));
                        }),
                    SizedBox(
                      width: 8,
                    ),
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: whiteColor,
                      child: CachedNetworkImage(
                        imageUrl: widget.image,
                        errorWidget: (w,e, r){
                          return CircleAvatar(
                            child: Text(widget.name[0].toUpperCase()), // Display the first letter of the name
                          );
                        },
                      ),
                      // backgroundImage: CachedNetworkImageProvider(
                      //   widget.group
                      //       ? widget.data['groupPictureUrl']
                      //       : widget.image,
                      // ),
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) =>
                          //         ProfileDetails(
                          //           img: widget.image,
                          //           name: widget.name,
                          //         ),
                          //   ),
                          // );
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              toBeginningOfSentenceCase(
                                  widget.name)!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  fontSize: 14,
                                  color: whiteColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection("users")
                                    .doc(id.toString())
                                    .snapshots(),
                                builder:
                                    (context, AsyncSnapshot snapshot) {
                                  if (!snapshot.hasData) {
                                    return const Text("Loading...");
                                  }
                                  Timestamp lastSeenTimestamp = snapshot.data['lastSeen'];
                                  DateTime lastSeen =
                                  lastSeenTimestamp.toDate();
                                  return Text(
                                    formatDate(lastSeen,
                                        snapshot.data["online"]),
                                    style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                        fontSize: 10,
                                        color: whiteColor,
                                      ),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  );
                                }),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          // InkWell(
                          //   child: SizedBox(
                          //     width: 19.0,
                          //     height: 20.0,
                          //     child: Image.asset(
                          //       "assets/images/video.png",
                          //       color: colorWhite,
                          //     ),
                          //   ),
                          //   onTap: () {
                          //     Navigator.push(
                          //       context,
                          //       MaterialPageRoute(
                          //         builder: (context) => VideoCallScreen(
                          //           img: widget.image,
                          //           name: widget.name,
                          //           userImage: widget.userImage,
                          //         ),
                          //       ),
                          //     );
                          //   },
                          // ),
                          // InkWell(
                          //   child: SizedBox(
                          //       height: 20.0,
                          //       child: const Icon(
                          //         Icons.call,
                          //         color: colorWhite,
                          //         size: 21.0,
                          //       )),
                          //   onTap: () {
                          //     Navigator.push(
                          //       context,
                          //       MaterialPageRoute(
                          //         builder: (context) => CallingScreen(
                          //           img: widget.image,
                          //           name: widget.name,
                          //         ),
                          //       ),
                          //     );
                          //   },
                          // ),
                          // SizedBox(
                          //   height: 16.0,
                          //   width: 16.0,
                          //   child: Image.asset(
                          //     "assets/images/menu.png",
                          //     color: colorWhite,
                          //   ),
                          // ),
                          // const SizedBox(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          body: Stack(
            children: [
              GestureDetector(
                child: Container(
                  decoration: const BoxDecoration(
                    color: whiteColor,
                    // image: DecorationImage(
                    //     image:
                    //     AssetImage('assets/images/backgrounddambo.png'),
                    //     fit: BoxFit.contain,
                    //     opacity: 0.05),
                    // borderRadius: BorderRadius.only(
                    //     topLeft: Radius.circular(30.h),
                    //     topRight: Radius.circular(30.h)),
                  ),
                  child: Obx(
                        () =>
                        Column(
                          children: <Widget>[
                            // Center(
                            //   child: Container(
                            //     height: 24.h,
                            //     width: 100.w,
                            //     decoration: BoxDecoration(
                            //       borderRadius: BorderRadius.circular(6.h),
                            //       color: const Color(0xFF34B7F1).withOpacity(0.45),
                            //     ),
                            //     child: Center(
                            //       child: Text(
                            //         '17th August 2021',
                            //         style: GoogleFonts.roboto(
                            //           textStyle: TextStyle(
                            //             fontSize: 10.sp,
                            //             fontWeight: FontWeight.bold,
                            //           ),
                            //         ),
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            // SizedBox(
                            //   height: 12.h,
                            // ),

                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 12,
                                  right: 6,
                                ),
                                child: StreamBuilder<QuerySnapshot>(
                                  stream: stream,
                                  builder: (context,
                                      AsyncSnapshot<QuerySnapshot> snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const SizedBox();
                                    } else if (snapshot.hasError) {
                                      // Handle error case
                                      print(snapshot.error);
                                      return Text('Error: ${snapshot.error}');
                                    } else {
                                      List<DocumentSnapshot> documents =
                                          snapshot.data!.docs;
                                      documents.sort((a, b) {
                                        // Get the timestamps from the documents
                                        Timestamp timestampA = a['created'];
                                        Timestamp timestampB = b['created'];
                                        // Compare the timestamps
                                        return timestampB.compareTo(
                                            timestampA);
                                      });
                                      if (documents.isEmpty) {
                                        return Container();
                                      } else {
                                        markAllMessagesAsSeen();
                                        return ListView.builder(
                                          reverse: true,
                                          controller:
                                          chatController.scrollController,
                                          shrinkWrap: true,
                                          itemCount: documents.length,
                                          itemBuilder: (context, index) {
                                            if (documents[index]['file']) {
                                              if (!chatController.imageUrls
                                                  .contains(documents[index]
                                              ['filePath'])) {
                                                chatController.imageUrls.add(
                                                    documents[index]['filePath']);
                                              }
                                            }
                                            String senderId =
                                            documents[index]['senderId'].toString();
                                            String message =
                                            documents[index]['content'];
                                            bool replyMessage =
                                            documents[index]['replyMessage'];
                                            bool delivered =
                                            documents[index]['delivered'];
                                            bool seen = documents[index]['read'];
                                            var messageTime =
                                            documents[index]['created'];
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 8.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                                children: <Widget>[
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  senderId !=
                                                      userId.toString()
                                                      ?Material(
                                                    color: Colors.transparent,
                                                    child: InkWell(
                                                      splashColor: primaryColor.withOpacity(0.5),
                                                      child: ReceivedMsg(
                                                        group: widget.group,
                                                        index: index,
                                                        dataProvider: themeController,
                                                        imageUrls:
                                                        chatController
                                                            .imageUrls,
                                                        showSelectedBox:
                                                        ChatScreen1
                                                            .showSelectedMessages,
                                                        message:
                                                        documents[index],
                                                        msg: message,
                                                        time: formatTime(
                                                            messageTime
                                                                .toDate()),
                                                        onSwipeMessage:
                                                            (replyMessage) {
                                                          chatController
                                                              .replyToMessage(
                                                              documents[
                                                              index]);
                                                          // chatController
                                                          //     .focusNode
                                                          //     .requestFocus();
                                                        },
                                                      ),
                                                      onLongPress: () {},
                                                      onTapDown: (details) {
                                                        if (ChatScreen1
                                                            .showSelectedMessages ==
                                                            false) {
                                                          setState(() {
                                                            themeController
                                                                .selectedMessages.value =
                                                            [];
                                                            themeController
                                                                .selectedUsers.value =
                                                            [];
                                                            ChatScreen1
                                                                .showSelectedMessages =
                                                            true;
                                                          });
                                                        }
                                                        Reactionpopup
                                                            .showReaction(
                                                          context,
                                                          offset: details
                                                              .globalPosition,
                                                          emotionPicked:
                                                          Emotions.angry,
                                                          handlePressed: (emotion) {
                                                            print(emotion);
                                                            toggleReaction(
                                                                documents[
                                                                index]
                                                                    .id,
                                                                emotion.name, themeController);
                                                          },
                                                        );
                                                      },
                                                    ),
                                                  )
                                                      : Material(
                                                    color: Colors.transparent,
                                                    child: InkWell(
                                                      splashColor: primaryColor.withOpacity(0.5),
                                                      child: SendMessage(
                                                        dataProvider:
                                                        themeController,
                                                        imageUrls:
                                                        chatController
                                                            .imageUrls,
                                                        showSelectedBox:
                                                        ChatScreen1
                                                            .showSelectedMessages,
                                                        replyMessage:
                                                        replyMessage,
                                                        document:
                                                        documents[index],
                                                        message: message,
                                                        messageTime:
                                                        messageTime,
                                                        seen: seen,
                                                        delivered: delivered,
                                                        index: index,
                                                        onSwipeMessage:
                                                            (replyMessage) {
                                                          chatController
                                                              .replyToMessage(
                                                              documents[
                                                              index]);
                                                          // chatController
                                                          //     .focusNode
                                                          //     .requestFocus();
                                                        },
                                                      ),
                                                      // onLongPress: () {
                                                      //   if (ChatScreen1
                                                      //           .showSelectedMessages ==
                                                      //       false) {
                                                      //     setState(() {
                                                      //       dataProvider
                                                      //           .selectedMessages = [];
                                                      //       dataProvider
                                                      //           .selectedUsers = [];
                                                      //       ChatScreen1
                                                      //               .showSelectedMessages =
                                                      //           true;
                                                      //     });
                                                      //   }
                                                      // },

                                                      onTapDown: (details) {
                                                        if (ChatScreen1
                                                            .showSelectedMessages ==
                                                            false) {
                                                          setState(() {
                                                            themeController
                                                                .selectedMessages.value =
                                                            [];
                                                            themeController
                                                                .selectedUsers.value =
                                                            [];
                                                            ChatScreen1
                                                                .showSelectedMessages =
                                                            true;
                                                          });
                                                        }
                                                        Reactionpopup
                                                            .showReaction(
                                                          context,
                                                          offset: details
                                                              .globalPosition,
                                                          emotionPicked:
                                                          Emotions.angry,
                                                          handlePressed:
                                                              (emotion) {
                                                            print(emotion);
                                                            print(
                                                                emotion.name);
                                                            toggleReaction(
                                                                documents[
                                                                index]
                                                                    .id,
                                                                emotion.name, themeController);
                                                          },
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        );
                                      }
                                    }
                                  },
                                ),
                              ),
                            ),

                            if (chatController.replyMessage.value != null)
                              Obx(
                                    () =>
                                    buildReply(
                                      messageDetails:
                                      chatController.replyMessage.value,
                                      onCancelReply: chatController
                                          .cancelReply,
                                      userName: widget.name,
                                    ),
                              ),
                            Obx(
                                  () =>
                                  Padding(
                                    padding: EdgeInsets.only(
                                      left: 5,
                                      right: 5,
                                      bottom: 5,
                                    ),
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Container(
                                            height: 40,
                                            width: 288,
                                            decoration: BoxDecoration(
                                              color: whiteColor,
                                              border: Border.all(
                                                color: primaryColor,
                                                // Set the border color here
                                                width:
                                                1.0, // Set the border width here
                                              ),
                                              borderRadius:
                                              chatController.replyMessage
                                                  .value ==
                                                  null
                                                  ? BorderRadius.circular(
                                                  50)
                                                  : BorderRadius.only(
                                                bottomLeft:
                                                Radius.circular(10),
                                                bottomRight:
                                                Radius.circular(10),
                                              ),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  left: 17, right: 15),
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                                children: <Widget>[
                                                  GestureDetector(
                                                    child: const Icon(
                                                      Icons
                                                          .emoji_emotions_outlined,
                                                      color: primaryColor,
                                                      size: 22.0,
                                                    ),
                                                    onTap: () {
                                                      chatController
                                                          .emojiShowing
                                                          .value =
                                                      !chatController
                                                          .emojiShowing.value;
                                                    },
                                                  ),
                                                  SizedBox(
                                                    width: 9,
                                                  ),
                                                  Expanded(
                                                    child: TextFormField(
                                                      controller: chatController
                                                          .messageController,
                                                      decoration:
                                                      InputDecoration
                                                          .collapsed(
                                                        hintText:
                                                        'Type your message ...',
                                                        hintStyle:
                                                        GoogleFonts.poppins(
                                                          textStyle: TextStyle(
                                                            color: greyColor,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ),
                                                      onTap: () {
                                                        if (chatController
                                                            .emojiShowing
                                                            .value) {
                                                          chatController
                                                              .emojiShowing
                                                              .value =
                                                          !chatController
                                                              .emojiShowing
                                                              .value;
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                  Row(
                                                    children: <Widget>[

                                                      SizedBox(
                                                        width: 8,
                                                      ),
                                                      SizedBox(
                                                        width: 8,
                                                      ),
                                                      InkWell(
                                                        child: const Icon(
                                                          Icons.attach_file,
                                                          color: primaryColor,
                                                          size: 23.0,
                                                        ),
                                                        onTap: () {
                                                          showModalBottomSheet(
                                                              backgroundColor:
                                                              Colors
                                                                  .transparent,
                                                              barrierColor:
                                                              Colors
                                                                  .transparent,
                                                              context: context,
                                                              builder: (
                                                                  context) {
                                                                return Padding(
                                                                  padding:
                                                                  EdgeInsets
                                                                      .only(
                                                                      left: 10, right: 10, bottom: 55),
                                                                  child: Container(
                                                                    width: double
                                                                        .infinity,
                                                                    height: 140,
                                                                    decoration: BoxDecoration(
                                                                        color: primaryColor
                                                                            .withOpacity(
                                                                            0.9),
                                                                        borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                            25)),
                                                                    child: Padding(
                                                                      padding:
                                                                      const EdgeInsets
                                                                          .only(
                                                                          left:
                                                                          30,
                                                                          right:
                                                                          30,
                                                                          top: 20,
                                                                          bottom:
                                                                          20),
                                                                      child: Column(
                                                                        crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                        mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                        children: [
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                            MainAxisAlignment
                                                                                .spaceBetween,
                                                                            children: [
                                                                              Column(
                                                                                children: [
                                                                                  InkWell(
                                                                                    onTap: () async{
                                                                                      chatController
                                                                                          .selectCamera(
                                                                                          context)
                                                                                          .then((
                                                                                          value) {
                                                                                        chatController
                                                                                            .isLoading
                                                                                            .value =
                                                                                        false;

                                                                                        if (chatController
                                                                                            .selectedMedia !=
                                                                                            null &&
                                                                                            chatController
                                                                                                .selectedMedia!
                                                                                                .isNotEmpty) {
                                                                                          Navigator
                                                                                              .push(
                                                                                              context,
                                                                                              MaterialPageRoute(
                                                                                                  builder: (
                                                                                                      context) =>
                                                                                                      SendPicture(
                                                                                                        data: widget.data,
                                                                                                        userId: userId.toString(),
                                                                                                        selectedImages: chatController
                                                                                                            .selectedMedia!,
                                                                                                        group: widget
                                                                                                            .group,
                                                                                                      )))
                                                                                              .then((
                                                                                              e) {
                                                                                            chatController
                                                                                                .scrollToBottom();
                                                                                            Navigator
                                                                                                .pop(
                                                                                                context);
                                                                                          });
                                                                                        }
                                                                                      });
                                                                                    },
                                                                                    child: const CircleAvatar(
                                                                                      backgroundColor: Colors
                                                                                          .purple,
                                                                                      radius: 35,
                                                                                      child: Icon(
                                                                                        Icons
                                                                                            .camera_alt,
                                                                                        color: Colors
                                                                                            .white,
                                                                                        size: 35,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  const SizedBox(
                                                                                    height: 5,
                                                                                  ),
                                                                                  const Text(
                                                                                    "Camera",
                                                                                    style: TextStyle(
                                                                                        color: Colors
                                                                                            .white),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              Column(
                                                                                children: [
                                                                                  InkWell(
                                                                                    onTap: () {
                                                                                      chatController
                                                                                          .selectMedia(
                                                                                          context)
                                                                                          .then((
                                                                                          value) {
                                                                                        chatController
                                                                                            .isLoading
                                                                                            .value =
                                                                                        false;

                                                                                        if (chatController
                                                                                            .selectedMedia !=
                                                                                            null &&
                                                                                            chatController
                                                                                                .selectedMedia!
                                                                                                .isNotEmpty) {
                                                                                          Navigator
                                                                                              .push(
                                                                                              context,
                                                                                              MaterialPageRoute(
                                                                                                  builder: (
                                                                                                      context) =>
                                                                                                      SendPicture(
                                                                                                        data: widget
                                                                                                            .data,
                                                                                                        userId: userId.toString(),
                                                                                                        selectedImages: chatController
                                                                                                            .selectedMedia!,
                                                                                                        group: widget
                                                                                                            .group,
                                                                                                      )))
                                                                                              .then((
                                                                                              e) {
                                                                                            chatController
                                                                                                .scrollToBottom();
                                                                                            Navigator
                                                                                                .pop(
                                                                                                context);
                                                                                          });
                                                                                        }
                                                                                      });
                                                                                    },
                                                                                    child: CircleAvatar(
                                                                                      backgroundColor: Colors
                                                                                          .pink
                                                                                          .shade900,
                                                                                      radius: 35,
                                                                                      child: const Icon(
                                                                                        Icons
                                                                                            .photo,
                                                                                        color: Colors
                                                                                            .white,
                                                                                        size: 35,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  const SizedBox(
                                                                                    height: 5,
                                                                                  ),
                                                                                  const Text(
                                                                                    "Gallery",
                                                                                    style: TextStyle(
                                                                                        color: Colors
                                                                                            .white),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              Column(
                                                                                children: [
                                                                                  InkWell(
                                                                                    onTap: () {
                                                                                      chatController
                                                                                          .pickPDFFile(
                                                                                          widget
                                                                                              .data);
                                                                                      //  chatController.createPdfMessage(context, widget.data, widget.group);
                                                                                    },
                                                                                    child: CircleAvatar(
                                                                                      backgroundColor: Colors
                                                                                          .blue
                                                                                          .shade400,
                                                                                      radius: 35,
                                                                                      child: const Icon(
                                                                                        Icons
                                                                                            .description,
                                                                                        color: Colors
                                                                                            .white,
                                                                                        size: 35,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  const SizedBox(
                                                                                    height: 5,
                                                                                  ),
                                                                                  const Text(
                                                                                    "Document",
                                                                                    style: TextStyle(
                                                                                        color: Colors
                                                                                            .white),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          // const SizedBox(
                                                                          //   height:
                                                                          //   20,
                                                                          // ),
                                                                          // Row(
                                                                          //   mainAxisAlignment:
                                                                          //   MainAxisAlignment
                                                                          //       .spaceBetween,
                                                                          //   children: [
                                                                          //     Column(
                                                                          //       children: [
                                                                          //         InkWell(
                                                                          //           onTap: () {
                                                                          //             // chatController
                                                                          //             //     .pickDOCFile(
                                                                          //             //     widget
                                                                          //             //         .data);
                                                                          //           },
                                                                          //           child: const CircleAvatar(
                                                                          //             backgroundColor: Colors
                                                                          //                 .deepOrange,
                                                                          //             radius: 35,
                                                                          //             child: Icon(
                                                                          //               Icons
                                                                          //                   .description,
                                                                          //               color: Colors
                                                                          //                   .white,
                                                                          //               size: 35,
                                                                          //             ),
                                                                          //           ),
                                                                          //         ),
                                                                          //         SizedBox(
                                                                          //           height: 5,
                                                                          //         ),
                                                                          //         Text(
                                                                          //           "Document",
                                                                          //           style: TextStyle(
                                                                          //               color: Colors
                                                                          //                   .white),
                                                                          //         ),
                                                                          //       ],
                                                                          //     ),
                                                                          //
                                                                          //     Column(
                                                                          //       children: [
                                                                          //         CircleAvatar(
                                                                          //           backgroundColor: Colors
                                                                          //               .cyan,
                                                                          //           radius: 35,
                                                                          //           child: Icon(
                                                                          //             Icons
                                                                          //                 .file_present,
                                                                          //             color: Colors
                                                                          //                 .white,
                                                                          //             size: 35,
                                                                          //           ),
                                                                          //         ),
                                                                          //         SizedBox(
                                                                          //           height: 5,
                                                                          //         ),
                                                                          //         Text(
                                                                          //           "Excel",
                                                                          //           style: TextStyle(
                                                                          //               color: Colors
                                                                          //                   .white),
                                                                          //         ),
                                                                          //       ],
                                                                          //     ),
                                                                          //
                                                                          //     SizedBox(
                                                                          //       width:
                                                                          //       70,
                                                                          //     ),
                                                                          //
                                                                          //     // Column(
                                                                          //     //   children: [
                                                                          //     //     CircleAvatar(
                                                                          //     //       backgroundColor: Colors.purple.shade400,
                                                                          //     //       radius: 35,
                                                                          //     //       child: Icon(Icons.picture_as_pdf, color: Colors.white, size: 35,),
                                                                          //     //     ),
                                                                          //     //     SizedBox(
                                                                          //     //       height: 5,
                                                                          //     //     ),
                                                                          //     //     Text("Pdf" , style: TextStyle(color: Colors.white),),
                                                                          //     //   ],
                                                                          //     // ),
                                                                          //   ],
                                                                          // )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                );
                                                              });
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 5.0),
                                        GestureDetector(
                                          child: Container(
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius
                                                  .circular(25),
                                              color: redColor,
                                            ),
                                            child: const Center(
                                              child: Icon(
                                                Icons.send,
                                                color: whiteColor,
                                                size: 23.0,
                                              ),
                                            ),
                                          ),
                                          onTap: () {
                                            if (chatController
                                                .messageController.text
                                                .isNotEmpty) {
                                              if (chatController.replyMessage
                                                  .value ==
                                                  null) {
                                                createMessage(context);
                                              } else {
                                                chatController
                                                    .createReplyMessage(
                                                    widget.data,
                                                    widget.group,  userId.toString());
                                              }
                                              chatController.scrollToBottom();
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                            ),

                            Offstage(
                              offstage: !chatController.emojiShowing.value,
                              child: EmojiPicker(
                                textEditingController:
                                chatController.messageController,
                                config: Config(
                                  height: 256,
                                  checkPlatformCompatibility: true,
                                  emojiViewConfig: EmojiViewConfig(
                                    emojiSizeMax: 28 *
                                        (foundation.defaultTargetPlatform ==
                                            TargetPlatform.iOS
                                            ? 1.2
                                            : 1.0),
                                  ),
                                  swapCategoryAndBottomBar: true,
                                  skinToneConfig: const SkinToneConfig(),
                                  categoryViewConfig: const CategoryViewConfig(
                                    indicatorColor: primaryColor,
                                  ),
                                  bottomActionBarConfig:
                                  const BottomActionBarConfig(
                                    backgroundColor: primaryColor,
                                  ),
                                  searchViewConfig: const SearchViewConfig(
                                    buttonColor: primaryColor,
                                    backgroundColor: primaryColor,
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(
                              height: 5,
                            ),
                          ],
                        ),
                  ),
                ),
                onTap: () {
                  if (chatController.emojiShowing.value) {
                    chatController.emojiShowing.value =
                    !chatController.emojiShowing.value;
                  }
                },
              ),
              chatController.isLoading.value
                  ? Container(
                    width: Get.width,
                    height: Get.height,
                     color: Colors.black.withOpacity(0.5),
                     child: const Center(
                    child: CircularProgressIndicator(color: primaryColor)),
              )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildReply({
    required DocumentSnapshot? messageDetails,
    required VoidCallback onCancelReply,
    required String userName,
  }) {
    chatController.repliedTo.value =
    messageDetails!['senderId'] == userId.toString()
        ? 'You'
        : userName;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: whiteColor,
                border: Border.all(color: greyColor),
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
              ),
              child: ToBeReplyMessageWidget(
                group: widget.group,
                userId: userId.toString(),
                message: messageDetails,
                onCancelReply: onCancelReply,
                userName: widget.name,
              ),
            ),
          ),
          const SizedBox(
            width: 5.0,
          ),
          Opacity(
            opacity: 0,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: redColor,
              ),
              child: const Center(
                child: Icon(
                  Icons.send,
                  color: whiteColor,
                  size: 23.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container showSelectionPanel(ThemeController dataProvider, int index) {
    return Container(
      decoration: const BoxDecoration(
        color: primaryColor,
      ),
      child: Padding(
        padding: EdgeInsets.only(
          top: 35,
          bottom: 15
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(
              width: 20,
            ),
            InkWell(
              child: const Icon(
                Icons.arrow_back,
                color: whiteColor,
              ),
              onTap: () {
                setState(() {
                  dataProvider.selectedMessages.value = [];
                  ChatScreen1.showSelectedMessages = false;
                });
              },
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              "${dataProvider.selectedMessages.length}",
              style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                  fontSize: 18,
                  color: whiteColor,
                ),
              ),
            ),
            const SizedBox(
              width: 30,
            ),
            dataProvider.selectedMessages.length == 1
                ? InkWell(
              child: const Icon(
                Icons.reply_outlined,
                color: whiteColor,
              ),
              onTap: () {
                chatController.replyMessage.value =
                    chatController.replyMessage1.value;
                chatController.index.value = chatController.index1.value;
              },
            )
                : const SizedBox(),
            const SizedBox(
              width: 20,
            ),
            dataProvider.selectedMessages.length == 1
                ? InkWell(
              child: const Icon(
                Icons.info_outline,
                color: whiteColor,
              ),
              onTap: () {
                // Get.to(MessageInfoScreen(
                //   time: chatController.replyMessage1.value!.get("created"), message:
                // chatController.replyMessage1.value!.get("content"),
                //   send: true,
                //   delivered: true,
                //
                // ));
              },
            )
                : const SizedBox(),
            const SizedBox(
              width: 20,
            ),
            InkWell(
              child: const Icon(
                Icons.star_border,
                color: whiteColor,
              ),
              onTap: () {
                for (var data in dataProvider.selectedMessages) {
                  if (kDebugMode) {
                    print(data);
                  }
                }

                starSelectedMessages(dataProvider);
              },
            ),
            const SizedBox(
              width: 20,
            ),
            InkWell(
              child: const Icon(
                Icons.delete_outline,
                color: whiteColor,
              ),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        surfaceTintColor: Colors.white,
                        backgroundColor: Colors.white,
                        title: const Text("Delete Messaging"),
                        content: const Text(
                            "Are you sure you want to delete the messaging?"),
                        actions: [
                          MaterialButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            color: Colors.green,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            child: const Text(
                              "No",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          MaterialButton(
                            onPressed: () {
                              Navigator.pop(context);
                              if (dataProvider.selectedMessages.isNotEmpty) {
                                for (var data
                                in dataProvider.selectedMessages) {
                                  if (kDebugMode) {
                                    print(data);
                                  }
                                }
                                deleteSelectedMessagesAndUpdateLastMessage(
                                    dataProvider);
                              }
                            },
                            color: Colors.red,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            child: const Text(
                              "Yes",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      );
                    });
              },
            ),
            const SizedBox(
              width: 20,
            ),
            InkWell(
              child: Image.asset(
                "assets/png/forward.png",
                width: 25,
                height: 30,
              ),
              onTap: () {
                if (dataProvider.selectedMessages.isNotEmpty) {
                  for (var data in dataProvider.selectedMessages) {
                    if (kDebugMode) {
                      print(data);
                    }
                  }

                  // Get.to(() =>
                  //     ForwardContactScreen(
                  //       conversationData: widget.data,
                  //       image: widget.image,
                  //       name: widget.name,
                  //     ));
                }
              },
            ),
            const SizedBox(
              width: 20,
            ),
            // InkWell(
            //   child: const Icon(
            //     Icons.more_vert,
            //     color: colorWhite,
            //   ),
            //   onTap: () {},
            // ),

            PopupMenuButton<String>(
                color: whiteColor,
                surfaceTintColor: whiteColor,
                icon: const Icon(
                  Icons.more_vert, // Use the three dots menu icon
                  color: Colors.white,
                ),
                onSelected: (value) {
                  if (value == "Settings") {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => const SettingsScreen(),
                    //   ),
                    // );
                  } else if (value == "Starred messages") {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) =>
                    //         StarredMessagesScreen(
                    //           data: widget.data,
                    //         ),
                    //   ),
                    // );
                  }
                },
                itemBuilder: (BuildContext context) {
                  return [
                    // PopupMenuItem(
                    //   value: 'New Group',
                    //   child: Text(
                    //     'New Group',
                    //     style: GoogleFonts.roboto(
                    //       textStyle: const TextStyle(
                    //         fontSize: 15.0,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    // PopupMenuItem(
                    //   value: 'New broadcast',
                    //   child: Text(
                    //     'New broadcast',
                    //     style: GoogleFonts.roboto(
                    //       textStyle: const TextStyle(
                    //         fontSize: 15.0,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    // PopupMenuItem(
                    //   value: 'Linked devices',
                    //   child: Text(
                    //     'Linked devices',
                    //     style: GoogleFonts.roboto(
                    //       textStyle: const TextStyle(
                    //         fontSize: 15.0,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    PopupMenuItem(
                      value: 'Starred messages',
                      child: Text(
                        'Starred messages',
                        style: GoogleFonts.roboto(
                          textStyle: const TextStyle(
                            fontSize: 15.0,
                          ),
                        ),
                      ),
                    ),
                    PopupMenuItem(
                      value: 'Settings',
                      child: Text(
                        'Settings',
                        style: GoogleFonts.roboto(
                          textStyle: const TextStyle(
                            fontSize: 15.0,
                          ),
                        ),
                      ),
                    ),
                  ];
                }),
            const SizedBox(
              width: 10,
            ),
          ],
        ),
      ),
    );
  }

  //
  // Future<Map<String, dynamic>?> createMessage(context) async {
  //   if (chatController.emojiShowing.value) {
  //     chatController.emojiShowing.value = !chatController.emojiShowing.value;
  //   }
  //
  //   Map<String, dynamic> messagesData = {
  //     'conversationId': widget.data.id,
  //     'senderId': chatController.user!.uid,
  //     "forwarded": false,
  //     "created": DateTime.now(),
  //     "replyMessage": false,
  //     "delivered": true,
  //     "read": false,
  //     "file": false,
  //     "starred" : false,
  //     "filePath": "path",
  //     "content": chatController.messageController.text.trim(),
  //   };
  //
  //   if (widget.group) {
  //     messagesData['group'] = true;
  //     messagesData['senderName'] = SharedPreferenceUtil.getDisplayName(); // Assuming you have access to the sender's display name
  //     messagesData['senderProfilePicture'] = SharedPreferenceUtil.getAvatarUrl(); // Assuming you have access to the sender's profile picture URL
  //   }
  //
  //   Map<String, dynamic> lastMessageUpdate = {
  //     "message": chatController.messageController.text.trim(),
  //     "time": DateTime.now(),
  //     "seen": false,
  //   };
  //   var message = chatController.messageController.text;
  //
  //   chatController.messageController.clear();
  //   try {
  //     await FirebaseFirestore.instance
  //         .collection('messagesListing')
  //         .add(messagesData);
  //   } catch (e) {
  //     print('Error creating messages : $e');
  //   }
  //
  //   try {
  //     await FirebaseFirestore.instance
  //         .collection('conversationListing')
  //         .doc(widget.data.id)
  //         .update({
  //       'lastMessage': lastMessageUpdate,
  //     });
  //
  //   } catch (e) {
  //     print('Error updating last message: $e');
  //   }
  //   String email = "";
  //   if(widget.data["user1"] == FirebaseAuth.instance.currentUser!.uid){
  //
  //     email = widget.data["user2"];
  //   }else if(widget.data["user2"] == FirebaseAuth.instance.currentUser!.uid){
  //
  //     email = widget.data["user1"];
  //
  //   }else{
  //
  //   }
  //
  //   String id = "";
  //
  //   DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(email)
  //       .get();
  //
  //   if (documentSnapshot.exists) {
  //     id = documentSnapshot.get("deviceToken");
  //   } else {
  //     print('User does not exist');
  //     return null;
  //   }
  //
  //   print("id : ${email}");
  //   print("token : $id");
  //
  //   String? accessToken = await NotificationServices.generateFCMAccessToken();
  //   NotificationServices.sendNotification("Dambo Notification", message , id, accessToken, context);
  //   // NotificationServices().firebaseInit(context);
  // }
  //

  Future<Map<String, dynamic>?> createMessage(context) async {
    if (chatController.emojiShowing.value) {
      chatController.emojiShowing.value = !chatController.emojiShowing.value;
    }
    String senderId = userId.toString();
    String receiverId = widget.data["user1"] == senderId
        ? widget.data["user2"]
        : widget.data["user1"];

    String messageId = _firestore.collection('messagesListing').doc().id;


    String messageContent = chatController.messageController.text.trim();
    Map<String, dynamic> messagesData = {
      'conversationId': widget.data.id,
      'senderId': userId,
      "isMessageDelete": false,
      'receiverId': receiverId,
      "forwarded": false,
      "created": DateTime.now(),
      "replyMessage": false,
      "delivered": false,
      "read": false,
      "file": false,
      "starred": false,
      "docId": messageId,
      "filePath": "path",
      "reactions": [],
      "content": messageContent,
    };

    Map<String, dynamic> lastMessageUpdate = {
      "message": messageContent,
      "time": DateTime.now(),
      "seen": false,
    };

    chatController.messageController.clear();

    // Add message for sender
    await _firestore
        .collection('messagesListing')
        .doc(senderId)
        .collection('messages')
        .doc(messageId)
        .set(messagesData);

    // Set the same message document under the receiver's messages collection
    await _firestore
        .collection('messagesListing')
        .doc(receiverId)
        .collection('messages')
        .doc(messageId)
        .set(messagesData);


    try {
      await FirebaseFirestore.instance
          .collection('conversationListing')
          .doc(widget.data.id)
          .update({
        'lastMessage': lastMessageUpdate,
      });
    } catch (e) {
      print('Error updating last message: $e');
    }

    // Send notification
    String email = "";
    if (widget.data["user1"] == userId.toString()) {
      email = widget.data["user2"];
    } else if (widget.data["user2"] == userId.toString()) {
      email = widget.data["user1"];
    }

    String id = "";

    DocumentSnapshot documentSnapshot =
    await FirebaseFirestore.instance.collection('users').doc(email).get();

    if (documentSnapshot.exists) {
      id = documentSnapshot.get("deviceToken");
    } else {
      print('User does not exist');
      return null;
    }
    print("id : ${email}");
    print("token : $id");

    // String? accessToken = await NotificationServices.generateFCMAccessToken();
    NotificationServices().sendNotification(context,
        "HAS Notification", messageContent, id, "msg",);
    // NotificationServices().firebaseInit(context);
  }


  Future<void> deleteSelectedMessagesAndUpdateLastMessage(
      ThemeController dataProvider) async {

    setState(() {
      ChatScreen1.showSelectedMessages = false;
    });

    final batch = FirebaseFirestore.instance.batch();
    Map<String, String> conversationUpdates = {};

    try {
      for (String messageId in dataProvider.selectedMessages) {
        DocumentReference messageRef = FirebaseFirestore.instance
            .collection('messagesListing')
            .doc(userId.toString())
            .collection("messages")
            .doc(messageId);
        DocumentSnapshot messageSnapshot = await messageRef.get();
        if (messageSnapshot.exists) {
          String conversationId = messageSnapshot.get("conversationId");
          conversationUpdates[conversationId] = messageId;
          // Instead of deleting, we update the 'isMessageDelete' field to true
          batch.update(messageRef, {"isMessageDelete": true});
        }
      }

      await batch.commit(); // Commit changes to the database

      // Update the last message for each conversation after marking messages as deleted
      for (String conversationId in conversationUpdates.keys) {
        QuerySnapshot remainingMessages = await FirebaseFirestore.instance
            .collection('messagesListing')
            .doc(userId.toString())
            .collection("messages")
            .where('conversationId', isEqualTo: conversationId)
            .where('isMessageDelete',
            isEqualTo: false) // Consider only non-deleted messages
            .orderBy('created', descending: true)
            .limit(1)
            .get();

        if (remainingMessages.docs.isNotEmpty) {
          var lastMessageData =
          remainingMessages.docs.first.data() as Map<String, dynamic>;
          FirebaseFirestore.instance
              .collection('conversationListing')
              .doc(conversationId)
              .update({
            'lastMessage': {
              "message": lastMessageData['content'],
              "time": lastMessageData['created'],
              "seen": false,
            },
          });
        } else {
          // If no messages left after marking as deleted, set last message to empty
          FirebaseFirestore.instance
              .collection('conversationListing')
              .doc(conversationId)
              .update({
            'lastMessage': {
              "message": "",
              "time": null,
              "seen": false,
            },
          });
        }
      }

      Navigator.pop(context); // Close the progress dialog
      setState(() {}); // Refresh UI
      dataProvider.selectedMessages.value = [];
    } catch (e) {
      print('Error updating message status: $e');
      Navigator.pop(context); // Ensure the dialog is closed in case of an error
    }
  }

  Future<void> starSelectedMessages(ThemeController dataProvider) async {

    setState(() {
      ChatScreen1.showSelectedMessages = false;
    });

    final batch = FirebaseFirestore.instance.batch();

    try {
      // Loop through all selected message IDs and prepare them for update
      for (String messageId in dataProvider.selectedMessages) {
        DocumentReference messageRef = FirebaseFirestore.instance
            .collection('messagesListing')
            .doc(userId.toString())
            .collection("messages")
            .doc(messageId);

        // Set the 'starred' field to true
        batch.update(messageRef, {'starred': true});
      }

      // Commit the batch to execute all updates
      await batch.commit();

      // Clear the selected messages list after successful update
      dataProvider.selectedMessages.value = [];

      // Optionally, navigate away or refresh the UI
      Navigator.pop(context); // Close the progress dialog
      setState(() {}); // Refresh the UI if necessary
    } catch (e) {
      print('Error starring messages: $e');
      Navigator.pop(context); // Ensure the dialog is closed in case of an error
    }
  }


  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> toggleReaction(String messageId, String emotion, ThemeController dataProvider) async {

    setState(() {
      ChatScreen1
          .showSelectedMessages =
      false;
    });

    String currentUserId = userId.toString();
    String senderId = userId.toString();
    String receiverId = widget.data["user1"] == senderId
        ? widget.data["user2"]
        : widget.data["user1"];

    DocumentReference messageRefSender = _firestore
        .collection('messagesListing')
        .doc(senderId)
        .collection("messages")
        .doc(messageId);

    DocumentReference messageRefReceiver = _firestore
        .collection('messagesListing')
        .doc(receiverId)
        .collection("messages")
        .doc(messageId);

    try {
      await _firestore.runTransaction((transaction) async {
        // First, read both documents
        DocumentSnapshot senderSnapshot = await transaction.get(messageRefSender);
        DocumentSnapshot receiverSnapshot = await transaction.get(messageRefReceiver);

        if (!senderSnapshot.exists || !receiverSnapshot.exists) {
          throw Exception("Message does not exist!");
        }

        // Process reactions for sender
        List<dynamic> senderReactions = senderSnapshot.get("reactions") ?? [];
        _processReactions(senderReactions, currentUserId, emotion);
        transaction.update(messageRefSender, {'reactions': senderReactions});

        // Process reactions for receiver
        List<dynamic> receiverReactions = receiverSnapshot.get("reactions") ?? [];
        _processReactions(receiverReactions, currentUserId, emotion);
        transaction.update(messageRefReceiver, {'reactions': receiverReactions});
      });

      print("Reaction toggled successfully for both sender and receiver.");
    } catch (e) {
      print("Failed to toggle reaction: $e");
    }
  }

  void _processReactions(List<dynamic> reactions, String userId, String emotion) {
    // Check if the user already has a reaction in the list
    int existingIndex = reactions.indexWhere((r) => r['userId'] == userId);

    if (existingIndex != -1) {
      // If user already has a reaction, check if it's the same as the new one
      if (reactions[existingIndex]['emotion'] == emotion) {
        // If it's the same, remove the reaction (toggle off)
        reactions.removeAt(existingIndex);
      } else {
        // If it's different, update the reaction with the new emotion
        reactions[existingIndex]['emotion'] = emotion;
      }
    } else {
      // If the user doesn't have a reaction yet, add a new one
      reactions.add({'userId': userId, 'emotion': emotion});
    }
  }

}
