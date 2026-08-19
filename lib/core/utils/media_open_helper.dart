import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:unicorn/core/utils/protected_file_downloader.dart';
import 'package:unicorn/ui/common_screens/chat/view/message_screen.dart';
import 'package:unicorn/webpage/in_app_pdf_viewer_screen.dart';
import 'package:unicorn/widget/common_toastification.dart';
import 'package:unicorn/widget/file_action_sheet.dart';

enum DownloadableKind { pdf, image, video, file }

DownloadableKind detectDownloadableKind(String? url, {String? fileName}) {
  final value = '${url ?? ''} ${fileName ?? ''}'.trim().toLowerCase();
  if (isPdfUrl(url) || value.contains('.pdf')) {
    return DownloadableKind.pdf;
  }
  if (RegExp(r'\.(jpg|jpeg|png|gif|webp)(\?|$)').hasMatch(value) ||
      value.contains('image/')) {
    return DownloadableKind.image;
  }
  if (RegExp(r'\.(mp4|mov|m4v|webm|m3u8)(\?|$)').hasMatch(value) ||
      value.contains('video/')) {
    return DownloadableKind.video;
  }
  return DownloadableKind.file;
}

String fileNameFromUrl(String url, {String fallback = 'file'}) {
  final uri = Uri.tryParse(url.trim());
  final last = uri?.pathSegments.isNotEmpty == true
      ? uri!.pathSegments.last
      : url.split('/').last;
  final decoded = Uri.decodeComponent(last.split('?').first).trim();
  final sanitized = decoded.replaceAll(RegExp(r'[^A-Za-z0-9._-]'), '_');
  return sanitized.isEmpty ? fallback : sanitized;
}

String _titleForKind(DownloadableKind kind, String? title) {
  if (title != null && title.trim().isNotEmpty) return title.trim();
  switch (kind) {
    case DownloadableKind.image:
      return 'view_image'.tr;
    case DownloadableKind.video:
      return 'view_video'.tr;
    case DownloadableKind.pdf:
      return 'view_pdf'.tr;
    case DownloadableKind.file:
      return 'choose_file_action'.tr;
  }
}

Future<void> openDownloadableMedia({
  String? url,
  Uint8List? bytes,
  String? title,
  String? fileName,
  DownloadableKind? kind,
  bool authenticated = true,
}) async {
  final trimmed = url?.trim() ?? '';
  if (trimmed.isEmpty && bytes == null) {
    showAppSnackbar('Error'.tr, 'failed_to_load_pdf'.tr);
    return;
  }

  final resolvedKind =
      kind ?? detectDownloadableKind(trimmed, fileName: fileName);
  final name = (fileName != null && fileName.trim().isNotEmpty)
      ? fileName.trim()
      : fileNameFromUrl(
          trimmed,
          fallback: resolvedKind == DownloadableKind.pdf
              ? 'document.pdf'
              : resolvedKind == DownloadableKind.image
                  ? 'image.jpg'
                  : resolvedKind == DownloadableKind.video
                      ? 'video.mp4'
                      : 'file',
        );

  final action = await showViewOrDownloadSheet(
    title: _titleForKind(resolvedKind, title),
  );
  if (action == null) return;

  if (action == FileOpenAction.view) {
    await viewDownloadableMedia(
      url: trimmed.isEmpty ? null : trimmed,
      bytes: bytes,
      title: _titleForKind(resolvedKind, title),
      fileName: name,
      kind: resolvedKind,
      authenticated: authenticated,
    );
    return;
  }

  await downloadDownloadableMedia(
    url: trimmed.isEmpty ? null : trimmed,
    bytes: bytes,
    fileName: name,
    kind: resolvedKind,
    authenticated: authenticated,
  );
}

Future<void> viewDownloadableMedia({
  String? url,
  Uint8List? bytes,
  String? title,
  String? fileName,
  DownloadableKind kind = DownloadableKind.pdf,
  bool authenticated = true,
}) async {
  switch (kind) {
    case DownloadableKind.pdf:
      await openInAppPdf(
        url: url,
        bytes: bytes,
        title: title ?? 'view_pdf'.tr,
        fileName: fileName,
        authenticated: authenticated,
      );
      return;
    case DownloadableKind.image:
    case DownloadableKind.video:
      await Get.to(
        () => FullScreenMediaViewer(
          data: {
            'text': url ?? '',
            'message': url ?? '',
            'fileName': fileName,
          },
          type: kind == DownloadableKind.video ? 'video' : 'image',
        ),
      );
      return;
    case DownloadableKind.file:
      if (isPdfUrl(url) || (fileName ?? '').toLowerCase().endsWith('.pdf')) {
        await openInAppPdf(
          url: url,
          bytes: bytes,
          title: title ?? 'view_pdf'.tr,
          fileName: fileName,
          authenticated: authenticated,
        );
        return;
      }
      await downloadDownloadableMedia(
        url: url,
        bytes: bytes,
        fileName: fileName ?? 'file',
        kind: kind,
        authenticated: authenticated,
      );
  }
}

Future<void> downloadDownloadableMedia({
  String? url,
  Uint8List? bytes,
  required String fileName,
  DownloadableKind kind = DownloadableKind.pdf,
  bool authenticated = true,
}) async {
  switch (kind) {
    case DownloadableKind.image:
      await ProtectedFileDownloader.saveImage(
        url: url,
        bytes: bytes,
        fileName: fileName,
        authenticated: authenticated,
      );
      return;
    case DownloadableKind.video:
      if (url == null || url.trim().isEmpty) {
        showAppSnackbar('Error'.tr, 'failed_to_download_file'.tr);
        return;
      }
      await ProtectedFileDownloader.saveVideo(
        url: url,
        fileName: fileName,
        authenticated: authenticated,
      );
      return;
    case DownloadableKind.pdf:
      await ProtectedFileDownloader.savePdf(
        url: url,
        bytes: bytes,
        fileName: fileName,
        authenticated: authenticated,
      );
      return;
    case DownloadableKind.file:
      await ProtectedFileDownloader.saveToDownloads(
        url: url,
        bytes: bytes,
        fileName: fileName,
        authenticated: authenticated,
      );
  }
}
