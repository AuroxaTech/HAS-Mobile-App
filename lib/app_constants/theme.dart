import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_app/app_constants/color_constants.dart';

class AppTheme {
  static final ThemeData theme = ThemeData(
      scaffoldBackgroundColor: const Color(0xffedf1f1),
      primaryColor: primaryColor,
      buttonTheme: const ButtonThemeData(buttonColor: Colors.black87),
      splashColor: const Color(0x3d0e8d8d),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.green[400]),
            textStyle: MaterialStateProperty.resolveWith((states) {
              if (states.contains(MaterialState.pressed)) {
                return const TextStyle(fontSize: 22);
              }

              return const TextStyle(fontSize: 16);
            }),
            padding: MaterialStateProperty.resolveWith((states) {
              if (states.contains(MaterialState.pressed)) {
                return const EdgeInsets.all(24);
              }
              return const EdgeInsets.all(16);
            }),
            visualDensity: VisualDensity.adaptivePlatformDensity,
          )),
      appBarTheme: const AppBarTheme(
          toolbarHeight: 70,
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 1.0,
          titleTextStyle: TextStyle(
              fontSize: 15,
              color: Colors.black87,
              wordSpacing: 1.1,
              letterSpacing: 0.9),
          toolbarTextStyle: TextStyle(
              fontSize: 14,
              color: Colors.black87,
              fontWeight: FontWeight.bold),
          iconTheme: IconThemeData(color: Colors.black87, size: 26)),
      iconTheme: const IconThemeData(
          color: Colors.black,
          size: 22,
          shadows: [BoxShadow(blurRadius: 10.0, offset: Offset.infinite)]),
      textTheme: TextTheme(
          titleLarge: GoogleFonts.robotoCondensed(
              color: blackColor,
              fontWeight: FontWeight.w300,
              fontSize: 15,
              fontStyle: FontStyle.normal),
          headlineSmall: GoogleFonts.robotoCondensed(
              color: Colors.black87,
              fontSize:14,
              fontStyle: FontStyle.normal),
          headlineMedium: GoogleFonts.robotoCondensed(
              color: Colors.teal, fontSize: 16, fontStyle: FontStyle.normal),
          displaySmall: GoogleFonts.robotoCondensed(
              color: Colors.black87,
              fontSize:14,
              fontStyle: FontStyle.normal),
          bodyLarge: GoogleFonts.robotoCondensed(
              color: Colors.black87,
              fontSize: 14,
              fontWeight: FontWeight.w300),
          bodyMedium: GoogleFonts.robotoCondensed(
              color: blackColor,
              fontSize: 13,
              fontWeight: FontWeight.w300)),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          elevation: 1.0,
          showSelectedLabels: true,
          type: BottomNavigationBarType.shifting,
          selectedIconTheme: IconThemeData(
              color: Colors.teal,
              size: 30,
              shadows: [BoxShadow(blurStyle: BlurStyle.outer)]),
          selectedLabelStyle: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w700,
            fontSize: 12,
            letterSpacing: 0.6,
          ),
          showUnselectedLabels: false,
          unselectedIconTheme: IconThemeData(color: Colors.blueGrey),
          unselectedItemColor: Colors.grey,
          selectedItemColor: Colors.teal));
}