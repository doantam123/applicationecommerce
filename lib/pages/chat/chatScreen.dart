import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MyWebView extends StatelessWidget {
  const MyWebView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 10,
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xffFE724C),
      ), //AppBar
      body: const WebView(
        initialUrl: 'https://tawk.to/chat/6618d604a0c6737bd12af6e3/1hr8g82c4',
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
