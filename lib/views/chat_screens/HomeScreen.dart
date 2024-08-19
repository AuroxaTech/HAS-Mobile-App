import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:property_app/app_constants/color_constants.dart';
import 'package:property_app/utils/shared_preferences/preferences.dart';
import 'package:property_app/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constant_widget/constant_widgets.dart';
import '../../services/notification_services/notification_services.dart';
import 'chat_view.dart';

class ChatListing extends StatefulWidget {
  const ChatListing({super.key});

  @override
  _ChatListingState createState() => _ChatListingState();
}

class _ChatListingState extends State<ChatListing>
    with SingleTickerProviderStateMixin {
  late TabController _controller;
  bool searchBox = false;

  NotificationServices notificationServices = NotificationServices();
  final firestore = FirebaseFirestore.instance;


  var userId;

  getUserId() async {
    var id = await Preferences.getUserID();
    setState(() {
      userId = id;
    });
  }
   _updateUserStatus(bool isOnline) async{

    if (userId != null) {
      FirebaseFirestore.instance.collection('users').doc(userId.toString()).update({
        'online': isOnline,
        'lastSeen': FieldValue.serverTimestamp(),
      });
      print(isOnline);
    }
  }

  @override
  void initState() {
    super.initState();
   // getUserId();
    _controller = TabController(length: 2, vsync: this, initialIndex: 0);
    _controller.addListener(_handleTabIndex);
    notificationServices.requestNotificationPermission();
    notificationServices.forgroundMessage();
    notificationServices.firebaseInit(context);

    // notificationServices.getDeviceToken().then((value){
    //   if (kDebugMode) {
    //     print('device token');
    //     print(value);
    //   }
    // });
  //  getUserId();
    getCheck();
    _updateUserStatus(true);
  }

  void getCheck() async {
    userId = await Preferences.getUserID();
    firestore
        .collection('conversationListing')
        .where('user', arrayContains: userId.toString())
        .snapshots()
        .listen((snapshot) {
      for (var conversationChange in snapshot.docChanges) {
        if (conversationChange.type == DocumentChangeType.added || conversationChange.type == DocumentChangeType.modified) {
          // Get the conversation document ID
          String receiverId = conversationChange.doc["user1"].toString() == userId.toString()
              ? conversationChange.doc["user2"].toString()
              : conversationChange.doc["user1"].toString();
          String conversationId = receiverId;
          print(conversationId);

          // Listen for new messages within this conversation
          firestore
              .collection('messagesListing')
              .doc(conversationId)
              .collection('messages')
              .where('receiverId', isEqualTo: userId.toString()) // Messages sent to the current user
              .snapshots()
              .listen((messageSnapshot) {
            for (var messageChange in messageSnapshot.docChanges) {
              if (messageChange.type == DocumentChangeType.added) {
                String senderId = messageChange.doc['senderId'].toString();
                String messageId = messageChange.doc.id;

                print("Trying to update message from sender: $senderId with message ID: $messageId");

                // Path to the sender's message document
                var senderMessagesRef = firestore
                    .collection('messagesListing')
                    .doc(senderId)
                    .collection('messages')
                    .doc(messageId);

                // Update the status to 'delivered' and initialize the time
                senderMessagesRef.update({
                  "delivered" : true,
                }).catchError((error) {
                  print("Failed to update message status: $error");
                });
              }
            }
          });
        }
      }
    });

  }

  @override
  void dispose() {
    _controller.removeListener(_handleTabIndex);
    _controller.dispose();
    super.dispose();
  }

  void _handleTabIndex() {
    setState(() {});
  }
  final AppState _appState = AppState();

  List<File>? selectedMedia = [];

  List<String>? mediaTypes = [];
  bool isLoading = false;
  Future<void> selectCamera(BuildContext ctx) async {
    isLoading = true;
    selectedMedia = [];
    mediaTypes = [];

    try {
      final imagePicker = ImagePicker();
      final pickedFile = await imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 75,
      );

      if (pickedFile != null) {
         setState(() {
           selectedMedia!.add(File(pickedFile.path));  // Add cropped file to the list
           String extension = path.extension(pickedFile.path).toLowerCase();
           mediaTypes!.add((extension == '.jpg' || extension == '.jpeg' || extension == '.png') ? 'Photo' : 'Unknown');
         });
        if(selectedMedia != null){
          // Navigator
          //     .push(
          //     ctx,
          //     MaterialPageRoute(
          //         builder: (
          //             context) =>
          //             ForwardContactScreen1(file: selectedMedia!.first,)));
         }

          // Add media type to the list

      }else{
        Navigator.pop(context);
      }

      isLoading = false;
    } catch (e) {
      isLoading = false;
      AppUtils.errorSnackBar("Error", "Unable to pick files, please try again");
     }
  }


  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addObserver(_appState);
    print("home build");
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: titleAppBar("Inbox", action: [
        IconButton(onPressed: (){
          setState(() {
            searchBox = !searchBox;
          });
        },
            icon:  searchBox ?  const Icon(Icons.close ) : Icon(Icons.search ))
        ],
      ),
      // backgroundColor: whiteColor,
      // appBar: AppBar(
      //   automaticallyImplyLeading: false,
      //   elevation: 0.0,
      //   backgroundColor: primaryColor,
      //   title: const Row(
      //     mainAxisAlignment: MainAxisAlignment.start,
      //     children: [
      //       Text("DAMBO",style: TextStyle(
      //         color: whiteColor,
      //         letterSpacing: 1.5,
      //         fontWeight: FontWeight.bold,
      //       ),),
      //       // Padding(
      //       //   padding: const EdgeInsets.only(bottom: 9.0, top: 5.0),
      //       //   child: CachedImage(
      //       //     imageWidth: 50.w,
      //       //     imageHeight: 50.w,
      //       //     radius: 25.w,
      //       //     color: colorWhite,
      //       //     image:
      //       //     'https://i.tribune.com.pk/media/images/Shahid-Afridi1616573639-1/Shahid-Afridi1616573639-1.jpg',
      //       //   ),
      //       // ),
      //     ],
      //   ),
      //   actions: [
      //     // IconButton(onPressed: (){
      //     //   setState(() {
      //     //     searchBox = !searchBox;
      //     //   });
      //     // }, icon: const Icon(Icons.search, color: Colors.white,)),
      //     IconButton(onPressed: (){
      //       selectCamera(context);
      //     }, icon: const Icon(Icons.camera_alt_outlined, color: Colors.white,)),
      //    PopupMenuButton<String>(
      //       color: whiteColor,
      //         surfaceTintColor: whiteColor,
      //         icon: const Icon(
      //           Icons.more_vert, // Use the three dots menu icon
      //           color: Colors.white,),
      //         onSelected: (value) {
      //           // value == 'Settings'
      //           //     ?
      //           // Navigator.push(
      //           //   context,
      //           //   MaterialPageRoute(
      //           //     builder: (context) =>
      //           //         const SettingsScreen(),
      //           //   ),
      //           // )
      //           //     : value == 'Starred messages'
      //           //     ? Navigator.push(
      //           //   context,
      //           //   MaterialPageRoute(
      //           //     builder: (context) =>
      //           //     const StarredMessagesScreen(),
      //           //   ),
      //           // )
      //           //     : value == 'Linked devices'
      //           //     ? Navigator.push(
      //           //   context,
      //           //   MaterialPageRoute(
      //           //     builder: (context) =>
      //           //     const LinkedDevices(),
      //           //   ),
      //           // )
      //           //     : value == 'New Group'
      //           //     ? Navigator.push(
      //           //   context,
      //           //   MaterialPageRoute(
      //           //     builder: (context) =>
      //           //     const NewGroupScreen(),
      //           //   ),
      //           // )
      //           // : print(value);
      //         }, itemBuilder: (BuildContext context) {
      //       return [
      //         PopupMenuItem(
      //           value: 'New Group',
      //           child: Text(
      //             'New Group',
      //             style: GoogleFonts.roboto(
      //               textStyle: const TextStyle(
      //                 fontSize: 15.0,
      //               ),
      //             ),
      //           ),
      //         ),
      //         // PopupMenuItem(
      //         //   value: 'New broadcast',
      //         //   child: Text(
      //         //     'New broadcast',
      //         //     style: GoogleFonts.roboto(
      //         //       textStyle: const TextStyle(
      //         //         fontSize: 15.0,
      //         //       ),
      //         //     ),
      //         //   ),
      //         // ),
      //         // PopupMenuItem(
      //         //   value: 'Linked devices',
      //         //   child: Text(
      //         //     'Linked devices',
      //         //     style: GoogleFonts.roboto(
      //         //       textStyle: const TextStyle(
      //         //         fontSize: 15.0,
      //         //       ),
      //         //     ),
      //         //   ),
      //         // ),
      //         PopupMenuItem(
      //           value: 'Starred messages',
      //           child: Text(
      //             'Starred messages',
      //             style: GoogleFonts.roboto(
      //               textStyle: const TextStyle(
      //                 fontSize: 15.0,
      //               ),
      //             ),
      //           ),
      //         ),
      //         PopupMenuItem(
      //           value: 'Settings',
      //           child: Text(
      //             'Settings',
      //             style: GoogleFonts.roboto(
      //               textStyle: const TextStyle(
      //                 fontSize: 15.0,
      //               ),
      //             ),
      //           ),
      //         ),
      //       ];
      //     }),
      //
      //   ],
      //   // bottom: TabBar(
      //   //   controller: _controller,
      //   //   indicator: const UnderlineTabIndicator(
      //   //     borderSide: BorderSide(
      //   //       width: 4,
      //   //       color: colorWhite,),
      //   //   ),
      //   //   indicatorSize: TabBarIndicatorSize.tab,
      //   //   tabs: [
      //   //     Padding(
      //   //       padding: const EdgeInsets.only(
      //   //         bottom: 9.0,
      //   //         top: 19.8,
      //   //       ),
      //   //       child: Text(
      //   //         "CHATS",
      //   //         style: GoogleFonts.roboto(
      //   //           textStyle: const TextStyle(
      //   //             fontSize: 14.0,
      //   //             fontWeight: FontWeight.bold,
      //   //             color: colorWhite,
      //   //           ),
      //   //         ),
      //   //       ),
      //   //     ),
      //   //     Padding(
      //   //       padding: const EdgeInsets.only(
      //   //         bottom: 9.0,
      //   //         top: 19.8,
      //   //       ),
      //   //       child: Text(
      //   //         "STATUS",
      //   //         style: GoogleFonts.roboto(
      //   //           textStyle: const TextStyle(
      //   //               fontSize: 14.0,
      //   //               color: colorWhite,
      //   //               fontWeight: FontWeight.bold),
      //   //         ),
      //   //       ),
      //   //     ),
      //   //   ],
      //   // ),
      // ),
      body: ChatView(userImg: '', searchBox: searchBox),
    //   floatingActionButton: _controller.index == 0
    //       ? Padding(
    //           padding: const EdgeInsets.only(right: 10.0, bottom: 30.0),
    //           child: SizedBox(
    //             width: 50,
    //             height: 50,
    //             child: FloatingActionButton(
    //               onPressed: () {
    //                 // Navigator.push(
    //                 //     context,
    //                 //     MaterialPageRoute(
    //                 //         builder: (context) => const ContactScreen()));
    //               },
    //               backgroundColor: redColor,
    //               elevation: 8.0,
    //               child: Image.asset('assets/images/message.png'),
    //             ),
    //           ),
    //         )
    //       : const SizedBox(),
    );
  }
}





class AppState with WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        _updateUserStatus(true);
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        _updateUserStatus(false);
        break;
      case AppLifecycleState.hidden:
        _updateUserStatus(false);
        // TODO: Handle this case.
    }
  }

  void _updateUserStatus(bool isOnline) async{
    var id = await Preferences.getUserID();

    if (id != null) {
      FirebaseFirestore.instance.collection('users').doc(id.toString()).update({
        'online': isOnline,
        'lastSeen': FieldValue.serverTimestamp(),
      });
      print(isOnline);
    }
  }
}
