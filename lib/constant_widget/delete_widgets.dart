import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../app_constants/app_icon.dart';
import 'constant_widgets.dart';

void deleteFunction(context, controller){
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Container(
            decoration: const BoxDecoration(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 10,
                ),
                Lottie.asset(
                  AppIcons.logoutAnimation,
                  width: 200,
                  height: 100,
                ),
                const SizedBox(
                  height: 20,
                ),
                customText(
                    text: "Are you sure to delete account?",
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                    textAlign: TextAlign.center),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceEvenly,
                  children: [
                    MaterialButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side:  const BorderSide(
                              color: Colors.black)),
                      child: customText(
                        text: "Cancel",
                      ),
                    ),
                    MaterialButton(
                      onPressed: () async {
                        controller.deleteUser();
                        // prefs.clear().then((value) {
                        // });
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side:  const BorderSide(
                              color: Colors.black)),
                      child: customText(
                        text: "Yes",
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      });
}