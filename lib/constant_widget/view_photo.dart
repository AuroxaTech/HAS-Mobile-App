import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:property_app/constant_widget/constant_widgets.dart';

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