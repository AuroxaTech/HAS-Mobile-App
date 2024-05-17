import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_app/app_constants/color_constants.dart';
import 'package:property_app/constant_widget/constant_widgets.dart';
import 'package:property_app/custom_widgets/custom_button.dart';
import 'package:property_app/custom_widgets/custom_text_field.dart';
import 'package:property_app/utils/api_urls.dart';
import 'package:property_app/views/settings/change_password_screen.dart';
import '../../app_constants/app_icon.dart';
import '../../app_constants/app_sizes.dart';
import '../../controllers/land_lord/profile_setting_screen_controller.dart';
import '../../route_management/constant_routes.dart';

class ProfileSettingsScreen extends GetView<ProfileSettingsScreenController> {
  const ProfileSettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: homeAppBar(context, text: "Settings"),
      body: SafeArea(
        child: Obx(() =>
            controller.isLoadingGet.value ? const Center(child: CircularProgressIndicator()) :
            Padding(
            padding: const EdgeInsets.only(left: 18, right: 18),
            child: SingleChildScrollView(
              child: Form(
                key: controller.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        controller.pickProfileImage();
                      },
                      child: Center(
                        child: CircleAvatar(
                          radius: 62,
                          backgroundColor: Colors.grey,
                          child: CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.white,
                            backgroundImage:  _getProfileImage(),                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: Container(
                                width: 30,
                                height: 30,
                                decoration: const BoxDecoration(
                                    color: primaryColor,
                                    shape: BoxShape.circle
                                ),
                                child: const Center(child: Icon(Icons.add, color: Colors.white,)),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    customText(
                      text: "Full Name :",
                      fontSize: 16,
                      color: greyColor,
                    ),
                    h10,
                    CustomTextField(
                      hintText: "Full name",
                      controller: controller.nameController,
                      validator: (value) {
                        if (value == null || value.isEmpty ) {
                          return 'Name is required';
                        }
                        return null;
                      },
                    ),
                    h5,
                    customText(
                      text: "Email :",
                      fontSize: 16,
                      color: greyColor,
                    ),
                    h5,
                    CustomTextField(
                      hintText: "Email",
                      controller: controller.email,
                      readOnly: true,
                    ),
                    h5,
                    customText(
                      text: "Phone Number :",
                      fontSize: 16,
                      color: greyColor,
                    ),
                    h5,
                    CustomTextField(
                      hintText: "Phone Number",
                      controller: controller.phoneNumber,
                      validator: (value) {
                        if (value == null || value.isEmpty || value.length < 10) {
                          return 'Invalid phone number. Must be at least 10 characters';
                        }
                        return null;
                      },
                    ),


                    h30,
                    Obx(
                      ()=> Center(child: CustomButton(
                        width: double.infinity,
                        text: "Save",
                        isLoading: controller.isLoading.value,
                        onTap: (){
                          if(controller.formKey.currentState!.validate()){
                            if(controller.profileImage.value == null){
                              controller.updateDataAndImage(
                                  name: controller.nameController.text,
                                  phoneNumber: controller.phoneNumber.text,
                                 );
                            }else{
                              print("profile image : ${controller.profileImage.value!.path}");
                              controller.updateDataAndImage(
                                  name: controller.nameController.text,
                                  phoneNumber: controller.phoneNumber.text,
                                  filePath: controller.profileImage.value!,
                              );
                            }
                          }
                        },
                      )),
                    ),

                    h20,
                    // InkWell(
                    //   onTap: (){
                    //     Get.toNamed(kChangePasswordScreen);
                    //   },
                    //   child: Container(
                    //     width: double.infinity,
                    //     height: 60,
                    //     decoration: BoxDecoration(
                    //         border: Border.all(color: Colors.grey.shade100),
                    //       borderRadius: BorderRadius.circular(10)
                    //     ),
                    //     child: Row(
                    //       crossAxisAlignment: CrossAxisAlignment.center,
                    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //       children: [
                    //         Padding(
                    //           padding: const EdgeInsets.only(left: 15),
                    //           child: customText(
                    //               text: "Change Password",
                    //               color: blackColor,
                    //               fontSize: 18
                    //           ),
                    //         ),
                    //         IconButton(onPressed: null,
                    //             icon: const Icon(Icons.arrow_forward)),
                    //       ],
                    //     ),
                    //
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  ImageProvider _getProfileImage() {
    // Check if a local file image is set first
    if (controller.profileImage.value != null && File(controller.profileImage.value!.path).existsSync()) {
      print("Using local file image: ${controller.profileImage.value!.path}");
      return FileImage(File(controller.profileImage.value!.path));
    } else if (controller.image.isNotEmpty) {
      print("Using network image: ${AppUrls.profileImageBaseUrl + controller.image}");
      return NetworkImage(AppUrls.profileImageBaseUrl + controller.image);
    }
    print("Using default asset image");
    return const AssetImage(AppIcons.personIcon);
  }

}

// % Define a structure for a vCard
// :- dynamic vcard/8.
//
// % Reads and parses vCards from a file
// read_vcards(FileName, VCards) :-
//     open(FileName, read, Stream),
//     read_lines(Stream, Lines),
//     close(Stream),
//     parse_vcards(Lines, VCards).
//
// % Read lines from the stream
// read_lines(Stream, []) :-
//     at_end_of_stream(Stream), !.
// read_lines(Stream, [Line | Lines]) :-
//     read_line_to_string(Stream, Line),
//     read_lines(Stream, Lines).
//
// % Parses lines into a list of vCard structures
// parse_vcards(Lines, [VCard|VCards]) :-
//     % Process each vCard block
//     process_vcard(Lines, VCardLines, RestLines),
//     create_vcard(VCardLines, VCard),
//     parse_vcards(RestLines, VCards).
// parse_vcards([], []).
//
// % Process a single vCard block
// process_vcard([Line|Lines], [Line|VCardLines], RestLines) :-
//     string(Line),
//     \+ sub_string(Line, 0, _, _, "END:VCARD"),
//     process_vcard(Lines, VCardLines, RestLines).
// process_vcard([Line|Lines], [], Lines) :-
//     string(Line),
//     sub_string(Line, 0, _, _, "END:VCARD").
//
// % Create a vCard structure from a list of lines
// create_vcard(Lines, vcard(FN)) :-
//     member(Line, Lines),
//     split_string(Line, ":", "", [Key, Value]),
//     Key = "FN",
//     FN = Value.
//
// % Convert a list of vCards to HTML
// vcards_to_html([VCard|VCards], HTML) :-
//     vcard_to_html(VCard, VCardHTML),
//     vcards_to_html(VCards, RestHTML),
//     string_concat(VCardHTML, RestHTML, HTML).
// vcards_to_html([], "").
//
// % Convert a single vCard to HTML
// vcard_to_html(vcard(FN), HTML) :-
//     format(string(HTML), '<div class="vcard"><div class="fn">~w</div></div>', [FN]).
//
// % Example usage:
// % ?- read_vcards('MedAssist.txt', VCards), vcards_to_html(VCards, HTML), write(HTML).
//
// % swipl -s task2.pl
// % [task2].
// % read_vcards('MedAssist.txt', VCards), vcards_to_html(VCards, HTML), write(HTML).