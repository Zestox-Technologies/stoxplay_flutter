import 'package:flutter/material.dart';
import 'package:stoxplay/utils/constants/app_colors.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HowToPlayWebView extends StatefulWidget {
  const HowToPlayWebView({super.key});

  @override
  State<HowToPlayWebView> createState() => _HowToPlayWebViewState();
}

class _HowToPlayWebViewState extends State<HowToPlayWebView> {
  late WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..loadRequest(Uri.parse('https://ds4914.github.io/stoxplay_how_to_play/'));
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
        title: Text("How to Play",style: TextStyle(color: AppColors.black),),
        centerTitle: true,
        backgroundColor: AppColors.white,
        actions: [
          SizedBox(
            width: kToolbarHeight, // Match the space of the leading icon
          ),
        ],
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: WebViewWidget(controller: controller),
      ),

    );
  }
}
