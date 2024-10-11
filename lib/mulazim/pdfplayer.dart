import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PdfPlayer extends StatefulWidget {
  final String url;
  final String tital;
  final String phone_number;
  PdfPlayer({super.key, required this.url, required this.tital, required this.phone_number});

  @override
  _PdfPlayer createState() => _PdfPlayer();
}

class _PdfPlayer extends State<PdfPlayer> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  late WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar if necessary
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onHttpError: (HttpResponseError error) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url)); // نقل هذه السطر هنا بعد تهيئة widget
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 10),
        child: Stack(
          children: [
            WebViewWidget(controller: controller),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 60,
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.only(top: 20),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Expanded(
                      child: Center(
                          child: Text(
                            widget.tital,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                              color: Colors.black,
                            ),
                          ),
                        ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned.fill(
              child: IgnorePointer(
                child: Center(
                  child: Opacity(
                    opacity: 0.35, // Make the watermark semi-transparent
                    child: Transform.rotate(
                      angle: -0.3, // Adjust the angle as needed
                      child: Text(
                        widget.phone_number, // Watermark text
                        style: TextStyle(
                          fontSize: 48,
                          color: Colors.grey, // Watermark color
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic, // Make text italic
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
