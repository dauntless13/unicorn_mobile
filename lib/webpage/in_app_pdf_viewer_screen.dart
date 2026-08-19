import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:printing/printing.dart';
import 'package:unicorn/core/ColorUtils.dart';
import 'package:unicorn/core/utils/protected_file_downloader.dart';
import 'package:unicorn/core/widget/back_button.dart';
import 'package:unicorn/core/widget/my_regular_text.dart';
import 'package:unicorn/service/session/session_helper.dart';

bool isPdfUrl(String? url) {
  final value = (url ?? '').trim().toLowerCase();
  if (value.isEmpty) return false;
  final withoutQuery = value.split('?').first;
  return withoutQuery.endsWith('.pdf') ||
      withoutQuery.contains('/forms/pdf/') ||
      value.contains('application/pdf');
}

Future<void> openInAppPdf({
  String? url,
  Uint8List? bytes,
  String title = 'PDF',
  String? fileName,
  bool authenticated = true,
}) async {
  final trimmedUrl = url?.trim() ?? '';
  if (trimmedUrl.isEmpty && bytes == null) {
    Get.snackbar(
      'Error'.tr,
      'failed_to_load_pdf'.tr,
      snackPosition: SnackPosition.BOTTOM,
    );
    return;
  }

  await Get.to(
    () => InAppPdfViewerScreen(
      title: title,
      url: trimmedUrl.isEmpty ? null : trimmedUrl,
      bytes: bytes,
      fileName: fileName,
      authenticated: authenticated,
    ),
  );
}

class InAppPdfViewerScreen extends StatefulWidget {
  final String title;
  final String? url;
  final Uint8List? bytes;
  final String? fileName;
  final bool authenticated;

  const InAppPdfViewerScreen({
    super.key,
    this.title = 'PDF',
    this.url,
    this.bytes,
    this.fileName,
    this.authenticated = true,
  });

  @override
  State<InAppPdfViewerScreen> createState() => _InAppPdfViewerScreenState();
}

class _InAppPdfViewerScreenState extends State<InAppPdfViewerScreen> {
  Uint8List? _bytes;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    if (widget.bytes != null && widget.bytes!.isNotEmpty) {
      setState(() {
        _bytes = widget.bytes;
        _loading = false;
        _error = null;
      });
      return;
    }

    final url = widget.url?.trim() ?? '';
    if (url.isEmpty) {
      setState(() {
        _loading = false;
        _error = 'failed_to_load_pdf'.tr;
      });
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final headers = <String, String>{
        'accept': 'application/pdf,*/*',
      };

      if (widget.authenticated) {
        final token = (await SessionHelper().getLoginResponse())?.data?.token;
        if (token != null && token.isNotEmpty) {
          headers['authorization'] = 'Bearer $token';
        }
      }

      final response = await Dio().get<List<int>>(
        url,
        options: Options(
          responseType: ResponseType.bytes,
          headers: headers,
          followRedirects: true,
          validateStatus: (status) => status != null && status < 400,
        ),
      );

      final data = response.data;
      if (data == null || data.isEmpty) {
        throw Exception('empty pdf');
      }

      if (!mounted) return;
      setState(() {
        _bytes = Uint8List.fromList(data);
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = 'failed_to_load_pdf'.tr;
      });
    }
  }

  Future<void> _download() async {
    await ProtectedFileDownloader.savePdf(
      bytes: _bytes,
      url: _bytes == null ? widget.url : null,
      fileName: widget.fileName?.trim().isNotEmpty == true
          ? widget.fileName!
          : 'document.pdf',
      authenticated: widget.authenticated,
    );
  }

  @override
  Widget build(BuildContext context) {
    final light = Theme.of(context).brightness == Brightness.light;

    return Scaffold(
      backgroundColor: light ? const Color(0xFFF6F7FB) : const Color(0xFF0F0F0F),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Row(
                children: [
                  appBackButton(context),
                  const SizedBox(width: 12),
                  Expanded(
                    child: MyRegularText(
                      label: widget.title,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: light ? const Color(0xFF0F172A) : Colors.white,
                      maxlines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    tooltip: 'download_file'.tr,
                    onPressed: (_loading || _bytes == null) ? null : _download,
                    icon: Icon(
                      Icons.download_rounded,
                      color: light ? const Color(0xFF0F172A) : Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(child: _body(light)),
          ],
        ),
      ),
    );
  }

  Widget _body(bool light) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null || _bytes == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.picture_as_pdf_outlined,
                size: 48,
                color: light ? const Color(0xFF94A3B8) : Colors.white38,
              ),
              const SizedBox(height: 12),
              MyRegularText(
                label: _error ?? 'failed_to_load_pdf'.tr,
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: light ? const Color(0xFF64748B) : Colors.white70,
                align: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _load,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: MyRegularText(
                  label: 'retry'.tr,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return PdfPreview(
      build: (_) async => _bytes!,
      useActions: false,
      canChangePageFormat: false,
      canChangeOrientation: false,
      canDebug: false,
      allowPrinting: false,
      allowSharing: false,
      dynamicLayout: false,
      padding: EdgeInsets.zero,
      maxPageWidth: 780,
      loadingWidget: const Center(child: CircularProgressIndicator()),
      scrollViewDecoration: BoxDecoration(
        color: light ? const Color(0xFFF6F7FB) : const Color(0xFF0F0F0F),
      ),
      pdfPreviewPageDecoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: light ? 0.06 : 0.35),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
    );
  }
}
