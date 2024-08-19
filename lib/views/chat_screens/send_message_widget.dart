import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_app/app_constants/color_constants.dart';
import 'package:property_app/controllers/theme_controller.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:translator/translator.dart';

import '../../controllers/chat_screens_controller/chat_controller.dart';
import '../../custom_widgets/custom_button.dart';

class SendMessage extends StatefulWidget {
  SendMessage({
    super.key,
    required this.replyMessage,
    required this.document,
    required this.message,
    required this.messageTime,
    required this.seen,
    required this.delivered,
    required this.onSwipeMessage,
    required this.showSelectedBox,
    required this.dataProvider,
    required this.imageUrls,
    required this.index
  });

  final bool replyMessage;
  final int index;
  final DocumentSnapshot document;
  String message;
  final dynamic messageTime;
  final bool seen;
  final bool delivered;
  final bool showSelectedBox;
  final ValueChanged<DocumentSnapshot> onSwipeMessage;
  final ThemeController dataProvider;
  final List<String> imageUrls;

  @override
  State<SendMessage> createState() => _SendMessageState();
}

class _SendMessageState extends State<SendMessage> {
  final translator = GoogleTranslator();
  String replyBody = "";
  String content = "";

  @override
  void initState() {
    if (widget.replyMessage){
      replyBody = widget.document['replyBody'];
      content =  widget.document['content'];
    }
    // TODO: implement initState
    super.initState();
  }
  ChatController chatController = Get.put(ChatController());



  @override
  void didUpdateWidget(covariant SendMessage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.document != oldWidget.document) {
      if (widget.replyMessage) {
        replyBody = widget.document['replyBody'];
        content = widget.document['content'];
      }
    }
  }
  PdfViewerController viewerController = PdfViewerController();
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();


  @override
  Widget build(BuildContext context) {
    int wordCount = replyBody.split(' ').length;
    return widget.document["isMessageDelete"] ? const SizedBox() : SwipeTo(
      offsetDx: 0.2,
      onLeftSwipe: (details) {
        widget.onSwipeMessage(widget.document);
      },

      /// Simple File

      child: Column(
        children: [
          widget.document['file']
              ? Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [

              GestureDetector(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      width: 230,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color : primaryColor.withOpacity(0.8),
                      ),
                      padding: const EdgeInsets.all(10),
                      child: Stack(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              widget.document["forwarded"] == true ?
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Image.asset("assets/images/forward.png", width: 30, height: 20, color: Colors.black,),
                                      const Text("Forwarded", style: TextStyle(
                                          fontStyle: FontStyle.italic
                                      ),),
                                    ],
                                  ),

                                  const SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ) : const SizedBox(),


                              if (widget.document['content'] == "PDF") GestureDetector(
                                onTap: (){
                                },
                                child: Container(
                                  constraints: const BoxConstraints(

                                    maxHeight: 148,

                                    minHeight: 100,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Material(
                                      elevation: 2.0,
                                      child: ClipRRect(
                                        child:   SfPdfViewer.network(
                                          key: _pdfViewerKey,
                                          onTap: (va){
                                           // Get.to(() => PdfViewerScreen(pdfUrl: widget.document['filePath'],));
                                          },
                                          initialZoomLevel: 1.5,
                                          initialScrollOffset: Offset.fromDirection(10),
                                          controller: viewerController,
                                          pageSpacing: 10,
                                          widget.document['filePath'],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ) else ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Material(
                                  elevation: 2.0,
                                  child: SizedBox(
                                    width:
                                    MediaQuery.of(context).size.width * 0.6,
                                    height: 148,
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                      children: <Widget>[
                                        ClipRRect(
                                          child:  Image.network(
                                            widget.document['filePath'],
                                            fit: BoxFit.cover,
                                            height: 148,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),



                              widget.document['fileText'] ?  Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 8, bottom: 15 ),
                                  child: Text(
                                    widget.document['fileMessage'],
                                    style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ) : const SizedBox(),

                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.end,
                              //   crossAxisAlignment: CrossAxisAlignment.end,
                              //   children: [
                              //
                              //     Align(
                              //       alignment: Alignment.topRight,
                              //       child: Padding(
                              //         padding: const EdgeInsets.only(right: 10, left: 4, top: 10),
                              //         child: Text(
                              //           formatTime(widget.message['created'].toDate()),
                              //           style: GoogleFonts.poppins(
                              //             textStyle: TextStyle(
                              //               fontSize: 8.sp,
                              //               color: Colors.grey.shade700 ,
                              //               fontWeight: FontWeight.normal,
                              //             ),
                              //           ),
                              //         ),
                              //       ),
                              //     ),
                              //   ],
                              // ),

                              widget.document["fileText"] == false ?
                              Text(
                                "",
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey.shade800,
                                  ),
                                ),
                              ) : const SizedBox(),



                            ],
                          ),

                          Positioned(
                            right: 1,
                            bottom: 1,
                            child:  Align(
                              alignment: Alignment.topRight,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  widget.document['starred'] == true  ?
                                  Icon(Icons.star,color: Colors.grey.shade800, size: 15,)  : const SizedBox(),
                                  Text(
                                    formatTime(widget.document['created'].toDate()),
                                    style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                        fontSize: 8,
                                        color: Colors.grey.shade800,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  widget.seen
                                      ? const Icon(Icons.done_all_outlined, size: 17)
                                      : widget.delivered
                                      ? const Icon(Icons.done_all_outlined,
                                      color: Colors.white, size: 15)
                                      : const Icon(Icons.done, color: Colors.white, size: 17),
                                ],
                              ),
                            ),
                          )

                        ],
                      ),
                    ),

                    widget.document["reactions"].isEmpty ? const SizedBox() :

                    Wrap(
                      alignment: WrapAlignment.end,
                      crossAxisAlignment: WrapCrossAlignment.end,
                      children: List<Widget>.generate(widget.document["reactions"].length, (index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 4.0, top: 2.0), // Adjust spacing as needed
                          child: Image.asset(
                            "images/${widget.document["reactions"][index]["emotion"]}.gif",
                            width: 20,
                            height: 20,
                          ),
                        );
                      }),
                    )
                  ],
                ),
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //       builder: (context) => ChatImageView(
                  //         imageUrl:  widget.document['filePath'],
                  //       )),
                  // );
                },

              ),


              // GestureDetector(
              //   child: Container(
              //     height: widget.document["forwarded"] == true ? 205.h : widget.document["fileText"] ? 210.h : 185.h,
              //     width: 230.w,
              //     decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(8.h),
              //       color: colorMsg.withOpacity(0.8),
              //     ),
              //     padding: const EdgeInsets.all(10),
              //     child: Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         widget.document["forwarded"] == true
              //             ? Padding(
              //               padding: const EdgeInsets.only(bottom: 10.0), // Adjust padding as needed
              //               child: Row(
              //                 children: [
              //                   Image.asset(
              //                     "assets/images/forward.png",
              //                     width: 30,
              //                     height: 20,
              //                     color: Colors.black,
              //                   ),
              //                   const SizedBox(width: 5),
              //                   const Text(
              //                     "Forwarded",
              //                     style: TextStyle(
              //                       fontStyle: FontStyle.italic,
              //                     ),
              //                   ),
              //                 ],
              //               ),
              //             )
              //             : const SizedBox(),
              //
              //         ClipRRect(
              //           borderRadius: BorderRadius.circular(8),
              //           child: Material(
              //             elevation: 2.0,
              //             child: SizedBox(
              //               width: MediaQuery.of(context).size.width * 0.6,
              //               height: 148.h,
              //               child: Column(
              //                 crossAxisAlignment: CrossAxisAlignment.stretch,
              //                 children: <Widget>[
              //                   ClipRRect(
              //                     child: Image.network(
              //                       widget.document['filePath'],
              //                       fit: BoxFit.cover,
              //                       height: 148.h,
              //                     ),
              //                   ),
              //                 ],
              //               ),
              //             ),
              //           ),
              //         ),
              //         const SizedBox(
              //           height: 5,
              //         ),
              //
              //
              //         widget.document['fileText'] ?  Padding(
              //           padding: const EdgeInsets.only(top: 8, ),
              //           child: Text(
              //             widget.document['fileMessage'],
              //             style: GoogleFonts.poppins(
              //               textStyle: TextStyle(
              //                 fontSize: 15.sp,
              //                 fontWeight: FontWeight.w500,
              //                 color: Colors.white,
              //               ),
              //             ),
              //           ),
              //         ) : SizedBox(),
              //         Align(
              //           alignment: Alignment.bottomRight,
              //           child: Row(
              //             mainAxisAlignment: MainAxisAlignment.end,
              //             crossAxisAlignment: CrossAxisAlignment.end,
              //             children: [
              //               Padding(
              //                 padding: const EdgeInsets.only(right: 10, left: 4, top: 10),
              //                 child: Text(
              //                   formatTime(widget.messageTime.toDate()),
              //                   style: GoogleFonts.poppins(
              //                     textStyle: TextStyle(
              //                       fontSize: 8.sp,
              //                       fontWeight: FontWeight.w500,
              //                       color: Colors.grey.shade800,
              //                     ),
              //                   ),
              //                 ),
              //               ),
              //               widget.seen
              //                   ? const Icon(Icons.done_all_outlined, size: 17)
              //                   : widget.delivered
              //                   ? const Icon(Icons.done_all_outlined,
              //                   color: Colors.white, size: 15)
              //                   : const Icon(Icons.done, color: Colors.white, size: 17),
              //             ],
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              //   onTap: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //           builder: (context) => ChatImageView(
              //             imageUrl:  widget.document['filePath'],
              //           )),
              //     );
              //   },
              // ),
              widget.showSelectedBox
                  ?
              Obx(() => SizedBox(
                  width: 40,
                  child: CheckboxListTile(
                    value: widget.dataProvider.selectedMessages
                        .contains(widget.document.id),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    checkboxShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    side: BorderSide(color: redColor.withOpacity(0.9), width: 1.8),

                    onChanged: (selected) async {
                      widget.dataProvider
                          .selectMessage(selected!, widget.document.id);
                      if(widget.dataProvider.selectedMessages.length == 1){
                        chatController.replyMessage1.value = widget.document;
                        chatController.index1.value = widget.index;
                      }else{
                        chatController.replyMessage.value = null;
                      }
                    },

                    activeColor: primaryColor,
                  ),
                ),
              )
                  : Container(),
            ],
          ) :


          /// Simple Text

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Flexible(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [

                    Container(
                      constraints: BoxConstraints(
                        minWidth:   widget.document['starred'] == true ?110 : 80,
                        maxWidth: 230,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: primaryColor.withOpacity(0.8),
                      ),
                      child: widget.replyMessage ?
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            constraints: BoxConstraints(
                              minWidth: 80,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: greenColor
                                    .withOpacity(0.3),
                              ),
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(10.0),
                                  topRight: Radius.circular(10.0)),
                              color: primaryColor.withOpacity(0.8),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 7.0, vertical: 4.0),
                              child: IntrinsicHeight(
                                child: Row(
                                  children: [
                                    Container(
                                      color: whiteColor,
                                      width: 4,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Flexible(  // Use Flexible to ensure the Row doesn't overflow
                                      child: InkWell(
                                        onTap: replyBody == "Photo" ? (){
                                          // Get.to(() => ChatImageView(imageUrl: widget.document['filePath'],));
                                        } : null,
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Flexible(
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    widget.document['repliedTo'] ==
                                                        "Second User"
                                                        ? 'You'
                                                        : widget.document['repliedTo'],
                                                    softWrap: true,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: GoogleFonts.poppins(
                                                      textStyle: TextStyle(
                                                        fontSize: 9,
                                                        color: whiteColor,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    replyBody,
                                                    overflow: TextOverflow.ellipsis,
                                                    softWrap: true,
                                                    maxLines: 2,
                                                    style: GoogleFonts.roboto(
                                                      textStyle: TextStyle(
                                                        fontSize: 11,
                                                        color: whiteColor.withOpacity(0.6),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            if (replyBody == "Photo")
                                              ClipRRect(
                                                borderRadius: BorderRadius.circular(6),
                                                child: Image.network(
                                                  widget.document['filePath'],
                                                  width: 60,
                                                  height: 50,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),


                          // Padding(
                          //   padding: EdgeInsets.symmetric(
                          //       horizontal: 10.w, vertical: 10.h),
                          //   child: Text(
                          //     content,
                          //     style: GoogleFonts.roboto(
                          //       textStyle: TextStyle(
                          //         color: colorWhite,
                          //         fontSize: 11.sp,
                          //       ),
                          //     ),
                          //   ),
                          // ),

                          Container(
                            constraints: BoxConstraints(
                                minWidth: 80
                            ),
                            child: Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      widget.document["forwarded"] == true
                                          ? Padding(
                                        padding: const EdgeInsets.only(bottom: 10.0), // Adjust padding as needed
                                        child: Row(
                                          children: [
                                            Image.asset(
                                              "assets/images/forward.png",
                                              width: 30,
                                              height: 20,
                                              color: Colors.black,
                                            ),
                                            const SizedBox(width: 5),
                                            const Text(
                                              "Forwarded",
                                              style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                          : const SizedBox(),
                                      Text(
                                        content,
                                        textAlign: TextAlign.justify,
                                        style: GoogleFonts.roboto(
                                          textStyle: TextStyle(
                                            fontSize: 15,
                                            color: whiteColor,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          widget.document['starred'] == true  ?
                                          Icon(Icons.star,color: Colors.grey.shade800, size: 15,)  : const SizedBox(),
                                          Padding(
                                            padding: const EdgeInsets.only(right: 10, left: 5),
                                            child: Text(
                                              formatTime(widget.messageTime.toDate()),
                                              style: GoogleFonts.poppins(
                                                textStyle: TextStyle(
                                                  fontSize: 8,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.grey.shade800,
                                                ),
                                              ),
                                            ),
                                          ),

                                          widget.seen
                                              ? const Icon(Icons.done_all_outlined,size: 17,)
                                              : widget.delivered
                                              ?  const Icon(Icons.done_all_outlined, color: Colors.white, size: 15,)
                                              : const Icon(Icons.done, color: Colors.white, size: 17,)

                                          // widget.seen
                                          //     ? MessageStatus(
                                          //   width: 22.0,
                                          //   height: 22.0,
                                          // )
                                          //     : widget.delivered
                                          //     ? MessageStatus(
                                          //   width: 22.0,
                                          //   height: 22.0,
                                          //   image: 'assets/images/icon-2.png',
                                          //   backgroundColor: colorWhite,
                                          //   tickColor: colorBlack,
                                          // )
                                          //     : MessageStatus(
                                          //   width: 22.0,
                                          //   height: 22.0,
                                          //   image: 'assets/images/singleCheck.png',
                                          //   backgroundColor: colorWhite,
                                          //   tickColor: colorBlack,
                                          // ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ) :
                      Stack(
                        children: [
                          SizedBox(
                            width:  widget.document["forwarded"] == true
                                ? 150 : 80,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10, left: 10),
                              child: Column(
                                children: [
                                  widget.document["forwarded"] == true
                                      ? Row(
                                    children: [
                                      Image.asset(
                                        "assets/images/forward.png",
                                        width: 30,
                                        height: 20,
                                        color: Colors.black,
                                      ),
                                      const SizedBox(width: 5),
                                      const Text(
                                        "Forwarded",
                                        style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ],
                                  )
                                      : const SizedBox(),
                                ],
                              ),
                            ),
                          ),

                          Padding(
                            padding: EdgeInsets.only(
                              left: 5,
                              right: 10,
                              top:  widget.document["forwarded"] == true
                                  ? 20 : 8,
                              bottom: 13,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                widget.message,
                                // Use ellipsis to handle text that can't fit
                                style: GoogleFonts.roboto(
                                  textStyle: TextStyle(
                                    fontSize: 15,
                                    color: whiteColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),



                          Positioned(
                            right: 5,
                            bottom: 10,

                            child: Padding(
                              padding: const EdgeInsets.only(),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,

                                children: [

                                  widget.document['starred'] == true  ?
                                  Align(
                                    alignment : Alignment.bottomCenter,
                                      child: Icon(Icons.star,color: Colors.grey.shade800, size: 12,))  : const SizedBox(),

                                  Padding(
                                    padding: const EdgeInsets.only(right: 10, left: 2, top: 10),
                                    child: Text(
                                      formatTime( widget.messageTime.toDate()),
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                          fontSize: 8,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey.shade800,
                                        ),
                                      ),
                                    ),
                                  ),

                                  widget.seen
                                      ? const Icon(Icons.done_all_outlined, size: 17,)
                                      : widget.delivered
                                      ? const Icon(Icons.done_all_outlined, color: Colors.white, size: 15,)
                                      : const Icon(Icons.done, color: Colors.white, size: 17,),

                                ],
                              ),
                            ),
                          ),


                        ],
                      ),
                    ),
                    widget.document["reactions"].isEmpty ? const SizedBox() :

                    Wrap(
                      alignment: WrapAlignment.start,
                      crossAxisAlignment: WrapCrossAlignment.start,
                      children: List<Widget>.generate(widget.document["reactions"].length, (index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 4.0, top: 2.0), // Adjust spacing as needed
                          child: Image.asset(
                            "images/${widget.document["reactions"][index]["emotion"]}.gif",
                            width: 20,
                            height: 20,
                          ),
                        );
                      }),
                    )
                  ],
                ),
              ),

              widget.showSelectedBox
                  ? Obx(() => SizedBox(
                width: 40,
                child: Theme(
                    data:
                    ThemeData(unselectedWidgetColor: Colors.green),
                    child: CheckboxListTile(
                      value: widget.dataProvider.selectedMessages
                          .contains(widget.document.id),
                      onChanged: (selected) async {
                        widget.dataProvider
                            .selectMessage(selected!, widget.document.id);
                        if(widget.dataProvider.selectedMessages.length == 1){
                          chatController.replyMessage1.value = widget.document;
                          chatController.index1.value = widget.index;
                        }else{
                          chatController.replyMessage.value = null;
                        }
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      checkboxShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      side: BorderSide(color: redColor.withOpacity(0.9), width: 1.8),

                      activeColor: primaryColor,
                    ),
                                    ),
                                  ),
                  )
                  : Container(),
            ],
          ),
        ],
      ),
    );
  }
}
