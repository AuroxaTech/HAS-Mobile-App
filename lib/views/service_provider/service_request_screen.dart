import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:property_app/app_constants/color_constants.dart';
import 'package:property_app/constant_widget/constant_widgets.dart';
import 'package:property_app/route_management/constant_routes.dart';
import '../../controllers/services_provider_controller/service_request_cotroller.dart';
import '../../models/service_provider_model/service_request_model.dart';
import '../../utils/api_urls.dart';

class ServiceRequestScreen extends GetView<ServiceRequestController> {
  const ServiceRequestScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: homeAppBar(context, text: "Service Requests"),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: ()async{
            controller.pagingController.itemList!.clear();
             await controller.getServicesRequests(1);
          },
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: PagedListView<int, ServiceRequestProvider>(
              shrinkWrap: true,
              pagingController: controller.pagingController,
              builderDelegate: PagedChildBuilderDelegate<ServiceRequestProvider>(
                  firstPageErrorIndicatorBuilder: (context) => MaterialButton(
                    child: const Text("No Data Found, Tap to try again."),
                    onPressed: () => controller.pagingController.refresh(),
                  ),
                  newPageErrorIndicatorBuilder: (context) => MaterialButton(
                    child: const Text("Failed to load more items. Tap to try again."),
                    onPressed: () => controller.pagingController.retryLastFailedRequest(),
                  ),
                  itemBuilder: (context, item, index) {
                    String imagesString = item.service == null ? "" : item.service!.media.toString();
                    List<String> imageList = imagesString.split(',');
                    DateTime createdAt = item.createdAt;
                    String requestDate = DateFormat('dd-M-yy').format(createdAt); // Adjust the pattern as needed
                    String requestTime = DateFormat('h:mm a').format(createdAt);
                    return Column(
                      children: [
                        serviceRequestWidget(
                            context,
                            image: AppUrls.mediaImages + imageList[0],
                            title: item.service == null ? "" : item.service!.serviceName,
                            contactDetail: item.user.email,
                            clientName: item.user.fullname,
                            location:  item.address,
                            description: item.description,
                            requestDate: requestDate,
                            requestTime: requestTime,
                            status: item.description,
                            time: item.time,
                            date: item.date,
                            acceptTap: item.approved == "1" ? null :  (){
                              animatedDialog(context,
                                  title: "Accept Request",
                                  subTitle: "Are you sure to accept this request",
                                  yesButtonText: "Accept",
                                  yesTap: (){
                                    controller.acceptServiceRequest(
                                        requestId: item.id,
                                        userId: item.userId.toString(),
                                        providerId: item.serviceproviderId.toString()).then((value) {
                                      controller.getServicesRequests(1);
                                    });
                                  }


                              );
                            },
                            acceptColor:  item.approved == "1" ? const Color(0xff14C034).withOpacity(0.3) : Color(0xff14C034) ,
                            declineColor:  item.decline == "1" ? redColor.withOpacity(0.3) : redColor ,
                            onTap: (){
                              Get.toNamed(kServiceRequestDetailScreen, arguments: item.id);
                            },
                            detailTap: (){
                              Get.toNamed(kServiceRequestDetailScreen, arguments: item.id);
                            },
                            declineTap: item.decline == "1" ? null : (){
                              animatedDialog(context,
                                  title: "Decline Request",
                                  subTitle: "Are you sure to decline this request",
                                  yesButtonText: "Decline",
                                  yesTap: (){
                                    controller.declineServiceRequest(requestId: item.id).then((value) {
                                      controller.getServicesRequests(1);
                                    });
                                  }
                              );
                            }
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    );
                  }
              ),
            ),
          ),
        ),
          ),
    );
  }
}
