import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:untitled/common/managers/firebase_notification_manager.dart';
import 'package:untitled/common/managers/logger.dart';
import 'package:untitled/common/managers/session_manager.dart';
import 'package:untitled/common/managers/subscription_manager.dart';
import 'package:untitled/common/widgets/functions.dart';
import 'package:untitled/localization/allLanguages.dart';
import 'package:untitled/screens/splash_screen/splash_screen_view.dart';
import 'package:untitled/utilities/const.dart';

import 'common/managers/ads/interstitial_manager.dart';
import 'localization/languages.dart';

/// ================= BACKGROUND HANDLER =================
/// هذا يُستدعى عندما يكون التطبيق بالخلفية أو مغلق
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  debugPrint('🟣 [FCM - خلفية] تم استلام إشعار');
  debugPrint('🟣 [FCM - خلفية] البيانات: ${message.data}');
  debugPrint('🟣 [FCM - خلفية] العنوان: ${message.notification?.title}');
  debugPrint('🟣 [FCM - خلفية] النص: ${message.notification?.body}');

  // عرض إشعار محلي (صوت النظام فقط)
  FirebaseNotificationManager.shared.showNotification(message);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  debugPrint('🟡 main: بدء تشغيل التطبيق');

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // ================= Firebase =================
  await Firebase.initializeApp();
  debugPrint('🟢 main: Firebase تم تهيئته');

  // ✅✅✅ السطر المهم (المفقود سابقًا)
  await FirebaseNotificationManager.shared.init();
  debugPrint('🟢 main: FirebaseNotificationManager جاهز');

  // ربط الـ background handler
  FirebaseMessaging.onBackgroundMessage(
    firebaseMessagingBackgroundHandler,
  );
  debugPrint('🟢 main: Background handler تم تسجيله');

  // ================= Storage =================
  await GetStorage.init();
  debugPrint('🟢 main: GetStorage تم تهيئته');

  // تهيئة Singletons
  SessionManager.shared;
  InterstitialManager.shared;
  debugPrint('🟢 main: Session & Ads Managers جاهزين');

  // ================= Tracking (iOS) =================
  await AppTrackingTransparency.requestTrackingAuthorization();
  debugPrint('🟢 main: AppTrackingTransparency تم طلبه');

  // ================= Package Info =================
  await PackageInfo.fromPlatform();
  debugPrint('🟢 main: PackageInfo جاهز');

  // ================= Subscription =================
  SubscriptionManager.shared.initPlatformState();
  debugPrint('🟢 main: SubscriptionManager جاهز');

  // ================= Ads =================
  MobileAds.instance.initialize();
  debugPrint('🟢 main: Google Mobile Ads جاهز');

  // ================= Flutter Errors =================
  FlutterError.onError = (FlutterErrorDetails details) {
    if (details.library == 'image resource service' && (details.exception.toString().contains('404') || details.exception.toString().contains('403'))) {
      return;
    }

    debugPrint('🔴 FlutterError: ${details.exception}');
    FlutterError.presentError(details);
  };

  debugPrint('🚀 main: تشغيل الواجهة');
  runApp(const MyApp());
}

// =====================================================

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('🟡 MyApp: build');

    Functions.changStatusBar(StatusBarStyle.black);
    Lang lang = SessionManager.shared.getLang();

    debugPrint('🟢 MyApp: اللغة الحالية = ${lang.language.languageCode}');

    return GetMaterialApp(
      translations: Languages(),
      locale: lang.language.local,
      fallbackLocale: LANGUAGES.first.language.local,
      debugShowCheckedModeBanner: false,
      title: appName,
      theme: ThemeData(
        useMaterial3: false,
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('🟡 MyHomePage: عرض SplashScreen');
    return const Scaffold(
      body: SplashScreenView(),
    );
  }
}
