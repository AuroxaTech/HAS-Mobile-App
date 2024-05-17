import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:property_app/app_constants/app_sizes.dart';
import 'package:property_app/app_constants/color_constants.dart';
import 'package:property_app/constant_widget/constant_widgets.dart';
import 'package:property_app/utils/api_urls.dart';
import '../../app_constants/app_icon.dart';
import '../../controllers/services_provider_controller/my_favourite_screen_controller.dart';
import '../../models/service_provider_model/favorite_provider.dart';
import '../../route_management/constant_routes.dart';

class MyFavouriteScreen extends GetView<MyFavouriteScreenController> {
  const MyFavouriteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
        backgroundColor: whiteColor,
        appBar: homeAppBar(
          context, text: "My Favourites",
        ),
        body:  SafeArea(
          child:  Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [

                Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[100], // Background color of the tab bar
                      borderRadius: BorderRadius.circular(50.0),
                      border: Border.all(color: borderColor)
                    ),
                    child: Row(
                      children: [
                        for (int i = 0; i < 2; i++)
                          Expanded(
                            child: InkWell(
                              highlightColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              onTap: () {
                                controller.tabController.animateTo(i);
                                controller.selectedIndex.value = i;
                              },
                              child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 10), // Padding for the tab
                                  alignment: Alignment.center,
                                  child: Column(
                                    children: [
                                      Container(
                                        width: 10,
                                        height: 10,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: controller.selectedIndex.value == i ?   Colors.blue : Colors.transparent
                                        ),
                                      ),
                                      h5,
                                      customText(
                                        text :  i == 0 ? 'Service Providers' : 'Properties',
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: controller.selectedIndex.value == i
                                        ? FontWeight.w600 : FontWeight.w400,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                      ],
                    ),
                ),
                h20,
               Expanded(
                      child: TabBarView(
                          controller: controller.tabController,
                          children: [
                            Stack(
                              children: [
                                RefreshIndicator(
                                  onRefresh: ()async{
                                    controller.pagingController.itemList!.clear();
                                    return controller.getFavorite(1);
                                  },
                                  child: PagedListView<int, FavoriteService>(
                                    shrinkWrap: true,
                                    pagingController: controller.pagingController,
                                    builderDelegate: PagedChildBuilderDelegate<FavoriteService>(
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
                                          print(item.service!.id);
                                          return Padding(
                                            padding: const EdgeInsets.only(top: 15),
                                            child: InkWell(
                                              onTap: (){
                                                Get.toNamed(kServiceListingScreenDetail, arguments: [item.service!.id, imageList],);
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
                                                                  child: CachedNetworkImage(
                                                                    imageUrl:AppUrls.mediaImages + imageList[0],
                                                                    width: 60,
                                                                    height: 70,
                                                                    fit: BoxFit.cover,
                                                                    errorWidget: (context, data , d){
                                                                      return Image.asset(AppIcons.appLogo);
                                                                    },
                                                                  ),
                                                                ),
                                                                w20,
                                                                Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Container(
                                                                      width : 150,
                                                                      child: customText(
                                                                        text: item.service!.serviceName,
                                                                        fontSize: 20,

                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                            IconButton(
                                                              icon: const Icon(
                                                                Icons.favorite,
                                                                color:  Colors.red,
                                                              ),
                                                              onPressed: () {
                                                                // controller.getServices();
                                                                controller.toggleFavoriteStatus(
                                                                  serviceId: item.serviceId.toString(),
                                                                  isFavorite: false,
                                                                ).then((value){
                                                                  List<FavoriteService> newList = List.from(controller.pagingController.itemList!);
                                                                  newList.removeAt(index);

                                                                  // Update the pagination controller's item list
                                                                  controller.pagingController.itemList = newList;    });
                                                              },
                                                            )
                                                          ],
                                                        ),
                                                        h15,
                                                        customText(
                                                            text: "Main Services Offered :",
                                                            fontSize: 16,
                                                            color: Colors.black54
                                                        ),
                                                        h5,
                                                        customText(
                                                          text: "${item.service!.additionalInformation }"?? "",
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
                                                                    color: Colors.black54
                                                                ),
                                                                Image.asset(AppIcons.clockDuration),
                                                              ],
                                                            ),
                                                            Row(
                                                              children: [
                                                                customText(
                                                                    text: "Service  ",
                                                                    fontSize: 16,
                                                                    color: Colors.black54
                                                                ),
                                                                SvgPicture.asset(AppIcons.locationRed),
                                                              ],
                                                            ),
                                                            w30
                                                          ],
                                                        ),
                                                        h10,
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            customText(
                                                                text: "${item.service!.startTime}  ${item.service!.endTime}",
                                                                fontSize: 16,
                                                                color: blackColor
                                                            ),
                                                            customText(
                                                                text: item.service!.location,
                                                                fontSize: 16,
                                                                color: blackColor
                                                            ),
                                                            w30
                                                          ],
                                                        ),
                                                        h10,
                                                        customText(
                                                            text: "Description :",
                                                            fontSize: 16,
                                                            color: Colors.black54
                                                        ),
                                                        h10,
                                                        customText(
                                                            text: item.service!.description,
                                                            fontSize: 14,
                                                            color: Colors.black54
                                                        ),
                                                        h10,
                                                        // Row(
                                                        //   children: [
                                                        //     Expanded(
                                                        //       child: CustomButton(
                                                        //         height: screenHeight(context) * 0.06,
                                                        //         text: "Contact",
                                                        //         fontSize: 18,
                                                        //         gradientColor: yellowGradient(),
                                                        //         onTap: (){
                                                        //           Get.toNamed(kChatConversionScreen);
                                                        //         },
                                                        //       ),
                                                        //     ),
                                                        //     w15,
                                                        //     Expanded(
                                                        //       child: CustomButton(
                                                        //         height: screenHeight(context) * 0.06,
                                                        //         text: "Book Service",
                                                        //         fontSize: 18,
                                                        //         gradientColor: gradient(),
                                                        //         onTap: (){
                                                        //           Get.toNamed(kNewServiceRequestScreen, arguments: [
                                                        //             (item.serviceName) , item.user== null ? "" : item.user!.email, (item.description) , item.userId,
                                                        //             item.id,  imageList[0]
                                                        //           ]);
                                                        //         },
                                                        //       ),
                                                        //     ),
                                                        //   ],
                                                        // )
                                                      ],
                                                    ),
                                                  )),
                                            ),
                                          );
                                        }
                                    ),
                                  ),
                                  // child: PagedListView<int, FavoriteService>(
                                  //   shrinkWrap: true,
                                  //   pagingController: controller.pagingController,
                                  //   builderDelegate: PagedChildBuilderDelegate<FavoriteService>(
                                  //       firstPageErrorIndicatorBuilder: (context) => MaterialButton(
                                  //         child: const Text("No Data Found, Tap to try again."),
                                  //         onPressed: () => controller.pagingController.refresh(),
                                  //       ),
                                  //       newPageErrorIndicatorBuilder: (context) => MaterialButton(
                                  //         child: const Text("Failed to load more items. Tap to try again."),
                                  //         onPressed: () => controller.pagingController.retryLastFailedRequest(),
                                  //       ),
                                  //       itemBuilder: (context, item, index) {
                                  //         String imagesString = item.service == null ? "" : item.service!.media.toString();
                                  //         List<String> imageList = imagesString.split(',');
                                  //         print(item.service!.id);
                                  //         return myPropertyFav(
                                  //             context,
                                  //             onTap: (){
                                  //               // Get.toNamed(kPropertyDetailScreen);
                                  //             },
                                  //             title: item.service == null ? "" : item.service!.serviceName,
                                  //             image: (item.service?.media != null && imageList.isNotEmpty)
                                  //                 ? AppUrls.mediaImages + imageList[0]
                                  //                 : "",
                                  //             price: "\$${item.service == null ? "" : item.service!.pricing}",
                                  //             description: item.service == null ? "" :  item.service!.description,
                                  //             bedroom: "7",
                                  //             bathroom: "5",
                                  //             marla: "5 marla",
                                  //             rent: "Sale",
                                  //             isFavorite: true,
                                  //             onFavoriteTap: (){
                                  //               controller.toggleFavoriteStatus(
                                  //                 serviceId: item.serviceId.toString(),
                                  //                 isFavorite: false,
                                  //               );
                                  //             }
                                  //
                                  //         );
                                  //       }
                                  //   ),
                                  // ),
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

                             //  controller.isLoading.value ? const Center(child: CircularProgressIndicator()) :
                             //  controller.favoriteServiceProviders.isEmpty ?
                             //  const Center(child: Text('No Services favorite')) :
                             // ListView.builder(
                             //      shrinkWrap: true,
                             //      itemCount : controller.favoriteServiceProviders.length,
                             //      itemBuilder: (BuildContext context, int index) {
                             //        String imagesString = controller.favoriteServiceProviders[index].service == null ? "" : controller.favoriteServiceProviders[index].service!.media.toString();
                             //        List<String> imageList = imagesString.split(',');
                             //        print(controller.favoriteServiceProviders[index].service!.id);
                             //        return myPropertyFav(
                             //          context,
                             //          onTap: (){
                             //            // Get.toNamed(kPropertyDetailScreen);
                             //          },
                             //          title: controller.favoriteServiceProviders[index].service == null ? "" : controller.favoriteServiceProviders[index].service!.serviceName,
                             //          image: (controller.favoriteServiceProviders[index].service?.media != null && imageList.isNotEmpty)
                             //              ? AppUrls.mediaImages + imageList[0]
                             //              : "",
                             //          price: "\$${controller.favoriteServiceProviders[index].service == null ? "" : controller.favoriteServiceProviders[index].service!.pricing}",
                             //          description: controller.favoriteServiceProviders[index].service == null ? "" :  controller.favoriteServiceProviders[index].service!.description,
                             //          bedroom: "7",
                             //          bathroom: "5",
                             //          marla: "5 marla",
                             //          rent: "Sale",
                             //          isFavorite: true,
                             //          onFavoriteTap: (){
                             //
                             //            controller.toggleFavoriteStatus(
                             //              serviceId: controller.favoriteServiceProviders[index].serviceId.toString(),
                             //              isFavorite: false,
                             //            );
                             //
                             //          }
                             //
                             //        );
                             //      },
                             //
                             //    ),

                            Stack(
                              children: [
                                  RefreshIndicator(
                                  onRefresh: ()async{
                                    controller.propertyPagingController.itemList!.clear();
                                    return controller.getPropertyFav(1);
                                  },
                                  child: PagedListView<int, FavoriteProperty>(
                                    shrinkWrap: true,
                                    pagingController: controller.propertyPagingController,
                                    builderDelegate: PagedChildBuilderDelegate<FavoriteProperty>(
                                        firstPageErrorIndicatorBuilder: (context) => MaterialButton(
                                          child: const Text("No Data Found, Tap to try again."),
                                          onPressed: () => controller.pagingController.refresh(),
                                        ),
                                        newPageErrorIndicatorBuilder: (context) => MaterialButton(
                                          child: const Text("Failed to load more items. Tap to try again."),
                                          onPressed: () => controller.pagingController.retryLastFailedRequest(),
                                        ),
                                        itemBuilder: (context, item, index) {
                                          String imagesString = item.property == null ? "" : item.property!.images.toString();
                                          List<String> imageList = imagesString.split(',');
                                          if (item.property != null) {
                                            print(item.property!.id);
                                            print( item.id);
                                          }
                                          return Column(
                                            children: [


                                              myPropertyFav(
                                                  context,
                                                  onTap: (){
                                                    Get.toNamed(kAllPropertyDetailScreen, arguments: item.property!.id);
                                                  },
                                                  title: item.property == null ? "" : item.property!.city.toString(),
                                                  image: AppUrls.propertyImages + imageList[0],
                                                  price: "\$${item.property == null ? "" : item.property!.amount}",
                                                  description: item.property == null ? "" :  item.property!.description.toString(),
                                                  bedroom:  item.property == null ? "" :  item.property!.bedroom.toString(),
                                                  bathroom:  item.property == null ? "" :  item.property!.bathroom.toString(),
                                                  marla:  item.property == null ? "" :  item.property!.areaRange.toString(),
                                                  rent: item.property == null ? "" :  item.property!.type == "1" ? "Sale" : "Rent",
                                                  isFavorite: true,
                                                  onFavoriteTap: (){
                                                    controller.toggleFavoritePropertyStatus(
                                                      propertyId: item.propertyId.toString(),
                                                      isFavorite: false,
                                                    ).then((value) {
                                                      List<FavoriteProperty> newList = List.from(controller.propertyPagingController.itemList!);
                                                      newList.removeAt(index);
                                                      // Update the pagination controller's item list
                                                      controller.propertyPagingController.itemList = newList;
                                                    });
                                                  }

                                              ),
                                              const SizedBox(
                                                height: 20,
                                              )
                                            ],
                                          );
                                        }
                                    ),
                                  ),
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

                            // ListView.builder(
                            //   shrinkWrap: true,
                            //   itemCount : controller.favoriteProperties.length,
                            //   itemBuilder: (BuildContext context, int index) {
                            //     String imagesString = controller.favoriteProperties[index].property == null ? "" : controller.favoriteServiceProviders[index].service!.media.toString();
                            //     List<String> imageList = imagesString.split(',');
                            //     print(controller.favoriteProperties[index].property!.id);
                            //     return myPropertyFav(
                            //         context,
                            //         onTap: (){
                            //           // Get.toNamed(kPropertyDetailScreen);
                            //         },
                            //         title: controller.favoriteProperties[index].property == null ? "" : controller.favoriteServiceProviders[index].service!.serviceName,
                            //         image: (controller.favoriteProperties[index].property?.media != null && imageList.isNotEmpty)
                            //             ? AppUrls.mediaImages + imageList[0]
                            //             : "",
                            //         price: "\$${controller.favoriteProperties[index].property == null ? "" : controller.favoriteServiceProviders[index].service!.pricing}",
                            //         description: controller.favoriteProperties[index].property == null ? "" :  controller.favoriteServiceProviders[index].service!.description,
                            //         bedroom: "7",
                            //         bathroom: "5",
                            //         marla: "5 marla",
                            //         rent: "Sale",
                            //         isFavorite: true,
                            //         onFavoriteTap: (){
                            //          controller.toggleFavoritePropertyStatus(
                            //             serviceId: controller.favoriteProperties[index].propertyId.toString(),
                            //             isFavorite: false,
                            //          );
                            //        }
                            //     );
                            //   },
                            //
                            // ),
                          ],
                      ),
                   ),

              ],
            ),
          ),

      ),
      ),
    );
  }
}
