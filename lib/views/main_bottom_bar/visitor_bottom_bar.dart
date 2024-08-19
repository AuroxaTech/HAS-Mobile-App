import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_app/app_constants/app_icon.dart';
import 'package:property_app/views/chat_screens/chat_screen_list.dart';
import 'package:property_app/views/dashoard_screens/all_property_screen.dart';
import 'package:property_app/views/service_provider/service_listing_screen.dart';
import 'package:property_app/views/tenant_profile/tenent_dashboard.dart';
import '../../app_constants/color_constants.dart';
import '../../services/notification_services/notification_services.dart';
import '../../utils/shared_preferences/preferences.dart';
import '../chat_screens/HomeScreen.dart';
import '../dashoard_screens/property_tabs.dart';
import '../land_lords/job_screeen.dart';
import '../visitor/visitor_dashboard.dart';
class VisitorBottomBar extends StatefulWidget {
  const VisitorBottomBar({Key? key}) : super(key: key);

  @override
  State<VisitorBottomBar> createState() => _VisitorBottomBarState();
}

class _VisitorBottomBarState extends State<VisitorBottomBar> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();
  bool isLoading = false;
  // @override
  // void initState() {
  //   /*for(int i = 0; i < 120; i++ ){
  //     print("D:/work/WES/QR codes/$i.png");
  //   }*/
  //   super.initState();
  // }

  NotificationServices notificationServices = NotificationServices();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notificationServices.requestNotificationPermission();
    notificationServices.forgroundMessage();
    notificationServices.firebaseInit(context);
    notificationServices.setupInteractMessage(context);
    // notificationServices.isTokenRefresh();

    // notificationServices.getDeviceToken().then((value){
    //   if (kDebugMode) {
    //     print('device token');
    //     print(value);
    //   }
    // });
  }



  List<Widget> widgetList = [
    const PropertyTabsScreen(),
    const ChatListing(),
    ServicesListingScreen(),
     JobsScreen(isBack: false,),
    const VisitorDashBoard(),
    // const Center(child: Text("People Settings")),
    // const Center(child: Text("Wallet")),
  ];
  final AppState _appState = AppState();
  _updateUserStatus(bool isOnline) async{
    var userId = await Preferences.getUserID();
    if (userId != null) {
      FirebaseFirestore.instance.collection('users').doc(userId.toString()).update({
        'online': isOnline,
        'lastSeen': FieldValue.serverTimestamp(),
      });
      print(isOnline);
    }
  }

  void dialog(){
    showDialog(context: context,
        builder: (context){
          return AlertDialog(
            surfaceTintColor: Colors.white,
            backgroundColor: Colors.white,
            title: const Text("Exit App"),
            content: const Text("Are you sure you want to exit the app?"),
            actions: [

              MaterialButton(onPressed: (){
                Navigator.pop(context);
              },
                color: Colors.red,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)
                ),
                child:  const Text("No", style: TextStyle(
                    color: Colors.white
                ),),
              ),

              MaterialButton(onPressed: ()async{
                await _updateUserStatus(false);
                SystemChannels.platform.invokeMethod('SystemNavigator.pop');
              },
                color: greenColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)
                ),
                child:  const Text("Yes", style: TextStyle(
                    color: Colors.white
                ),),
              ),




            ],
          );
        });
  }

  @override

  Widget build(BuildContext context) {
    WidgetsBinding.instance.addObserver(_appState);
    return PopScope(
        canPop: false,
        onPopInvoked: (val){
          dialog();
        },
      child: Scaffold(
        backgroundColor: whiteColor,
        body: widgetList[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          backgroundColor: whiteColor,
          type: BottomNavigationBarType.fixed,
          onTap: _onTappedBar,
          unselectedItemColor: greyColor,
          selectedLabelStyle:
          GoogleFonts.poppins(color: primaryColor, fontSize: 12, fontWeight: FontWeight.w500),
          unselectedLabelStyle:
          GoogleFonts.poppins(color: inactiveBottomColor),
          selectedItemColor: primaryColor,
          showSelectedLabels: true,
          elevation: 5,
          enableFeedback: false,
          items: [
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: SvgPicture.asset(
                  _selectedIndex == 0 ? AppIcons.homePrimary  : AppIcons.home ,
                  // height: _selectedIndex == 0 ? 25 : 18,
                  // width: 25,
                  color: _selectedIndex == 0
                      ? primaryColor
                      : greyColor,
                ),
              ),
              label: 'Home',
            ),

            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: SvgPicture.asset(
                  _selectedIndex == 1 ? AppIcons.chat  : AppIcons.chat ,
                  // height: _selectedIndex == 1 ? 25 : 18,
                  // width: 25,
                  color: _selectedIndex == 1
                      ? primaryColor
                      : greyColor,
                ),
              ),
              label: 'Chat',
            ),

            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: SvgPicture.asset(
                  _selectedIndex == 2 ? AppIcons.people  : AppIcons.people ,
                  // height: _selectedIndex == 1 ? 25 : 18,
                  // width: 25,
                  color: _selectedIndex == 2
                      ? primaryColor
                      : greyColor,
                ),
              ),
              label: 'Services',
            ),

            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: SvgPicture.asset(
                  _selectedIndex == 3 ? AppIcons.edit  : AppIcons.edit ,
                  // height: _selectedIndex == 2 ? 25 : 18,
                  // width: 25,
                  color: _selectedIndex == 3
                      ? primaryColor
                      : greyColor,
                ),
              ),
              label: 'Edit',
            ),

            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Image.asset(
                  _selectedIndex == 4 ? AppIcons.personSett  : AppIcons.personSett ,
                  // height: _selectedIndex == 1 ? 25 : 18,
                  // width: 25,
                  color: _selectedIndex == 4
                      ? primaryColor
                      : greyColor,
                ),
              ),
              label: 'Profile',
            ),
            // BottomNavigationBarItem(
            //   icon: Padding(
            //     padding: const EdgeInsets.only(bottom: 5),
            //     child: SvgPicture.asset(
            //       _selectedIndex == 5 ? AppIcons.wallet  : AppIcons.wallet ,
            //       // height: _selectedIndex == 3 ? 25 : 18,
            //       // width: 25,
            //       color: _selectedIndex == 5
            //           ? primaryColor
            //           : greyColor,
            //     ),
            //   ),
            //   label: 'Wallet',
            // ),
          ],
        ),
      ),
    );
  }

  void _onTappedBar(int value) {
    setState(() {
      _selectedIndex = value;
    });
  }

}
