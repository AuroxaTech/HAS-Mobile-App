import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:property_app/app_constants/app_icon.dart';
import 'package:property_app/app_constants/app_sizes.dart';
import 'package:property_app/app_constants/color_constants.dart';
import 'package:property_app/constant_widget/constant_widgets.dart';
import 'package:property_app/route_management/constant_routes.dart';

import '../../controllers/services_provider_controller/rating_controller.dart';
import '../../models/service_provider_model/rating.dart';
class RatingScreen extends GetView<RatingController> {
  const RatingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int maxRatings = [
      controller.fiveRate.value,
      controller.fourRate.value,
      controller.threeRate.value,
      controller.twoRate.value,
      controller.oneRate.value,
    ].reduce(max); // Import 'dart:math' to use max.

    return Scaffold(
      backgroundColor: whiteColor,
      appBar: homeAppBar(context, text: "Reviews"),
      floatingActionButton: FloatingActionButton(onPressed: (){
         Get.toNamed(kRateExperienceScreen);
        }, child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Obx(() =>
              controller.isLoading.value ? Center(child: CircularProgressIndicator()) :
              SingleChildScrollView(
                child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(
                      top: 12,
                      bottom: 12,
                      left: 5, right: 5
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: whiteColor,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 1.0,
                          ),
                        ]
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(AppIcons.star),
                            h10,
                            customText(
                              text: "Average Rating",
                              fontSize: 14,
                              color: greyText,
                            ),
                            h5,
                            customText(
                              text: "Based on 25,000 ratings",
                              fontSize: 10,
                              color: greyText,
                            ),
                          ],
                        ),
                        // Column(
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   children: [
                        //     ratingContainer(
                        //       rating: "5 Star  ",
                        //       ratingWidth: 100,
                        //       text: "  10,000"
                        //     ),
                        //     h7,
                        //     ratingContainer(
                        //         rating: "4 Star  ",
                        //         ratingWidth: 60,
                        //         text: "  8,000"
                        //     ),
                        //     h7,
                        //     ratingContainer(
                        //         rating: "3 Star  ",
                        //         ratingWidth: 40,
                        //         text: "  6,000"
                        //     ),
                        //     h7,
                        //     ratingContainer(
                        //         rating: "2 Star  ",
                        //         ratingWidth: 30,
                        //         text: "  4,000"
                        //     ),
                        //     h7,
                        //     ratingContainer(
                        //         rating: "1 Star  ",
                        //         ratingWidth: 15,
                        //         text: "  2,000"
                        //     )
                        //   ],
                        // )
                        Obx(() => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ratingContainer(
                                rating: "5 Star ",
                                ratingWidth: maxRatings > 0 ? (controller.fiveRate.value / maxRatings) * 100 : 0, // Calculate the width dynamically
                                text: "  ${controller.fiveRate}", // Bind the text dynamically
                              ),
                              h7, // Spacer
                              ratingContainer(
                                rating: "4 Star ",
                                ratingWidth: maxRatings > 0 ? (controller.fourRate.value / maxRatings) * 100 : 0, // Calculate the width dynamically
                                text: "  ${controller.fourRate}", // Bind the text dynamically
                              ),
                              h7, // Spacer
                              ratingContainer(
                                rating: "3 Star ",
                                ratingWidth: maxRatings > 0 ? (controller.threeRate.value / maxRatings) * 100 : 0, // Calculate the width dynamically
                                text: "  ${controller.threeRate}", // Bind the text dynamically
                              ),
                              h7, // Spacer
                              ratingContainer(
                                rating: "2 Star ",
                                ratingWidth: maxRatings > 0 ? (controller.twoRate.value / maxRatings) * 100 : 0, // Calculate the width dynamically
                                text: "  ${controller.twoRate}", // Bind the text dynamically
                              ),
                              h7, // Spacer
                              ratingContainer(
                                rating: "1 Star ",
                                ratingWidth: maxRatings > 0 ? (controller.oneRate.value / maxRatings) * 100 : 0, // Calculate the width dynamically
                                text: "  ${controller.oneRate}", // Bind the text dynamically
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  h20,
                  // ListView.builder(
                  //   itemCount: controller.allFeedBackList.length,
                  //   shrinkWrap: true,
                  //   physics: NeverScrollableScrollPhysics(),
                  //   itemBuilder: (context, index) {
                  //     int? rat = int.tryParse( controller.allFeedBackList[index].rate);
                  //     return Column(
                  //       children: [
                  //         Container(
                  //           decoration: BoxDecoration(
                  //               borderRadius: BorderRadius.circular(15),
                  //               color: whiteColor,
                  //               boxShadow: [
                  //                 BoxShadow(
                  //                   color: Colors.black.withOpacity(0.2),
                  //                   blurRadius: 1.0,
                  //                 ),
                  //               ]
                  //           ),
                  //           padding: const EdgeInsets.only(top: 10, bottom: 10),
                  //           child: ListTile(
                  //             leading:  Container(
                  //               width: 50,
                  //               decoration: const BoxDecoration(
                  //                 image: DecorationImage(
                  //                   image: AssetImage(AppIcons.person)
                  //                 )
                  //               ),
                  //             ),
                  //             title: headingText(
                  //                 text: controller.allFeedBackList[index].subpropertytype.name,
                  //                 fontSize: 20,
                  //                 color: greyColor
                  //             ),
                  //             subtitle: Column(
                  //               mainAxisAlignment: MainAxisAlignment.start,
                  //               crossAxisAlignment: CrossAxisAlignment.start,
                  //               children: [
                  //                 RatingWidget(
                  //                   maxRating: 5,
                  //                   isRating: false,
                  //                   initialRating: rat!,
                  //                   onRatingChanged: (rating) {
                  //                     print('Selected rating: $rating');
                  //                   },
                  //                 ),
                  //                 customText(
                  //                   text: controller.allFeedBackList[index].description,
                  //                  // text: " I must say, it's a game-changer! The user interface is sleek and intuitive a breeze.",
                  //                   fontSize: 10
                  //                 )
                  //
                  //               ],
                  //             ),
                  //           ),
                  //         ),
                  //         SizedBox(
                  //           height: 15,
                  //         )
                  //       ],
                  //     );
                  //   }
                  // ),

                  PagedListView<int, RatingDatum>(
                    shrinkWrap: true,
                    pagingController: controller.pagingController,
                    builderDelegate: PagedChildBuilderDelegate<RatingDatum>(
                        firstPageErrorIndicatorBuilder: (context) => MaterialButton(
                          child: const Text("No Data Found, Tap to try again."),
                          onPressed: () => controller.pagingController.refresh(),
                        ),
                        itemBuilder: (context, item, index) {
                          int? rat = int.tryParse( item.rate);
                          return Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: whiteColor,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 1.0,
                                      ),
                                    ]
                                ),
                                padding: const EdgeInsets.only(top: 10, bottom: 10),
                                child: ListTile(
                                  leading:  Container(
                                    width: 50,
                                    decoration: const BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage(AppIcons.person)
                                        )
                                    ),
                                  ),
                                  title: headingText(
                                      text: item.subpropertytype.name,
                                      fontSize: 20,
                                      color: greyColor
                                  ),
                                  subtitle: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      RatingWidget(
                                        maxRating: 5,
                                        isRating: false,
                                        initialRating: rat!,
                                        onRatingChanged: (rating) {
                                          print('Selected rating: $rating');
                                        },
                                      ),
                                      customText(
                                          text: item.description,
                                          // text: " I must say, it's a game-changer! The user interface is sleek and intuitive a breeze.",
                                          fontSize: 10
                                      )

                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              )
                            ],
                          );
                        }
                    ),
                  ),
                ],
                            ),
              ),
          ),
        ),
      ),
    );
  }

  Widget ratingContainer({String? rating, double? ratingWidth, String? text }){
    return Row(
      children: [
        customText(
            text: rating,
            fontSize: 10,
            color: greyText
        ),
        Container(
          width: 100,
          height: 14,
          decoration: BoxDecoration(
              border: Border.all(color: greyColor),
              borderRadius: BorderRadius.circular(3)
          ),
          child: Align(
            alignment: Alignment.topLeft,
            child: Container(
              width: ratingWidth,
              height: 14,
              decoration: const BoxDecoration(
                  color: starColor
              ),
            ),
          ),
        ),
        customText(
            text: text,
            fontSize: 10,
            color: greyText

        )

      ],
    );
  }
}

class RatingWidget extends StatefulWidget {
  final int maxRating;
  final int initialRating;
  final double? size;
  bool? isRating = true;
  final Function(int) onRatingChanged;

   RatingWidget({super.key,
    required this.maxRating,
    required this.initialRating,
    required this.isRating,
    required this.onRatingChanged,
    this.size
  });

  @override
  // ignore: library_private_types_in_public_api
  _RatingWidgetState createState() => _RatingWidgetState();
}

class _RatingWidgetState extends State<RatingWidget> {
  late int currentRating;

  @override
  void initState() {
    super.initState();
    currentRating = widget.initialRating;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(widget.maxRating, (index) {
        return GestureDetector(
          onTap: widget.isRating == true ? () {
            setState(() {
              currentRating = index + 1;
            });
            widget.onRatingChanged(currentRating);
          } : null,
          child: Icon(
            index < currentRating ? Icons.star : Icons.star_border,
            size: widget.size ?? 15.0,
            color: starColor,
          ),
        );
      }),
    );
  }
}