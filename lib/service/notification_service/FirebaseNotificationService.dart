import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../ui/common_screens/chat/view/message_screen.dart';
import '../../routes/app_routs.dart';
import '../../service/session/session_helper.dart';
import '../../service/api_service/api_worker.dart';
import '../../ui/parent/main_tab_bar/controller/maintab_controller.dart';
import '../../ui/parent/main_tab_bar/view/screeen/profile/view/student_leave/view/student_leave_listing.dart';
import '../../ui/teacher/teacher_bottom_tab/controller/teacher_bottom_tab_controller.dart';
import '../../ui/teacher/teacher_bottom_tab/view/screens/profile/view/my_leave/my_leave_list.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel',
  'High Importance Notifications',
  description: 'This channel is used for important notifications',
  importance: Importance.max,
  showBadge: true,
  playSound: true,
);

class FirebaseNotificationService {
  static String? currentChatId;
  static final FlutterLocalNotificationsPlugin _localPlugin = FlutterLocalNotificationsPlugin();
  static final GetStorage _box = GetStorage();
  
  static const String _pendingPayloadKey = 'pending_notification_payload';
  
  static bool _isAppReadyForNavigation = false;
  static String? _internalPendingPayload;

  static String _buildNotificationPayload(Map<String, dynamic> data) {
    final type = (data['type'] ?? '').toString();
    final normalizedType = type.trim().toLowerCase();
    
    // Robust extraction for various ID keys
    final id = (normalizedType == 'chat'
            ? (data['chatId'] ?? data['chat_id'] ?? data['id'] ?? data['slug'])
            : (data['studentSlug'] ?? data['student_slug'] ?? data['studentId'] ?? data['student_id'] ?? data['trip_id'] ?? data['id'] ?? data['slug']))
        ?.toString() ?? '';
        
    return '$type|$id';
  }

  static Future<void> init() async {
    try {
      final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

      await firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        announcement: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
      );

      await firebaseMessaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      const initializationSettingsAndroid = AndroidInitializationSettings('ic_notification');
      const initializationSettingsDarwin = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      await _localPlugin.initialize(
        const InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsDarwin,
        ),
        onDidReceiveNotificationResponse: (response) {
          if (response.payload != null && response.payload!.isNotEmpty) {
            _handleOnTap(response.payload!);
          }
        },
        onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
      );

      final androidPlugin = _localPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      await androidPlugin?.createNotificationChannel(channel);
      if (Platform.isAndroid) {
        await androidPlugin?.requestNotificationsPermission();
        await Permission.notification.request();
      }

      final initialMessage = await firebaseMessaging.getInitialMessage();
      if (initialMessage != null) {
        final payload = _buildNotificationPayload(initialMessage.data);
        _handleOnTap(payload);
      }

      final launchDetails = await _localPlugin.getNotificationAppLaunchDetails();
      if (launchDetails?.didNotificationLaunchApp ?? false) {
        final payload = launchDetails?.notificationResponse?.payload;
        if (payload != null && payload.isNotEmpty) {
          _handleOnTap(payload);
        }
      }

      FirebaseMessaging.onMessage.listen((message) {
        print('Foreground FCM: ${message.messageId}');
        _showForegroundNotification(message);
      });

      FirebaseMessaging.onMessageOpenedApp.listen((message) {
        print('Background FCM tap: ${message.messageId}');
        final payload = _buildNotificationPayload(message.data);
        _handleOnTap(payload);
      });

      firebaseMessaging.onTokenRefresh.listen((token) {
        persistToken(Get.context);
      });

      await persistToken(Get.context);
      print('FCM Token: ${await firebaseMessaging.getToken()}');
    } catch (e, st) {
      print('Notification Init Error: $e\n$st');
    }
  }

  static Future<void> persistToken(BuildContext? context) async {
    try {
      final token = await FirebaseMessaging.instance.getToken();
      if (token == null || token.isEmpty) return;

      final login = await SessionHelper().getLoginResponse();
      final userId = login?.data?.user?.id;
      if (userId == null || userId.isEmpty) return;

      if (context != null && context.mounted) {
        await ApiWorker().updateFcmToken(token, context);
      }

      final chats = await FirebaseFirestore.instance
          .collection('chats')
          .where('participants', arrayContains: userId)
          .get();
      for (final doc in chats.docs) {
        await doc.reference.update({"participantsTokens.$userId": token});
      }
    } catch (e) {
      print('FCM persist token error: $e');
    }
  }

  static Future<void> _showForegroundNotification(RemoteMessage message) async {
    final data = message.data;
    final type = (data['type'] ?? '').toString().toLowerCase();
    final incomingChatId = (data['chatId'] ?? data['chat_id'] ?? data['id'] ?? data['slug'])?.toString();

    // BLOCK if already in the specific chat
    if (type == 'chat' && incomingChatId != null && currentChatId != null && 
        incomingChatId.trim() == currentChatId!.trim()) {
      print('⛔ Notification suppressed: User is in this chat');
      return;
    }

    await _displayLocalNotification(message);
  }

  static Future<void> _displayLocalNotification(RemoteMessage message) async {
    try {
      final data = message.data;
      final title = message.notification?.title ?? data['title'] ?? 'New Message';
      final body = message.notification?.body ?? data['body'] ?? data['message'] ?? '';

      if (title.isEmpty && body.isEmpty) return;

      final details = NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id, channel.name,
          channelDescription: channel.description,
          importance: Importance.max,
          priority: Priority.high,
          icon: 'ic_notification',
          playSound: true,
          enableVibration: true,
          ticker: 'unicorn',
        ),
        iOS: const DarwinNotificationDetails(presentAlert: true, presentBadge: true, presentSound: true),
      );

      final id = (DateTime.now().millisecondsSinceEpoch % 100000) + (message.messageId.hashCode % 10000);
      
      await _localPlugin.show(
        id, title, body, details,
        payload: _buildNotificationPayload(data),
      );
    } catch (e) {
      print('Display Error: $e');
    }
  }

  static void _handleOnTap(String payload) {
    print('🔔 Notification Tap Detected: $payload');
    _internalPendingPayload = payload;
    _box.write(_pendingPayloadKey, payload); // Persist for cold start resilience
    _processNavigation();
  }

  static Future<void> markAppReadyForNotificationNavigation() async {
    print('🔔 App Ready for Navigation');
    _isAppReadyForNavigation = true;
    
    // Recover from storage if lost in memory
    final stored = _box.read(_pendingPayloadKey);
    if (stored != null && (_internalPendingPayload == null || _internalPendingPayload!.isEmpty)) {
      _internalPendingPayload = stored;
    }
    
    await _processNavigation();
  }

  static Future<void> _processNavigation() async {
    if (!_isAppReadyForNavigation || _internalPendingPayload == null) {
      print('🔔 Navigation Deferred: Ready=$_isAppReadyForNavigation, Payload=${_internalPendingPayload != null}');
      return;
    }

    final payload = _internalPendingPayload!;
    _internalPendingPayload = null;
    await _box.remove(_pendingPayloadKey);

    print('🔔 Executing Navigation for: $payload');
    
    // Give GetX/Splash/Home transition enough time to finish
    await Future.delayed(const Duration(milliseconds: 1200));
    
    try {
      final parts = payload.split('|');
      final type = parts[0].trim();
      final id = parts.length > 1 ? parts.sublist(1).join('|').trim() : '';

      await navigateFromNotification(type: type, id: id);
    } catch (e) {
      print('Process Navigation Error: $e');
    }
  }

  static Future<void> navigateFromNotification({required String type, String? id}) async {
    final normalizedType = type.trim().toUpperCase();
    if (normalizedType.isEmpty) return;

    final login = await SessionHelper().getLoginResponse();
    final role = (login?.data?.user?.role ?? '').trim().toUpperCase();

    if (role == 'TEACHER') {
      await _navigateTeacher(normalizedType, id);
    } else if (role == 'PARENT') {
      await _navigateParent(normalizedType, id);
    }
  }

  static Future<void> _navigateTeacher(String type, String? id) async {
    switch (type) {
      case 'CHAT':
        await _openTeacherTab(3);
        if (id != null && id.isNotEmpty) {
          await Future.delayed(const Duration(milliseconds: 500));
          Get.to(() => const AllMessageScreen(), arguments: {
            'chatId': id, 'receiverId': '', 'receiverName': 'Chat',
            'receiverImage': '', 'fcmToken': '', 'isOnline': false, 'chatType': 0
          });
        }
        break;
      case 'LEAVE':
        Get.to(() => const MyLeaveList());
        break;
      case 'REPORT':
      case 'POST':
        await _openTeacherTab(0);
        break;
      case 'EVENT':
      case 'HOLIDAY':
        await _openTeacherTab(1);
        break;
      case 'FEES':
      case 'BILLING':
        await _openTeacherTab(2);
        break;
    }
  }

  static Future<void> _navigateParent(String type, String? id) async {
    switch (type) {
      case 'CHAT':
        await _openParentTab(3);
        if (id != null && id.isNotEmpty) {
          await Future.delayed(const Duration(milliseconds: 500));
          Get.to(() => const AllMessageScreen(), arguments: {
            'chatId': id, 'receiverId': '', 'receiverName': 'Chat',
            'receiverImage': '', 'fcmToken': '', 'isOnline': false, 'chatType': 0
          });
        }
        break;
      case 'LEAVE':
        Get.to(() => const StudentLeaveListing());
        break;
      case 'POST':
        await _openParentTab(0);
        break;
      case 'ACTIVITY':
        await _openParentTab(2, kidsTabIndex: 0, studentSlug: id);
        break;
      case 'REPORT':
        await _openParentTab(2, kidsTabIndex: 1, studentSlug: id);
        break;
      case 'EVENT':
      case 'HOLIDAY':
        await _openParentTab(2, kidsTabIndex: 5, studentSlug: id);
        break;
      case 'FEES':
      case 'BILLING':
        await _openParentTab(2, kidsTabIndex: 4, studentSlug: id);
        break;
    }
  }

  static Future<void> _openTeacherTab(int index) async {
    final controller = await _ensureTeacherTabController();
    controller?.changeTab(index);
  }

  static Future<void> _openParentTab(int index, {int? kidsTabIndex, String? studentSlug}) async {
    final controller = await _ensureParentTabController();
    if (index == 2 && kidsTabIndex != null) {
      controller?.openKidsTab(kidsTabIndex, studentSlug: studentSlug);
    } else {
      controller?.changeTab(index, studentSlug: studentSlug);
    }
  }

  static Future<TeacherBottomTabController?> _ensureTeacherTabController() async {
    if (!Get.currentRoute.contains(Routes.TEACHERBOTTOMTAB)) {
      await Get.offAllNamed(Routes.TEACHERBOTTOMTAB);
      await Future.delayed(const Duration(milliseconds: 800));
    }
    for (int i = 0; i < 20; i++) {
      if (Get.isRegistered<TeacherBottomTabController>()) return Get.find<TeacherBottomTabController>();
      await Future.delayed(const Duration(milliseconds: 100));
    }
    return null;
  }

  static Future<MainTabController?> _ensureParentTabController() async {
    if (!Get.currentRoute.contains(Routes.MAINTABBAR)) {
      await Get.offAllNamed(Routes.MAINTABBAR);
      await Future.delayed(const Duration(milliseconds: 800));
    }
    for (int i = 0; i < 20; i++) {
      if (Get.isRegistered<MainTabController>()) return Get.find<MainTabController>();
      await Future.delayed(const Duration(milliseconds: 100));
    }
    return null;
  }

  static Future<void> clearBadge() async {
    await _localPlugin.cancelAll();
  }
}

@pragma('vm:entry-point')
Future<void> myBackgroundMessageHandler(RemoteMessage message) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  print('🔔 Background message: ${message.messageId}');
  
  // If it's a notification message, Android system shows it automatically when in background
  if (message.notification != null) return;

  // Manual display for data-only messages
  await _showBackgroundLocalNotification(message);
}

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse response) {
  if (response.payload != null && response.payload!.isNotEmpty) {
    final box = GetStorage();
    box.write('pending_notification_payload', response.payload);
  }
}

Future<void> _showBackgroundLocalNotification(RemoteMessage message) async {
  try {
    final data = message.data;
    final title = data['title'] ?? 'New Notification';
    final body = data['body'] ?? data['message'] ?? '';
    if (title.isEmpty && body.isEmpty) return;

    final plugin = FlutterLocalNotificationsPlugin();
    await plugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('ic_notification'),
        iOS: DarwinInitializationSettings(),
      ),
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    await plugin.show(
      message.messageId.hashCode, title, body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id, channel.name,
          channelDescription: channel.description,
          importance: Importance.max, priority: Priority.high,
          icon: 'ic_notification', playSound: true,
        ),
        iOS: const DarwinNotificationDetails(),
      ),
      payload: '${data['type']}|${data['chatId'] ?? data['studentSlug'] ?? data['id'] ?? ''}',
    );
  } catch (e) {
    print('Background Show Error: $e');
  }
}
