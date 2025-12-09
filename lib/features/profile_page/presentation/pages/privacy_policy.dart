import 'package:flutter/material.dart';
import 'package:stoxplay/utils/constants/app_colors.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  late WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..loadRequest(Uri.parse('https://ds4914.github.io/stoxplay_privacy_policy/'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
          color: AppColors.black,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text("Privacy Policy", style: TextStyle(color: AppColors.black)),
        centerTitle: true,
        backgroundColor: AppColors.white,
        actions: [
          SizedBox(
            width: kToolbarHeight, // Match the space of the leading icon
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        width: double.infinity,
        height: double.infinity,
        child: WebViewWidget(controller: controller),
      ),
    );
  }
}
