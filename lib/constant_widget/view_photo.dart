import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:property_app/constant_widget/constant_widgets.dart';
import 'package:property_app/models/service_provider_model/all_services.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../models/propert_model/service_image_model.dart';

class ViewImage extends StatelessWidget {
  final String photo;
  const ViewImage({super.key, required this.photo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: titleAppBar("View Photo"),
        body: Center(
          child: PhotoView(
            imageProvider: NetworkImage(photo),
          ),
        ),

    );
  }
}

class ViewImages extends StatefulWidget {
  final List<String> photo;
  final int index;
  const ViewImages({super.key, required this.photo, required this.index});

  @override
  State<ViewImages> createState() => _ViewImagesState();
}

class _ViewImagesState extends State<ViewImages> {

  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: titleAppBar("View Photo"),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.horizontal,
            itemCount: widget.photo.length,
            itemBuilder: (context, index) {
              return CachedNetworkImage(
                imageUrl: widget.photo[index],
                fit: BoxFit.cover,
              );
            },
          ),
          Positioned(
            bottom: 30.0,
            child: SmoothPageIndicator(
              controller: _pageController,
              count: widget.photo.length,
              effect: WormEffect(
                dotHeight: 8.0,
                dotWidth: 8.0,
                spacing: 8.0,
                dotColor: Colors.grey,  // Inactive color
                activeDotColor: Colors.white,  // Active color
              ),
            ),
          ),
        ],
      ),

    );
  }
}

class ViewImagesModel extends StatefulWidget {
  final List<ServiceImage> photo;
  final int index;
  const ViewImagesModel({super.key, required this.photo, required this.index});

  @override
  State<ViewImagesModel> createState() => _ViewImagesModelState();
}

class _ViewImagesModelState extends State<ViewImagesModel> {

  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: titleAppBar("View Photo"),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.horizontal,
            itemCount: widget.photo.length,
            itemBuilder: (context, index) {
              return CachedNetworkImage(
                imageUrl: widget.photo[index].imagePath,
                fit: BoxFit.cover,
              );
            },
          ),
          Positioned(
            bottom: 30.0,
            child: SmoothPageIndicator(
              controller: _pageController,
              count: widget.photo.length,
              effect: WormEffect(
                dotHeight: 8.0,
                dotWidth: 8.0,
                spacing: 8.0,
                dotColor: Colors.grey,  // Inactive color
                activeDotColor: Colors.white,  // Active color
              ),
            ),
          ),
        ],
      ),

    );
  }
}