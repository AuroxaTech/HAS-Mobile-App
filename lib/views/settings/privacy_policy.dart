import 'package:flutter/material.dart';
import 'package:property_app/constant_widget/constant_widgets.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({super.key});

  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  PdfViewerController viewerController = PdfViewerController();
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: homeAppBar(context, text: "Privacy Policy"),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SfPdfViewer.asset(
                key: _pdfViewerKey,
                onTap: (va){
                  // Get.to(() => PdfViewerScreen(pdfUrl: widget.document['filePath'],));
                },
                initialZoomLevel: 1.5,
                initialScrollOffset: Offset.fromDirection(10),
                controller: viewerController,
                pageSpacing: 10,
                "assets/animation/policy.pdf",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
