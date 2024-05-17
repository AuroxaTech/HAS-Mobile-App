import 'package:flutter/material.dart';
import 'package:property_app/app_constants/color_constants.dart';

import '../../app_constants/app_sizes.dart';
import '../../constant_widget/constant_widgets.dart';


class PageBuilderWidget extends StatelessWidget {
 final String title;
 final String description;
 final String imageUrl;
 const PageBuilderWidget(
      {Key? key,
        required this.title,
        required this.description,
        required this.imageUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return topContainer();
  }

  Widget topContainer() {
    return Center(
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 80),
              child: Image.asset(
                imageUrl,
              ),
            ),
          ),
          Align(
            alignment: FractionalOffset.bottomCenter,
            child: Container(
                height: 350,
                width: double.infinity,
                decoration: const BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))),
                child: Column(
                  children: [
                    h25,
                    customText(
                      textAlign: TextAlign.center,
                        text: title, fontSize: 25, fontWeight: FontWeight.w500),
                    h25,
                    customText(
                        text: description,
                        fontSize: 20,
                        textAlign: TextAlign.center,
                        fontWeight: FontWeight.w300),
                  ],
                )),
          )
        ],
      ),
    );
  }
}
