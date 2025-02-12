import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:property_app/app_constants/app_icon.dart';
import 'package:property_app/app_constants/color_constants.dart';
import 'package:property_app/custom_widgets/custom_button.dart';

import '../app_constants/app_sizes.dart';
import '../route_management/constant_routes.dart';

Widget customText(
    {String? text,
    TextStyle? style,
    Color? color,
    double? fontSize,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    TextDecoration? txtDecoration,
    TextOverflow? overFlow,
    TextAlign? textAlign,
    Color? decorationColor,
    double? letterSpacing,
    TextDirection? textDirection,
    int? maxLines}) {
  return Text(
    text ?? "",
    textAlign: textAlign,
    textDirection: textDirection,
    maxLines: maxLines,
    style: GoogleFonts.poppins(
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      decoration: txtDecoration,
      decorationColor: decorationColor,
      decorationThickness: 2.0,
      letterSpacing: letterSpacing,
    ),
  );
}

Map<String, String> getHeader({required String userToken}) {
  return {
    "Content-Type": "application/json",
    "Authorization": "Bearer $userToken",
  };
}

Widget headingText(
    {String? text,
    TextStyle? style,
    Color? color,
    double? fontSize,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    TextDecoration? txtDecoration,
    TextOverflow? overFlow,
    TextAlign? textAlign,
    Color? decorationColor,
    double? letterSpacing,
    TextDirection? textDirection,
    int? maxLines}) {
  return Text(
    text!,
    textAlign: textAlign,
    textDirection: textDirection,
    maxLines: maxLines,
    style: GoogleFonts.poppins(
      color: color ?? blackColor,
      fontSize: fontSize,
      fontWeight: FontWeight.w500,
      fontStyle: fontStyle,
      decoration: txtDecoration,
      decorationColor: decorationColor,
      decorationThickness: 2.0,
      letterSpacing: letterSpacing,
    ),
  );
}

LinearGradient gradient() {
  return const LinearGradient(
    begin: FractionalOffset(0.0, 0.0),
    end: FractionalOffset(1.0, 0.0),
    colors: [
      secondaryColor,
      primaryColor,
    ],
  );
}

LinearGradient greenGradient() {
  return const LinearGradient(
    begin: FractionalOffset(0.0, 0.0),
    end: FractionalOffset(1.0, 0.0),
    colors: [
      greenColor,
      greenColor,
    ],
  );
}

LinearGradient yellowGradient() {
  return const LinearGradient(
    begin: FractionalOffset(0.0, 0.0),
    end: FractionalOffset(1.0, 0.0),
    colors: [
      starColor,
      starColor,
    ],
  );
}

LinearGradient redGradient({Color? color}) {
  return LinearGradient(
    begin: const FractionalOffset(0.0, 0.0),
    end: const FractionalOffset(1.0, 0.0),
    colors: [
      color ?? redColor,
      color ?? redColor,
    ],
  );
}

LinearGradient whiteGradient() {
  return const LinearGradient(
    begin: FractionalOffset(0.0, 0.0),
    end: FractionalOffset(1.0, 0.0),
    colors: [
      whiteColor,
      whiteColor,
    ],
  );
}

LinearGradient acceptGradient({Color? color}) {
  return LinearGradient(
    begin: const FractionalOffset(0.0, 0.0),
    end: const FractionalOffset(1.0, 0.0),
    colors: [
      color ?? const Color(0xff14C034),
      color ?? const Color(0xff14C034),
    ],
  );
}

LinearGradient detailGradient() {
  return const LinearGradient(
    begin: FractionalOffset(0.0, 0.0),
    end: FractionalOffset(1.0, 0.0),
    colors: [
      Color(0xff595B5E),
      Color(0xff595B5E),
    ],
  );
}

LinearGradient defaultGradient() {
  return const LinearGradient(
    begin: FractionalOffset(0.0, 0.0),
    end: FractionalOffset(1.0, 0.0),
    colors: [
      bluishWhite,
      bluishWhite,
    ],
  );
}

OutlineInputBorder shapeBorder = OutlineInputBorder(
  borderSide: BorderSide(
    color: Colors.grey.shade100,
  ),
  borderRadius: BorderRadius.circular(15),
);

PreferredSizeWidget backAppBar(
    {String? text, bool? isTitle = false, Widget? leading}) {
  return AppBar(
    elevation: 0.0,
    backgroundColor: whiteColor,
    leading: leading,
    automaticallyImplyLeading: true,
    title: isTitle == true
        ? customText(
            text: text,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          )
        : const SizedBox(),
    centerTitle: false,
  );
}

PreferredSizeWidget titleAppBar(String text,
    {List<Widget>? action, PreferredSizeWidget? bottom}) {
  return AppBar(
    elevation: 0.0,
    backgroundColor: whiteColor,
    automaticallyImplyLeading: true,
    title: headingText(text: text, fontSize: 24),
    centerTitle: false,
    actions: action,
    bottom: bottom,
  );
}

PreferredSizeWidget homeAppBar(context,
    {String? text,
    PreferredSizeWidget? bottom,
    bool? showNotification = false,
    VoidCallback? menuOnTap,
    bool? isBack = false,
    bool? isMenu = false,
    VoidCallback? backTap,
    bool? back = true}) {
  return AppBar(
    elevation: 0.0,
    automaticallyImplyLeading: false,
    backgroundColor: whiteColor,
    leading: back == true
        ? Builder(builder: (context) {
            return IconButton(
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 18,
                  color: backIconColor,
                ),
                onPressed: () {
                  isBack == false ? Navigator.pop(context) : null;
                  //Scaffold.of(context).openDrawer(),
                });
          })
        : null,
    title: headingText(text: text ?? "Landlord profile", fontSize: 20),
    centerTitle: false,
    actions: [
      showNotification!
          ? GestureDetector(
              onTap: () {
                Get.toNamed(kNotificationScreen);
              },
              child: Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: borderColor)),
                padding: const EdgeInsets.all(12),
                child: SvgPicture.asset(AppIcons.notification),
              ),
            )
          : const SizedBox(),
      const SizedBox(
        width: 5,
      ),
      // Container(
      //   decoration: BoxDecoration(
      //       shape: BoxShape.circle,
      //       border: Border.all(color: borderColor)
      //   ),
      //   padding: const EdgeInsets.all(4.3),
      //   child: SvgPicture.asset(AppIcons.cartPerson),
      // ),
      // const SizedBox(
      //   width: 5,
      // ),
      isMenu == true
          ? InkWell(
              onTap: menuOnTap,
              child: Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: borderColor)),
                padding: const EdgeInsets.all(12),
                child: SvgPicture.asset(AppIcons.menu),
              ),
            )
          : const SizedBox.shrink(),
      const SizedBox(
        width: 8,
      ),

      // IconButton(onPressed:(){
      //
      // }, icon: Icon(Icons.add, color: primaryColor,))
    ],
    bottom: bottom,
  );
}

PreferredSizeWidget backWithSkip() {
  return AppBar(
    backgroundColor: Colors.transparent,
    automaticallyImplyLeading: true,
    actions: [
      TextButton(
          onPressed: () {
            Get.back();
          },
          child: customText(
              text: "Skip", fontWeight: FontWeight.w500, fontSize: 18))
    ],
  );
}

PreferredSizeWidget notificationAppbar(context,
    {String? text,
    PreferredSizeWidget? bottom,
    bool? showNotification = false}) {
  return AppBar(
    elevation: 0.0,
    automaticallyImplyLeading: false,
    backgroundColor: whiteColor,
    leading: Builder(builder: (context) {
      return IconButton(
          tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 18,
            color: backIconColor,
          ),
          onPressed: () {
            Navigator.pop(context);
            //Scaffold.of(context).openDrawer(),
          });
    }),
    title: headingText(text: text, fontSize: 20),
    centerTitle: false,
    actions: [
      Container(
        decoration: BoxDecoration(
            shape: BoxShape.circle, border: Border.all(color: borderColor)),
        padding: const EdgeInsets.all(8),
        child: Center(child: Image.asset(AppIcons.delete)),
      ),
      const SizedBox(
        width: 8,
      ),

      // IconButton(onPressed:(){
      //
      // }, icon: Icon(Icons.add, color: primaryColor,))
    ],
    bottom: bottom,
  );
}

Widget imageButton(
    {Color? imageColor,
    Color? textColor,
    Color? borderColor,
    double? width,
    String? image,
    String? text,
    bool? isLoading = false,
    VoidCallback? onTap,
    EdgeInsets? padding}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: width ?? double.infinity,
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: borderColor ?? Colors.grey.shade100),
          borderRadius: BorderRadius.circular(8)),
      padding: padding ?? const EdgeInsets.only(top: 12, bottom: 12),
      child: isLoading!
          ? const Center(child: CircularProgressIndicator())
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  image!,
                  color: imageColor,
                ),
                w15,
                customText(text: text, fontSize: 18, color: textColor),
              ],
            ),
    ),
  );
}

Widget uploadImageContainer(
    {VoidCallback? onTap, String? text, IconData? icon}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 1.0,
          ),
        ],
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Container(
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 1.0,
                ),
              ],
            ),
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(AppIcons.upload),
                h10,
                customText(
                    text: text ?? "Upload\nImages",
                    fontSize: 15,
                    color: blackColor),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

Widget roundedSmallButton({
  required String text,
  required bool isSelected,
  VoidCallback? onTap,
  String? subTitle,
  bool? isSecondText = false,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      decoration: BoxDecoration(
        gradient: isSelected ? gradient() : defaultGradient(),
        borderRadius: BorderRadius.circular(45),
      ),
      padding: const EdgeInsets.only(
        top: 5,
        bottom: 5,
        right: 15,
        left: 15,
      ),
      child: Center(
        child: Row(
          children: [
            customText(
              text: text,
              fontWeight: FontWeight.w300,
              fontSize: 20,
              color: isSelected ? whiteColor : blackColor,
            ),
            isSecondText! ? w2 : const SizedBox(),
            isSecondText
                ? Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 1),
                      child: customText(
                        text: subTitle ?? "",
                        fontWeight: FontWeight.w300,
                        fontSize: 15,
                        color: isSelected ? whiteColor : blackColor,
                      ),
                    ),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    ),
  );
}

Widget fileImage({String? image, VoidCallback? onTap}) {
  return Container(
    padding: const EdgeInsets.only(right: 10),
    child: Stack(
      children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(15),
              image: DecorationImage(
                image: FileImage(File(image!)),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Positioned(
          right: 0.0001,
          child: GestureDetector(
              onTap: onTap,
              child: Container(
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Colors.white),
                  child: Center(
                      child: SvgPicture.asset(
                    AppIcons.close,
                    height: 20,
                    width: 20,
                  )))),
        ),
      ],
    ),
  );
}

Widget networkImage({String? image, VoidCallback? onTap}) {
  return Container(
    padding: const EdgeInsets.only(right: 10),
    child: Stack(
      children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(15),
              image: DecorationImage(
                image: CachedNetworkImageProvider(image!),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Positioned(
          right: 0.0001,
          child: GestureDetector(
              onTap: onTap,
              child: Container(
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Colors.white),
                  child: Center(
                      child: SvgPicture.asset(
                    AppIcons.close,
                    height: 20,
                    width: 20,
                  )))),
        ),
      ],
    ),
  );
}

Widget dashboardSmallContainer(context,
    {String? title, String? subTitle, String? thirdTitle}) {
  return Container(
    width: screenWidth(context) * 0.2,
    decoration: BoxDecoration(
      color: whiteColor,
      borderRadius: BorderRadius.circular(12),
    ),
    padding: const EdgeInsets.all(10),
    child: Column(
      children: [
        customText(text: title, fontSize: 16, color: purpleTextColor),
        customText(text: subTitle, fontSize: 10, color: blackColor),
        customText(text: thirdTitle, fontSize: 10, color: blackColor),
      ],
    ),
  );
}

Widget labelText(text) {
  return customText(
      text: text, fontSize: 16, fontWeight: FontWeight.w500, color: blackColor);
}

Widget dashboardContainer({
  required String title,
  required IconData icon,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      height: 140,
      width: 140,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FaIcon(
            icon,
            size: 32, // Slightly smaller size for FA icons
            color: primaryColor,
          ),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget rowMainAxis({children}) {
  return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween, children: children);
}

Widget myPropertyWidget(context,
    {required VoidCallback onTap,
    required String title,
    required String image,
    required String price,
    required String description,
    required String bedroom,
    required String bathroom,
    required String marla,
    required String rent,
    Widget? icon,
    int? index}) {
  late ImageProvider imgVariable;
  imgVariable = CachedNetworkImageProvider(image, errorListener: (ee) {
    imgVariable = const AssetImage(AppIcons.appLogo);
  });
  return InkWell(
    onTap: onTap,
    child: Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 1.0,
          ),
        ],
      ),
      child: Column(
        children: [
          // Container(
          //   width: double.infinity,
          //   height: screenHeight(context) *0.23,
          //   decoration:  BoxDecoration(
          //     borderRadius: const BorderRadius.only(
          //       topRight: Radius.circular(25),
          //       topLeft: Radius.circular(25),
          //     ),
          //     image: DecorationImage(
          //       image: image == "" ? const AssetImage(AppIcons.appLogo)
          //           : imgVariable, fit: BoxFit.cover,
          //     ) ),
          //     child:  icon ?? const SizedBox(),
          // ),
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(25),
              topLeft: Radius.circular(25),
            ),
            child: Stack(
              children: [
                CachedNetworkImage(
                  imageUrl: image,
                  width: double.infinity,
                  height: screenHeight(context) * 0.23,
                  fit: BoxFit.cover,
                  errorWidget: (context, d, g) {
                    return index == 0
                        ? Image.asset(
                            AppIcons.p3,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          )
                        : index == 1
                            ? Image.asset(
                                AppIcons.p1,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                AppIcons.p2,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              );
                  },
                ),
                Positioned(
                  child: icon ?? const SizedBox(),
                )
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 10, right: 15, left: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    headingText(
                      text: title,
                      fontSize: 20,
                    ),
                    headingText(
                      text: price,
                      fontSize: 14,
                    ),
                  ],
                ),
                h5,
                customText(
                  text: description,
                  fontSize: 10,
                ),
                h5,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(color: borderColor)),
                          padding: const EdgeInsets.only(
                              top: 5, bottom: 5, right: 10, left: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              customText(text: bedroom, fontSize: 12),
                              w10,
                              SvgPicture.asset(
                                AppIcons.bedroom,
                                width: 13,
                                height: 9,
                                color: primaryColor,
                              ),
                            ],
                          ),
                        ),
                        w10,
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(color: borderColor)),
                          padding: const EdgeInsets.only(
                              top: 5, bottom: 5, right: 10, left: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              customText(text: bathroom, fontSize: 12),
                              w10,
                              SvgPicture.asset(
                                AppIcons.bathroom,
                                width: 13,
                                height: 9,
                                color: primaryColor,
                              ),
                            ],
                          ),
                        ),
                        w10,
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(color: borderColor)),
                          padding: const EdgeInsets.only(
                              top: 5, bottom: 5, right: 10, left: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              customText(text: marla, fontSize: 12),
                              w5,
                              customText(text: "Marla", fontSize: 12),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: greyColor.withOpacity(0.5)),
                      padding: const EdgeInsets.only(
                          top: 5, bottom: 5, right: 15, left: 15),
                      child: Center(
                        child: customText(text: rent, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          h15,
        ],
      ),
    ),
  );
}

Widget myPropertyFav(context,
    {required VoidCallback onTap,
    required String title,
    required String image,
    required String price,
    required String description,
    required String bedroom,
    required String bathroom,
    required String marla,
    required String rent,
    required bool isFavorite,
    required VoidCallback onFavoriteTap}) {
  late ImageProvider imgVariable;
  imgVariable = CachedNetworkImageProvider(image, errorListener: (ee) {
    imgVariable = const AssetImage(AppIcons.appLogo);
  });
  return InkWell(
    onTap: onTap,
    child: Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 1.0,
          ),
        ],
      ),
      child: Column(
        children: [
          // Container(
          //   width: double.infinity,
          //   height: screenHeight(context) *0.23,
          //   decoration:  BoxDecoration(
          //     borderRadius: const BorderRadius.only(
          //       topRight: Radius.circular(25),
          //       topLeft: Radius.circular(25),
          //     ),
          //     image: DecorationImage(
          //       image: image == "" || image == null ? const AssetImage(AppIcons.appLogo) : imgVariable, fit: BoxFit.cover,
          //     ),),
          //   child: Padding(
          //     padding: const EdgeInsets.all(8.0),
          //     child: Align(
          //       alignment: Alignment.topRight,
          //       child: IconButton(
          //         icon: Icon(
          //           isFavorite ? Icons.favorite : Icons.favorite_border,
          //           color: isFavorite ? Colors.red : Colors.grey,
          //         ),
          //         onPressed: onFavoriteTap,
          //       ),
          //     ),
          //   ),
          // ),

          ClipRRect(
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(25),
              topLeft: Radius.circular(25),
            ),
            child: Stack(
              children: [
                CachedNetworkImage(
                  imageUrl: image,
                  width: double.infinity,
                  height: screenHeight(context) * 0.23,
                  fit: BoxFit.cover,
                  errorWidget: (context, d, g) {
                    return Image.asset(AppIcons.appLogo);
                  },
                ),
                Positioned(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.grey,
                      ),
                      onPressed: onFavoriteTap,
                    ),
                  ),
                ))
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 10, right: 15, left: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    headingText(
                      text: title,
                      fontSize: 20,
                    ),
                    headingText(
                      text: price,
                      fontSize: 14,
                    ),
                  ],
                ),
                h5,
                customText(
                  text: description,
                  fontSize: 10,
                ),
                h5,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(color: borderColor)),
                          padding: const EdgeInsets.only(
                              top: 5, bottom: 5, right: 10, left: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              customText(text: bedroom, fontSize: 12),
                              w10,
                              SvgPicture.asset(
                                AppIcons.bedroom,
                                width: 13,
                                height: 9,
                                color: primaryColor,
                              ),
                            ],
                          ),
                        ),
                        w10,
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(color: borderColor)),
                          padding: const EdgeInsets.only(
                              top: 5, bottom: 5, right: 10, left: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              customText(text: bathroom, fontSize: 12),
                              w10,
                              SvgPicture.asset(
                                AppIcons.bathroom,
                                width: 13,
                                height: 9,
                                color: primaryColor,
                              ),
                            ],
                          ),
                        ),
                        w10,
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(color: borderColor)),
                          padding: const EdgeInsets.only(
                              top: 5, bottom: 5, right: 10, left: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              customText(text: marla, fontSize: 12),
                              w5,
                              customText(text: "Marla", fontSize: 12),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: greyColor.withOpacity(0.5)),
                      padding: const EdgeInsets.only(
                          top: 5, bottom: 5, right: 15, left: 15),
                      child: Center(
                        child: customText(text: rent, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          h15,
        ],
      ),
    ),
  );
}

Widget myServicesWidget(context,
    {required VoidCallback onTap,
    required String title,
    required String price,
    required String image,
    required String description,
    required String bedroom,
    required String bathroom,
    required String marla,
    required String rent,
    required String serviceArea,
    required String duration,
    required String pricing,
    VoidCallback? onTapDetail,
    VoidCallback? editTap,
    VoidCallback? deleteTap}) {
  late ImageProvider imgVariable;
  imgVariable = CachedNetworkImageProvider(image, errorListener: (ee) {
    imgVariable = const AssetImage(AppIcons.appLogo);
  });
  print(image);
  return InkWell(
    onTap: onTap,
    child: Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 1.0,
          ),
        ],
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(25),
              topLeft: Radius.circular(25),
            ),
            child: Stack(
              children: [
                CachedNetworkImage(
                  imageUrl: image,
                  width: double.infinity,
                  height: screenHeight(context) * 0.23,
                  fit: BoxFit.cover,
                  errorWidget: (context, d, g) {
                    return Image.asset(AppIcons.appLogo);
                  },
                ),
                Positioned(
                  child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                InkWell(
                                  onTap: editTap,
                                  child: CircleAvatar(
                                    backgroundColor: primaryColor,
                                    child: SvgPicture.asset(
                                      AppIcons.editIcon,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 6,
                                ),
                                CircleAvatar(
                                  backgroundColor: Colors.red,
                                  child: IconButton(
                                      onPressed: deleteTap,
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.white,
                                      )),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(
                            height: 25,
                          ),

                          // Center(
                          //   child: Padding(
                          //     padding: const EdgeInsets.only(left: 15, right: 15),
                          //     child: Row(
                          //       crossAxisAlignment: CrossAxisAlignment.center,
                          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //       children: [
                          //         CircleAvatar(
                          //           backgroundColor : Colors.white,
                          //           child: IconButton(onPressed: (){},
                          //               icon: const Icon(Icons.arrow_back_ios_new_rounded, color: blackColor)),
                          //         ),
                          //         CircleAvatar(
                          //           backgroundColor : Colors.white,
                          //           child: IconButton(onPressed: (){},
                          //               icon: const Icon(Icons.arrow_forward_ios_rounded, color: blackColor,)),
                          //         ),
                          //       ],
                          //     ),
                          //   ),
                          // ),
                        ],
                      ) ??
                      const SizedBox(),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, right: 15, left: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        headingText(
                          text: title,
                          fontSize: 20,
                        ),
                        // Row(
                        //   children: [
                        //     RatingWidget(
                        //       maxRating: 5,
                        //       isRating: true,
                        //       initialRating: 3,
                        //       onRatingChanged: (rating) {
                        //         print('Selected rating: $rating');
                        //       },
                        //     ),
                        //     customText(
                        //       text: " 5 "
                        //     ),
                        //     customText(
                        //         text: "(25)",
                        //       color: greyColor
                        //     )
                        //   ],
                        // ),
                      ],
                    ),
                    Row(
                      children: [
                        // CustomButton(
                        //   text: "Edit",
                        //   onTap: editTap,
                        //   fontSize: 10,
                        //   height: screenHeight(context) * 0.035,
                        //   width: screenWidth(context) * 0.1,
                        // ),
                        // CustomButton(
                        //   text: "Delete",
                        //   onTap: deleteTap,
                        //   fontSize: 10,
                        //   height: screenHeight(context) * 0.035,
                        //   width: screenWidth(context) * 0.1,
                        // ),

                        CustomButton(
                          onTap: onTapDetail,
                          text: "View Detail",
                          fontSize: 12,
                          height: screenHeight(context) * 0.035,
                          width: screenWidth(context) * 0.22,
                        ),
                      ],
                    ),
                  ],
                ),
                h5,
                customText(text: description, fontSize: 15, color: descColor),
                h5,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image.asset(AppIcons.clockDuration),
                        w10,
                        customText(
                            text: "Duration :",
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: greyColor),
                        w10,
                        customText(
                            text: duration, fontSize: 14, color: descColor),
                      ],
                    ),
                    headingText(
                      text: "\$$pricing",
                      fontSize: 16,
                    ),
                  ],
                ),
                h5,
                Row(
                  children: [
                    Image.asset(AppIcons.serviceArea),
                    w10,
                    customText(
                        text: "Service Area :",
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: greyColor),
                    w10,
                    customText(
                        text: serviceArea, fontSize: 14, color: descColor),
                  ],
                ),
              ],
            ),
          ),
          h15,
        ],
      ),
    ),
  );
}

Widget serviceRequestWidget(
  context, {
  VoidCallback? onTap,
  String? title,
  String? clientName,
  String? contactDetail,
  String? description,
  String? postalCode,
  String? location,
  String? status,
  String? requestTime,
  String? requestDate,
  VoidCallback? acceptTap,
  VoidCallback? declineTap,
  VoidCallback? contactTap,
  VoidCallback? detailTap,
  Color? acceptColor,
  Color? declineColor,
  String? image,
  String? time,
  String? date,
}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 1.0,
          ),
        ],
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(25),
              topLeft: Radius.circular(25),
            ),
            child: Stack(
              children: [
                CachedNetworkImage(
                  imageUrl: image!,
                  width: double.infinity,
                  height: screenHeight(context) * 0.15,
                  fit: BoxFit.cover,
                  errorWidget: (context, d, g) {
                    return Image.asset(AppIcons.appLogo);
                  },
                ),
              ],
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(top: 15, right: 15, left: 15),
              child: Column(
                children: [
                  headingText(
                    text: title ?? "",
                    fontSize: 20,
                  ),
                ],
              )),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customText(
                        text: "Client Name :", color: greyColor, fontSize: 10),
                    h5,
                    customText(
                        text: clientName ?? "", color: blackColor, fontSize: 8),
                    h10,
                    customText(
                        text: "Description :", color: greyColor, fontSize: 10),
                    h5,
                    SizedBox(
                      width: screenHeight(context) * 0.2,
                      child: customText(
                          text: description ?? "",
                          color: blackColor,
                          fontSize: 8),
                    ),
                    h10,
                    customText(
                        text: "Postal Code :", color: greyColor, fontSize: 10),
                    h5,
                    SizedBox(
                      width: screenHeight(context) * 0.2,
                      child: customText(
                          text: postalCode ?? "",
                          color: blackColor,
                          fontSize: 8),
                    ),
                    h15,
                    customText(
                        text: "Request Date & Time : ",
                        color: greyColor,
                        fontSize: 10),
                    h5,
                    Row(
                      children: [
                        Image.asset(
                          AppIcons.calendar,
                          width: 12,
                          height: 12,
                        ),
                        customText(
                            text: " Date :", color: greyColor, fontSize: 10),
                        w10,
                        customText(
                            text: requestDate ?? "",
                            color: blackColor,
                            fontSize: 8),
                      ],
                    ),
                    h5,
                    Row(
                      children: [
                        Image.asset(
                          AppIcons.clockDuration,
                          width: 12,
                          height: 12,
                        ),
                        customText(
                            text: " Time :", color: greyColor, fontSize: 10),
                        w10,
                        customText(
                            text: requestTime ?? "",
                            color: blackColor,
                            fontSize: 8),
                      ],
                    ),
                  ],
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      customText(text: "Contact Details :", color: greyColor),
                      h5,
                      customText(
                          text: contactDetail ?? "",
                          color: blackColor,
                          fontSize: 8),
                      h5,
                      customText(
                          text: "Location :", color: greyColor, fontSize: 10),
                      h5,
                      customText(
                          text: location ?? "", color: blackColor, fontSize: 8),
                      h5,
                      customText(
                          text: "Request Status :",
                          color: greyColor,
                          fontSize: 10),
                      h5,
                      Row(
                        children: [
                          Image.asset(AppIcons.progress),
                          Expanded(
                            child: customText(
                                text: " $status",
                                color: blackColor,
                                fontSize: 8),
                          ),
                        ],
                      ),
                      h10,
                      customText(
                          text: "Client Date & Time : ",
                          color: greyColor,
                          fontSize: 10),
                      h5,
                      Row(
                        children: [
                          Image.asset(
                            AppIcons.calendar,
                            width: 12,
                            height: 12,
                          ),
                          customText(
                              text: " Date :", color: greyColor, fontSize: 10),
                          w10,
                          customText(
                              text: date ?? "", color: blackColor, fontSize: 8),
                        ],
                      ),
                      h5,
                      Row(
                        children: [
                          Image.asset(
                            AppIcons.clockDuration,
                            width: 12,
                            height: 12,
                          ),
                          customText(
                              text: " Time :", color: greyColor, fontSize: 10),
                          w10,
                          customText(
                              text: time ?? "", color: blackColor, fontSize: 8),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: CustomButton(
                    onTap: acceptTap,
                    height: screenHeight(context) * 0.04,
                    text: "Accept",
                    fontSize: 12,
                    gradientColor: acceptGradient(color: acceptColor),
                  ),
                ),
                w10,
                Expanded(
                  child: CustomButton(
                    onTap: declineTap,
                    height: screenHeight(context) * 0.04,
                    text: "Decline",
                    fontSize: 12,
                    gradientColor: redGradient(color: declineColor),
                  ),
                ),
                w10,
                Expanded(
                  child: CustomButton(
                    onTap: contactTap,
                    height: screenHeight(context) * 0.04,
                    text: "Contact",
                    fontSize: 12,
                  ),
                ),
                w10,
                Expanded(
                  child: CustomButton(
                    onTap: detailTap,
                    height: screenHeight(context) * 0.04,
                    text: "Details",
                    fontSize: 12,
                    gradientColor: detailGradient(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget jobWidget(context,
    {VoidCallback? onTap,
    String? title,
    String? image,
    String? clientName,
    String? contactDetail,
    String? description,
    String? location,
    String? status,
    String? requestTime,
    String? requestDate,
    String? clientDate,
    String? clientTime,
    VoidCallback? detailTap}) {
  late ImageProvider imgVariable;
  imgVariable = CachedNetworkImageProvider(image!, errorListener: (ee) {
    imgVariable = const AssetImage(AppIcons.appLogo);
  });
  return InkWell(
    onTap: onTap,
    child: Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 1.0,
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: screenHeight(context) * 0.15,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(25),
                topLeft: Radius.circular(25),
              ),
              image: DecorationImage(
                  image: image == ""
                      ? const AssetImage(AppIcons.appLogo)
                      : imgVariable,
                  fit: BoxFit.cover),
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(top: 15, right: 15, left: 15),
              child: Column(
                children: [
                  headingText(
                    text: title ?? "",
                    fontSize: 20,
                  ),
                ],
              )),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customText(
                        text: "Client Name :", color: greyColor, fontSize: 10),
                    h5,
                    customText(
                        text: clientName ?? "", color: blackColor, fontSize: 8),
                    h10,
                    customText(
                        text: "Description :", color: greyColor, fontSize: 10),
                    h5,
                    SizedBox(
                      width: screenHeight(context) * 0.2,
                      child: customText(
                          text: description ?? "",
                          color: blackColor,
                          fontSize: 8),
                    ),
                    h15,
                    customText(
                        text: "Request Date & Time : ",
                        color: greyColor,
                        fontSize: 10),
                    h5,
                    Row(
                      children: [
                        Image.asset(
                          AppIcons.calendar,
                          width: 12,
                          height: 12,
                        ),
                        customText(
                            text: " Date :", color: greyColor, fontSize: 10),
                        w10,
                        customText(
                            text: requestDate ?? "",
                            color: blackColor,
                            fontSize: 8),
                      ],
                    ),
                    h5,
                    Row(
                      children: [
                        Image.asset(
                          AppIcons.clockDuration,
                          width: 12,
                          height: 12,
                        ),
                        customText(
                            text: " Time :", color: greyColor, fontSize: 10),
                        w10,
                        customText(
                            text: requestTime ?? "",
                            color: blackColor,
                            fontSize: 8),
                      ],
                    ),
                  ],
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      customText(text: "Contact Details :", color: greyColor),
                      h5,
                      customText(
                          text: contactDetail ?? "",
                          color: blackColor,
                          fontSize: 8),
                      h5,
                      customText(
                          text: "Location :", color: greyColor, fontSize: 10),
                      h5,
                      customText(
                          text: location ?? "", color: blackColor, fontSize: 8),
                      h5,
                      customText(
                          text: "Request Status :",
                          color: greyColor,
                          fontSize: 10),
                      h5,
                      Row(
                        children: [
                          Image.asset(AppIcons.progress),
                          customText(
                              text: " In Progress",
                              color: blackColor,
                              fontSize: 8),
                        ],
                      ),
                      h10,
                      customText(
                          text: "Client Date & Time : ",
                          color: greyColor,
                          fontSize: 10),
                      h5,
                      Row(
                        children: [
                          Image.asset(
                            AppIcons.calendar,
                            width: 12,
                            height: 12,
                          ),
                          customText(
                              text: " Date :", color: greyColor, fontSize: 10),
                          w10,
                          customText(
                              text: clientDate ?? "",
                              color: blackColor,
                              fontSize: 8),
                        ],
                      ),
                      h5,
                      Row(
                        children: [
                          Image.asset(
                            AppIcons.clockDuration,
                            width: 12,
                            height: 12,
                          ),
                          customText(
                              text: " Time :", color: greyColor, fontSize: 10),
                          w10,
                          customText(
                              text: clientTime ?? "",
                              color: blackColor,
                              fontSize: 8),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: CustomButton(
                    height: screenHeight(context) * 0.04,
                    text: "Contact",
                    fontSize: 12,
                  ),
                ),
                w10,
                Expanded(
                  child: CustomButton(
                    onTap: detailTap,
                    height: screenHeight(context) * 0.04,
                    text: "Details",
                    fontSize: 12,
                    gradientColor: detailGradient(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

class addServiceWidget extends StatelessWidget {
  const addServiceWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
          shape: BoxShape.circle, border: Border.all(color: greyColor)),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(5),
              child: FaIcon(
                FontAwesomeIcons.toolbox,
                color: Colors.black54,
                size: 38,
              ),
            ),
            Text(
              'Add Service',
              style:
                  TextStyle(color: Colors.black54, fontWeight: FontWeight.w600),
            )
          ],
        ),
      ),
    );
  }
}

Widget circleAvatar({String? text, IconData? icon}) {
  return Center(
    child: Container(
      decoration: BoxDecoration(
        border: Border.all(color: borderColor),
        shape: BoxShape.circle,
      ),
      padding: const EdgeInsets.all(30),
      child: Column(
        children: [
          Icon(
            icon!,
            size: 50,
          ),
          h10,
          customText(text: text, fontSize: 12),
        ],
      ),
    ),
  );
}

Future<dynamic> animatedDialog(BuildContext context,
    {String? title,
    String? subTitle,
    String? thirdTitle,
    VoidCallback? yesTap,
    VoidCallback? cancelTap,
    String? yesButtonText,
    String? canceluttonText,
    bool? isLoading = false}) {
  return showGeneralDialog(
      barrierColor: Colors.black.withOpacity(0.5),
      transitionBuilder: (context, a1, a2, widget) {
        final curvedValue = Curves.easeInOutSine.transform(a1.value) - 1.0;
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Transform(
            transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
            child: Opacity(
              opacity: a1.value,
              child: Dialog(
                backgroundColor: whiteColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.only(left: 18, right: 18, top: 10),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Lottie.asset("assets/animation/logout.json",
                            width: 120, height: 150),
                        customText(
                            text: title,
                            color: blackColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                        const SizedBox(
                          height: 20,
                        ),
                        customText(
                            text: subTitle,
                            color: blackColor,
                            fontSize: 17,
                            overFlow: TextOverflow.visible,
                            textAlign: TextAlign.center),
                        const SizedBox(
                          height: 20,
                        ),
                        // Container(
                        //   child: customText(
                        //     text: thirdTitle,
                        //     color: blackColor,
                        //     fontSize: 15,
                        //     overFlow: TextOverflow.visible,
                        //     textAlign: TextAlign.center,
                        //   ),
                        // ),

                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: CustomButton(
                                onTap: () {
                                  setState(() {
                                    isLoading = true;
                                    // Make sure this updates the variable the dialog checks
                                  });
                                  // Then call your original tap handler and update state as necessary
                                  yesTap?.call();
                                },
                                fontSize: 14,
                                isLoading: isLoading,
                                text: yesButtonText ?? "Complete",
                                width: MediaQuery.of(context).size.width,
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                              ),
                            ),
                            w15,
                            Expanded(
                              child: CustomButton(
                                onTap:
                                    cancelTap ?? () => Navigator.pop(context),
                                fontSize: 14,
                                gradientColor: redGradient(),
                                text: canceluttonText ?? "Cancel",
                                width: MediaQuery.of(context).size.width,
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ]),
                ),
              ),
            ),
          );
        });
      },
      transitionDuration: const Duration(milliseconds: 300),
      barrierDismissible: true,
      barrierLabel: '',
      context: context,
      pageBuilder: (context, animation1, animation2) {
        return Container();
      });
}

bool emailValidation(String em) {
  String p =
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$";
  RegExp regExp = RegExp(p);
  return regExp.hasMatch(em);
}
