import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:untitled/common/managers/logger.dart';
import 'package:untitled/common/managers/session_manager.dart';
import 'package:untitled/utilities/const.dart';
import 'package:untitled/utilities/params.dart';

class FirebaseNotificationManager {
  // Singleton
  static final FirebaseNotificationManager shared = FirebaseNotificationManager._internal();

  FirebaseNotificationManager._internal() {}

  // ================== INSTANCES ==================
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  String _lastMessageId = '';

  // ================== ANDROID CHANNEL ==================
  final AndroidNotificationChannel _channel = const AndroidNotificationChannel(
    'chatter',
    'Chatter Notifications',
    description: 'Chat notifications',
    importance: Importance.max,
    playSound: true, // ✅ صوت النظام
    enableVibration: true,
  );

  // ================== INIT ==================
  Future<void> init() async {
    debugPrint('🟡 FCM: بدء التهيئة');

    // 1️⃣ طلب صلاحيات الإشعارات
    final permission = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    debugPrint('🟢 FCM: حالة الصلاحيات = ${permission.authorizationStatus}');

    // 2️⃣ تهيئة flutter_local_notifications
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');

    const iosInit = DarwinInitializationSettings(
      defaultPresentAlert: true,
      defaultPresentSound: true,
      defaultPresentBadge: true,
    );

    final initSettings = InitializationSettings(android: androidInit, iOS: iosInit);

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (response) {
        debugPrint('🟣 FCM: تم الضغط على الإشعار');
        debugPrint('🟣 FCM: payload = ${response.payload}');

        final payload = response.payload;
        if (payload != null && payload.isNotEmpty) {
          _openChat(payload);
        }
      },
    );

    debugPrint('🟢 FCM: Local Notifications مهيأة');

    // 3️⃣ إنشاء Notification Channel (Android)
    await _localNotifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(_channel);

    debugPrint('🟢 FCM: Notification Channel جاهز');

    // 4️⃣ Foreground listener
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('🚨 onMessage اشتغل');
      debugPrint('🚨 notification = ${message.notification}');
      debugPrint('🚨 data = ${message.data}');

      debugPrint('📩 FCM: رسالة واردة والتطبيق مفتوح');
      debugPrint('📩 FCM DATA = ${message.data}');

      final conversationId = message.data[Param.conversationId];
      final currentConversation = SessionManager.shared.getStoredConversation();

      if (conversationId != null && conversationId == currentConversation) {
        // 🔔 إشعار نظامي بصوت فقط بدون إظهار
        showNotification(message);
        return;
      }

      if (message.messageId != _lastMessageId || Platform.isAndroid) {
        _lastMessageId = message.messageId ?? '';
        debugPrint('🔔 FCM: عرض إشعار');
        showNotification(message);
      }
    });

    // 5️⃣ 🔥 جلب التوكن (هنا يتم استدعاء الدالة)
    getNotificationToken((token) {
      debugPrint('🔥🔥🔥 FCM TOKEN = $token');
    });

    debugPrint('✅ FCM: التهيئة اكتملت');
  }

  // ================== SHOW NOTIFICATION ==================
  void showNotification(RemoteMessage message) {
    debugPrint('🟣 FCM: دخول showNotification');

    final title = message.notification?.title ?? message.data['title'] ?? appName;
    final body = message.notification?.body ?? message.data['body'] ?? '';

    final androidDetails = AndroidNotificationDetails(
      _channel.id,
      _channel.name,
      channelDescription: _channel.description,
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentSound: true,
      presentBadge: true,
      sound: 'default',
    );

    final details = NotificationDetails(android: androidDetails, iOS: iosDetails);

    _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      details,
    );

    debugPrint('✅ FCM: flutterLocalNotifications.show تم تنفيذها');
  }

  // ================== OPEN CHAT ==================
  void _openChat(String conversationId) {
    Loggers.success('➡ فتح محادثة من الإشعار: $conversationId');
    SessionManager.shared.setStoredConversation(conversationId);

    // حسب نظامك (Route / Tab)
    // مثال:
    // Get.toNamed('/chat', arguments: conversationId);
  }

  // ================== TOKEN (⬅️ هذه الدالة التي سألت عنها) ==================
  void getNotificationToken(Function(String token) completion) {
    try {
      _firebaseMessaging.getToken().then((value) {
        if (value == null || value.isEmpty) {
          debugPrint('🔴 FCM: التوكن فارغ');
          completion('No Token');
        } else {
          Loggers.success('🟢 FCM Token: $value');
          completion(value);
        }
      });
    } catch (e) {
      debugPrint('❌ FCM: خطأ أثناء جلب التوكن $e');
      completion('No Token');
    }
  }

  // ================== TOPIC ==================
  Future<void> subscribeToTopic(String topic) async {
    await _firebaseMessaging.subscribeToTopic(
      '${topic}_${Platform.isIOS ? 'ios' : 'android'}',
    );
  }

  Future<void> unsubscribeToTopic(String topic) async {
    await _firebaseMessaging.unsubscribeFromTopic(
      '${topic}_${Platform.isIOS ? 'ios' : 'android'}',
    );
  }
}
