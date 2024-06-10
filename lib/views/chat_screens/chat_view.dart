import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:property_app/app_constants/color_constants.dart';

import '../../custom_widgets/custom_button.dart';
import '../../utils/shared_preferences/preferences.dart';
import 'chat_conversion_screen.dart';


class ChatView extends StatefulWidget {
  final String userImg;
  final bool searchBox;

  const ChatView({super.key, required this.userImg, required this.searchBox});

  @override
  _ChatViewState createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {

  int userId = 0;

  getUserId() async {
    var id = await Preferences.getUserID();
    setState(() {
      userId = id;
    });
  }

  late Stream<QuerySnapshot> stream;
  final TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    stream = Stream.empty();
    getUserIdAndSetupStream();

    print("my user id ${userId}");
  }

  Future<void> getUserIdAndSetupStream() async {
    userId = await Preferences.getUserID();
      stream = FirebaseFirestore.instance
          .collection('conversationListing')
          .where('user', arrayContains: userId.toString())
          .orderBy('lastMessage.time', descending: true)
          .snapshots();

      // Trigger a rebuild after stream is initialized
      setState(() {});
  }

  // void setupStream()async {
  //   userId = await Preferences.getUserID();
  //   stream =  FirebaseFirestore.instance
  //       .collection('conversationListing')
  //       .where('user', arrayContains: userId.toString())
  //       .orderBy('lastMessage.time', descending: true)
  //       .snapshots();
  // }

  @override
  Widget build(BuildContext context) {

    return  Scaffold(
      backgroundColor: whiteColor,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          color: whiteColor,
          // image: DecorationImage(
          //   image: AssetImage(
          //     'assets/images/backgrounddambo1.png',
          //   ),
          //   fit: BoxFit.contain,
          //   opacity: 0. 03,
          // ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              widget.searchBox
                  ? Container(
                padding: EdgeInsets.all(18.0),
                child: TextFormField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Search...',

                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(color: Colors.grey),

                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                    });
                  },
                ),
              )
                  : SizedBox(),
              // Padding(
              //   padding: EdgeInsets.only(left: 12.w, bottom: 20.h),
              //   child: Text(
              //     'RECENT CHATS',
              //     style: GoogleFonts.poppins(
              //       textStyle: TextStyle(
              //           fontSize: 12.sp,
              //           fontWeight: FontWeight.bold,
              //           letterSpacing: 0.5),
              //     ),
              //   ),
              // ),
              SizedBox(
                height: 10,
              ),
              StreamBuilder<QuerySnapshot>(
                stream: stream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: SizedBox(
                        height: 50.0,
                        width: 50.0,
                        child: CircularProgressIndicator(
                          color: primaryColor,
                        ),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    print(snapshot.error);
                    return Text('Error: ${snapshot.error}');
                  } else {
                    List<DocumentSnapshot> documents = snapshot.data!.docs;
                    documents.sort((a, b) {
                      Timestamp timestampA = a['lastMessage']['time'] ?? a['created'];
                      Timestamp timestampB = b['lastMessage']['time'] ?? b['created'];
                      return timestampB.compareTo(timestampA);
                    });

                    if (searchQuery.isNotEmpty) {
                      documents = documents.where((doc) {
                        var participants = doc['members'];
                        String otherParticipantName = '';
                        for (var participant in participants) {
                          if (participant['userId'].toString() != userId.toString()) {
                            otherParticipantName = participant['userName'];
                            break;
                          }
                        }
                        return otherParticipantName.toLowerCase().contains(searchQuery.toLowerCase());
                      }).toList();
                    }

                    if (documents.isEmpty) {
                      return const Center(child: Text("No chats available"));
                    } else {
                      return Padding(
                        padding: const EdgeInsets.only(
                            left: 18, right: 25, bottom: 10),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: documents.length,
                          itemBuilder: (context, index) {
                            bool group = documents[index]['group'];
                            String profilePictureUrl = '';
                            var participants = documents[index]['members'];
                            String otherParticipantName = '';
                            for (var participant in participants) {
                              if (participant['userId'].toString() != userId.toString()) {
                                otherParticipantName = participant['userName'];
                                profilePictureUrl = participant['profilePictureUrl'];
                                break;
                              }
                            }
                            if (otherParticipantName.isEmpty) {
                              otherParticipantName = 'YOU';
                              profilePictureUrl = participants[0]['profilePictureUrl'];
                            }

                            var lastMessage = documents[index]['lastMessage'];
                            var createdTime = documents[index]['created'];
                            String id = documents[index].id;

                            return lastMessage['time'] == null && lastMessage['message'] == "" ? Container () :
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                splashColor: primaryColor.withOpacity(0.5),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>[
                                          CircleAvatar(
                                            radius: 25,
                                            backgroundColor: primaryColor,
                                            child: CircleAvatar(
                                              radius: 24,
                                              backgroundColor: whiteColor,
                                              child: CachedNetworkImage(imageUrl: profilePictureUrl,
                                              errorWidget: (e, r, f){
                                               return CircleAvatar(
                                                  child: Text(otherParticipantName[0].toUpperCase()), // Display the first letter of the name
                                                );
                                              },
                                              ),
                                             // backgroundImage: CachedNetworkImageProvider(profilePictureUrl),
                                            ),
                                          ),
                                          Flexible(
                                            child: Container(
                                              padding: EdgeInsets.only(left: 12),
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  lastMessage['seen']
                                                      ? Text(
                                                    toBeginningOfSentenceCase(otherParticipantName.toString())! ,
                                                    style: GoogleFonts.roboto(
                                                      textStyle: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                        FontWeight.bold,
                                                      ),
                                                    ),
                                                  )
                                                      : FutureBuilder<String>(
                                                      future: unReadMessages(id),
                                                      builder:
                                                          (context, snapshot) {
                                                        if (snapshot
                                                            .connectionState ==
                                                            ConnectionState
                                                                .waiting) {
                                                          return const CircularProgressIndicator(
                                                            color: whiteColor,
                                                          );
                                                        } else if (snapshot
                                                            .hasError) {
                                                          return Text(
                                                              'Error: ${snapshot.error}');
                                                        } else {
                                                          String unreadCount =
                                                          snapshot.data!;
                                                          return Row(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                            children: <Widget>[
                                                              Text(
                                                               toBeginningOfSentenceCase(otherParticipantName)! ,
                                                                style: GoogleFonts
                                                                    .roboto(
                                                                  textStyle:
                                                                  TextStyle(
                                                                    fontSize:
                                                                    14,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                  ),
                                                                ),
                                                              ),
                                                              unreadCount == "0"
                                                                  ? Container()
                                                                  : Padding(
                                                                padding: EdgeInsets.only(
                                                                    right: 15),
                                                                child:
                                                                Material(
                                                                  elevation:
                                                                  2.0,
                                                                  borderRadius:
                                                                  BorderRadius.circular(
                                                                      16),
                                                                  child:
                                                                  Container(
                                                                    width:
                                                                    16,
                                                                    height:
                                                                    16,
                                                                    decoration:
                                                                    BoxDecoration(
                                                                      color:
                                                                      primaryColor,
                                                                      borderRadius:
                                                                      BorderRadius.circular(8),
                                                                    ),
                                                                    child:
                                                                    Center(
                                                                      child:
                                                                      Text(
                                                                        unreadCount.toString(),
                                                                        style:
                                                                        GoogleFonts.poppins(
                                                                          textStyle: TextStyle(
                                                                            fontSize: 8,
                                                                            color: whiteColor,
                                                                            fontWeight: FontWeight.bold,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          );
                                                        }
                                                      }),
                                                  lastMessage['seen']
                                                      ? Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                    children: <Widget>[
                                                      Expanded(
                                                        child: Text(
                                                          lastMessage['time'] ==
                                                              null
                                                              ? group ? lastMessage['message'] :  "No previous messages"
                                                              : lastMessage[
                                                          'message'],
                                                          style: GoogleFonts
                                                              .roboto(
                                                            textStyle:
                                                            TextStyle(
                                                              fontSize: 12,
                                                              color: blackColor,
                                                            ),
                                                          ),
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                      Text(
                                                        lastMessage['time'] !=
                                                            null
                                                            ? formatTime(
                                                            lastMessage[
                                                            'time']
                                                                .toDate())
                                                            : formatTime(
                                                            createdTime
                                                                .toDate()),
                                                        style:
                                                        GoogleFonts.poppins(
                                                          textStyle: TextStyle(
                                                            fontSize: 10,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  )
                                                      : FutureBuilder(
                                                    future: unReadMessages(id),
                                                    builder:
                                                        (context, snapshot) {
                                                      if (snapshot
                                                          .connectionState ==
                                                          ConnectionState
                                                              .waiting) {
                                                        return const CircularProgressIndicator(
                                                          color: whiteColor,
                                                        );
                                                      } else if (snapshot
                                                          .hasError) {
                                                        return Text(
                                                            'Error: ${snapshot.error}');
                                                      } else {
                                                        String unreadCount =
                                                        snapshot.data!;
                                                        return Padding(
                                                          padding:
                                                          EdgeInsets.only(
                                                              top: 5),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                            children: <Widget>[
                                                              Expanded(
                                                                child: Text(
                                                                  lastMessage['time'] ==
                                                                      null
                                                                      ? "No previous messages"
                                                                      : lastMessage[
                                                                  'message'],
                                                                  style:
                                                                  GoogleFonts
                                                                      .roboto(
                                                                    textStyle: TextStyle(
                                                                        fontSize: 12,
                                                                        color:
                                                                        greyColor,
                                                                        fontWeight: unreadCount ==
                                                                            "0"
                                                                            ? FontWeight.normal
                                                                            : FontWeight.bold),
                                                                  ),
                                                                  maxLines: 1,
                                                                  overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                                ),
                                                              ),
                                                              Text(
                                                                lastMessage['time'] !=
                                                                    null
                                                                    ? formatTime(
                                                                    lastMessage['time']
                                                                        .toDate())
                                                                    : formatTime(
                                                                    createdTime
                                                                        .toDate()),
                                                                style:
                                                                GoogleFonts
                                                                    .poppins(
                                                                  textStyle:
                                                                  TextStyle(
                                                                    color: unreadCount ==
                                                                        "0"
                                                                        ? blackColor
                                                                        : redColor,
                                                                    fontWeight: unreadCount == "0"
                                                                        ? FontWeight
                                                                        .normal
                                                                        : FontWeight
                                                                        .bold,
                                                                    fontSize:
                                                                    10,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      }
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 14,),
                                    ],
                                  ),
                                ),
                                onTap: () async {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ChatScreen1(
                                        group: group,
                                        data: documents[index],
                                        name: otherParticipantName,
                                        image: profilePictureUrl,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      );
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String> unReadMessages(String id) async {
    int unreadCount = 0;
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('messagesListing')
          .doc(userId.toString())
          .collection("messages")
          .where('conversationId', isEqualTo: id)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        for (QueryDocumentSnapshot messageSnapshot in querySnapshot.docs) {
          if (messageSnapshot.get('senderId').toString() != userId.toString()) {
            if (messageSnapshot.get('read') != true) {
              unreadCount++;
            }
          }
        }
      }
    } catch (e) {
      print('Error fetching unread messages: $e');
    }

    return unreadCount.toString();
  }
}
