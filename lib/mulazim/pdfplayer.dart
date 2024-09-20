import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.tital),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.bookmark,
              color: Colors.white,
              semanticLabel: 'Bookmark',
            ),
            onPressed: () {
              _pdfViewerKey.currentState?.openBookmarkView();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          SfPdfViewer.network(
            widget.url,
            key: _pdfViewerKey,
          ),
          // Overlay for watermark
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
    );
  }
}
