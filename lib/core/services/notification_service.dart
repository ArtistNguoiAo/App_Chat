import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';

import '../router/app_router.dart';
import '../router/app_router.gr.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  static Future<void> initialize() async {
    // Request permission
    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Initialize local notifications
    const initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );

    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        print("Notification clicked from foreground");
        final payload = response.payload;
        if (payload != null) {
          final appRouter = GetIt.instance<AppRouter>();
          if(payload == 'friend_request') {
            appRouter.push(const NotifyRoute());
            return;
          }
          appRouter.push(MessageRoute(chatId: payload));
        }
      },
    );

    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final appRouter = GetIt.instance<AppRouter>();
      final currentRoute = appRouter.current;
      final type = message.data['type'];
      if(type == 'text' || type == 'image' || type == 'file') {
        final incomingChatId = message.data['chatId'];
        if (currentRoute.name == MessageRoute.name) {
          final currentChatIdOnScreen = currentRoute.pathParams.optString('chatId');
          if (currentChatIdOnScreen == incomingChatId) {
            print("User is on the chat screen for $incomingChatId. Suppressing foreground notification.");
            return;
          }
        }
      }
      _showNotification(message);
    });

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        _handleNotificationClick(message);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _handleNotificationClick(message);
    });
  }

  static void _handleNotificationClick(RemoteMessage message) {
    if(message.data['type'] == 'friend_request') {
      final appRouter = GetIt.instance<AppRouter>();
      appRouter.push(const NotifyRoute());
      return;
    }
    final chatId = message.data['chatId'];
    if (chatId != null) {
      final appRouter = GetIt.instance<AppRouter>();
      appRouter.push(MessageRoute(
        chatId: chatId,
      ));
    }
  }

  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    _showNotification(message);
  }

  static Future<void> _showNotification(RemoteMessage message) async {
    const notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'messages_channel',
        'Messages',
        importance: Importance.max,
        priority: Priority.high,
        enableLights: true,
        enableVibration: true,
        playSound: true,
        showWhen: true,
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    final type = message.data['type'];
    if (type == 'text') {
      await _notificationsPlugin.show(
        message.hashCode,
        message.notification?.title ?? 'New Message',
        message.notification?.body ?? '',
        notificationDetails,
        payload: message.data['chatId'],
      );
    } else if (type == 'image') {
      await _notificationsPlugin.show(
        message.hashCode,
        message.notification?.title ?? 'New Image',
        message.notification?.body ?? '',
        notificationDetails,
        payload: message.data['chatId'],
      );
    } else if (type == 'friend_request') {
      await _notificationsPlugin.show(
        message.hashCode,
        message.notification?.title ?? 'New Friend Request',
        message.notification?.body ?? '',
        notificationDetails,
        payload: 'friend_request',
      );
    } 


  }

  static Future<String?> getToken() async {
    return await _firebaseMessaging.getToken();
  }

  static Future<void> pushNotification({
    required String title,
    required String body,
    required String token,
    String? chatId,
    String type = 'message',
  }) async {
    print("Notification request xxx");
    try {
      final dio = Dio();

      final response = await dio.post(
        'http://194.233.76.208:3000/send-notification',
        data: {
          'token': token,
          'title': title,
          'message': body,
          'data': {
            'chatId': chatId ?? '',
            'type': type,
          },
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'x-api-key': 'NOTIFICATION_ANDROID_API_KEY',
          },
        ),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to send notification');
      }
    } catch (e) {
      print('Error sending notification: $e');
      rethrow;
    }
  }
}
