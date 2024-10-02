import 'dart:async'; // For debounce functionality

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:property_app/constant_widget/constant_widgets.dart';
import 'package:property_app/services/chat_sevice/chat_service.dart';
import 'package:property_app/utils/utils.dart';

import '../../app_constants/color_constants.dart';
import '../../utils/shared_preferences/preferences.dart';
import 'chat_conversion_screen.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  ChatServices chatServices = ChatServices();
  final TextEditingController searchController = TextEditingController();
  List<dynamic> searchResults = [];
  bool isLoading = false;
  Timer? _debounce;

  // Function to trigger the API call based on the search query
  void performSearch(String query) async {
    if (query.isNotEmpty) {
      setState(() {
        isLoading = true;
      });

      // Debugging statements
      print("Performing search for: $query");

      final response = await chatServices.searchUser(query);

      // Debugging the response
      print("Search Response: $response");

      if (response['status'] == true) {
        setState(() {
          searchResults = response['data'];
          isLoading = false;
        });
      } else {
        setState(() {
          searchResults = [];
          isLoading = false;
        });
        AppUtils.errorSnackBar('Error', response['message']);
      }
    } else {
      // If the search query is empty, clear the search results
      setState(() {
        searchResults = [];
      });
    }
  }

  // Debounce logic to prevent excessive API calls on each keystroke
  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      performSearch(query);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: whiteColor,
        appBar: AppBar(
            backgroundColor: whiteColor,
            title: customText(
                text: "Contacts", fontSize: 24, fontWeight: FontWeight.w500)),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
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
                onChanged: _onSearchChanged, // Triggers real-time search
              ),
            ),
            isLoading
                ? Center(child: CircularProgressIndicator())
                : searchResults.isEmpty
                    ? Center(child: Text('No users found'))
                    : Expanded(
                        child: ListView.builder(
                          itemCount: searchResults.length,
                          itemBuilder: (context, index) {
                            final user = searchResults[index];
                            return ListTile(
                              title: Text(user['fullname']),
                              subtitle: Text(user['email']),
                              onTap: () {
                                createConversation(
                                    user['fullname'],
                                    user['profileimage'],
                                    user['id'].toString(),
                                    context);
                              },
                            );
                          },
                        ),
                      ),
          ],
        ));
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
