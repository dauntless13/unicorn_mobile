import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unicorn/core/widget/my_regular_text.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatefulWidget {
  WebViewScreen({Key? key}) : super(key: key);

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late String title;
  late String url;
  late WebViewController controller;

  @override
  void initState() {
    super.initState();

    // Handle Get.arguments safely
    final args = Get.arguments;
    title = args[0] ?? 'Web View';
    String rawUrl = args[1] ?? 'https://flutter.dev';

    // Ensure the URL has a valid scheme
    if (!rawUrl.startsWith('http://') && !rawUrl.startsWith('https://')) {
      rawUrl = 'https://$rawUrl';
    }

    // Check if the URL is a PDF and redirect to Google Docs Viewer
    if (rawUrl.toLowerCase().endsWith('.pdf')) {
      url = 'https://docs.google.com/viewer?url=${Uri.encodeComponent(rawUrl)}';
    } else {
      // Validate URL and provide fallback if invalid
      try {
        url = Uri.parse(rawUrl).isAbsolute ? rawUrl : 'https://flutter.dev';
      } catch (e) {
        url = 'https://flutter.dev'; // Fallback URL
      }
    }

    print('Loading URL: $url');

    controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setBackgroundColor(const Color(0x00000000))
          ..loadRequest(Uri.parse(url));

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 14),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.black,
                        size: 24,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: MyRegularText(
                        label: title,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(child: WebViewWidget(controller: controller)),
            ],
          ),
        ),
      ),
    );
  }
}
