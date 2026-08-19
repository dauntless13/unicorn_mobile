import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;

class FirebaseSendAdminNotification {

  // 🔥 OPTION 1: Send DATA-ONLY messages (Recommended for full control)
  static Future<void> sendSingleNotification(
      String title,
      String description,
      String image,
      String fcmToken,
      BuildContext? context, {
        Map<String, String>? data,
        int badgeCount = 1,
      }) async {
    try {
      final serviceAccountKey =
      await rootBundle.loadString('assets/google-services.json');
      final credentials =
      ServiceAccountCredentials.fromJson(json.decode(serviceAccountKey));

      final scopes = ['https://www.googleapis.com/auth/cloud-platform'];
      final client = await clientViaServiceAccount(credentials, scopes);

      final accessToken = client.credentials.accessToken.data;

      print("AccessToken: $accessToken");
      print('user+notification++$fcmToken+++$title++$description+++$image');

      // 🔥 KEY CHANGE: Send ONLY data payload, no notification payload
      // This prevents FCM from showing automatic notifications
      final Map<String, dynamic> messageData = {
        "title": title,
        "body": description,
        if (image.isNotEmpty) "image": image,
        if (data != null) ...data,
      };

      // final Map<String, dynamic> message = {
      //   'token': fcmToken,
      //   'data': messageData, // ONLY data, no 'notification' field
      //   'apns': {
      //     'payload': {
      //       'aps': {
      //         'badge': badgeCount,
      //         'sound': 'default',
      //         'alert': {
      //           'title': title,
      //           'body': description,
      //         },
      //         'content-available': 1, // Wake app in background
      //       }
      //     }
      //   },
      //   'android': {
      //     'priority': 'high', // Ensure background delivery
      //     'data': { // Android needs data in both places
      //       'title': title,
      //       'body': description,
      //       'image': image.isNotEmpty ? image : null,
      //       'channel_id': 'high_importance_channel',
      //     },
      //   },
      // };
      final message = {
        'token': fcmToken,

        // 🔥 REQUIRED for killed iOS
        'notification': {
          'title': title,
          'body': description,
        },

        'data': {
          'type': data?['type'] ?? 'chat',
          'senderId': data?['senderId'] ?? '',
        },

        'apns': {
          'payload': {
            'aps': {
              'badge': badgeCount,
              'sound': 'default',
            }
          }
        },

        'android': {
          'priority': 'high',
          'notification': {
            'channel_id': 'high_importance_channel',
          }
        }
      };


      const String url =
          'https://fcm.googleapis.com/v1/projects/unicorn-nursery-dc96e/messages:send';

      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Authorization': 'Bearer $accessToken',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, dynamic>{
          'message': message,
        }),
      );

      if (response.statusCode == 200) {
        print('✅ Data-only notification sent successfully: ${response.body}');
      } else {
        print('❌ Failed to send notification: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error sending notification: $e');
    }
  }

  // 🔥 OPTION 2: Send NOTIFICATION messages (simpler but less control)
  // Use this if you want FCM to handle notifications automatically in background
  static Future<void> sendNotificationWithPayload(
      String title,
      String description,
      String image,
      String fcmToken,
      BuildContext context, {
        Map<String, String>? data,
        int badgeCount = 1,
      }) async {
    try {
      final serviceAccountKey =
      await rootBundle.loadString('assets/google-services.json');
      final credentials =
      ServiceAccountCredentials.fromJson(json.decode(serviceAccountKey));

      final scopes = ['https://www.googleapis.com/auth/cloud-platform'];
      final client = await clientViaServiceAccount(credentials, scopes);

      final accessToken = client.credentials.accessToken.data;

      final Map<String, dynamic> message = {
        'token': fcmToken,
        'notification': { // FCM will show this automatically
          'title': title,
          'body': description,
          if (image.isNotEmpty) 'image': image,
        },
        'data': data ?? {}, // Additional data for app
        'apns': {
          'payload': {
            'aps': {
              'badge': badgeCount,
              'sound': 'default',
            }
          }
        },
        'android': {
          'notification': {
            'channel_id': 'high_importance_channel',
          },
        },
      };

      const String url =
          'https://fcm.googleapis.com/v1/projects/unicorn-nursery-dc96e/messages:send';

      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Authorization': 'Bearer $accessToken',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, dynamic>{
          'message': message,
        }),
      );

      if (response.statusCode == 200) {
        print('✅ Notification sent successfully: ${response.body}');
      } else {
        print('❌ Failed to send notification: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error sending notification: $e');
    }
  }
}
