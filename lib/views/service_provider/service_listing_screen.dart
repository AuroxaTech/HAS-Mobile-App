import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:property_app/app_constants/app_icon.dart';
import 'package:property_app/app_constants/app_sizes.dart';
import 'package:property_app/app_constants/color_constants.dart';
import 'package:property_app/constant_widget/constant_widgets.dart';
import 'package:property_app/custom_widgets/custom_button.dart';
import 'package:property_app/route_management/constant_routes.dart';

import '../../controllers/services_provider_controller/service_listing_screen_controller.dart';
import '../../models/service_provider_model/all_services.dart';
import '../../utils/shared_preferences/preferences.dart';
import '../chat_screens/chat_conversion_screen.dart';

class ServicesListingScreen extends GetView<ServiceListingScreenController> {
  ServicesListingScreen({Key? key}) : super(key: key);
  @override
  final controller = Get.put(ServiceListingScreenController());
  @override
  Widget build(BuildContext context) {
    return Obx(
      ()=> Scaffold(
        key: controller.key,
        backgroundColor: whiteColor,
        appBar: titleAppBar(
          "Service Listing",
          leading: controller.selectedCategoryId.value.isEmpty
              ? null
              : Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                controller.selectedCategory.value = "";
                controller.selectedCategoryId.value = "";
                controller.selectedSubCategory.value = "";
                controller.selectedSubCategoryId.value = "";
              },
            ),
          ),
          action: [
            IconButton(
                onPressed: () {
                  Get.toNamed(kServiceFilterScreen)?.then((result) {
                    if (result != null) {
                      controller.pagingController.value.itemList!.clear();
                      return controller.getServices(1, result);
                    }
                  });
                },
                icon: const Icon(Icons.filter_list)),
          ],
        ),
        body: SafeArea(
          child: Stack(
            children: [
              Obx(
                    () {
                  if (controller.selectedCategoryId.value.isEmpty) {
                    // Show Categories
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const AlwaysScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 1.1,
                        ),
                        itemCount: controller.categoriesList.length,
                        itemBuilder: (context, index) {
                          final category = controller.categoriesList[index];

                          return Obx(
                                () => GestureDetector(
                              onTap: () {
                                controller.selectedCategory.value = category['name'];
                                controller.selectedCategoryId.value = category['id'].toString();
                                controller.selectedSubCategory.value = ""; // Reset subcategory
                                controller.selectedSubCategoryId.value = ""; // Reset subcategory ID
                                controller.updateSubCategories(controller.selectedCategory.value);
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                curve: Curves.easeInOut,
                                decoration: BoxDecoration(
                                  gradient: controller.selectedCategory.value == category['name']
                                      ? LinearGradient(colors: [Colors.blueAccent, Colors.lightBlue])
                                      : null,
                                  color: controller.selectedCategory.value == category['name']
                                      ? null
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.shade300,
                                      blurRadius: 5,
                                      spreadRadius: 2,
                                      offset: const Offset(2, 2),
                                    ),
                                  ],
                                  border: Border.all(
                                    color: controller.selectedCategory.value == category['name']
                                        ? Colors.transparent
                                        : Colors.grey.shade300,
                                  ),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                alignment: Alignment.center,
                                child: Text(
                                  category['name'],
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: controller.selectedCategory.value == category['name']
                                        ? Colors.white
                                        : Colors.black87,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  } else if (controller.selectedSubCategoryId.value.isEmpty) {
                    // Show Subcategories
                    return Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          // Back Button (Optional, you can add this if needed)
                          // InkWell(
                          //   onTap: () {
                          //     controller.selectedCategoryId.value = "";
                          //     controller.selectedCategory.value = "";
                          //     controller.selectedSubCategory.value = "";
                          //     controller.selectedSubCategoryId.value = "";
                          //   },
                          //   child: const Icon(Icons.arrow_back),
                          // ),
                          Expanded(
                            child: GridView.builder(
                              shrinkWrap: true,
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                childAspectRatio: 1,
                              ),
                              itemCount: controller.subCategoriesList.length,
                              itemBuilder: (context, index) {

                                return Obx(
                                      () {
                                        final subCategory = controller.subCategoriesList[index];
                                        final isSelected = controller.selectedSubCategory.value == subCategory['name'];

                                        return  GestureDetector(
                                          onTap: () async{
                                            controller.selectedSubCategory.value = subCategory['name'];
                                            controller.selectedSubCategoryId.value = subCategory['id'].toString();

                                            if(controller.isFirsTime.value == false){
                                              Future.microtask((){
                                                controller.pagingController.addPageRequestListener((pageKey) {
                                                  controller.getServices(pageKey,{
                                                    "category_id" : controller.selectedCategoryId.value,
                                                  });
                                                });
                                              });
                                              controller.isFirsTime.value = true;
                                            }else{
                                              controller.pagingController.itemList!.clear();
                                              controller.getServices(1,{
                                                "category_id" : controller.selectedCategoryId.value,
                                              });
                                            }



                                          },
                                          child: AnimatedContainer(
                                            duration: const Duration(milliseconds: 250),
                                            curve: Curves.easeInOut,
                                            decoration: BoxDecoration(
                                              gradient: isSelected
                                                  ? LinearGradient(colors: [Colors.blueAccent, Colors.lightBlue])
                                                  : null,
                                              color: isSelected ? null : Colors.white,
                                              borderRadius: BorderRadius.circular(12),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey.shade300,
                                                  blurRadius: 5,
                                                  spreadRadius: 2,
                                                  offset: const Offset(2, 2),
                                                ),
                                              ],
                                              border: Border.all(
                                                color: isSelected ? Colors.transparent : Colors.grey.shade300,
                                              ),
                                            ),
                                            padding: const EdgeInsets.symmetric(vertical: 12),
                                            alignment: Alignment.center,
                                            child: Text(
                                              subCategory['name'],
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.poppins(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: isSelected ? Colors.white : Colors.black87,
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    // Show PagedListView of Services
                    return RefreshIndicator(
                      onRefresh: () async {
                        controller.pagingController.itemList!.clear();
                        return controller.getServices(1);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: PagedListView<int, AllService>(
                          shrinkWrap: true,
                          pagingController: controller.pagingController,
                          builderDelegate: PagedChildBuilderDelegate<AllService>(
                            firstPageErrorIndicatorBuilder: (context) => MaterialButton(
                              child: const Text("No Data Found, Tap to try again."),
                              onPressed: () {
                                controller.pagingController.refresh();
                              },
                            ),
                            newPageErrorIndicatorBuilder: (context) => MaterialButton(
                              child: const Text("Failed to load more items. Tap to try again."),
                              onPressed: () {
                                controller.pagingController.retryLastFailedRequest();
                              },
                            ),
                            noItemsFoundIndicatorBuilder: (context) => MaterialButton(
                              child: const Text("No Data found. Tap to reset"),
                              onPressed: () {
                                controller.pagingController.refresh();
                              },
                            ),
                            itemBuilder: (context, item, index) {
                              print("Screen - Building item for service ID: ${item.id}");
                              print("Screen - isApplied value: ${item.isApplied}");
                              print("Screen - Raw isApplied type: ${item.isApplied.runtimeType}");
                              print("Screen - Condition check: item.isApplied == 1 is ${item.isApplied == 1}");
                              print("Favourite = ${item.isFavorite}");
                              print("is Applied => ${item.isApplied}");
                              int? isApplied;
                              String imageUrl = AppIcons.appLogo;
                              if (item.serviceImages.isNotEmpty) {
                                imageUrl = item.serviceImages[0].imagePath;
                              }
                              return Padding(
                                padding: const EdgeInsets.only(top: 15),
                                child: InkWell(
                                  onTap: () {
                                    Get.toNamed(
                                      kServiceListingScreenDetail,
                                      arguments: [
                                        item.id,
                                        item.serviceImages.map((img) => img.imagePath).toList()
                                      ],
                                    );
                                  },
                                  child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.2),
                                            spreadRadius: 1,
                                            blurRadius: 6,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Container(
                                                      width: 60,
                                                      height: 70,
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(10),
                                                      ),
                                                      child: ClipRRect(
                                                        borderRadius: BorderRadius.circular(10),
                                                        child: CachedNetworkImage(
                                                          imageUrl: imageUrl,
                                                          width: 60,
                                                          height: 70,
                                                          fit: BoxFit.cover,
                                                          errorWidget: (context, url, error) =>
                                                              Image.asset(AppIcons.appLogo),
                                                        ),
                                                      ),
                                                    ),
                                                    w20,
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        SizedBox(
                                                          width: 150,
                                                          child: customText(
                                                            text: item.serviceName,
                                                            fontSize: 20,
                                                          ),
                                                        ),
                                                        Row(
                                                          children: [
                                                            const Icon(Icons.star, color: Colors.amber, size: 20),
                                                            const SizedBox(width: 4),
                                                            customText(
                                                                text:
                                                                "${item.averageRate} (${item.countOfService})")
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                IconButton(
                                                  icon: Icon(
                                                    item.isFavorite == 1
                                                        ? Icons.favorite
                                                        : Icons.favorite_border,
                                                    color: item.isFavorite == 1
                                                        ? Colors.red
                                                        : greyText,
                                                  ),
                                                  onPressed: () {
                                                    controller.toggleFavorite1(index, item.id);
                                                  },
                                                )
                                              ],
                                            ),
                                            h15,
                                            customText(
                                                text: "Main Services Offered :",
                                                fontSize: 16,
                                                color: Colors.black54),
                                            h5,
                                            customText(
                                              text: "${item.additionalInformation}" ?? "",
                                              fontSize: 16,
                                            ),
                                            h10,
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    customText(
                                                        text: "Available  ",
                                                        fontSize: 16,
                                                        color: Colors.black54),
                                                    Image.asset(AppIcons.clockDuration),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    customText(
                                                        text: "Service  ",
                                                        fontSize: 16,
                                                        color: Colors.black54),
                                                    SvgPicture.asset(AppIcons.locationRed),
                                                  ],
                                                ),
                                                w30
                                              ],
                                            ),
                                            h10,
                                            customText(
                                                text: "${item.startTime}  ${item.endTime}",
                                                fontSize: 16,
                                                color: blackColor),
                                            h10,
                                            customText(
                                                text: item.location,
                                                fontSize: 16,
                                                color: blackColor),
                                            h10,
                                            customText(
                                                text: "Description :",
                                                fontSize: 16,
                                                color: Colors.black54),
                                            h10,
                                            customText(
                                                text: item.description,
                                                fontSize: 14,
                                                color: Colors.black54),
                                            h10,
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: CustomButton(
                                                    height: screenHeight(context) * 0.06,
                                                    text: "Contact",
                                                    fontSize: 18,
                                                    gradientColor: yellowGradient(),
                                                    onTap: () {
                                                      createConversation(
                                                          item.user!.fullname.toString(),
                                                          item.user!.profileimage,
                                                          item.user!.id.toString(),
                                                          context);
                                                    },
                                                  ),
                                                ),
                                                w15,
                                                Expanded(
                                                  child: item.isBooked == true
                                                      ? CustomButton(
                                                    gradientColor: detailGradient(),
                                                    height: screenHeight(context) * 0.06,
                                                    text: "Pending",
                                                    fontSize: 18,
                                                    onTap: () {
                                                      print(
                                                          "Service ${item.id} is already applied (isApplied=${item.isApplied})");
                                                    },
                                                  )
                                                      : CustomButton(
                                                    height: screenHeight(context) * 0.06,
                                                    text: "Book Service",
                                                    fontSize: 18,
                                                    gradientColor: gradient(),
                                                    onTap: () {
                                                      print(
                                                          "Booking service ${item.id} (isApplied=${item.isApplied})");
                                                      Get.toNamed(kNewServiceRequestScreen, arguments: [
                                                        item.serviceName,
                                                        item.user == null ? "" : item.user!.email,
                                                        item.description,
                                                        item.userId,
                                                        item.id,
                                                        imageUrl,
                                                        item.country,
                                                        item.city,
                                                        item.yearExperience,
                                                        item.cnicFrontPic,
                                                        item.cnicBackPic,
                                                        item.certification,
                                                        item.resume,
                                                        item.pricing,
                                                        item.serviceImages
                                                      ]);
                                                    },
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      )),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  }
                },
              ),
              // Obx(() => Positioned(
              //     left: 0,
              //     right: 0,
              //     top: 0,
              //     bottom: 0,
              //     child:  controller.isLoading.value ? const Center(child: CircularProgressIndicator()) : const SizedBox.shrink()),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  bool _shouldShowBookService(
      int? isApplied, int? isDeclined, int? isApproved) {
    if (isApplied == null || isDeclined == null || isApproved == null) {
      return true;
    }
    return (isApplied == 0 && isDeclined == 0) || (isDeclined == 1);
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
