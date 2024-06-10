// import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:dambo/provider/shared_preference.dart';
// import 'package:dambo/screens/ForwardContactScreen.dart';
// import 'package:dambo/utils/AppAssets.dart';
// import 'package:dambo/utils/AppColor.dart';
// import 'package:dambo/widgets/ReceivedMsg.dart';
// import 'package:dambo/widgets/SendMessage.dart';
// import 'package:dambo/widgets/ToBeReplyMessageWidget.dart';
// import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:path/path.dart' as path;
// import '../../services/notification_services/notification_services.dart';
//
// class ChatController extends GetxController {
//   final String name;
//   final String image;
//   final bool group;
//   final DocumentSnapshot data;
//
//   ChatController({
//     required this.name,
//     required this.image,
//     required this.data,
//     required this.group,
//   });
//
//   var messageController = TextEditingController();
//   var user = FirebaseAuth.instance.currentUser;
//   var participants = ''.obs;
//   var emojiShowing = false.obs;
//   var replyMessage = Rxn<DocumentSnapshot>();
//   var repliedTo = "".obs;
//   var selectedImage = Rxn<File>();
//   var imageUrls = <String>[].obs;
//   var isLoading = false.obs;
//   var showSelectedMessages = false.obs;
//
//   final _scrollController = ScrollController();
//   final focusNode = FocusNode();
//
//   @override
//   void onInit() {
//     super.onInit();
//     if (group) {
//       getParticipants();
//     }
//     markLastMessageAsSeen(data.id);
//     markMessagesAsRead(data.id);
//   }
//
//   @override
//   void onClose() {
//     messageController.dispose();
//     super.onClose();
//   }
//
//   void getParticipants() {
//     for (int i = 0; i < data['members'].length; i++) {
//       var memberData = data['members'][i];
//       participants.value += memberData['userName'];
//       if (i != data['members'].length - 1) {
//         participants.value += " , ";
//       }
//     }
//   }
//
//   Future<void> selectMedia() async {
//     isLoading.value = true;
//     selectedImage.value = null;
//     try {
//       final imagePicker = ImagePicker();
//       final pickedFiles = await imagePicker.pickMultiImage(
//         limit: 4,
//         imageQuality: 75,
//       );
//
//       if (pickedFiles != null) {
//         if (pickedFiles.length > 4) {
//           Get.snackbar("Error", "Only 4 images can be uploaded at a time");
//           return;
//         }
//         imageUrls.value = pickedFiles.map((file) => file.path).toList();
//       }
//     } catch (e) {
//       throw Exception("Unable to pick files, please try again");
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   void replyToMessage(DocumentSnapshot message) {
//     replyMessage.value = message;
//   }
//
//   void cancelReply() {
//     replyMessage.value = null;
//   }
//
//   Future<void> createMessage() async {
//     if (emojiShowing.value) {
//       emojiShowing.value = !emojiShowing.value;
//     }
//
//     Map<String, dynamic> messagesData = {
//       'conversationId': data.id,
//       'senderId': user!.uid,
//       "forwarded": false,
//       "created": DateTime.now(),
//       "replyMessage": false,
//       "delivered": true,
//       "read": false,
//       "file": false,
//       "filePath": "path",
//       "content": messageController.text.trim(),
//     };
//
//     if (group) {
//       messagesData['group'] = true;
//       messagesData['senderName'] = SharedPreferenceUtil.getDisplayName();
//       messagesData['senderProfilePicture'] = SharedPreferenceUtil.getAvatarUrl();
//     }
//
//     Map<String, dynamic> lastMessageUpdate = {
//       "message": messageController.text.trim(),
//       "time": DateTime.now(),
//       "seen": false,
//     };
//
//     try {
//       await FirebaseFirestore.instance
//           .collection('messagesListing')
//           .add(messagesData);
//       await FirebaseFirestore.instance
//           .collection('conversationListing')
//           .doc(data.id)
//           .update({
//         'lastMessage': lastMessageUpdate,
//       });
//       String email = "";
//       if (data["user1"] == FirebaseAuth.instance.currentUser!.uid) {
//         email = data["user2"];
//       } else if (data["user2"] == FirebaseAuth.instance.currentUser!.uid) {
//         email = data["user1"];
//       }
//       DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
//           .collection('users')
//           .doc(email)
//           .get();
//
//       if (documentSnapshot.exists) {
//         String id = documentSnapshot.get("deviceToken");
//         String? accessToken = await NotificationServices.generateFCMAccessToken();
//         NotificationServices.sendNotification("Dambo Notification", messageController.text, id, accessToken, Get.context!);
//       }
//       messageController.clear();
//     } catch (e) {
//       print('Error creating messages : $e');
//     }
//   }
//
//   Future<void> createReplyMessage() async {
//     if (emojiShowing.value) {
//       emojiShowing.value = !emojiShowing.value;
//     }
//     Map<String, dynamic> messagesData = {
//       'conversationId': data.id,
//       'senderId': user!.uid,
//       "created": DateTime.now(),
//       "forwarded": false,
//       "file": false,
//       "filePath": "path",
//       "repliedTo": repliedTo.value,
//       "replyMessage": true,
//       "replyBody": replyMessage.value!['content'],
//       "delivered": true,
//       "read": false,
//       "content": messageController.text.trim(),
//     };
//
//     if (group) {
//       messagesData['group'] = true;
//       messagesData['senderName'] = SharedPreferenceUtil.getDisplayName();
//       messagesData['senderProfilePicture'] = SharedPreferenceUtil.getAvatarUrl();
//     }
//
//     Map<String, dynamic> lastMessageUpdate = {
//       "message": messageController.text.trim(),
//       "time": DateTime.now(),
//       "seen": false,
//     };
//
//     try {
//       await FirebaseFirestore.instance
//           .collection('messagesListing')
//           .add(messagesData);
//       await FirebaseFirestore.instance
//           .collection('conversationListing')
//           .doc(data.id)
//           .update({
//         'lastMessage': lastMessageUpdate,
//       });
//       replyMessage.value = null;
//       messageController.clear();
//     } catch (e) {
//       print('Error creating messages : $e');
//     }
//   }
//
//   Future<void> markLastMessageAsSeen(String conversationId) async {
//     try {
//       DocumentReference conversationRef = FirebaseFirestore.instance
//           .collection('conversationListing')
//           .doc(conversationId);
//
//       DocumentSnapshot conversationSnapshot = await conversationRef.get();
//       Map<String, dynamic>? data = conversationSnapshot.data() as Map<String, dynamic>?;
//
//       if (data != null && data.containsKey('lastMessage')) {
//         Map<String, dynamic> lastMessage = data['lastMessage'] as Map<String, dynamic>;
//         if (lastMessage.containsKey('seen') && lastMessage['seen'] == false) {
//           if (data['user1'] != user!.uid) {
//             await conversationRef.update({
//               'lastMessage.seen': true,
//             });
//           }
//         }
//       }
//     } catch (e) {
//       print('Error updating last message: $e');
//     }
//   }
//
//   Future<void> markMessagesAsRead(String conversationId) async {
//     try {
//       QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//           .collection('messagesListing')
//           .where('conversationId', isEqualTo: conversationId)
//           .get();
//
//       if (querySnapshot.docs.isNotEmpty) {
//         WriteBatch batch = FirebaseFirestore.instance.batch();
//
//         querySnapshot.docs.forEach((message) {
//           Map<String, dynamic>? messageData = message.data() as Map<String, dynamic>?;
//
//           if (messageData != null &&
//               messageData.containsKey('read') &&
//               messageData['read'] == false &&
//               messageData['senderId'] != user!.uid) {
//             batch.update(message.reference, {'read': true});
//           }
//         });
//
//         await batch.commit();
//       }
//     } catch (e) {
//       print('Error marking messages as read: $e');
//     }
//   }
// }



import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:property_app/app_constants/color_constants.dart';
import 'package:property_app/utils/utils.dart';
import '../../services/notification_services/notification_services.dart';

class ChatController extends GetxController {
  // final String name;
  // final String image;
  // final bool group;
  // final DocumentSnapshot data;
  //
  // ChatController({
  //   required this.name,
  //   required this.image,
  //   required this.data,
  //   required this.group,
  // });

  var messageController = TextEditingController();
  var participants = ''.obs;
  var emojiShowing = false.obs;
  var replyMessage = Rxn<DocumentSnapshot>();
  var replyMessage1 = Rxn<DocumentSnapshot>();
  var repliedTo = "".obs;
  var selectedImage = Rxn<File>();
  var imageUrls = <String>[].obs;
  var isLoading = false.obs;
  var showSelectedMessages = false.obs;
  RxInt index = 0.obs;
  RxInt index1 = 0.obs;



  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final messages = <DocumentSnapshot>[].obs;

  Stream<List<DocumentSnapshot>> getMessages(String conversationId, String userId) {
    return firestore
        .collection('messagesListing')
        .where('conversationId', isEqualTo: conversationId)
        .snapshots()
        .map((snapshot) {
      List<DocumentSnapshot> documents = snapshot.docs;
      documents.sort((a, b) {
        Timestamp timestampA = a['created'];
        Timestamp timestampB = b['created'];
        return timestampB.compareTo(timestampA);
      });

      for (var doc in documents) {
        if (doc['senderId'] != userId && !doc['read']) {
          doc.reference.update({'read': true});
        }
      }

      return documents;
    });
  }

  void addImageUrl(String filePath) {
    if (!imageUrls.contains(filePath)) {
      imageUrls.add(filePath);
    }
  }

  final _scrollController = ScrollController();
  final focusNode = FocusNode();

  @override
  void onInit() {
    super.onInit();

  }

  var selectedMessages = <String>[].obs;

  @override
  void onClose() {
    messageController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  void getParticipants(DocumentSnapshot data) {
    for (int i = 0; i < data['members'].length; i++) {
      var memberData = data['members'][i];
      participants.value += memberData['userName'];
      if (i != data['members'].length - 1) {
        participants.value += " , ";
      }
    }
  }

  List<File>? selectedMedia = [];

  List<String>? mediaTypes = [];


  // Future<void> selectMedia(context) async {
  //
  //     isLoading.value = true;
  //     selectedMedia = null;
  //     mediaTypes = null;
  //
  //   try {
  //     final imagePicker = ImagePicker();
  //     final pickedFiles = await imagePicker.pickMultiImage(
  //         limit: 4,
  //         imageQuality: 75
  //     );
  //
  //     if (pickedFiles != null) {
  //       if (pickedFiles.length > 4) {
  //         displayToastMessage("Only 4 images can be uploaded at a time", context);
  //         return;
  //       }
  //       selectedMedia = pickedFiles.map((file) => File(file.path)).toList();
  //
  //       // Initialize the media types list
  //       mediaTypes = List<String>.filled(selectedMedia!.length, '');
  //
  //       // Determine the type of each selected file
  //       for (int i = 0; i < selectedMedia!.length; i++) {
  //         String extension = path.extension(selectedMedia![i].path).toLowerCase();
  //         if (extension == '.jpg' || extension == '.jpeg' || extension == '.png') {
  //           mediaTypes![i] = 'Photo';
  //         } else if (extension == '.mp4' || extension == '.mov' || extension == '.avi') {
  //           mediaTypes![i] = 'Video';
  //         }
  //       }
  //     } else {}
  //   } catch (e) {
  //     throw Exception("Unable to pick files, please try again");
  //   }
  // }

  Future<void> selectMedia(BuildContext context) async {
    isLoading.value = true;
    selectedMedia = null;
    mediaTypes = null;

    try {
      final imagePicker = ImagePicker();
      final pickedFiles = await imagePicker.pickMultiImage(
        imageQuality: 75,
      );

      if (pickedFiles != null) {
        if (pickedFiles.length > 4) {
          AppUtils.errorSnackBar("Error", "Only 4 images can be uploaded at a time");
          isLoading.value = false;
          return;
        }

        // Crop each selected image
        List<File> croppedFiles = [];
        for (var pickedFile in pickedFiles) {
          File? croppedFile = await cropImage(File(pickedFile.path));
          if (croppedFile != null) {
            croppedFiles.add(croppedFile);
          }
        }

        selectedMedia = croppedFiles;
        // Initialize the media types list
        mediaTypes = List<String>.filled(selectedMedia!.length, '');

        // Determine the type of each selected file
        for (int i = 0; i < selectedMedia!.length; i++) {
          String extension = path.extension(selectedMedia![i].path).toLowerCase();
          if (extension == '.jpg' || extension == '.jpeg' || extension == '.png') {
            mediaTypes![i] = 'Photo';
          } else if (extension == '.mp4' || extension == '.mov' || extension == '.avi') {
            mediaTypes![i] = 'Video';
          }
        }
      } else {
        Navigator.pop(context);
        isLoading.value = false;
      }
    } catch (e) {
      isLoading.value = false;
      throw Exception("Unable to pick files, please try again");
    }
  }

  Future<void> selectCamera(BuildContext context) async {
    isLoading.value = true;
    selectedMedia = [];
    mediaTypes = [];

    try {
      final imagePicker = ImagePicker();
      final pickedFile = await imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 75,
      );

      if (pickedFile != null) {
        File? croppedFile = await cropImage(File(pickedFile.path));
        if (croppedFile != null) {
          selectedMedia!.add(croppedFile); // Add cropped file to the list
          String extension = path.extension(croppedFile.path).toLowerCase();
          mediaTypes!.add((extension == '.jpg' || extension == '.jpeg' || extension == '.png') ? 'Photo' : 'Unknown'); // Add media type to the list
        }
      }else{
        Navigator.pop(context);
      }

      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      Navigator.pop(context);
      AppUtils.errorSnackBar("Error", "Unable to pick files, please try again");
    }
  }
  Future<File?> cropImage(File imageFile) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,

      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Picture',
          toolbarColor: primaryColor,
          activeControlsWidgetColor: primaryColor,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );

    if (croppedFile != null) {
      return File(croppedFile.path);
    } else {
      return null;
    }
  }

  void replyToMessage(DocumentSnapshot message) {
    replyMessage.value = message;
    //update();
  }

  void cancelReply() {
    replyMessage.value = null;
    update();
  }



  // Future<void> createReplyMessage(DocumentSnapshot data, group) async {
  //   if (emojiShowing.value) {
  //       emojiShowing.value = !emojiShowing.value;
  //   }
  //   Map<String, dynamic> messagesData = {
  //     'conversationId': data.id,
  //     'senderId': user!.uid,
  //     "created": DateTime.now(),
  //     "forwarded": false,
  //     "starred" : false,
  //     "file": false,
  //     "filePath": replyMessage.value!["filePath"],
  //     "repliedTo": repliedTo.value,
  //     "replyMessage": true,
  //     "replyBody": replyMessage.value!['content'],
  //     "delivered": true,
  //     "read": false,
  //     "content": messageController.text.trim(),
  //   };
  //
  //   if (group) {
  //     messagesData['group'] = true;
  //     messagesData['senderName'] = SharedPreferenceUtil.getDisplayName(); // Assuming you have access to the sender's display name
  //     messagesData['senderProfilePicture'] = SharedPreferenceUtil.getAvatarUrl(); // Assuming you have access to the sender's profile picture URL
  //   }
  //
  //   Map<String, dynamic> lastMessageUpdate = {
  //     "message": messageController.text.trim(),
  //     "time": DateTime.now(),
  //     "seen": false,
  //   };
  //
  //     replyMessage.value = null;
  //
  //   messageController.clear();
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
  //         .doc(data.id)
  //         .update({
  //       'lastMessage': lastMessageUpdate,
  //     });
  //   } catch (e) {
  //     print('Error updating last message: $e');
  //   }
  // }


  Future<void> createReplyMessage(DocumentSnapshot data, bool group, String userId) async {
    if (emojiShowing.value) {
      emojiShowing.value = !emojiShowing.value;
    }

    String messageContent = messageController.text.trim();

    String senderId = userId;
    String receiverId = data["user1"] == senderId ? data["user2"] : data["user1"];


    String messageId = firestore.collection('messagesListing').doc().id;


    Map<String, dynamic> messagesData = {
      "isMessageDelete" : false,
      'conversationId': data.id,
      'receiverId': receiverId,
      'senderId': userId,
      "created": DateTime.now(),
      "forwarded": false,
      "starred": false,
      "file": false,
      "filePath": replyMessage.value?["filePath"] ?? "",
      "repliedTo": repliedTo.value,
      "replyMessage": true,
      "replyBody": replyMessage.value?['content'] ?? "",
      "delivered": true,
      "read": false,
      "reactions" : [],
      "docId": messageId,
      "content": messageContent,
    };



    Map<String, dynamic> lastMessageUpdate = {
      "message": messageContent,
      "time": DateTime.now(),
      "seen": false,
    };

    replyMessage.value = null;
    messageController.clear();


    // Add reply message for sender
    await firestore
        .collection('messagesListing')
        .doc(senderId)
        .collection('messages')
        .doc(messageId)
        .set(messagesData);

    // Set the same message document under the receiver's messages collection
    await firestore
        .collection('messagesListing')
        .doc(receiverId)
        .collection('messages')
        .doc(messageId)
        .set(messagesData);


    try {
      await FirebaseFirestore.instance
          .collection('conversationListing')
          .doc(data.id)
          .update({
        'lastMessage': lastMessageUpdate,
      });

    } catch (e) {
      print('Error updating last message: $e');
    }


  }





  Future<void> markLastMessageAsSeen(String conversationId, String userId) async {
    try {
      DocumentReference conversationRef = FirebaseFirestore.instance
          .collection('conversationListing')
          .doc(conversationId);

      // Fetch the document snapshot
      DocumentSnapshot conversationSnapshot = await conversationRef.get();

      // Access the data from the snapshot and cast it to Map<String, dynamic>
      Map<String, dynamic>? data =
      conversationSnapshot.data() as Map<String, dynamic>?;

      // Check if 'lastMessage' field exists and if 'seen' is false
      if (data != null && data.containsKey('lastMessage')) {
        Map<String, dynamic> lastMessage =
        data['lastMessage'] as Map<String, dynamic>;
        if (lastMessage.containsKey('seen') && lastMessage['seen'] == false) {
          // Check if the current user is the sender of the last message
          if (data['user1'] != userId) {
            await conversationRef.update({
              'lastMessage.seen': true,
            });
          }
        }
      }
    } catch (e) {
      print('Error updating last message: $e');
    }
  }

  Future<void> markMessagesAsRead(String conversationId, String userId) async {
    try {
      // Get references for all messages in the conversation
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('messagesListing')
          .where('conversationId', isEqualTo: conversationId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        WriteBatch batch = FirebaseFirestore.instance.batch();

        // Update 'read' field for each message in batch
        querySnapshot.docs.forEach((message) {
          Map<String, dynamic>? messageData =
          message.data() as Map<String, dynamic>?;

          // Ensure the message data is not null and contains the 'read' field
          if (messageData != null &&
              messageData.containsKey('read') &&
              messageData['read'] == false) {
            // Check if the message sender is not the current user
            if (messageData['senderId'] != userId) {
              batch.update(message.reference, {'read': true});
            }
          }
        });

        // Commit the batched writes
        await batch.commit();
      }
    } catch (e) {
      print('Error marking messages as read: $e');
    }
  }



  final ScrollController scrollController = ScrollController();






  // void scrollToBottom() {
  //   if (_scrollController.hasClients) {
  //     scrollController.animateTo(
  //       scrollController.position.maxScrollExtent,
  //       duration: const Duration(milliseconds: 300),
  //       curve: Curves.easeOut,
  //     );
  //   }
  // }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          0.0, // Since it's not reversed, you want to go to the start of the scroll, which is the bottom of the list.
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }


  Future<String> uploadFile(File file) async {
    try {
      String filePath = 'uploads/${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}';
      Reference reference = FirebaseStorage.instance.ref().child(filePath);
      UploadTask uploadTask = reference.putFile(file);
      TaskSnapshot taskSnapshot = await uploadTask;
      return await taskSnapshot.ref.getDownloadURL();
    } catch (e) {
      print(e.toString());
      return '';
    }
  }


  //
  // Future<Map<String, dynamic>?> createPdfMessage(context, DocumentSnapshot data, bool group) async {
  //   if (emojiShowing.value) {
  //       emojiShowing.value = !emojiShowing.value;
  //   }
  //
  //   String senderId = user!.uid;
  //   String receiverId = data["user1"] == senderId ? data["user2"] : data["user1"];
  //
  //   File? pdfFile = await pickPDFFile();
  //   String? fileUrl = pdfFile != null ? await uploadPDF(pdfFile) : null;
  //
  //   Map<String, dynamic> messagesData = {
  //     'conversationId': data.id,
  //     'senderId': senderId,
  //     "isMessageDelete": false,
  //     'receiverId': receiverId,
  //     "forwarded": false,
  //     "created": DateTime.now(),
  //     "replyMessage": false,
  //     "delivered": false,
  //     "read": false,
  //     "file": true,
  //     "filePath": fileUrl ?? "",
  //     "content":  "PDF",
  //     "starred": false,
  //   };
  //
  //   if (group) {
  //     messagesData['group'] = true;
  //     messagesData['senderName'] = SharedPreferenceUtil.getDisplayName();
  //     messagesData['senderProfilePicture'] = SharedPreferenceUtil.getAvatarUrl();
  //   }
  //
  //   messageController.clear();
  //
  //   try {
  //     await FirebaseFirestore.instance.collection('messagesListing').doc(senderId).collection('messages').add(messagesData);
  //     await FirebaseFirestore.instance.collection('messagesListing').doc(receiverId).collection('messages').add(messagesData);
  //     await FirebaseFirestore.instance.collection('conversationListing').doc(data.id).update({
  //       'lastMessage': {
  //         "message": "PDF",
  //         "time": DateTime.now(),
  //         "seen": false,
  //       },
  //     });
  //   } catch (e) {
  //     print('Error updating Firestore: $e');
  //     return null;
  //   }
  //
  //   // Example of notification sending omitted for brevity
  //   return messagesData;
  // }
  //


  var pickedFilePath = RxnString();

  Future<void> pickPDFFile(DocumentSnapshot data) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      pickedFilePath.value = result.files.single.path;
      File selectedFile = File(result.files.single.path!);
     // Get.to(() => PdfScreen(user: user!, data: data, selectedFile: selectedFile, group: false,));
    } else {
      pickedFilePath.value = null;
    }
  }


  var pickedDocPath = RxnString();

  Future<void> pickDOCFile(DocumentSnapshot data) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['doc'],
    );

    if (result != null) {
      pickedFilePath.value = result.files.single.path;
      File selectedFile = File(result.files.single.path!);

      //await OpenFile.open(pickedFilePath.value);
      // Get.to(() => DocFileScreen(user: user!, data: data, selectedFile: selectedFile, group: false,));
    } else {
      pickedFilePath.value = null;
    }
  }





}
