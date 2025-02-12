import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:property_app/models/propert_model/service_job_status.dart';

import '../../app_constants/app_sizes.dart';
import '../../app_constants/color_constants.dart';
import '../../constant_widget/constant_widgets.dart';
import '../../controllers/jobs_controller/jobs_screen_controller.dart';
import '../../route_management/constant_routes.dart';
import '../../utils/api_urls.dart';

class JobsScreen extends GetView<JobScreenController> {
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
            await Future.microtask(() => controller.getServiceJobs(1));
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
                                    controller.pendingJobController.itemList!
                                        .clear();
                                    controller.completedJobController.itemList!
                                        .clear();
                                    controller.rejectedJobController.itemList!
                                        .clear();
                                    controller.getServiceJobs(1);
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
                                    controller.pendingJobController.itemList!
                                        .clear();
                                    controller.completedJobController.itemList!
                                        .clear();
                                    controller.rejectedJobController.itemList!
                                        .clear();
                                    controller.getServiceJobs(1);
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
                                    controller.pendingJobController.itemList!
                                        .clear();
                                    controller.completedJobController.itemList!
                                        .clear();
                                    controller.rejectedJobController.itemList!
                                        .clear();
                                    controller.getServiceJobs(1);
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
                            ],
                          ),
                          h15,
                          // jobWidget(context, ),

                          controller.pending.value
                              ? PagedListView<int, PendingJob>(
                                  shrinkWrap: true,
                                  pagingController:
                                      controller.pendingJobController,
                                  physics: const BouncingScrollPhysics(),
                                  builderDelegate:
                                      PagedChildBuilderDelegate<PendingJob>(
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
                                      DateTime? createdAt = item.createdAt;
                                      String requestDate = createdAt != null
                                          ? DateFormat('dd-M-yy')
                                              .format(createdAt)
                                          : 'N/A'; // Fallback if createdAt is null
                                      String requestTime = createdAt != null
                                          ? DateFormat('h:mm a')
                                              .format(createdAt)
                                          : 'N/A'; // Fallback if createdAt is null

                                      String imagesString = item.request == null
                                          ? ""
                                          : item.request.service.media;
                                      List<String> imageList =
                                          imagesString.split(',');

                                      return Column(
                                        children: [
                                          jobWidget(
                                            context,
                                            image: AppUrls.mediaImages +
                                                imageList[0],
                                            // Fallback for missing image
                                            title: item.request.service
                                                    .serviceName ??
                                                'No Service Name', // Null check for service name
                                            contactDetail: item
                                                    .provider.email ??
                                                'No Email', // Null check for email
                                            clientName: item
                                                    .provider.fullname ??
                                                'No Client Name', // Null check for client name
                                            location: item.request.address ??
                                                'No Address', // Null check for address
                                            description: item
                                                    .request.description ??
                                                'No Description', // Null check for description
                                            clientDate: item.request.date ??
                                                'No Date', // Null check for client date
                                            clientTime: item.request.time ??
                                                'No Time', // Null check for client time
                                            requestTime: requestTime,
                                            requestDate: requestDate,
                                            detailTap: () {
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
                              ? PagedListView<int, CompletedJob>(
                                  shrinkWrap: true,
                                  pagingController:
                                      controller.completedJobController,
                                  physics: const BouncingScrollPhysics(),
                                  builderDelegate: PagedChildBuilderDelegate<
                                          CompletedJob>(
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
                                        DateTime createdAt = item.createdAt;
                                        String requestDate =
                                            DateFormat('dd-M-yy').format(
                                                createdAt); // Adjust the pattern as needed
                                        String requestTime =
                                            DateFormat('h:mm a')
                                                .format(createdAt);
                                        String imagesString =
                                            item.request == null
                                                ? ""
                                                : item.request.service.media;
                                        List<String> imageList =
                                            imagesString.split(',');
                                        return Column(
                                          children: [
                                            jobWidget(
                                              context,
                                              image: AppUrls.mediaImages +
                                                  imageList[0],
                                              title: item.request.service
                                                  .serviceName, // Using null-aware operators to avoid runtime errors
                                              contactDetail:
                                                  item.provider.email,
                                              clientName:
                                                  item.provider.fullname,
                                              location: item.request.address,
                                              description:
                                                  item.request.description,
                                              clientDate: item.request.date,
                                              clientTime: item.request.time,
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
                              ? PagedListView<int, RejectedJob>(
                                  shrinkWrap: true,
                                  pagingController:
                                      controller.rejectedJobController,
                                  physics: const BouncingScrollPhysics(),
                                  builderDelegate: PagedChildBuilderDelegate<
                                          RejectedJob>(
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
                                        DateTime createdAt = item.createdAt;
                                        String requestDate =
                                            DateFormat('dd-M-yy').format(
                                                createdAt); // Adjust the pattern as needed
                                        String requestTime =
                                            DateFormat('h:mm a')
                                                .format(createdAt);
                                        String imagesString =
                                            item.request == null
                                                ? ""
                                                : item.request.service.media;
                                        List<String> imageList =
                                            imagesString.split(',');
                                        return Column(
                                          children: [
                                            jobWidget(
                                              context,
                                              image: AppUrls.mediaImages +
                                                  imageList[0],
                                              title: item.request.service
                                                  .serviceName, // Using null-aware operators to avoid runtime errors
                                              contactDetail:
                                                  item.provider.email,
                                              clientName:
                                                  item.provider.fullname,
                                              location: item.request.address,
                                              description:
                                                  item.request.description,
                                              clientDate: item.request.date,
                                              clientTime: item.request.time,
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
