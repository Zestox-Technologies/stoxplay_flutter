import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_plus/share_plus.dart';
import 'package:stoxplay/utils/constants/app_colors.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import 'package:stoxplay/utils/constants/app_routes.dart';

class PdfViewerScreen extends StatefulWidget {
  final String title;
  final String pdfUrl;
  final int index;

  const PdfViewerScreen({super.key, required this.title, required this.pdfUrl, required this.index});

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  bool _isLoading = true;
  String? _pdfPath;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _downloadAndLoadPdf();
  }

  Future<void> _downloadAndLoadPdf() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      // Get the temporary directory
      final directory = await getTemporaryDirectory();
      final fileName = 'pdf_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final filePath = '${directory.path}/$fileName';

      // Download the PDF
      final response = await http.get(Uri.parse(widget.pdfUrl));

      if (response.statusCode == 200) {
        // Save the PDF to local storage
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        setState(() {
          _pdfPath = filePath;
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to download PDF: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to load PDF: $e'), backgroundColor: AppColors.orangeF6A6));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: AppColors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.title,
          style: TextStyle(
            color: AppColors.black,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            fontFamily: 'Sofia Sans',
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onLongPress: () {
              if (widget.index == 3) {
                Navigator.pushNamed(context, AppRoutes.onBoardingPage);
              } else {
                return;
              }
            },
            icon: Icon(Icons.share, color: AppColors.black),
            onPressed: () {
              SharePlus.instance.share(ShareParams(title: widget.title, text: widget.pdfUrl));
            },
          ),
        ],
      ),
      body:
          _isLoading
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryPurple)),
                    SizedBox(height: 16.h),
                    Text(
                      'Loading PDF...',
                      style: TextStyle(fontSize: 16.sp, color: AppColors.black6666, fontFamily: 'Sofia Sans'),
                    ),
                  ],
                ),
              )
              : _pdfPath != null
              ? PDFView(
                filePath: _pdfPath!,
                enableSwipe: true,
                swipeHorizontal: false,
                autoSpacing: true,
                pageFling: true,
                pageSnap: true,
                defaultPage: 0,
                fitPolicy: FitPolicy.BOTH,
                preventLinkNavigation: false,
              )
              : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 64.w, color: AppColors.black9999),
                    SizedBox(height: 16.h),
                    Text(
                      'Failed to load PDF',
                      style: TextStyle(fontSize: 16.sp, color: AppColors.black6666, fontFamily: 'Sofia Sans'),
                    ),
                    if (_errorMessage != null) ...[
                      SizedBox(height: 8.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 32.w),
                        child: Text(
                          _errorMessage!,
                          style: TextStyle(fontSize: 12.sp, color: AppColors.black9999, fontFamily: 'Sofia Sans'),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                    SizedBox(height: 16.h),
                    ElevatedButton(
                      onPressed: _downloadAndLoadPdf,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryPurple,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                      ),
                      child: Text('Retry', style: TextStyle(color: AppColors.white, fontFamily: 'Sofia Sans')),
                    ),
                  ],
                ),
              ),
    );
  }
}
