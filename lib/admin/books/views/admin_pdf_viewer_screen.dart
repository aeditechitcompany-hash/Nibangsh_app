import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../../common/util/app_colors.dart';

class AdminPdfViewerScreen extends StatefulWidget {
  final String title;
  final String pdfUrl;

  const AdminPdfViewerScreen({
    super.key,
    required this.title,
    required this.pdfUrl,
  });

  @override
  State<AdminPdfViewerScreen> createState() =>
      _AdminPdfViewerScreenState();
}

class _AdminPdfViewerScreenState
    extends State<AdminPdfViewerScreen> {
  final PdfViewerController _pdfViewerController =
  PdfViewerController();

  bool _isLoading = true;
  String? _error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: AppColors.navyDark,
        foregroundColor: Colors.white,
        title: Text(
          widget.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          IconButton(
            tooltip: 'Previous page',
            onPressed: () {
              _pdfViewerController.previousPage();
            },
            icon: const Icon(
              Icons.keyboard_arrow_up_rounded,
            ),
          ),

          IconButton(
            tooltip: 'Next page',
            onPressed: () {
              _pdfViewerController.nextPage();
            },
            icon: const Icon(
              Icons.keyboard_arrow_down_rounded,
            ),
          ),
        ],
      ),

      body: Stack(
        children: [
          if (_error == null)
            SfPdfViewer.network(
              widget.pdfUrl,
              controller: _pdfViewerController,

              onDocumentLoaded: (details) {
                if (!mounted) return;

                setState(() {
                  _isLoading = false;
                });
              },

              onDocumentLoadFailed: (details) {
                if (!mounted) return;

                setState(() {
                  _isLoading = false;
                  _error = details.description;
                });
              },
            ),

          if (_isLoading && _error == null)
            const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(
                    color: Colors.white,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Loading PDF...',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),

          if (_error != null)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.picture_as_pdf_rounded,
                      color: Colors.white54,
                      size: 64,
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      'Could not load PDF',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      _error!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),

                    const SizedBox(height: 24),

                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _error = null;
                          _isLoading = true;
                        });
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Try Again'),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}