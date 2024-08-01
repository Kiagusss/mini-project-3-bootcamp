import 'dart:convert';
import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:mini_project_3_bootcamp/notification_helper.dart';

class FcmHelper {
  Future<void> init() async {
    await FirebaseMessaging.instance.requestPermission();

    final fcmToken = await FirebaseMessaging.instance.getToken();
    debugPrint("FCM Token : $fcmToken");

    /// Handle Notification jika ditekan dari kondisi App ditutup
    FirebaseMessaging.instance.getInitialMessage().then(
      (value) {
        /// Set Payload pada [Notification Helper]
        NotificationHelper.payload.value = jsonEncode(
          {
            "title": value?.notification?.title,
            "body": value?.notification?.body,
            "data": value?.data,
          },
        );
      },
    );

    /// Handle Notification jika ditekan dari kondisi Minimized
    FirebaseMessaging.onMessageOpenedApp.listen((value) {
      /// Set Payload pada [Notification Helper]
      NotificationHelper.payload.value = jsonEncode(
        {
          "title": value.notification?.title,
          "body": value.notification?.body,
          "data": value.data,
        },
      );
    });

    /// Handle Notification jika ditekan dari kondisi App dibuka
    FirebaseMessaging.onMessage.listen(
      (message) async {
        /// Data notifikasi
        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;

        /// Jika notifikasi masuk, dan platform adalah Android.
        if (notification != null && android != null) {
          /// Tampilkan Notifikasi menggunakan Local Notification.
          await NotificationHelper.flutterLocalNotificationsPlugin.show(
            Random().nextInt(99),
            notification.title,
            notification.body,
            payload: jsonEncode(
              {
                "title": notification.title,
                "body": notification.body,
                "data": message.data,
              },
            ),
            NotificationHelper.notificationDetails,
          );
        }
      },
    );
  }

  Map<String, dynamic> tryDecode(data) {
    try {
      return jsonDecode(data);
    } catch (e) {
      return {};
    }
  }
}