import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SendPicture extends StatefulWidget {
  final String userId;
  final DocumentSnapshot data;
  final List<File> selectedImages;
  final bool group;

  SendPicture(
      {Key? key,
      required this.userId,
      required this.data,
      required this.selectedImages,
      required this.group})
      : super(key: key);

  @override
  _SendPictureState createState() => _SendPictureState();
}

class _SendPictureState extends State<SendPicture> {
  bool isLoading = false;
  late File sendPicture;

  @override
  void initState() {
    super.initState();
    sendPicture =
        widget.selectedImages.isNotEmpty ? widget.selectedImages[0] : File('');
  }

  var messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Image Preview"),
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
        ),
        backgroundColor: Colors.black,
        resizeToAvoidBottomInset: true, // This is important
        body: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: FileImage(sendPicture),
                  fit: BoxFit.contain,
                ),
              ),
              child: Stack(
                children: <Widget>[
                  Positioned(
                    bottom: 55,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.selectedImages.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                sendPicture = widget.selectedImages[index];
                              });
                            },
                            child: Stack(
                              children: [
                                widget.selectedImages.length < 2
                                    ? Container()
                                    : Container(
                                        margin: const EdgeInsets.all(3),
                                        width: 80,
                                        height: 80,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all(
                                            color: Colors.red,
                                            width: 2,
                                          ),
                                        ),
                                        child: Image.file(
                                            widget.selectedImages[index],
                                            fit: BoxFit.cover),
                                      ),
                                widget.selectedImages.length < 2
                                    ? Container()
                                    : Positioned(
                                        top: 0,
                                        right: 0,
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              widget.selectedImages
                                                  .removeAt(index);
                                              if (widget
                                                  .selectedImages.isEmpty) {
                                                sendPicture = File('');
                                              }
                                            });
                                          },
                                          child: Container(
                                            decoration: const BoxDecoration(
                                              color: Colors.red,
                                              shape: BoxShape.circle,
                                            ),
                                            padding: const EdgeInsets.all(4),
                                            child: const Icon(Icons.delete,
                                                color: Colors.white, size: 15),
                                          ),
                                        ),
                                      ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 50,
              left: 20,
              right: 20,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextFormField(
                      controller: messageController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Type message....",
                        fillColor: Colors.black,
                        filled: true,
                        hintStyle: const TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.red),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.red),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                        onTap: () async {
                          FirebaseFirestore firestore =
                              FirebaseFirestore.instance;

                          if (messageController.text.isEmpty) {
                            setState(() {
                              isLoading = true;
                            });
                            try {
                              List<String> uploadedImageUrls = [];

                              for (File imageFile in widget.selectedImages) {
                                String fileName = DateTime.now()
                                    .millisecondsSinceEpoch
                                    .toString();
                                TaskSnapshot uploadTask = await FirebaseStorage
                                    .instance
                                    .ref()
                                    .child('media/${widget.data.id}/$fileName')
                                    .putFile(imageFile);

                                String imageUrl =
                                    await uploadTask.ref.getDownloadURL();
                                uploadedImageUrls.add(imageUrl);
                              }

                              for (String imageUrl in uploadedImageUrls) {
                                String messageId = firestore
                                    .collection('messagesListing')
                                    .doc()
                                    .id;

                                Map<String, dynamic> messageData = {
                                  'conversationId': widget.data.id,
                                  'senderId': widget.userId,
                                  'forwarded': false,
                                  "group": false,
                                  'created': DateTime.now(),
                                  'replyMessage': false,
                                  'delivered': true,
                                  'read': false,
                                  "isMessageDelete": false,
                                  'file': true,
                                  "starred": false,
                                  'filePath': imageUrl,
                                  'content': 'Photo',
                                  'fileText': false,
                                  "docId": messageId,
                                  "reactions": [],
                                };
                                String senderId = widget.userId;
                                String receiverId =
                                    widget.data["user1"] == senderId
                                        ? widget.data["user2"]
                                        : widget.data["user1"];

                                //await FirebaseFirestore.instance.collection('messagesListing').add(messageData);

                                await firestore
                                    .collection('messagesListing')
                                    .doc(senderId)
                                    .collection('messages')
                                    .doc(messageId)
                                    .set(messageData);

                                // Set the same message document under the receiver's messages collection
                                await firestore
                                    .collection('messagesListing')
                                    .doc(receiverId)
                                    .collection('messages')
                                    .doc(messageId)
                                    .set(messageData);
                              }

                              Map<String, dynamic> lastMessageUpdate = {
                                'message': 'Photo',
                                'time': DateTime.now(),
                                'seen': false,
                              };

                              await FirebaseFirestore.instance
                                  .collection('conversationListing')
                                  .doc(widget.data.id)
                                  .update({
                                'lastMessage': lastMessageUpdate,
                              });

                              setState(() {
                                isLoading = false;
                              });
                              Navigator.pop(context);
                            } catch (e) {
                              print('Error uploading images: $e');
                              setState(() {
                                isLoading = false;
                              });
                            }
                          } else {
                            setState(() {
                              isLoading = true;
                            });

                            try {
                              List<String> uploadedImageUrls = [];

                              for (File imageFile in widget.selectedImages) {
                                String fileName = DateTime.now()
                                    .millisecondsSinceEpoch
                                    .toString();
                                TaskSnapshot uploadTask = await FirebaseStorage
                                    .instance
                                    .ref()
                                    .child('media/${widget.data.id}/$fileName')
                                    .putFile(imageFile);

                                String imageUrl =
                                    await uploadTask.ref.getDownloadURL();
                                uploadedImageUrls.add(imageUrl);
                              }

                              for (String imageUrl in uploadedImageUrls) {
                                String messageId = firestore
                                    .collection('messagesListing')
                                    .doc()
                                    .id;

                                Map<String, dynamic> messageData = {
                                  'conversationId': widget.data.id,
                                  'senderId': widget.userId,
                                  'group': false,
                                  'forwarded': false,
                                  "isMessageDelete": false,
                                  'created': DateTime.now(),
                                  'replyMessage': false,
                                  'delivered': true,
                                  'read': false,
                                  'file': true,
                                  "starred": false,
                                  'filePath': imageUrl,
                                  'content': 'Photo',
                                  'fileText': true,
                                  'fileMessage': messageController.text,
                                  "docId": messageId,
                                  "reactions": [],
                                };

                                // await FirebaseFirestore.instance.collection('messagesListing').add(messageData);

                                String senderId = widget.userId;
                                String receiverId =
                                    widget.data["user1"] == senderId
                                        ? widget.data["user2"]
                                        : widget.data["user1"];

                                // await FirebaseFirestore.instance.collection('messagesListing').add(messageData);

                                await firestore
                                    .collection('messagesListing')
                                    .doc(senderId)
                                    .collection('messages')
                                    .doc(messageId)
                                    .set(messageData);

                                // Set the same message document under the receiver's messages collection
                                await firestore
                                    .collection('messagesListing')
                                    .doc(receiverId)
                                    .collection('messages')
                                    .doc(messageId)
                                    .set(messageData);
                              }

                              Map<String, dynamic> lastMessageUpdate = {
                                'message': 'Photo',
                                'time': DateTime.now(),
                                'seen': false,
                              };

                              await FirebaseFirestore.instance
                                  .collection('conversationListing')
                                  .doc(widget.data.id)
                                  .update({
                                'lastMessage': lastMessageUpdate,
                              });

                              setState(() {
                                isLoading = false;
                              });
                              Navigator.pop(context);
                            } catch (e) {
                              print('Error uploading images: $e');
                              setState(() {
                                isLoading = false;
                              });
                            }
                          }
                        },
                        child: Container(
                          width: 50.0,
                          height: 50.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25.0),
                            color: Colors.red,
                          ),
                          padding: const EdgeInsets.all(
                              12.0), // Add padding to reduce SVG size
                          child: SvgPicture.asset(
                            'assets/svg/send.svg',
                            fit: BoxFit.contain, // Use contain instead of cover
                          ),
                        ))
                  ],
                ),
              ),
            ),
            isLoading
                ? Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    color: Colors.black.withOpacity(0.5),
                    child: const Center(
                        child: CircularProgressIndicator(color: Colors.red)),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
