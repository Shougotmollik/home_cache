import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:home_cache/view/widget/custom_progress_indicator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class OnlinePdfViewer extends StatefulWidget {
  final String url;
  const OnlinePdfViewer({super.key, required this.url});

  @override
  State<OnlinePdfViewer> createState() => _OnlinePdfViewerState();
}

class _OnlinePdfViewerState extends State<OnlinePdfViewer> {
  String? localPath;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPdf();
  }

  Future<void> _loadPdf() async {
    final response = await http.get(Uri.parse(widget.url));
    final bytes = response.bodyBytes;
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/temp.pdf');
    await file.writeAsBytes(bytes, flush: true);
    setState(() {
      localPath = file.path;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CustomProgressIndicator())
        : PDFView(
            filePath: localPath!,
            enableSwipe: true,
            swipeHorizontal: false,
            autoSpacing: true,
            pageFling: true,
          );
  }
}
