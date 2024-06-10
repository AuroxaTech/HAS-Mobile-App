import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:property_app/app_constants/color_constants.dart';


class ToBeReplyMessageWidget extends StatefulWidget {
  final DocumentSnapshot? message;
  final VoidCallback? onCancelReply;
  final String userName;
  final String userId;
  final bool group;

  const ToBeReplyMessageWidget(
      {Key? key,
        this.onCancelReply,
        required this.message,
        required this.userName,required this.userId,required this.group})
      : super(key: key);

  @override
  State<ToBeReplyMessageWidget> createState() => _ToBeReplyMessageWidgetState();
}

class _ToBeReplyMessageWidgetState extends State<ToBeReplyMessageWidget> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.message!.data().toString());
    return IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            color: primaryColor,
            width: 4,
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(child: buildReplyMessage()),
        ],
      ),
    );
  }


  // String checkFile(MessageModelHive message) {
  //   String extension;
  //   String path = message.relativeFilePath ?? '';
  //   // print(path);
  //   if (message.relativeFilePath != null) {
  //     if (path.endsWith(".jpg") ||
  //         path.endsWith(".png") ||
  //         path.endsWith(".jpeg")) {
  //       extension = "Photo";
  //       return extension;
  //     } else if (path.endsWith(".mp4")) {
  //       extension = "Video";
  //       return extension;
  //     } else if (path.endsWith(".m4a")) {
  //       extension = "Voice Note";
  //       return extension;
  //     } else if (path.endsWith(".mp3")) {
  //       extension = "Audio";
  //       return extension;
  //     } else if (path.endsWith(".pdf")) {
  //       extension = "Pdf Document";
  //       return extension;
  //     } else {
  //       extension = path;
  //       return extension;
  //     }
  //   } else {
  //     return message.body ?? '';
  //   }
  // }


  Widget buildReplyMessage() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
              child: Text(
                widget.message!['senderId'] == widget.userId ? 'You' : widget.group ? widget.message!['senderName'] : widget.userName,
                style: const TextStyle(
                  fontSize: 11,
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              )),
          if (widget.onCancelReply != null)
            GestureDetector(
              onTap: widget.onCancelReply,
              child: const Icon(
                Icons.close,
                size: 20,
                color: primaryColor,
              ),
            ),
        ],
      ),
      const SizedBox(height: 3.0,),
       Row(
         children: [

           Expanded(
             child: Text(widget.message!['content'],
              maxLines: 2,
              style:  const TextStyle(
                fontSize: 13,
                color: primaryColor,
                overflow: TextOverflow.ellipsis,
              ),
             ),
           ),

           widget.message!['content'] == "Photo" ?
           ClipRRect(
             borderRadius: BorderRadius.circular(6),
             child: Image.network(widget.message!["filePath"],
               width: 50,
               height: 50,
               fit: BoxFit.cover,
             ),
           )  : SizedBox(),

         ],
       ),
      const SizedBox(height: 5.0,),
    ],
  );
}
