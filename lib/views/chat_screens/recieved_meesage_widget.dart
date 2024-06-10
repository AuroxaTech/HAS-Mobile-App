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

class ReceivedMsg extends StatefulWidget {
  String msg;
  final DocumentSnapshot message;
  final String time;
  final ValueChanged<DocumentSnapshot> onSwipeMessage;
  final bool showSelectedBox;
  final int index;
  final ThemeController dataProvider;
  final bool group;
  final List<String> imageUrls;

  ReceivedMsg({
    super.key,
    required this.time,
    required this.group,
    required this.msg,
    required this.onSwipeMessage,
    required this.message,
    required this.showSelectedBox,
    required this.index,
    required this.dataProvider, required this.imageUrls,
  });

  @override
  State<ReceivedMsg> createState() => _ReceivedMsgState();
}

class _ReceivedMsgState extends State<ReceivedMsg> {
  PdfViewerController viewerController = PdfViewerController();
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  final translator = GoogleTranslator();
  String replyBody = '';
  String content = "";
  @override
  void initState() {
    if (widget.message['replyMessage']){
      replyBody = widget.message['replyBody'];
      content =  widget.message['content'];
    }
    // TODO: implement initState
    super.initState();
  }


  ChatController chatController = Get.put(ChatController());
  @override
  Widget build(BuildContext context) {
    return widget.message["isMessageDelete"] ?  const SizedBox() :
    SwipeTo(
        offsetDx: 0.2,
        onRightSwipe: (details) {
          widget.onSwipeMessage(widget.message);
        },
        child: widget.message['file'] ? Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            widget.showSelectedBox
                ?  Obx(
                  ()=> SizedBox(
                    width: 40,
                    child: Theme(
                  data:
                  ThemeData(unselectedWidgetColor: Colors.green),
                  child: CheckboxListTile(
                    value: widget.dataProvider.selectedMessages
                        .contains(widget.message.id),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    checkboxShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    side: BorderSide(color: redColor.withOpacity(0.9), width: 1.8),

                    onChanged: (selected) async {
                      widget.dataProvider
                          .selectMessage(selected!, widget.message.id);
                      if(widget.dataProvider.selectedMessages.length == 1){
                        chatController.replyMessage1.value = widget.message;
                        chatController.index1.value = widget.index;
                      }else{
                        chatController.replyMessage.value = null;
                      }
                    },
                    activeColor: primaryColor,
                  ),
                                ),
                              ),
                )
                : Container(),

            GestureDetector(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 230,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: greyColor.withOpacity(0.5),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            widget.message["forwarded"] == true ?
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


                            widget.message['content'] == "PDF" ?

                            GestureDetector(
                              onTap: (){
                              },
                              child: Container(
                                constraints: BoxConstraints(

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
                                         // Get.to(() => PdfViewerScreen(pdfUrl: widget.message['filePath'],));
                                        },
                                        initialZoomLevel: 1.5,
                                        initialScrollOffset: Offset.fromDirection(10),
                                        controller: viewerController,
                                        pageSpacing: 10,
                                        widget.message['filePath'],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ) :
                            ClipRRect(
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
                                          widget.message['filePath'],
                                          fit: BoxFit.cover,
                                          height: 148,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            widget.message['fileText'] ?  Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 8, bottom: 15 ),
                                child: Text(
                                  widget.message['fileMessage'],
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey.shade800,
                                    ),
                                  ),
                                ),
                              ),
                            ) : SizedBox(),

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

                            widget.message["fileText"] == false ?
                            Text(
                              "",
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey.shade800,
                                ),
                              ),
                            ) : SizedBox(),



                          ],
                        ),

                        Positioned(
                          right: 1,
                          bottom: 1,
                          child:  Row(
                            children: [
                              widget.message['starred'] == true  ?
                              Icon(Icons.star,color: Colors.grey.shade700, size: 15,)  : SizedBox(),

                              Align(
                                alignment: Alignment.topRight,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 10, left: 4, top: 10),
                                  child: Text(
                                    formatTime(widget.message['created'].toDate()),
                                    style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                        fontSize: 8,
                                        color: Colors.grey.shade700 ,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )

                      ],
                    ),
                  ),
                  widget.message["reactions"].isEmpty ? const SizedBox() :

                  Wrap(
                    alignment: WrapAlignment.end,
                    crossAxisAlignment: WrapCrossAlignment.end,
                    children: List<Widget>.generate(widget.message["reactions"].length, (index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 4.0, top: 2.0), // Adjust spacing as needed
                        child: Image.asset(
                          "images/${widget.message["reactions"][index]["emotion"]}.gif",
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
                //         imageUrl:  widget.message['filePath'],
                //       )),
                // );

              },


            ),
          ],
        ) :
        widget.message['replyMessage']
            ?  Row(
          children: [
            widget.showSelectedBox
                ? Obx(
            () => SizedBox(
              width: 40,
              child: Theme(
                  data:
                  ThemeData(unselectedWidgetColor: Colors.green),
                  child: CheckboxListTile(
                    value: widget.dataProvider.selectedMessages
                        .contains(widget.message.id),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    checkboxShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    side: BorderSide(color: redColor.withOpacity(0.9), width: 1.8),

                    onChanged: (selected) async {
                      widget.dataProvider
                          .selectMessage(selected!, widget.message.id);
                      if(widget.dataProvider.selectedMessages.length == 1){
                        chatController.replyMessage1.value = widget.message;
                        chatController.index1.value = widget.index;
                      }else{
                        chatController.replyMessage.value = null;
                      }
                    },
                    activeColor: primaryColor,
                  ),
                                ),
                              ),
                )
                : Container(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  constraints: BoxConstraints(maxWidth: 230),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: primaryColor.withOpacity(0.5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      widget.message["forwarded"] == true ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Image.asset("assets/images/forward.png", width: 30, height: 20, color: Colors.black,),
                              const Text("Forwarded", style: TextStyle(
                                fontStyle: FontStyle.italic,

                              ),),
                            ],
                          ),

                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ) : const SizedBox(),
                      Container(

                        decoration: BoxDecoration(
                          border: Border.all(
                            color: greyColor.withOpacity(0.3),
                          ),
                          borderRadius:  BorderRadius.only(
                              topLeft: Radius.circular(8),
                              topRight: Radius.circular(8)),
                          color: greyColor.withOpacity(0.6),
                        ),
                        child: Padding(
                          padding:  const EdgeInsets.symmetric(
                              horizontal: 7.0, vertical: 4.0),
                          child: IntrinsicHeight(
                            child: Row(
                              children: [
                                Container(
                                  color: primaryColor,
                                  width: 4,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Flexible(

                                  child: InkWell(
                                    onTap: replyBody == "Photo" ? (){
                                   //   Get.to(() => ChatImageView(imageUrl: widget.message['filePath'],));
                                    } : null,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                widget.message['repliedTo'] ==
                                                   "Second User"
                                                    ? 'You'
                                                    : widget
                                                    .message['repliedTo'],
                                                style: GoogleFonts.poppins(
                                                  textStyle: TextStyle(
                                                    fontSize: 9,
                                                    color: primaryColor,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  replyBody,
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: GoogleFonts.roboto(
                                                    textStyle: TextStyle(
                                                      fontSize: 11,
                                                      color: blackColor.withOpacity(0.5),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        replyBody == "Photo" ?
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(6),
                                          child: Image.network(
                                            widget.message['filePath'],
                                            width: 60,
                                            height: 50,
                                            fit: BoxFit.cover,
                                          ),
                                        ) : const SizedBox(),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Text(
                              content,
                              style: GoogleFonts.roboto(
                                textStyle: TextStyle(
                                    color: blackColor,
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal
                                ),
                              ),
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                widget.message['starred'] == true  ?
                                Icon(Icons.star,color: Colors.grey.shade700, size: 15,)  : SizedBox(),

                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Text(
                                    formatTime(widget.message['created'].toDate()),
                                    style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                        fontSize: 8,
                                        color: Colors.grey.shade700,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                widget.message["reactions"].isEmpty ? const SizedBox() :

                Wrap(
                  alignment: WrapAlignment.end,
                  crossAxisAlignment: WrapCrossAlignment.end,
                  children: List<Widget>.generate(widget.message["reactions"].length, (index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 5.0, top: 2.0), // Adjust spacing as needed
                      child: Image.asset(
                        "images/${widget.message["reactions"][index]["emotion"]}.gif",
                        width: 20,
                        height: 20,
                      ),
                    );
                  }),
                )
              ],
            ),
          ],
        ) : Row(
          children: [
            widget.showSelectedBox
                ?  Obx(
                  ()=> SizedBox(
                    width: 40,
                    child: Theme(
                  data:
                  ThemeData(unselectedWidgetColor: Colors.green),
                  child: CheckboxListTile(
                    value: widget.dataProvider.selectedMessages
                        .contains(widget.message.id),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    checkboxShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    side: BorderSide(color: redColor.withOpacity(0.9), width: 1.8),

                    onChanged: (selected) async {
                      widget.dataProvider
                          .selectMessage(selected!, widget.message.id);
                      if(widget.dataProvider.selectedMessages.length == 1){
                        chatController.replyMessage1.value = widget.message;
                        chatController.index1.value = widget.index;
                      }else{
                        chatController.replyMessage.value = null;
                      }
                    },
                    activeColor: primaryColor,
                  ),
                                ),
                              ),
                )
                : Container(),
            Flexible(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    constraints: BoxConstraints(
                        minWidth: 80,
                        maxWidth: 230
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: greyColor.withOpacity(0.5),
                    ),
                    child: !widget.group ?
                    Stack(

                      children: [

                        SizedBox(
                          width:  widget.message["forwarded"] == true
                              ? 150 : 80,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10, left: 10),
                            child: Column(
                              children: [
                                widget.message["forwarded"] == true
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
                            top:  widget.message["forwarded"] == true
                                ? 20 : 8,
                            bottom: 13,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              widget.msg,
                              // Use ellipsis to handle text that can't fit
                              style: GoogleFonts.roboto(
                                textStyle: TextStyle(
                                  fontSize: 15,
                                  color: blackColor,
                                  fontWeight: FontWeight.normal,
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

                                widget.message['starred'] == true  ?
                                Icon(Icons.star,color: Colors.grey.shade800, size: 15,)  : SizedBox(),

                                Padding(
                                  padding: const EdgeInsets.only(right: 10, left: 2, top: 10),
                                  child: Text(
                                    widget.time,
                                    style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                        fontSize: 8,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey.shade800,
                                      ),
                                    ),
                                  ),
                                ),

                              ],
                            ),
                          ),
                        ),
                      ],
                    ) :
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.message['senderName'],
                          textAlign: TextAlign.left,
                          style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                              fontSize: 12,
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                          widget.msg,
                          textAlign: TextAlign.justify,
                          style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                              fontSize: 15,
                              color: blackColor,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  widget.message["reactions"].isEmpty ? const SizedBox() :

                  Wrap(
                    alignment: WrapAlignment.start,
                    crossAxisAlignment: WrapCrossAlignment.start,
                    children: List<Widget>.generate(widget.message["reactions"].length, (index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 4.0, top: 2.0), // Adjust spacing as needed
                        child: Image.asset(
                          "images/${widget.message["reactions"][index]["emotion"]}.gif",
                          width: 20,
                          height: 20,
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ],
        ),
      );



  }
}

// expires