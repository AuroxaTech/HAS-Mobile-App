import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:property_app/app_constants/color_constants.dart';
import 'package:property_app/constant_widget/constant_widgets.dart';
import 'package:property_app/controllers/payment_controller/payment_screen_controller.dart';
import 'package:webview_flutter/webview_flutter.dart'; // Add webview package
import '../../app_constants/app_icon.dart';
import '../../app_constants/app_sizes.dart';

class PaymentsScreen extends GetView<PaymentScreenController> {
  const PaymentsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: titleAppBar("Payments", action: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
      ]),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final account = controller.stripeAccount.value?['account'];
        final status = account?['status'];

        if (controller.stripeAccount.value == null || controller.stripeAccount.value?['error'] != null) {
          // No Stripe account connected
          return _buildConnectStripeSection(controller);
        } else if (status == 'pending') {
          // Stripe account connected but not completed
          return _buildConnectStripeSection(controller, pending: true);
        } else if (status == 'active') {
          // Stripe account fully active
          return _buildActiveStripeInfo(account);
        }

        return const Center(child: Text("Unknown Stripe status"));
      }),
    );
  }

  Widget _buildConnectStripeSection(PaymentScreenController controller, {bool pending = false}) {
    return Column(
      children: [
        const SizedBox(height: 100),
        SvgPicture.asset(AppIcons.amount, height: 100),
        const SizedBox(height: 40),
        customText(
          text: pending
              ? "Your Stripe account setup is incomplete. Please finish onboarding."
              : "Connect your Stripe account to start receiving payments.",
          fontSize: 18,
          fontWeight: FontWeight.w400,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 30),
        ElevatedButton(
          onPressed: () async {
            final response = await controller.connectStripeAccount();
            if (response['onboarding_url'] != null) {
              Get.to(() => StripeOnboardingWebView(url: response['onboarding_url']));
            } else {
              Get.snackbar("Message", response['message'] ?? "Unknown error");
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            padding: const EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Text("Connect Stripe Account", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          ),
        ),
      ],
    );
  }

  Widget _buildActiveStripeInfo(Map<String, dynamic> account) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 30),
        const Center(
          child: Icon(Icons.verified, size: 80, color: Colors.green),
        ),
        const SizedBox(height: 20),
        Center(
          child: customText(
            text: "Stripe Connected Successfully!",
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 30),
        _stripeDetailRow("Name", account['name'] ?? "-"),
        _stripeDetailRow("Email", account['email'] ?? "-"),
        _stripeDetailRow("Charges Enabled", account['charges_enabled'] ? "Yes" : "No"),
        _stripeDetailRow("Payouts Enabled", account['payouts_enabled'] ? "Yes" : "No"),
        _stripeDetailRow("Status", account['status']),
      ],
    );
  }

  Widget _stripeDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          customText(text: "$title:", fontSize: 16, fontWeight: FontWeight.w500),
          customText(text: value, fontSize: 16),
        ],
      ),
    );
  }

}



class StripeOnboardingWebView extends StatefulWidget {
  final String url;
  const StripeOnboardingWebView({Key? key, required this.url}) : super(key: key);

  @override
  State<StripeOnboardingWebView> createState() => _StripeOnboardingWebViewState();
}

class _StripeOnboardingWebViewState extends State<StripeOnboardingWebView> {
  late final WebViewController controller;
  // Add a variable to track the loading state
  var _loadingPercentage = 0;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading percentage and trigger a rebuild
            setState(() {
              _loadingPercentage = progress;
            });
          },
          onPageStarted: (String url) {
            // Reset loading percentage when a new page starts
            setState(() {
              _loadingPercentage = 0;
            });
          },
          onPageFinished: (String url) {
            // Set loading percentage to 100 when the page finishes
            setState(() {
              _loadingPercentage = 100;
            });
          },
          onWebResourceError: (WebResourceError error) {
            // Handle web resource errors if needed
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stripe Onboarding')),
      body: Stack( // Use a Stack to overlay the loading indicator
        children: [
          WebViewWidget(controller: controller),
          // Show the loading indicator while the page is loading
          if (_loadingPercentage < 100)
            Center(
              child: CircularProgressIndicator(
                value: _loadingPercentage / 100.0, // Show progress
              ),
            ),
        ],
      ),
    );
  }
}