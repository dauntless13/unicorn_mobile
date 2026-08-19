import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cross_file/cross_file.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:unicorn/core/utils/protected_file_downloader.dart';
import 'package:unicorn/core/widget/profile_avatar.dart';
import 'package:unicorn/ui/common_screens/chat/view/teacher_group_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import '../../../../service/notification_service/FirebaseNotificationService.dart';
import '../../../../service/notification_service/firebase_send_admin_notification.dart';
import '../../../../service/session/session_helper.dart';
import '../../../../webpage/in_app_pdf_viewer_screen.dart';
import '../../../../webpage/webview_screen.dart';
import '../../../../widget/file_action_sheet.dart';
import '../../../auth/view/model/login/login_response.dart';
import 'message_controller.dart';


class _T {
  final bool light;
  const _T(this.light);

  // Scaffold / page
  Color get scaffold      => light ? const Color(0xFFF0F2F5) : const Color(0xFF0A0A0E);

  // AppBar
  Color get appBar        => light ? Colors.white             : const Color(0xFF141418);
  Color get appBarBorder  => light ? const Color(0xFFE8ECF2)  : const Color(0xFF1E1E26);
  Color get appBarIcon    => light ? Colors.black             : Colors.white;
  Color get appBarTitle   => light ? const Color(0xFF111111)  : Colors.white;
  Color get onlineGreen   => const Color(0xFF27AE60);
  Color get lastSeen      => light ? const Color(0xFF7A8BA6)  : const Color(0xFF5A6A80);

  // Bubbles
  Color get bubbleMe      => light ? const Color(0xFFD9FDD3)  : const Color(0xFF1A3A1A);
  Color get bubbleThem    => light ? Colors.white             : const Color(0xFF1E1E26);
  Color get bubbleShadow  => light
      ? Colors.black.withOpacity(0.06)
      : Colors.black.withOpacity(0.3);
  Color get bubbleTxtMe   => light ? const Color(0xFF111827)  : const Color(0xFFE0F2E0);
  Color get bubbleTxtThem => light ? const Color(0xFF111827)  : Colors.white;
  Color get tsMe          => light ? Colors.green.shade800    : Colors.green.shade300;
  Color get tsThem        => light ? Colors.grey              : const Color(0xFF5A6A80);
  Color get tickColor     => const Color(0xFF34B7F1);

  // Input bar
  Color get inputBg       => light ? Colors.white             : const Color(0xFF141418);
  Color get inputBorder   => light ? const Color(0xFFE0E4EC)  : const Color(0xFF1E1E26);
  Color get inputField    => light ? const Color(0xFFF4F6FA)  : const Color(0xFF1E1E26);
  Color get inputHint     => light ? const Color(0xFFAAAAAA)  : const Color(0xFF4A5568);
  Color get inputTxt      => light ? Colors.black             : Colors.white;
  Color get inputIcon     => const Color(0xFF0C7189);

  // Recording bar
  Color get recBg         => light ? Colors.white             : const Color(0xFF1A1A22);
  Color get recBorder     => light ? const Color(0xFFE0E4EC)  : const Color(0xFF2A2A38);
  Color get recTxt        => light ? Colors.black87           : Colors.white;
  Color get recMuted      => light ? const Color(0xFF9E9E9E)  : const Color(0xFF4A5568);
  Color get recCancelBg   => light ? Colors.red.shade50       : Colors.red.shade900.withOpacity(0.3);

  // Media sheet
  Color get sheetBg       => light ? Colors.white             : const Color(0xFF141418);
  Color get sheetHandle   => light ? Colors.grey.shade300     : const Color(0xFF2A2A38);
  Color get sheetLabel    => light ? Colors.black87           : Colors.white70;

  // Document bubble
  Color get docSub        => light ? Colors.grey.shade600     : const Color(0xFF5A6A80);

  // Icon box (appbar)
  Color get iconBoxBorder => light ? Colors.grey.shade300     : const Color(0xFF2A2A38);

  // Empty state
  Color get emptytxt      => light ? Colors.grey.shade600     : const Color(0xFF4A5568);

  // Delete dialog
  Color get dialogBg      => light ? Colors.white             : const Color(0xFF1C1C24);
  Color get dialogTitle   => light ? const Color(0xFF111111)  : Colors.white;

  // Primary brand
  static const brand = Color(0xFF0C7189);
}

// =============================================================================
//  FULL-SCREEN MEDIA VIEWER
// =============================================================================

class FullScreenMediaViewer extends StatefulWidget {
  final Map<String, dynamic> data;
  final String type;
  const FullScreenMediaViewer({super.key, required this.data, required this.type});

  @override
  State<FullScreenMediaViewer> createState() => _FullScreenMediaViewerState();
}

class _FullScreenMediaViewerState extends State<FullScreenMediaViewer> {
  VideoPlayerController? _videoCtrl;
  bool _videoInitialized = false;
  bool _isPlaying = false;
  bool _isSharingImage = false;
  bool _isDownloadingImage = false;

  @override
  void initState() {
    super.initState();
    if (widget.type == 'video') _initVideo();
  }

  Future<void> _initVideo() async {
    final url = widget.data['text'] ?? widget.data['message'] ?? '';
    _videoCtrl = VideoPlayerController.network(url);
    await _videoCtrl!.initialize();
    _videoCtrl!.addListener(() { if (mounted) setState(() {}); });
    if (mounted) setState(() => _videoInitialized = true);
  }

  @override
  void dispose() { _videoCtrl?.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.7),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (widget.type == 'image' || widget.type == 'video') ...[
            if (widget.type == 'image')
              IconButton(
                icon: _isSharingImage
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Icon(Icons.share_rounded, color: Colors.white),
                onPressed:
                    (_isSharingImage || _isDownloadingImage) ? null : _shareImage,
              ),
            IconButton(
              icon: _isDownloadingImage
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Icon(Icons.download_rounded, color: Colors.white),
              onPressed: (_isSharingImage || _isDownloadingImage)
                  ? null
                  : _saveMediaToGallery,
            ),
          ],
        ],
      ),
      body: _buildBody(),
    );
  }

  String _titleForType() {
    switch (widget.type) {
      case 'image': return 'Photo';
      case 'video': return 'Video';
      case 'audio': return 'Voice Message';
      case 'document': return widget.data['fileName'] as String? ?? 'Document';
      default: return 'File';
    }
  }

  Widget _buildBody() {
    switch (widget.type) {
      case 'image':    return _imageViewer();
      case 'video':    return _videoViewer();
      case 'document': return _documentViewer();
      default: return const Center(
          child: Text('Cannot preview', style: TextStyle(color: Colors.white)));
    }
  }

  Widget _imageViewer() {
    final url = widget.data['text'] ?? widget.data['message'] ?? '';
    return Center(
      child: InteractiveViewer(
        minScale: 0.5, maxScale: 4.0,
        child: CachedNetworkImage(
          imageUrl: url, fit: BoxFit.contain,
          placeholder: (_, __) =>
          const Center(child: CupertinoActivityIndicator(color: Colors.white)),
          errorWidget: (_, __, ___) =>
          const Icon(Icons.broken_image, color: Colors.white, size: 60),
        ),
      ),
    );
  }

  Widget _videoViewer() {
    if (!_videoInitialized) {
      return const Center(child: CupertinoActivityIndicator(color: Colors.white));
    }
    return Stack(
      alignment: Alignment.center,
      children: [
        Center(
          child: AspectRatio(
            aspectRatio: _videoCtrl!.value.aspectRatio,
            child: VideoPlayer(_videoCtrl!),
          ),
        ),
        GestureDetector(
          onTap: () => setState(() {
            _isPlaying = !_isPlaying;
            _isPlaying ? _videoCtrl!.play() : _videoCtrl!.pause();
          }),
          child: AnimatedOpacity(
            opacity: _isPlaying ? 0.0 : 1.0,
            duration: const Duration(milliseconds: 200),
            child: Container(
              width: 64, height: 64,
              decoration: const BoxDecoration(
                  color: Colors.black54, shape: BoxShape.circle),
              child: Icon(_isPlaying ? Icons.pause : Icons.play_arrow,
                  color: Colors.white, size: 36),
            ),
          ),
        ),
        Positioned(
          bottom: 0, left: 0, right: 0,
          child: VideoProgressIndicator(_videoCtrl!, allowScrubbing: true,
            colors: const VideoProgressColors(
              playedColor: Colors.white,
              bufferedColor: Colors.white38,
              backgroundColor: Colors.white12,
            ),
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          ),
        ),
      ],
    );
  }

  Widget _documentViewer() {
    final fileName = widget.data['fileName'] as String? ?? 'Document';
    final fileExt  = (widget.data['fileExt'] as String? ?? '').toLowerCase();
    final fileUrl  = widget.data['text'] ?? widget.data['message'] ?? '';
    final isImage  = ['jpg','jpeg','png','gif','webp'].contains(fileExt);
    final isDoc    = ['pdf','doc','docx','xls','xlsx','csv','ppt','pptx'].contains(fileExt);

    if (isImage) {
      return CachedNetworkImage(imageUrl: fileUrl, fit: BoxFit.contain,
        placeholder: (_, __) => const Center(child: CupertinoActivityIndicator()),
        errorWidget: (_, __, ___) => const Icon(Icons.broken_image, size: 60),
      );
    }
    if (isDoc) {
      return Center(
        child: ElevatedButton.icon(
          icon: Icon(fileExt == 'pdf' ? Icons.visibility_rounded : Icons.open_in_new),
          label: Text(fileExt == 'pdf' ? 'view_pdf'.tr : 'Open Document'),
          onPressed: () async {
            if (fileExt == 'pdf' || isPdfUrl(fileUrl)) {
              final action = await showViewOrDownloadSheet(title: fileName);
              if (action == FileOpenAction.view) {
                await openInAppPdf(
                  url: fileUrl,
                  title: fileName,
                  fileName: fileName,
                );
              } else if (action == FileOpenAction.download) {
                await ProtectedFileDownloader.savePdf(
                  url: fileUrl,
                  fileName: fileName,
                );
              }
              return;
            }
            Get.to(() => WebViewScreen(), arguments: [fileName, fileUrl]);
          },
        ),
      );
    }
    return const Center(child: Text("Preview not available",
        style: TextStyle(color: Colors.white)));
  }

  Future<void> _downloadFile() async {
    final url = widget.data['text'] ?? widget.data['message'] ?? '';
    final uri = Uri.tryParse(url);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  String get _mediaUrl => widget.data['text'] ?? widget.data['message'] ?? '';

  Future<void> _shareImage() async {
    try {
      setState(() => _isSharingImage = true);
      final file = await _downloadNetworkImage(
        fileNamePrefix: 'shared_image',
        directory: await getTemporaryDirectory(),
      );
      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'Image from Unicorn',
      );
    } catch (e) {
      _showInfo('Unable to share image');
    } finally {
      if (mounted) {
        setState(() => _isSharingImage = false);
      }
    }
  }

  Future<void> _saveMediaToGallery() async {
    try {
      setState(() => _isDownloadingImage = true);
      if (widget.type == 'video') {
        await ProtectedFileDownloader.saveVideo(
          url: _mediaUrl,
          fileName:
              'unicorn_${DateTime.now().millisecondsSinceEpoch}.${_extractVideoExtension(_mediaUrl)}',
        );
      } else {
        await ProtectedFileDownloader.saveImage(
          url: _mediaUrl,
          fileName:
              'unicorn_${DateTime.now().millisecondsSinceEpoch}.${_extractImageExtension(_mediaUrl)}',
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isDownloadingImage = false);
      }
    }
  }

  Future<void> _downloadImage() async {
    await _saveMediaToGallery();
  }

  Future<Directory> _resolveDownloadDirectory() async {
    if (Platform.isAndroid) {
      await _requestAndroidStoragePermission();

      final downloadDir = Directory('/storage/emulated/0/Download');
      if (await downloadDir.exists()) {
        return downloadDir;
      }

      final externalDir = await getExternalStorageDirectory();
      if (externalDir != null) {
        return externalDir;
      }
    }

    if (Platform.isIOS) {
      return getApplicationDocumentsDirectory();
    }

    return await getTemporaryDirectory();
  }

  Future<void> _requestAndroidStoragePermission() async {
    final storageStatus = await Permission.storage.request();
    if (storageStatus.isGranted) return;

    final photosStatus = await Permission.photos.request();
    if (photosStatus.isGranted || photosStatus.isLimited) return;

    final videosStatus = await Permission.videos.request();
    if (videosStatus.isGranted || videosStatus.isLimited) return;
  }

  Future<File> _downloadNetworkImage({
    required String fileNamePrefix,
    required Directory directory,
  }) async {
    final extension = _extractImageExtension(_mediaUrl);
    final fileName =
        '${fileNamePrefix}_${DateTime.now().millisecondsSinceEpoch}.$extension';
    final file = File('${directory.path}${Platform.pathSeparator}$fileName');

    await Dio().download(_mediaUrl, file.path);
    return file;
  }

  String _extractImageExtension(String url) {
    final uri = Uri.tryParse(url);
    final path = uri?.path ?? url;
    final ext = path.split('.').last.toLowerCase();
    const allowed = {'jpg', 'jpeg', 'png', 'webp', 'gif'};
    return allowed.contains(ext) ? ext : 'jpg';
  }

  String _extractVideoExtension(String url) {
    final uri = Uri.tryParse(url);
    final path = uri?.path ?? url;
    final ext = path.split('.').last.toLowerCase();
    const allowed = {'mp4', 'mov', 'm4v', 'webm'};
    return allowed.contains(ext) ? ext : 'mp4';
  }

  void _showInfo(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

// =============================================================================
//  MAIN MESSAGE SCREEN
// =============================================================================

class AllMessageScreen extends StatefulWidget {
  const AllMessageScreen({super.key});

  @override
  State<AllMessageScreen> createState() => _AllMessageScreenState();
}

class _AllMessageScreenState extends State<AllMessageScreen>
    with WidgetsBindingObserver {
  // ── Route args ─────────────────────────────────────────────────────────────
  late final String chatId;
  late final String receiverId;
  late final String receiverName;
  late final String receiverImage;
  late final String receiverFcmToken;
  late final bool   isOnline;
  late final int    chatType;

  // ── Controllers ────────────────────────────────────────────────────────────
  final ChatController       _chatCtrl  = Get.put(ChatController());
  final TextEditingController _msgCtrl  = TextEditingController();
  final ScrollController      _scrollCtrl = ScrollController();

  // ── User ───────────────────────────────────────────────────────────────────
  LoginResponse? _loginResponse;
  String get _currentUserId =>
      _loginResponse?.data?.user?.id.toString() ?? "";

  // =========================================================================
  //  LIFECYCLE
  // =========================================================================
  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>;
    chatId           = args['chatId'];
    receiverId       = args['receiverId'];
    receiverName     = args['receiverName'];
    receiverImage    = args['receiverImage'] ?? "";
    receiverFcmToken = args['fcmToken'] ?? "";
    isOnline         = args['isOnline'] ?? false;
    chatType         = args["chatType"] ?? 0;
    WidgetsBinding.instance.addObserver(this);
    _loadCurrentUser();
    FirebaseNotificationService.clearBadge();
    FirebaseNotificationService.currentChatId = chatId;
    _markMessagesAsDelivered();
  }
  Future<void> _setUserActiveChat(String? chatId) async {
    final uid = _currentUserId;

    if (uid.isEmpty) {
      debugPrint("❌ UID EMPTY");
      return;
    }

    try {
      final ref = FirebaseFirestore.instance.collection("users").doc(uid);

      await ref.update({
        "activeChatId": chatId,
      });

      debugPrint("✅ UPDATED activeChatId: $chatId");

    } catch (e) {
      debugPrint("⚠️ update failed → using set fallback");

      // fallback if doc doesn't exist
      await FirebaseFirestore.instance.collection("users").doc(uid).set({
        "activeChatId": chatId,
      }, SetOptions(merge: true));
    }
  }
  Future<void> _markMessagesAsSeen() async {
    final uid = _currentUserId;

    final messages = await FirebaseFirestore.instance
        .collection("chats")
        .doc(chatId)
        .collection("messages")
        .where("senderId", isNotEqualTo: uid)
        .get();

    for (var doc in messages.docs) {
      await doc.reference.update({
        'seenBy': FieldValue.arrayUnion([uid]),
      });
    }
  }
  void _handleTitleClick() {
    switch (chatType) {
      case 6: Get.to(() => TeacherGroupScreen()); break;
      case 7: Get.to(() => ParentGroupScreen());  break;
      default: break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    FirebaseNotificationService.currentChatId = null;
    _msgCtrl.clear();
    _scrollCtrl.dispose();
    _setUserActiveChat(null);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _markChatAsRead();
      FirebaseNotificationService.clearBadge();
    }
  }

  // =========================================================================
  //  DATA
  // =========================================================================
  Future<void> _loadCurrentUser() async {
    _loginResponse = await SessionHelper().getLoginResponse();
    if (mounted) setState(() {});
    await _setUserActiveChat(chatId);
    if (_loginResponse?.data != null) _markChatAsRead();

  }

  // Future<void> _markChatAsRead() async {
  //   try {
  //     final lr  = await SessionHelper().getLoginResponse();
  //     final uid = lr!.data!.user!.id.toString();
  //     await FirebaseFirestore.instance
  //         .collection("chats").doc(chatId)
  //         .update({'unreadCount.$uid': 0});
  //
  //     await _markMessagesAsSeen();
  //   } catch (e) { debugPrint("markChatAsRead: $e"); }
  // }

  Future<void> _markChatAsRead() async {
    try {
      final lr = await SessionHelper().getLoginResponse();
      final uid = lr!.data!.user!.id.toString();

      final chatRef =
      FirebaseFirestore.instance.collection("chats").doc(chatId);

      await chatRef.update({
        'unreadCount.$uid': 0,
      });

      await _markMessagesAsSeen();

      // 🔥 ADD THIS (VERY IMPORTANT)
      await chatRef.update({
        'lastMessageStatus': 'seen',
      });

    } catch (e) {
      debugPrint("markChatAsRead: $e");
    }
  }
  Future<void> _deleteMessage(String messageId) async {
    try {
      await FirebaseFirestore.instance
          .collection("chats").doc(chatId)
          .collection("messages").doc(messageId).delete();

      final latest = await FirebaseFirestore.instance
          .collection("chats").doc(chatId)
          .collection("messages")
          .orderBy("timestamp", descending: true).limit(1).get();

      if (latest.docs.isNotEmpty) {
        final d = latest.docs.first.data();
        await FirebaseFirestore.instance.collection("chats").doc(chatId).update({
          "lastMessage": d["text"] ?? d["message"] ?? "",
          "lastMessageTime": d["timestamp"] ?? d["createdAt"],
          "lastSenderId": d["senderId"] ?? "",
        });
      } else {
        await FirebaseFirestore.instance.collection("chats").doc(chatId).update({
          "lastMessage": "",
          "lastMessageTime": FieldValue.serverTimestamp(),
          "lastSenderId": "",
        });
      }
    } catch (e) { debugPrint("Delete: $e"); }
  }

  // =========================================================================
  //  SEND HELPERS
  // =========================================================================
  // Map<String, dynamic> _baseMessageFields({
  //   required String docId,
  //   required String type,
  // }) {
  //   final now   = FieldValue.serverTimestamp();
  //   final nowMs = DateTime.now().millisecondsSinceEpoch;
  //   return {
  //     'id': docId, 'chatId': chatId,
  //     'senderId': _currentUserId, 'receiverId': receiverId,
  //     'senderName':
  //     '${_loginResponse?.data?.user?.firstName ?? ""} ${_loginResponse?.data?.user?.lastName ?? ""}'.trim(),
  //     'senderImage': _loginResponse?.data?.user?.profileLink ?? "",
  //     'type': type, 'attachments': [],
  //     'timestamp': now, 'createdAt': now, 'updatedAt': now,
  //     'createdAtMs': nowMs, 'updatedAtMs': nowMs,
  //   };
  // }

  Map<String, dynamic> _baseMessageFields({
    required String docId,
    required String type,
  }) {
    final now = FieldValue.serverTimestamp();
    final nowMs = DateTime.now().millisecondsSinceEpoch;

    return {
      // ── Core IDs ─────────────────────────────
      'id': docId,
      'chatId': chatId,
      'senderId': _currentUserId,
      'receiverId': receiverId,

      // ── Sender Info ─────────────────────────
      'senderName':
      '${_loginResponse?.data?.user?.firstName ?? ""} ${_loginResponse?.data?.user?.lastName ?? ""}'.trim(),
      'senderImage':
      _loginResponse?.data?.user?.profileLink ?? "",

      // ── Message Type ────────────────────────
      'type': type, // text, image, video, audio, document

      // ── Message Content ─────────────────────
      'text': '',
      'message': '',
      'attachments': [],

      // ── 🟢 DELIVERY STATUS (IMPORTANT) ─────
      'deliveredTo': [
        _currentUserId
      ], // sender already has it → 1 tick instantly

      'seenBy': [
        _currentUserId
      ], // sender already seen → needed for UI logic

      'createdAt': now,
      'updatedAt': now,
      'createdAtMs': nowMs,
      'updatedAtMs': nowMs,
    };
  }
  Future<void> _markMessagesAsDelivered() async {
    final uid = _currentUserId;

    final messages = await FirebaseFirestore.instance
        .collection("chats")
        .doc(chatId)
        .collection("messages")
        .where("senderId", isNotEqualTo: uid)
        .get();

    for (var doc in messages.docs) {
      await doc.reference.update({
        'deliveredTo': FieldValue.arrayUnion([uid]),
      });
    }
  }
  //
  // Future<void> _updateChatAndNotify({
  //   required String lastMessage,
  //   required String notificationBody,
  //   String? imageUrl,
  //   required String type,
  // }) async {
  //   final now   = FieldValue.serverTimestamp();
  //   final nowMs = DateTime.now().millisecondsSinceEpoch;
  //   final chatRef = FirebaseFirestore.instance.collection("chats").doc(chatId);
  //
  //   await chatRef.update({
  //     'lastMessage': lastMessage,
  //     'lastMessageTime': now,
  //     'lastMessageTimeMs': nowMs,
  //     'lastSenderId': _currentUserId,
  //     'updatedAt': now,
  //   });
  //
  //   final snap = await chatRef.get();
  //   final data = snap.data() ?? {};
  //   final Map<String, dynamic> tokens =
  //   Map<String, dynamic>.from(data['participantsTokens'] ?? {});
  //
  //   for (final entry in tokens.entries) {
  //     if (entry.key == _currentUserId) continue;
  //     final token = entry.value?.toString() ?? '';
  //     if (token.isEmpty) continue;
  //     await FirebaseSendAdminNotification.sendSingleNotification(
  //       _loginResponse?.data?.user?.firstName ?? "User",
  //       notificationBody, imageUrl ?? "", token, context,
  //       data: {"chatId": chatId, "type": "chat"}, badgeCount: 1,
  //     );
  //   }
  // }
  Future<void> _updateChatAndNotify({
    required String lastMessage,
    required String notificationBody,
    String? imageUrl,
    required String type,
  }) async {
    final safeContext = mounted ? context : null;
    final now = FieldValue.serverTimestamp();
    final nowMs = DateTime.now().millisecondsSinceEpoch;

    final chatRef =
    FirebaseFirestore.instance.collection("chats").doc(chatId);

    final snap = await chatRef.get();
    final data = snap.data() ?? {};

    final Map<String, dynamic> tokens =
    Map<String, dynamic>.from(data['participantsTokens'] ?? {});

    final Map<String, dynamic> unreadMap =
    Map<String, dynamic>.from(data['unreadCount'] ?? {});

    for (final entry in tokens.entries) {
      final userId = entry.key;

      if (userId == _currentUserId) {
        unreadMap[userId] = 0;
        continue;
      }

      // 🔥 CHECK ACTIVE CHAT
      final userDoc = await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .get();

      final activeChatId = userDoc.data()?['activeChatId'];

      if (activeChatId == chatId) {
        // ✅ USER INSIDE CHAT → BLUE TICK DIRECT
        unreadMap[userId] = 0;

        final msg = await chatRef
            .collection("messages")
            .orderBy("createdAt", descending: true)
            .limit(1)
            .get();

        for (var d in msg.docs) {
          await d.reference.update({
            'deliveredTo': FieldValue.arrayUnion([userId]),
            'seenBy': FieldValue.arrayUnion([userId]),
          });
        }

      } else {
        // ❌ USER NOT IN CHAT
        unreadMap[userId] = (unreadMap[userId] ?? 0) + 1;

        final msg = await chatRef
            .collection("messages")
            .orderBy("createdAt", descending: true)
            .limit(1)
            .get();

        for (var d in msg.docs) {
          await d.reference.update({
            'deliveredTo': FieldValue.arrayUnion([userId]),
          });
        }

        // 🔔 SEND NOTIFICATION
        final token = entry.value?.toString() ?? '';
        if (token.isNotEmpty) {
          await FirebaseSendAdminNotification.sendSingleNotification(
            _loginResponse?.data?.user?.firstName ?? "User",
            notificationBody,
            imageUrl ?? "",
            token,
            safeContext,
            data: {"chatId": chatId, "type": "chat"},
            badgeCount: 1,
          );
        }
      }
    }
    String lastStatus = "sent"; // default

    for (final entry in tokens.entries) {
      final userId = entry.key;

      if (userId == _currentUserId) continue;

      final userDoc = await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .get();

      final activeChatId = userDoc.data()?['activeChatId'];

      if (activeChatId == chatId) {
        lastStatus = "seen"; // 🔵
      } else {
        lastStatus = "delivered"; // ⚪
      }
    }
    await chatRef.update({
      'lastMessage': lastMessage,
      'lastMessageTime': now,
      'lastMessageTimeMs': nowMs,
      'lastMessageStatus': lastStatus,
      'lastSenderId': _currentUserId,
      'updatedAt': now,
      'unreadCount': unreadMap,
    });
  }

  Future<void> _sendTextMessage() async {
    final msg = _msgCtrl.text.trim();
    if (msg.isEmpty || _loginResponse?.data == null) return;
    _msgCtrl.clear();
    final doc = FirebaseFirestore.instance
        .collection("chats").doc(chatId).collection("messages").doc();
    await doc.set({
      ..._baseMessageFields(docId: doc.id, type: 'text'),
      'text': msg, 'message': msg,
    });
    await _updateChatAndNotify(lastMessage: msg, notificationBody: msg, type: 'text');
    _scrollToBottom();
  }

  Future<void> _sendImageMessage(String url) async {
    if (_loginResponse?.data == null) return;
    final doc = FirebaseFirestore.instance
        .collection("chats").doc(chatId).collection("messages").doc();
    await doc.set({
      ..._baseMessageFields(docId: doc.id, type: 'image'),
      'text': url, 'message': url,
    });
    await _updateChatAndNotify(
        lastMessage: "📷 Photo", notificationBody: "sent a photo 📸",
        imageUrl: url, type: 'image');
    _scrollToBottom();
  }

  Future<void> _sendVideoMessage(String url) async {
    if (_loginResponse?.data == null) return;
    final doc = FirebaseFirestore.instance
        .collection("chats").doc(chatId).collection("messages").doc();
    await doc.set({
      ..._baseMessageFields(docId: doc.id, type: 'video'),
      'text': url, 'message': url,
    });
    await _updateChatAndNotify(
        lastMessage: "🎥 Video", notificationBody: "sent a video 🎥", type: 'video');
    _scrollToBottom();
  }

  Future<void> _sendAudioMessage(String url, {required int durationSeconds}) async {
    if (_loginResponse?.data == null) return;
    final doc = FirebaseFirestore.instance
        .collection("chats").doc(chatId).collection("messages").doc();
    await doc.set({
      ..._baseMessageFields(docId: doc.id, type: 'audio'),
      'text': url, 'message': url, 'audioDuration': durationSeconds,
    });
    await _updateChatAndNotify(
        lastMessage: "🎤 Voice message",
        notificationBody: "sent a voice message 🎤", type: 'audio');
    _scrollToBottom();
  }

  Future<void> _sendDocumentMessage({
    required String fileUrl,
    required String fileName,
    required int fileSizeBytes,
    required String fileExt,
  }) async {
    if (_loginResponse?.data == null) return;
    final doc = FirebaseFirestore.instance
        .collection("chats").doc(chatId).collection("messages").doc();
    await doc.set({
      ..._baseMessageFields(docId: doc.id, type: 'document'),
      'text': fileUrl, 'message': fileUrl,
      'fileName': fileName, 'fileSizeBytes': fileSizeBytes, 'fileExt': fileExt,
    });
    final emoji = _docEmoji(fileExt);
    await _updateChatAndNotify(
        lastMessage: "$emoji $fileName",
        notificationBody: "sent a file 📎", type: 'document');
    _scrollToBottom();
  }

  String _docEmoji(String ext) {
    switch (ext) {
      case 'pdf': return '📄';
      case 'doc': case 'docx': return '📝';
      case 'xls': case 'xlsx': return '📊';
      case 'csv': return '📋';
      case 'txt': return '📃';
      default: return '📎';
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut);
      }
    });
  }

  // =========================================================================
  //  BUILD
  // =========================================================================
  @override
  Widget build(BuildContext context) {
    final t = _T(Theme.of(context).brightness == Brightness.light);

    return Scaffold(
      backgroundColor: t.scaffold,
      appBar: _buildAppBar(t),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Upload progress bar
            Obx(() => _chatCtrl.isUploading.value
                ? LinearProgressIndicator(
              backgroundColor: t.inputBorder,
              color: _T.brand,
              minHeight: 3,
            )
                : const SizedBox.shrink()),
            Expanded(child: _buildMessageList(t)),
            _buildInputBar(t),
          ],
        ),
      ),
    );
  }

  // ── AppBar ─────────────────────────────────────────────────────────────────
  PreferredSizeWidget _buildAppBar(_T t) {
    return AppBar(
      backgroundColor: t.appBar,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      toolbarHeight: 70,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: t.appBarBorder),
      ),
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            // Back
            _iconBox(t, Icons.arrow_back, onTap: Get.back),
            const SizedBox(width: 12),
            // Avatar
            ProfileAvatar(
              radius: 20,
              imageUrl: receiverImage,
              backgroundColor: t.inputField,
              iconColor: t.appBarTitle,
              iconSize: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: _handleTitleClick,
                    child: Text(receiverName,
                        style: TextStyle(
                            color: t.appBarTitle, fontSize: 16,
                            fontWeight: FontWeight.w600)),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    isOnline ? "Online" : "Last seen recently",
                    style: TextStyle(
                      fontSize: 12,
                      color: isOnline ? t.onlineGreen : t.lastSeen,
                    ),
                  ),
                ],
              ),
            ),
            // _iconBox(t, Icons.more_vert),
          ],
        ),
      ),
    );
  }

  Widget _iconBox(_T t, IconData icon, {VoidCallback? onTap}) {
    return Container(
      width: 36, height: 36,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: t.iconBoxBorder),
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(icon, size: 18, color: t.appBarIcon),
        onPressed: onTap,
      ),
    );
  }
  String _getDateLabel(DateTime date) {
    final now = DateTime.now();

    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(date.year, date.month, date.day);

    final difference = today.difference(messageDate).inDays ;

    if (difference == 0) return "Today";
    if (difference == 1) return "Yesterday";

    return "${date.day} ${_monthName(date.month)} ${date.year}";
  }

  String _monthName(int month) {
    const months = [
      "Jan", "Feb", "Mar", "Apr", "May", "Jun",
      "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    ];
    return months[month - 1];
  }
  Widget _dateSeparator(_T t, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: t.light
                ? Colors.grey.shade200
                : const Color(0xFF2A2A38),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: t.light ? Colors.black87 : Colors.white70,
            ),
          ),
        ),
      ),
    );
  }
  // ── Message list ──────────────────────────────────────────────────────────
  Widget _buildMessageList(_T t) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("chats").doc(chatId)
          .collection("messages")
          .orderBy("createdAt", descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CupertinoActivityIndicator(
              color: t.appBarIcon));
        }
        final docs = snapshot.data!.docs;
        if (docs.isEmpty) {
          return Center(
              child: Text("Say hello 👋",
                  style: TextStyle(color: t.emptytxt, fontSize: 16)));
        }
        return ListView.builder(
          reverse: true,
          controller: _scrollCtrl,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          itemCount: docs.length,
          // itemBuilder: (context, index) {
          //   final data  = docs[index].data() as Map<String, dynamic>;
          //   final isMe  = data['senderId'] == _currentUserId;
          //   final type  = data['type'] ?? 'text';
          //   final msgId = data['id'] ?? docs[index].id;
          //   final ts    = (data['createdAt'] ?? data['timestamp']) as Timestamp?;
          //   return GestureDetector(
          //     onLongPress: isMe ? () => _showDeleteDialog(t, msgId) : null,
          //     child: _buildBubble(
          //         t: t, data: data, isMe: isMe,
          //         type: type, timestamp: ts, docs: docs, index: index),
          //   );
          // },
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final isMe = data['senderId'] == _currentUserId;
              final type = data['type'] ?? 'text';
              final msgId = data['id'] ?? docs[index].id;

              final ts = (data['createdAt'] ?? data['timestamp']) as Timestamp?;
              final currentDate = ts?.toDate();

              // 🔥 PREVIOUS MESSAGE DATE
              DateTime? previousDate;
              if (index < docs.length - 1) {
                final prevData =
                docs[index + 1].data() as Map<String, dynamic>;
                final prevTs =
                (prevData['createdAt'] ?? prevData['timestamp']) as Timestamp?;
                previousDate = prevTs?.toDate();
              }

              bool showDate = false;

              if (currentDate != null) {
                if (previousDate == null) {
                  showDate = true;
                } else {
                  final currentDay =
                  DateTime(currentDate.year, currentDate.month, currentDate.day);
                  final prevDay =
                  DateTime(previousDate.year, previousDate.month, previousDate.day);

                  showDate = currentDay != prevDay;
                }
              }

              return Column(
                children: [
                  if (showDate && currentDate != null)
                    _dateSeparator(t, _getDateLabel(currentDate)),

                  GestureDetector(
                    onLongPress:
                    isMe ? () => _showDeleteDialog(t, msgId) : null,
                    child: _buildBubble(
                      t: t,
                      data: data,
                      isMe: isMe,
                      type: type,
                      timestamp: ts,
                      docs: docs,
                      index: index,
                    ),
                  ),
                ],
              );
            }
        );
      },
    );
  }

  // ── Bubble ────────────────────────────────────────────────────────────────
  Widget _buildBubble({
    required _T t,
    required Map<String, dynamic> data,
    required bool isMe,
    required String type,
    required Timestamp? timestamp,
    required List<QueryDocumentSnapshot> docs,
    required int index,
  }) {
    final isMedia    = type == 'image' || type == 'video';
    final isTappable = type == 'image' || type == 'video' || type == 'document';

    Widget bubble = Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 3),
        constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: isMe ? t.bubbleMe : t.bubbleThem,  
          borderRadius: BorderRadius.only(
            topLeft:     const Radius.circular(12),
            topRight:    const Radius.circular(12),
            bottomLeft:  isMe ? const Radius.circular(12) : const Radius.circular(2),
            bottomRight: isMe ? const Radius.circular(2)  : const Radius.circular(12),
          ),
          boxShadow: [BoxShadow(
              color: t.bubbleShadow, blurRadius: 4,
              offset: const Offset(0, 1))],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft:     const Radius.circular(12),
            topRight:    const Radius.circular(12),
            bottomLeft:  isMe ? const Radius.circular(12) : const Radius.circular(2),
            bottomRight: isMe ? const Radius.circular(2)  : const Radius.circular(12),
          ),
          child: Column(
            crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              if (type == 'text')     _textContent(t, data, isMe),
              if (type == 'image')    _imageContent(data),
              if (type == 'video')    _videoContent(data, isMe),
              if (type == 'audio')    _audioContent(t, data, isMe),
              if (type == 'document') _documentContent(t, data, isMe),
              Padding(
                padding: isMedia
                    ? const EdgeInsets.fromLTRB(8, 2, 8, 6)
                    : const EdgeInsets.fromLTRB(10, 0, 10, 6),
                child:_timestampRow(t, timestamp, isMe, data)
              ),
            ],
          ),
        ),
      ),
    );

    if (isTappable) {
      return GestureDetector(
        onTap: () => Navigator.push(context,
            MaterialPageRoute(builder: (_) =>
                FullScreenMediaViewer(data: data, type: type))),
        onLongPress: isMe
            ? () => _showDeleteDialog(t, data['id'] ?? '') : null,
        child: bubble,
      );
    }
    return bubble;
  }

  // ── Text ──────────────────────────────────────────────────────────────────
  Widget _textContent(_T t, Map<String, dynamic> data, bool isMe) {
    final txt = data['text'] ?? data['message'] ?? "";
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 2),
      child: Text(txt,
          style: TextStyle(
              fontSize: 15,
              color: isMe ? t.bubbleTxtMe : t.bubbleTxtThem)),
    );
  }

  // ── Image ─────────────────────────────────────────────────────────────────
  Widget _imageContent(Map<String, dynamic> data) {
    final url = data['text'] ?? data['message'] ?? '';
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: url, width: 220, height: 260, fit: BoxFit.cover,
          placeholder: (_, __) => Container(
              width: 220, height: 260, color: Colors.grey.shade800,
              child: const Center(child: CupertinoActivityIndicator())),
          errorWidget: (_, __, ___) => Container(
              width: 220, height: 260, color: Colors.grey.shade800,
              child: const Icon(Icons.broken_image, size: 40, color: Colors.white54)),
        ),
        Positioned(
          bottom: 8, right: 8,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
                color: Colors.black45,
                borderRadius: BorderRadius.circular(12)),
            child: const Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(Icons.fullscreen, color: Colors.white, size: 14),
              SizedBox(width: 4),
              Text('View',
                  style: TextStyle(color: Colors.white, fontSize: 11)),
            ]),
          ),
        ),
      ],
    );
  }

  // ── Video ─────────────────────────────────────────────────────────────────
  Widget _videoContent(Map<String, dynamic> data, bool isMe) {
    final url = data['text'] ?? data['message'] ?? '';
    return _VideoMessageWidget(videoUrl: url, isMe: isMe);
  }

  // ── Audio ─────────────────────────────────────────────────────────────────
  Widget _audioContent(_T t, Map<String, dynamic> data, bool isMe) {
    final msgId      = data['id'] ?? '';
    final audioUrl   = data['text'] ?? data['message'] ?? '';
    final durationSec = (data['audioDuration'] ?? 0) as int;
    final m = durationSec ~/ 60;
    final s = (durationSec % 60).toString().padLeft(2, '0');
    final durationLabel = "$m:$s";

    final playBtnBg  = isMe
        ? Colors.green.shade700.withOpacity(t.light ? 0.2 : 0.3)
        : _T.brand.withOpacity(0.15);
    final playBtnClr = isMe
        ? (t.light ? Colors.green.shade800 : Colors.green.shade300)
        : (t.light ? _T.brand : Colors.lightBlue.shade200);
    final waveColor  = isMe
        ? (t.light ? Colors.green.shade700 : Colors.green.shade400)
        : (t.light ? Colors.grey.shade400   : Colors.grey.shade600);
    final durColor   = isMe ? playBtnClr : t.tsThem;

    return Obx(() {
      final isPlaying = _chatCtrl.isPlayingAudio.value &&
          _chatCtrl.currentPlayingAudioId.value == msgId;
      return Padding(
        padding: const EdgeInsets.fromLTRB(10, 8, 10, 4),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          GestureDetector(
            onTap: () => _chatCtrl.playAudio(msgId, audioUrl),
            child: Container(
              width: 38, height: 38,
              decoration: BoxDecoration(
                  color: playBtnBg, shape: BoxShape.circle),
              child: Icon(
                  isPlaying ? Icons.pause : Icons.play_arrow,
                  color: playBtnClr, size: 22),
            ),
          ),
          const SizedBox(width: 8),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(
              width: 110, height: 24,
              child: CustomPaint(
                  painter: _WaveformPainter(color: waveColor)),
            ),
            const SizedBox(height: 2),
            Text(durationLabel,
                style: TextStyle(fontSize: 11, color: durColor)),
          ]),
        ]),
      );
    });
  }

  // ── Document ──────────────────────────────────────────────────────────────
  Widget _documentContent(_T t, Map<String, dynamic> data, bool isMe) {
    final fileName     = data['fileName'] as String? ?? 'file';
    final fileSizeBytes = (data['fileSizeBytes'] ?? 0) as int;
    final fileExt      = data['fileExt'] as String? ?? '';
    final icon         = FileTypeHelper.getDocumentIcon(fileName);
    final iconColor    = FileTypeHelper.getDocumentColor(fileName);

    return Container(
      padding: const EdgeInsets.all(10),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Container(
          width: 44, height: 44,
          decoration: BoxDecoration(
              color: iconColor.withOpacity(t.light ? 0.12 : 0.22),
              borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: iconColor, size: 26),
        ),
        const SizedBox(width: 10),
        Flexible(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(fileName,
                maxLines: 2, overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w500,
                    color: isMe ? t.bubbleTxtMe : t.bubbleTxtThem)),
            const SizedBox(height: 3),
            Text(
              "${FileTypeHelper.formatFileSize(fileSizeBytes)} · ${fileExt.toUpperCase()}",
              style: TextStyle(fontSize: 11, color: t.docSub),
            ),
          ]),
        ),
        const SizedBox(width: 8),
        Icon(Icons.open_in_new_rounded,
            color: t.light ? _T.brand : Colors.lightBlue.shade200,
            size: 20),
      ]),
    );
  }

  // ── Timestamp row ─────────────────────────────────────────────────────────
  Widget _timestampRow(_T t, Timestamp? ts, bool isMe, Map<String, dynamic> data) {
    final seenBy = List<String>.from(data['seenBy'] ?? []);
    final deliveredTo = List<String>.from(data['deliveredTo'] ?? []);

    IconData icon;
    Color color;

    if (seenBy.contains(receiverId)) {
      icon = Icons.done_all;
      color = t.tickColor; // 🔵 BLUE
    } else if (deliveredTo.contains(receiverId)) {
      icon = Icons.done_all;
      color = Colors.grey; // ⚪ GREY DOUBLE
    } else {
      icon = Icons.check;
      color = Colors.grey; // ✓ SINGLE
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(_formatTs(ts),
            style: TextStyle(
                fontSize: 11,
                color: isMe ? t.tsMe : t.tsThem)),
        if (isMe) ...[
          const SizedBox(width: 3),
          Icon(icon, size: 16, color: color),
        ],
      ],
    );
  }
  // ── Delete dialog ─────────────────────────────────────────────────────────
  void _showDeleteDialog(_T t, String messageId) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: t.dialogBg,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14)),
        title: Text("Delete message?",
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w600,
                color: t.dialogTitle)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteMessage(messageId);
            },
            child: const Text("Delete",
                style: TextStyle(color: Colors.red)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel",
                style: TextStyle(color: t.lastSeen)),
          ),
        ],
      ),
    );
  }

  // =========================================================================
  //  MEDIA SHEET
  // =========================================================================
  void _showMediaSheet() {
    final t = _T(Theme.of(context).brightness == Brightness.light);
    showModalBottomSheet(
      context: context,
      backgroundColor: t.sheetBg,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle
              Container(
                width: 40, height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                    color: t.sheetHandle,
                    borderRadius: BorderRadius.circular(4)),
              ),
              // Row 1
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _mediaOption(t, icon: Icons.camera_alt_rounded, label: "Camera",
                      color: Colors.deepPurple, onTap: () async {
                        Get.back();
                        final file = await _chatCtrl.pickImageFromCamera();
                        if (file != null) {
                          final url = await _chatCtrl.uploadImages(context, file.path);
                          if (url.isNotEmpty) _sendImageMessage(url);
                        }
                      }),
                  _mediaOption(t, icon: Icons.photo_library_rounded, label: "Gallery",
                      color: Colors.pink, onTap: () async {
                        Get.back();
                        final file = await _chatCtrl.pickImageFromGallery();
                        if (file != null) {
                          final url = await _chatCtrl.uploadImages(context, file.path);
                          if (url.isNotEmpty) _sendImageMessage(url);
                        }
                      }),
                  _mediaOption(t, icon: Icons.videocam_rounded, label: "Camera\nVideo",
                      color: Colors.red, onTap: () async {
                        Get.back();
                        final file = await _chatCtrl.pickVideoFromCamera();
                        if (file != null) {
                          final url = await _chatCtrl.uploadVideo(context, file.path);
                          if (url.isNotEmpty) _sendVideoMessage(url);
                        }
                      }),
                  _mediaOption(t, icon: Icons.video_library_rounded, label: "Gallery\nVideo",
                      color: Colors.orange, onTap: () async {
                        Get.back();
                        final file = await _chatCtrl.pickVideoFromGallery();
                        if (file != null) {
                          final url = await _chatCtrl.uploadVideo(context, file.path);
                          if (url.isNotEmpty) _sendVideoMessage(url);
                        }
                      }),
                ],
              ),
              const SizedBox(height: 20),
              // Row 2
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _mediaOption(t, icon: Icons.picture_as_pdf_rounded, label: "PDF",
                      color: Colors.red.shade700, onTap: () => _pickAndSendDocument()),
                  _mediaOption(t, icon: Icons.description_rounded, label: "Document",
                      color: Colors.blue, onTap: () => _pickAndSendDocument()),
                  _mediaOption(t, icon: Icons.table_chart_rounded, label: "Excel",
                      color: Colors.green.shade700, onTap: () => _pickAndSendDocument()),
                  _mediaOption(t, icon: Icons.text_snippet_rounded, label: "Text / CSV",
                      color: Colors.teal, onTap: () => _pickAndSendDocument()),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickAndSendDocument() async {
    Get.back();
    final picked = await _chatCtrl.pickDocument();
    if (picked == null) return;
    final url = await _chatCtrl.uploadDocument(context, picked.path);
    if (url.isNotEmpty) {
      await _sendDocumentMessage(
          fileUrl: url, fileName: picked.name,
          fileSizeBytes: picked.sizeBytes, fileExt: picked.ext);
    }
  }

  Widget _mediaOption(_T t, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color color = Colors.blue,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(children: [
        Container(
          width: 56, height: 56,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          child: Icon(icon, color: Colors.white, size: 26),
        ),
        const SizedBox(height: 8),
        Text(label,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11, color: t.sheetLabel)),
      ]),
    );
  }

  // =========================================================================
  //  AUDIO RECORDING
  // =========================================================================
  Future<void> _stopAndSendAudio() async {
    final path = await _chatCtrl.stopRecording();
    if (path != null) {
      final url = await _chatCtrl.uploadAudio(context, path);
      if (url.isNotEmpty) {
        await _sendAudioMessage(url,
            durationSeconds: _chatCtrl.recordingSeconds);
      }
    }
  }

  Future<void> _onMicTapDown() async { await _chatCtrl.startRecording(); }
  Future<void> _onMicTapUp()   async { await _stopAndSendAudio(); }
  Future<void> _onMicCancel()  async { await _chatCtrl.stopRecording(cancel: true); }

  // =========================================================================
  //  INPUT BAR
  // =========================================================================
  Widget _buildInputBar(_T t) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 6, 8, 10),
      decoration: BoxDecoration(
        color: t.inputBg,
        border: Border(top: BorderSide(color: t.inputBorder)),
      ),
      child: SafeArea(
        top: false,
        child: Obx(() {
          if (_chatCtrl.isRecording.value) return _recordingBar(t);
          return Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Attachment
              IconButton(
                icon: Icon(Icons.add, size: 26, color: t.inputIcon),
                onPressed: _showMediaSheet,
              ),
              // Text field
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: t.inputField,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: TextField(
                    controller: _msgCtrl,
                    minLines: 1, maxLines: 5,
                    style: TextStyle(fontSize: 16, color: t.inputTxt),
                    decoration: InputDecoration(
                      hintText: "Type a message...",
                      hintStyle:
                      TextStyle(color: t.inputHint, fontSize: 15),
                      filled: false,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(22),
                          borderSide: BorderSide.none),
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
              ),
              // Camera (when empty)
              if (_msgCtrl.text.trim().isEmpty)
                IconButton(
                  icon: Icon(Icons.camera_alt_outlined,
                      size: 24, color: t.inputIcon),
                  onPressed: () async {
                    final file = await _chatCtrl.pickImageFromCamera();
                    if (file != null) {
                      final url =
                      await _chatCtrl.uploadImages(context, file.path);
                      if (url.isNotEmpty) _sendImageMessage(url);
                    }
                  },
                ),
              // Send / Mic
              if (_msgCtrl.text.trim().isNotEmpty)
                _sendButton()
              else
                _micButton(),
            ],
          );
        }),
      ),
    );
  }

  Widget _sendButton() => GestureDetector(
    onTap: _sendTextMessage,
    child: Container(
      width: 44, height: 44,
      margin: const EdgeInsets.only(left: 4),
      decoration: const BoxDecoration(
          color: _T.brand, shape: BoxShape.circle),
      child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
    ),
  );

  Widget _micButton() => GestureDetector(
    onLongPressStart: (_) => _onMicTapDown(),
    onLongPressEnd:   (_) => _onMicTapUp(),
    onLongPressCancel: _onMicCancel,
    child: Container(
      width: 44, height: 44,
      margin: const EdgeInsets.only(left: 4),
      decoration: const BoxDecoration(
          color: _T.brand, shape: BoxShape.circle),
      child: const Icon(Icons.mic, color: Colors.white, size: 22),
    ),
  );

  // ── Recording bar ─────────────────────────────────────────────────────────
  Widget _recordingBar(_T t) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: t.recBg,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: t.recBorder),
      ),
      child: Row(children: [
        _BlinkingDot(),
        const SizedBox(width: 8),
        Obx(() => Text(_chatCtrl.recordingDuration.value,
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w600,
                color: t.recTxt))),
        const SizedBox(width: 8),
        Expanded(
          child: Text("Recording…",
              style: TextStyle(color: t.recMuted, fontSize: 13)),
        ),
        // Cancel
        GestureDetector(
          onTap: _onMicCancel,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: t.recCancelBg, shape: BoxShape.circle),
            child: const Icon(Icons.delete_outline,
                color: Colors.red, size: 20),
          ),
        ),
        const SizedBox(width: 8),
        // Send
        GestureDetector(
          onTap: _stopAndSendAudio,
          child: Container(
            width: 44, height: 44,
            decoration: const BoxDecoration(
                color: _T.brand, shape: BoxShape.circle),
            child: const Icon(Icons.send_rounded,
                color: Colors.white, size: 20),
          ),
        ),
      ]),
    );
  }

  String _formatTs(Timestamp? ts) {
    if (ts == null) return '';
    final dt = ts.toDate();
    final h  = dt.hour > 12 ? dt.hour - 12 : dt.hour == 0 ? 12 : dt.hour;
    final ap = dt.hour >= 12 ? 'PM' : 'AM';
    final m  = dt.minute.toString().padLeft(2, '0');
    return "$h:$m $ap";
  }
}

// =============================================================================
//  BLINKING DOT
// =============================================================================
class _BlinkingDot extends StatefulWidget {
  @override
  State<_BlinkingDot> createState() => _BlinkingDotState();
}
class _BlinkingDotState extends State<_BlinkingDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ac =
  AnimationController(vsync: this,
      duration: const Duration(milliseconds: 600))
    ..repeat(reverse: true);
  @override
  void dispose() { _ac.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) => FadeTransition(
    opacity: _ac,
    child: const Icon(Icons.fiber_manual_record, color: Colors.red, size: 14),
  );
}

// =============================================================================
//  VIDEO MESSAGE WIDGET
// =============================================================================
class _VideoMessageWidget extends StatefulWidget {
  final String videoUrl;
  final bool isMe;
  const _VideoMessageWidget({required this.videoUrl, required this.isMe});
  @override
  State<_VideoMessageWidget> createState() => _VideoMessageWidgetState();
}
class _VideoMessageWidgetState extends State<_VideoMessageWidget> {
  VideoPlayerController? _controller;
  bool _initialized = false;
  bool _isPlaying   = false;

  @override
  void initState() { super.initState(); _init(); }
  Future<void> _init() async {
    _controller = VideoPlayerController.network(widget.videoUrl);
    await _controller!.initialize();
    _controller!.addListener(() { if (mounted) setState(() {}); });
    if (mounted) setState(() => _initialized = true);
  }
  @override
  void dispose() { _controller?.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.center, children: [
      Container(
        width: 220, height: 260, color: Colors.black,
        child: _initialized
            ? AspectRatio(
            aspectRatio: _controller!.value.aspectRatio,
            child: VideoPlayer(_controller!))
            : const Center(child: CupertinoActivityIndicator()),
      ),
      if (_initialized)
        GestureDetector(
          onTap: () => setState(() {
            _isPlaying = !_isPlaying;
            _isPlaying ? _controller!.play() : _controller!.pause();
          }),
          child: Container(
            width: 44, height: 44,
            decoration: const BoxDecoration(
                color: Colors.black45, shape: BoxShape.circle),
            child: Icon(
                _isPlaying ? Icons.pause : Icons.play_arrow,
                color: Colors.white, size: 26),
          ),
        ),
      const Positioned(bottom: 8, right: 8,
          child: Icon(Icons.fullscreen, color: Colors.white70, size: 20)),
    ]);
  }
}

// =============================================================================
//  WAVEFORM PAINTER
// =============================================================================
class _WaveformPainter extends CustomPainter {
  final Color color;
  const _WaveformPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;
    const bars    = 18;
    final spacing = size.width / bars;
    const heights = [
      0.4, 0.7, 0.5, 0.9, 0.6, 0.8, 0.4, 1.0, 0.7, 0.5,
      0.8, 0.6, 0.9, 0.5, 0.7, 0.4, 0.6, 0.5,
    ];
    for (int i = 0; i < bars; i++) {
      final h  = size.height * heights[i % heights.length];
      final x  = i * spacing + spacing / 2;
      final cy = size.height / 2;
      canvas.drawLine(Offset(x, cy - h / 2), Offset(x, cy + h / 2), paint);
    }
  }
  @override
  bool shouldRepaint(_WaveformPainter old) => old.color != color;
}

// =============================================================================
//  FILE TYPE HELPER
// =============================================================================
class FileTypeHelper {
  static IconData getDocumentIcon(String fileName) {
    final ext = fileName.split('.').last.toLowerCase();
    switch (ext) {
      case 'pdf':  return Icons.picture_as_pdf_rounded;
      case 'doc':  case 'docx': return Icons.description_rounded;
      case 'xls':  case 'xlsx': return Icons.table_chart_rounded;
      case 'csv':  return Icons.list_alt_rounded;
      case 'txt':  return Icons.text_snippet_rounded;
      case 'zip':  case 'rar':  return Icons.folder_zip_rounded;
      case 'png':  case 'jpg':  case 'jpeg':
      case 'gif':  case 'webp': return Icons.image_rounded;
      default:     return Icons.insert_drive_file_rounded;
    }
  }

  static Color getDocumentColor(String fileName) {
    final ext = fileName.split('.').last.toLowerCase();
    switch (ext) {
      case 'pdf':  return Colors.red;
      case 'doc':  case 'docx': return Colors.blue;
      case 'xls':  case 'xlsx': return Colors.green.shade700;
      case 'csv':  return Colors.teal;
      case 'txt':  return Colors.orange;
      case 'zip':  case 'rar':  return Colors.amber.shade700;
      case 'png':  case 'jpg':  case 'jpeg':
      case 'gif':  case 'webp': return Colors.purple;
      default:     return Colors.blueGrey;
    }
  }

  static String formatFileSize(int bytes) {
    if (bytes <= 0) return "0 B";
    if (bytes < 1024) return "$bytes B";
    if (bytes < 1024 * 1024) return "${(bytes / 1024).toStringAsFixed(1)} KB";
    return "${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB";
  }
}
