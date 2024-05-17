import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_app/app_constants/app_icon.dart';
import 'package:property_app/views/chat_screens/chat_screen_list.dart';
import 'package:property_app/views/dashoard_screens/all_property_screen.dart';
import 'package:property_app/views/dashoard_screens/congrate_screen.dart';
import 'package:property_app/views/dashoard_screens/dashboard_screen.dart';
import 'package:property_app/views/service_provider/service_listing_screen.dart';
import 'package:property_app/views/service_provider/services_provider_screen.dart';
import 'package:property_app/views/tenant_profile/tenent_dashboard.dart';

import '../../app_constants/color_constants.dart';
import '../../services/notification_services/notification_services.dart';
import '../land_lords/job_screeen.dart';
class TenantBottomBar extends StatefulWidget {
  const TenantBottomBar({Key? key}) : super(key: key);

  @override
  State<TenantBottomBar> createState() => _TenantBottomBarState();
}

class _TenantBottomBarState extends State<TenantBottomBar> {
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
    AllPropertyScreen(),
    const ChatScreenList(),
    ServicesListingScreen(),
     JobsScreen(),
    const TenantDashboard(),
    // const Center(child: Text("People Settings")),
    // const Center(child: Text("Wallet")),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            label: 'People',
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
    );
  }

  void _onTappedBar(int value) {
    setState(() {
      _selectedIndex = value;
    });
  }

}
