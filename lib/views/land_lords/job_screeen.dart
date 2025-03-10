// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
// import 'package:intl/intl.dart';
// import 'package:property_app/models/propert_model/service_job_status.dart';
//
// import '../../app_constants/app_sizes.dart';
// import '../../app_constants/color_constants.dart';
// import '../../constant_widget/constant_widgets.dart';
// import '../../controllers/jobs_controller/jobs_screen_controller.dart';
// import '../../route_management/constant_routes.dart';
// import '../../utils/api_urls.dart';
//
// class JobsScreen extends GetView<JobScreenController> {
//   final bool isBack;
//   const JobsScreen({super.key, required this.isBack});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: whiteColor,
//       appBar: homeAppBar(
//         context,
//         text: "Jobs",
//         isBack: false,
//         back: isBack,
//       ),
//       body: SafeArea(
//         child: RefreshIndicator(
//           onRefresh: () async {
//             controller.pendingJobController.itemList!.clear();
//             controller.completedJobController.itemList!.clear();
//             controller.rejectedJobController.itemList!.clear();
//             await Future.microtask(() => controller.getServiceJobs(1));
//           },
//           child: Padding(
//             padding: const EdgeInsets.all(18.0),
//             child: Obx(
//               () => controller.isLoading.value
//                   ? const Center(child: CircularProgressIndicator())
//                   : SingleChildScrollView(
//                       physics: const AlwaysScrollableScrollPhysics(),
//                       child: Column(
//                         children: [
//                           Row(
//                             children: [
//                               Expanded(
//                                 child: topContainer(
//                                   onTap: () {
//                                     controller.pending.value = true;
//                                     controller.completed.value = false;
//                                     controller.reject.value = false;
//                                     controller.pendingJobController.itemList!
//                                         .clear();
//                                     controller.completedJobController.itemList!
//                                         .clear();
//                                     controller.rejectedJobController.itemList!
//                                         .clear();
//                                     controller.getServiceJobs(1);
//                                   },
//                                   text:
//                                       "Pending(${controller.pendingJobController.itemList?.length ?? 0})",
//                                   textColor: controller.pending.value
//                                       ? primaryColor
//                                       : greyColor,
//                                   borderColor: controller.pending.value
//                                       ? primaryColor
//                                       : greyColor,
//                                 ),
//                               ),
//                               w10,
//                               Expanded(
//                                 child: topContainer(
//                                   onTap: () {
//                                     controller.pending.value = false;
//                                     controller.completed.value = true;
//                                     controller.reject.value = false;
//                                     controller.pendingJobController.itemList!
//                                         .clear();
//                                     controller.completedJobController.itemList!
//                                         .clear();
//                                     controller.rejectedJobController.itemList!
//                                         .clear();
//                                     controller.getServiceJobs(1);
//                                   },
//                                   text:
//                                       "Completed(${controller.completedJobController.itemList?.length ?? 0})",
//                                   textColor: controller.completed.value
//                                       ? primaryColor
//                                       : greyColor,
//                                   borderColor: controller.completed.value
//                                       ? primaryColor
//                                       : greyColor,
//                                 ),
//                               ),
//                               w10,
//                               Expanded(
//                                 child: topContainer(
//                                   onTap: () {
//                                     controller.pending.value = false;
//                                     controller.completed.value = false;
//                                     controller.reject.value = true;
//                                     controller.pendingJobController.itemList!
//                                         .clear();
//                                     controller.completedJobController.itemList!
//                                         .clear();
//                                     controller.rejectedJobController.itemList!
//                                         .clear();
//                                     controller.getServiceJobs(1);
//                                   },
//                                   text:
//                                       "Rejected(${controller.rejectedJobController.itemList?.length ?? 0})",
//                                   textColor: controller.reject.value
//                                       ? primaryColor
//                                       : greyColor,
//                                   borderColor: controller.reject.value
//                                       ? primaryColor
//                                       : greyColor,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           h15,
//                           // jobWidget(context, ),
//
//                           controller.pending.value
//                               ? PagedListView<int, PendingJob>(
//                                   shrinkWrap: true,
//                                   pagingController: controller.pendingJobController,
//                                   physics: const BouncingScrollPhysics(),
//                                   builderDelegate:
//                                       PagedChildBuilderDelegate<PendingJob>(
//                                     firstPageErrorIndicatorBuilder: (context) =>
//                                         MaterialButton(
//                                       child: const Text(
//                                           "No Data Found, Tap to try again."),
//                                       onPressed: () => controller
//                                           .pendingJobController
//                                           .refresh(),
//                                     ),
//                                     newPageErrorIndicatorBuilder: (context) =>
//                                         MaterialButton(
//                                       child: const Text(
//                                           "Failed to load more items. Tap to try again."),
//                                       onPressed: () => controller
//                                           .pendingJobController
//                                           .retryLastFailedRequest(),
//                                     ),
//                                     itemBuilder: (context, item, index) {
//                                       // Handle null createdAt safely
//
//                                       print("Item $index: $item"); // Debugging line
//
//                                       DateTime? createdAt = item.createdAt;
//                                       String requestDate = createdAt != null
//                                           ? DateFormat('dd-M-yy')
//                                               .format(createdAt)
//                                           : 'N/A'; // Fallback if createdAt is null
//                                       String requestTime = createdAt != null
//                                           ? DateFormat('h:mm a')
//                                               .format(createdAt)
//                                           : 'N/A'; // Fallback if createdAt is null
//
//                                       String imagesString = item.request == null
//                                           ? ""
//                                           : item.request.service.media;
//                                       List<String> imageList =
//                                           imagesString.split(',');
//
//                                       return Column(
//                                         children: [
//                                           jobWidget(
//                                             context,
//                                             image: AppUrls.mediaImages +
//                                                 imageList[0],
//                                             // Fallback for missing image
//                                             title: item.request.service
//                                                     .serviceName ??
//                                                 'No Service Name', // Null check for service name
//                                             contactDetail: item
//                                                     .provider.email ??
//                                                 'No Email', // Null check for email
//                                             clientName: item
//                                                     .provider.fullname ??
//                                                 'No Client Name', // Null check for client name
//                                             location: item.request.address ??
//                                                 'No Address', // Null check for address
//                                             description: item
//                                                     .request.description ??
//                                                 'No Description', // Null check for description
//                                             clientDate: item.request.date ??
//                                                 'No Date', // Null check for client date
//                                             clientTime: item.request.time ??
//                                                 'No Time', // Null check for client time
//                                             requestTime: requestTime,
//                                             requestDate: requestDate,
//                                             detailTap: () {
//                                               Get.toNamed(kJobDetailScreen,
//                                                   arguments: item.id);
//                                             },
//                                           ),
//                                           const SizedBox(height: 20),
//                                         ],
//                                       );
//                                     },
//                                   ),
//                                 )
//                               : const SizedBox(),
//
//                           controller.completed.value
//                               ? PagedListView<int, CompletedJob>(
//                                   shrinkWrap: true,
//                                   pagingController:
//                                       controller.completedJobController,
//                                   physics: const BouncingScrollPhysics(),
//                                   builderDelegate: PagedChildBuilderDelegate<
//                                           CompletedJob>(
//                                       firstPageErrorIndicatorBuilder:
//                                           (context) => MaterialButton(
//                                                 child: const Text(
//                                                     "No Data Found, Tap to try again."),
//                                                 onPressed: () => controller
//                                                     .completedJobController
//                                                     .refresh(),
//                                               ),
//                                       newPageErrorIndicatorBuilder: (context) =>
//                                           MaterialButton(
//                                             child: const Text(
//                                                 "Failed to load more items. Tap to try again."),
//                                             onPressed: () => controller
//                                                 .completedJobController
//                                                 .retryLastFailedRequest(),
//                                           ),
//                                       itemBuilder: (context, item, index) {
//                                         DateTime createdAt = item.createdAt;
//                                         String requestDate =
//                                             DateFormat('dd-M-yy').format(
//                                                 createdAt); // Adjust the pattern as needed
//                                         String requestTime =
//                                             DateFormat('h:mm a')
//                                                 .format(createdAt);
//                                         String imagesString =
//                                             item.request == null
//                                                 ? ""
//                                                 : item.request.service.media;
//                                         List<String> imageList =
//                                             imagesString.split(',');
//                                         return Column(
//                                           children: [
//                                             jobWidget(
//                                               context,
//                                               image: AppUrls.mediaImages +
//                                                   imageList[0],
//                                               title: item.request.service
//                                                   .serviceName, // Using null-aware operators to avoid runtime errors
//                                               contactDetail:
//                                                   item.provider.email,
//                                               clientName:
//                                                   item.provider.fullname,
//                                               location: item.request.address,
//                                               description:
//                                                   item.request.description,
//                                               clientDate: item.request.date,
//                                               clientTime: item.request.time,
//                                               requestTime: requestTime,
//                                               requestDate: requestDate,
//                                               // detailTap: (){
//                                               //   Get.toNamed(kJobDetailScreen, arguments: item.id );
//                                               // }
//                                             ),
//                                             const SizedBox(height: 20),
//                                           ],
//                                         );
//                                       }),
//                                 )
//                               : const SizedBox(),
//
//                           controller.reject.value
//                               ? PagedListView<int, RejectedJob>(
//                                   shrinkWrap: true,
//                                   pagingController:
//                                       controller.rejectedJobController,
//                                   physics: const BouncingScrollPhysics(),
//                                   builderDelegate: PagedChildBuilderDelegate<
//                                           RejectedJob>(
//                                       firstPageErrorIndicatorBuilder:
//                                           (context) => MaterialButton(
//                                                 child: const Text(
//                                                     "No Data Found, Tap to try again."),
//                                                 onPressed: () => controller
//                                                     .rejectedJobController
//                                                     .refresh(),
//                                               ),
//                                       newPageErrorIndicatorBuilder: (context) =>
//                                           MaterialButton(
//                                             child: const Text(
//                                                 "Failed to load more items. Tap to try again."),
//                                             onPressed: () => controller
//                                                 .rejectedJobController
//                                                 .retryLastFailedRequest(),
//                                           ),
//                                       itemBuilder: (context, item, index) {
//                                         DateTime createdAt = item.createdAt;
//                                         String requestDate =
//                                             DateFormat('dd-M-yy').format(
//                                                 createdAt); // Adjust the pattern as needed
//                                         String requestTime =
//                                             DateFormat('h:mm a')
//                                                 .format(createdAt);
//                                         String imagesString =
//                                             item.request == null
//                                                 ? ""
//                                                 : item.request.service.media;
//                                         List<String> imageList =
//                                             imagesString.split(',');
//                                         return Column(
//                                           children: [
//                                             jobWidget(
//                                               context,
//                                               image: AppUrls.mediaImages +
//                                                   imageList[0],
//                                               title: item.request.service
//                                                   .serviceName, // Using null-aware operators to avoid runtime errors
//                                               contactDetail:
//                                                   item.provider.email,
//                                               clientName:
//                                                   item.provider.fullname,
//                                               location: item.request.address,
//                                               description:
//                                                   item.request.description,
//                                               clientDate: item.request.date,
//                                               clientTime: item.request.time,
//                                               requestTime: requestTime,
//                                               requestDate: requestDate,
//                                               // detailTap: (){
//                                               //   Get.toNamed(kJobDetailScreen, arguments: item.id );
//                                               // }
//                                             ),
//                                             const SizedBox(height: 20),
//                                           ],
//                                         );
//                                       }),
//                                 )
//                               : const SizedBox(),
//                         ],
//                       ),
//                     ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget topContainer(
//       {String? text,
//       Color? textColor,
//       Color? borderColor,
//       VoidCallback? onTap}) {
//     return InkWell(
//       borderRadius: BorderRadius.circular(30),
//       onTap: onTap,
//       child: Container(
//         decoration: BoxDecoration(
//           border: Border.all(color: borderColor!),
//           borderRadius: BorderRadius.circular(30),
//         ),
//         padding: const EdgeInsets.only(top: 8, bottom: 8, left: 2, right: 2),
//         child: Center(
//           child: customText(text: text, color: textColor, fontSize: 10),
//         ),
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:property_app/controllers/jobs_controller/jobs_screen_controller.dart';

import '../../app_constants/app_sizes.dart';
import '../../app_constants/color_constants.dart';
import '../../constant_widget/constant_widgets.dart';
import '../../models/propert_model/service_job_status.dart';
import '../../route_management/constant_routes.dart';
import '../../utils/api_urls.dart';

class JobsScreen extends GetView<JobScreenController> { // Changed to JobListController
  final bool isBack;
  const JobsScreen({super.key, required this.isBack});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: homeAppBar(
        context,
        text: "Jobs",
        isBack: false,
        back: isBack,
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            controller.pendingJobController.itemList!.clear();
            controller.completedJobController.itemList!.clear();
            controller.rejectedJobController.itemList!.clear();
            //controller.acceptedJobController.itemList!.clear(); // Clear accepted jobs
           // controller.cancelledJobController.itemList!.clear(); // Clear cancelled jobs
            await Future.microtask(() => controller.getServiceJobs(1, 'pending')); // Default to pending
          },
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Obx(
                  () => controller.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: topContainer(
                            onTap: () {
                              controller.pending.value = true;
                              controller.completed.value = false;
                              controller.reject.value = false;
                              // controller.accepted.value = false; // Reset accepted
                              // controller.cancelled.value = false; // Reset cancelled
                              controller.pendingJobController.itemList!.clear();
                              controller.completedJobController.itemList!.clear();
                              controller.rejectedJobController.itemList!.clear();
                              // controller.acceptedJobController.itemList!.clear(); // Clear accepted
                              // controller.cancelledJobController.itemList!.clear(); // Clear cancelled
                              controller.getServiceJobs(1, 'pending'); // Pass status
                            },
                            text:
                            "Pending(${controller.pendingJobController.itemList?.length ?? 0})",
                            textColor: controller.pending.value
                                ? primaryColor
                                : greyColor,
                            borderColor: controller.pending.value
                                ? primaryColor
                                : greyColor,
                          ),
                        ),
                        w10,
                        Expanded(
                          child: topContainer(
                            onTap: () {
                              controller.pending.value = false;
                              controller.completed.value = true;
                              controller.reject.value = false;
                              // controller.accepted.value = false; // Reset accepted
                              // controller.cancelled.value = false; // Reset cancelled
                              controller.pendingJobController.itemList!.clear();
                              controller.completedJobController.itemList!.clear();
                              controller.rejectedJobController.itemList!.clear();
                              // controller.acceptedJobController.itemList!.clear(); // Clear accepted
                              // controller.cancelledJobController.itemList!.clear(); // Clear cancelled
                              controller.getServiceJobs(1, 'completed'); // Pass status
                            },
                            text:
                            "Completed(${controller.completedJobController.itemList?.length ?? 0})",
                            textColor: controller.completed.value
                                ? primaryColor
                                : greyColor,
                            borderColor: controller.completed.value
                                ? primaryColor
                                : greyColor,
                          ),
                        ),
                        w10,
                        Expanded(
                          child: topContainer(
                            onTap: () {
                              controller.pending.value = false;
                              controller.completed.value = false;
                              controller.reject.value = true;
                              // controller.accepted.value = false; // Reset accepted
                              // controller.cancelled.value = false; // Reset cancelled
                              controller.pendingJobController.itemList!.clear();
                              controller.completedJobController.itemList!.clear();
                              controller.rejectedJobController.itemList!.clear();
                              // controller.acceptedJobController.itemList!.clear(); // Clear accepted
                              // controller.cancelledJobController.itemList!.clear(); // Clear cancelled
                              controller.getServiceJobs(1, 'rejected'); // Pass status
                            },
                            text:
                            "Rejected(${controller.rejectedJobController.itemList?.length ?? 0})",
                            textColor: controller.reject.value
                                ? primaryColor
                                : greyColor,
                            borderColor: controller.reject.value
                                ? primaryColor
                                : greyColor,
                          ),
                        ),
                        w10,
                        // Expanded(
                        //   child: topContainer(
                        //     onTap: () {
                        //       controller.pending.value = false;
                        //       controller.completed.value = false;
                        //       controller.reject.value = false;
                        //       controller.accepted.value = true; // Set accepted
                        //       controller.cancelled.value = false; // Reset cancelled
                        //       controller.pendingJobController.itemList!.clear();
                        //       controller.completedJobController.itemList!.clear();
                        //       controller.rejectedJobController.itemList!.clear();
                        //       controller.acceptedJobController.itemList!.clear(); // Clear accepted
                        //       controller.cancelledJobController.itemList!.clear(); // Clear cancelled
                        //       controller.getServiceJobs(1, 'accepted'); // Pass status
                        //     },
                        //     text:
                        //     "Accepted(${controller.acceptedJobController.itemList?.length ?? 0})",
                        //     textColor: controller.accepted.value
                        //         ? primaryColor
                        //         : greyColor,
                        //     borderColor: controller.accepted.value
                        //         ? primaryColor
                        //         : greyColor,
                        //   ),
                        // ),
                        // w10,
                        // Expanded(
                        //   child: topContainer(
                        //     onTap: () {
                        //       controller.pending.value = false;
                        //       controller.completed.value = false;
                        //       controller.reject.value = false;
                        //       controller.accepted.value = false; // Reset accepted
                        //       controller.cancelled.value = true; // Set cancelled
                        //       controller.pendingJobController.itemList!.clear();
                        //       controller.completedJobController.itemList!.clear();
                        //       controller.rejectedJobController.itemList!.clear();
                        //       controller.acceptedJobController.itemList!.clear(); // Clear accepted
                        //       controller.cancelledJobController.itemList!.clear(); // Clear cancelled
                        //       controller.getServiceJobs(1, 'cancelled'); // Pass status
                        //     },
                        //     text:
                        //     "Cancelled(${controller.cancelledJobController.itemList?.length ?? 0})",
                        //     textColor: controller.cancelled.value
                        //         ? primaryColor
                        //         : greyColor,
                        //     borderColor: controller.cancelled.value
                        //         ? primaryColor
                        //         : greyColor,
                        //   ),
                        // ),
                      ],
                    ),
                    h15,
                    // jobWidget(context, ),

                    controller.pending.value
                        ? PagedListView<int, Job>( // Changed to Job
                      shrinkWrap: true,
                      pagingController: controller.pendingJobController,
                      physics: const BouncingScrollPhysics(),
                      builderDelegate:
                      PagedChildBuilderDelegate<Job>( // Changed to Job
                        firstPageErrorIndicatorBuilder: (context) =>
                            MaterialButton(
                              child: const Text(
                                  "No Data Found, Tap to try again."),
                              onPressed: () => controller
                                  .pendingJobController
                                  .refresh(),
                            ),
                        newPageErrorIndicatorBuilder: (context) =>
                            MaterialButton(
                              child: const Text(
                                  "Failed to load more items. Tap to try again."),
                              onPressed: () => controller
                                  .pendingJobController
                                  .retryLastFailedRequest(),
                            ),
                        itemBuilder: (context, item, index) {
                          // Handle null createdAt safely

                          print("Pending Item $index: $item"); // Debugging line

                          DateTime? createdAt = item.createdAt;
                          String requestDate = createdAt != null
                              ? DateFormat('dd-M-yy')
                              .format(createdAt)
                              : 'N/A'; // Fallback if createdAt is null
                          String requestTime = createdAt != null
                              ? DateFormat('h:mm a')
                              .format(createdAt)
                              : 'N/A'; // Fallback if createdAt is null

                          return Column(
                            children: [
                              jobWidget(
                                context,
                                image: item.serviceImages.isNotEmpty ?
                                    item.serviceImages[0] : "https://tse2.mm.bing.net/th?id=OIP.t9Ra4_Fudgqfn9B_hCFuOAHaE7&pid=Api", // Use serviceImages and fallback
                                title: item.serviceName ?? 'No Service Name', // Null check serviceName directly
                                contactDetail: item.user.email ?? 'No Email', // Access user.email
                                clientName: item.user.fullName ?? 'No Client Name', // Access user.fullName
                                location: item.location ?? 'No Location', // Use location directly
                                description: item.description ?? 'No Description', // Use description directly
                                clientDate: requestDate, // Use formatted requestDate
                                clientTime: requestTime, // Use formatted requestTime
                                requestTime: requestTime,
                                requestDate: requestDate,
                                detailTap: () {
                                  print(item.id);
                                  Get.toNamed(kJobDetailScreen,
                                      arguments: item.id);
                                },
                              ),
                              const SizedBox(height: 20),
                            ],
                          );
                        },
                      ),
                    )
                        : const SizedBox(),

                    controller.completed.value
                        ? PagedListView<int, Job>( // Changed to Job
                      shrinkWrap: true,
                      pagingController:
                      controller.completedJobController,
                      physics: const BouncingScrollPhysics(),
                      builderDelegate: PagedChildBuilderDelegate<
                          Job>( // Changed to Job
                          firstPageErrorIndicatorBuilder:
                              (context) => MaterialButton(
                            child: const Text(
                                "No Data Found, Tap to try again."),
                            onPressed: () => controller
                                .completedJobController
                                .refresh(),
                          ),
                          newPageErrorIndicatorBuilder: (context) =>
                              MaterialButton(
                                child: const Text(
                                    "Failed to load more items. Tap to try again."),
                                onPressed: () => controller
                                    .completedJobController
                                    .retryLastFailedRequest(),
                              ),
                          itemBuilder: (context, item, index) {
                            DateTime? createdAt = item.createdAt;
                            String requestDate = createdAt != null
                                ? DateFormat('dd-M-yy').format(createdAt)
                                : 'N/A'; // Adjust the pattern as needed
                            String requestTime = createdAt != null
                                ? DateFormat('h:mm a')
                                .format(createdAt)
                                : 'N/A';
                            return Column(
                              children: [
                                jobWidget(
                                  context,
                                  image: item.serviceImages.isNotEmpty ?
                                  item.serviceImages[0] : "https://tse2.mm.bing.net/th?id=OIP.t9Ra4_Fudgqfn9B_hCFuOAHaE7&pid=Api", // Use serviceImages and fallback
                                  title: item.serviceName ?? 'No Service Name', // Null check serviceName directly
                                  contactDetail: item.user.email ?? 'No Email', // Access user.email
                                  clientName: item.user.fullName ?? 'No Client Name', // Access user.fullName
                                  location: item.location ?? 'No Location', // Use location directly
                                  description: item.description ?? 'No Description', // Use description directly
                                  clientDate: requestDate, // Use formatted requestDate
                                  clientTime: requestTime, // Use formatted requestTime
                                  requestTime: requestTime,
                                  requestDate: requestDate,
                                  // detailTap: (){
                                  //   Get.toNamed(kJobDetailScreen, arguments: item.id );
                                  // }
                                ),
                                const SizedBox(height: 20),
                              ],
                            );
                          }),
                    )
                        : const SizedBox(),

                    controller.reject.value
                        ? PagedListView<int, Job>( // Changed to Job
                      shrinkWrap: true,
                      pagingController:
                      controller.rejectedJobController,
                      physics: const BouncingScrollPhysics(),
                      builderDelegate: PagedChildBuilderDelegate<
                          Job>( // Changed to Job
                          firstPageErrorIndicatorBuilder:
                              (context) => MaterialButton(
                            child: const Text(
                                "No Data Found, Tap to try again."),
                            onPressed: () => controller
                                .rejectedJobController
                                .refresh(),
                          ),
                          newPageErrorIndicatorBuilder: (context) =>
                              MaterialButton(
                                child: const Text(
                                    "Failed to load more items. Tap to try again."),
                                onPressed: () => controller
                                    .rejectedJobController
                                    .retryLastFailedRequest(),
                              ),
                          itemBuilder: (context, item, index) {
                            DateTime? createdAt = item.createdAt;
                            String requestDate = createdAt != null
                                ? DateFormat('dd-M-yy').format(createdAt)
                                : 'N/A'; // Adjust the pattern as needed
                            String requestTime = createdAt != null
                                ? DateFormat('h:mm a')
                                .format(createdAt)
                                : 'N/A';
                            return Column(
                              children: [
                                jobWidget(
                                  context,
                                  image: item.serviceImages.isNotEmpty ?
                                  item.serviceImages[0] : "https://tse2.mm.bing.net/th?id=OIP.t9Ra4_Fudgqfn9B_hCFuOAHaE7&pid=Api", // Use serviceImages and fallback
                                  title: item.serviceName ?? 'No Service Name', // Null check serviceName directly
                                  contactDetail: item.user.email ?? 'No Email', // Access user.email
                                  clientName: item.user.fullName ?? 'No Client Name', // Access user.fullName
                                  location: item.location ?? 'No Location', // Use location directly
                                  description: item.description ?? 'No Description', // Use description directly
                                  clientDate: requestDate, // Use formatted requestDate
                                  clientTime: requestTime, // Use formatted requestTime
                                  requestTime: requestTime,
                                  requestDate: requestDate,
                                  // detailTap: (){
                                  //   Get.toNamed(kJobDetailScreen, arguments: item.id );
                                  // }
                                ),
                                const SizedBox(height: 20),
                              ],
                            );
                          }),
                    )
                        : const SizedBox(),

                    // controller.accepted.value
                    //     ? PagedListView<int, Job>( // Changed to Job
                    //   shrinkWrap: true,
                    //   pagingController:
                    //   controller.acceptedJobController,
                    //   physics: const BouncingScrollPhysics(),
                    //   builderDelegate: PagedChildBuilderDelegate<
                    //       Job>( // Changed to Job
                    //       firstPageErrorIndicatorBuilder:
                    //           (context) => MaterialButton(
                    //         child: const Text(
                    //             "No Data Found, Tap to try again."),
                    //         onPressed: () => controller
                    //             .acceptedJobController
                    //             .refresh(),
                    //       ),
                    //       newPageErrorIndicatorBuilder: (context) =>
                    //           MaterialButton(
                    //             child: const Text(
                    //                 "Failed to load more items. Tap to try again."),
                    //             onPressed: () => controller
                    //                 .acceptedJobController
                    //                 .retryLastFailedRequest(),
                    //           ),
                    //       itemBuilder: (context, item, index) {
                    //         DateTime? createdAt = item.createdAt;
                    //         String requestDate = createdAt != null
                    //             ? DateFormat('dd-M-yy').format(createdAt)
                    //             : 'N/A'; // Adjust the pattern as needed
                    //         String requestTime = createdAt != null
                    //             ? DateFormat('h:mm a')
                    //             .format(createdAt)
                    //             : 'N/A';
                    //         return Column(
                    //           children: [
                    //             jobWidget(
                    //               context,
                    //               image: item.serviceImages.isNotEmpty ? AppUrls.mediaImages +
                    //                   item.serviceImages[0] : 'fallback_image_path', // Use serviceImages and fallback
                    //               title: item.serviceName ?? 'No Service Name', // Null check serviceName directly
                    //               contactDetail: item.user.email ?? 'No Email', // Access user.email
                    //               clientName: item.user.fullName ?? 'No Client Name', // Access user.fullName
                    //               location: item.location ?? 'No Location', // Use location directly
                    //               description: item.description ?? 'No Description', // Use description directly
                    //               clientDate: requestDate, // Use formatted requestDate
                    //               clientTime: requestTime, // Use formatted requestTime
                    //               requestTime: requestTime,
                    //               requestDate: requestDate,
                    //               // detailTap: (){
                    //               //   Get.toNamed(kJobDetailScreen, arguments: item.id );
                    //               // }
                    //             ),
                    //             const SizedBox(height: 20),
                    //           ],
                    //         );
                    //       }),
                    // )
                    //     : const SizedBox(),
                    //
                    // controller.cancelled.value
                    //     ? PagedListView<int, Job>( // Changed to Job
                    //   shrinkWrap: true,
                    //   pagingController:
                    //   controller.cancelledJobController,
                    //   physics: const BouncingScrollPhysics(),
                    //   builderDelegate: PagedChildBuilderDelegate<
                    //       Job>( // Changed to Job
                    //       firstPageErrorIndicatorBuilder:
                    //           (context) => MaterialButton(
                    //         child: const Text(
                    //             "No Data Found, Tap to try again."),
                    //         onPressed: () => controller
                    //             .cancelledJobController
                    //             .refresh(),
                    //       ),
                    //       newPageErrorIndicatorBuilder: (context) =>
                    //           MaterialButton(
                    //             child: const Text(
                    //                 "Failed to load more items. Tap to try again."),
                    //             onPressed: () => controller
                    //                 .cancelledJobController
                    //                 .retryLastFailedRequest(),
                    //           ),
                    //       itemBuilder: (context, item, index) {
                    //         DateTime? createdAt = item.createdAt;
                    //         String requestDate = createdAt != null
                    //             ? DateFormat('dd-M-yy').format(createdAt)
                    //             : 'N/A'; // Adjust the pattern as needed
                    //         String requestTime = createdAt != null
                    //             ? DateFormat('h:mm a')
                    //             .format(createdAt)
                    //             : 'N/A';
                    //         return Column(
                    //           children: [
                    //             jobWidget(
                    //               context,
                    //               image: item.serviceImages.isNotEmpty ? AppUrls.mediaImages +
                    //                   item.serviceImages[0] : 'fallback_image_path', // Use serviceImages and fallback
                    //               title: item.serviceName ?? 'No Service Name', // Null check serviceName directly
                    //               contactDetail: item.user.email ?? 'No Email', // Access user.email
                    //               clientName: item.user.fullName ?? 'No Client Name', // Access user.fullName
                    //               location: item.location ?? 'No Location', // Use location directly
                    //               description: item.description ?? 'No Description', // Use description directly
                    //               clientDate: requestDate, // Use formatted requestDate
                    //               clientTime: requestTime, // Use formatted requestTime
                    //               requestTime: requestTime,
                    //               requestDate: requestDate,
                    //               // detailTap: (){
                    //               //   Get.toNamed(kJobDetailScreen, arguments: item.id );
                    //               // }
                    //             ),
                    //             const SizedBox(height: 20),
                    //           ],
                    //         );
                    //       }),
                    // )
                    //     : const SizedBox(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget topContainer(
      {String? text,
        Color? textColor,
        Color? borderColor,
        VoidCallback? onTap}) {
    return InkWell(
      borderRadius: BorderRadius.circular(30),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: borderColor!),
          borderRadius: BorderRadius.circular(30),
        ),
        padding: const EdgeInsets.only(top: 8, bottom: 8, left: 2, right: 2),
        child: Center(
          child: customText(text: text, color: textColor, fontSize: 10),
        ),
      ),
    );
  }
}