import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:untitled/common/api_service/user_service.dart';
import 'package:untitled/common/managers/session_manager.dart';
import 'package:untitled/utilities/const.dart';

bool isSubscribe = false;
bool isPurchaseConfig = false;

/// يتم ضبطه بعد fetchSetting من السيرفر
bool isInAppPurchaseEnabled = false;

class SubscriptionManager {
  static var shared = SubscriptionManager();

  List<Package> packages = [];

  /// تهيئة RevenueCat (فقط إذا كانت المشتريات مفعّلة)
  Future<void> initPlatformState() async {
    if (!isInAppPurchaseEnabled) {
      log('ℹ️ In-App Purchase disabled from backend');
      return;
    }

    PurchasesConfiguration? configuration;

    if (Platform.isAndroid && revenuecatAndroidApiKey.isNotEmpty) {
      configuration = PurchasesConfiguration(revenuecatAndroidApiKey);
    } else if (Platform.isIOS && revenuecatAppleApiKey.isNotEmpty) {
      configuration = PurchasesConfiguration(revenuecatAppleApiKey);
    }

    if (configuration == null) {
      log('❌ RevenueCat configuration missing');
      return;
    }

    Purchases.setLogLevel(LogLevel.debug);
    await Purchases.configure(configuration);

    isPurchaseConfig = await Purchases.isConfigured;

    if (!isPurchaseConfig) {
      log('❌ RevenueCat not configured');
      return;
    }

    await fetchOfferings();
    await subscriptionListener();
  }

  /// التحقق من حالة الاشتراك
  bool checkSubscription(CustomerInfo customerInfo) {
    if (customerInfo.latestExpirationDate == null ||
        customerInfo.latestExpirationDate!.isEmpty) {
      isSubscribe = false;
    } else {
      DateTime expireDate =
      DateTime.parse(customerInfo.latestExpirationDate!).toLocal();
      DateTime now = DateTime.now();

      isSubscribe = expireDate.isAfter(now);
    }

    log('✅ Subscription Status : ${isSubscribe ? 'Active' : 'InActive'}');
    return isSubscribe;
  }

  /// مستمع تحديثات الاشتراك
  Future<void> subscriptionListener() async {
    if (!isPurchaseConfig) {
      log('⚠️ subscriptionListener skipped');
      return;
    }

    try {
      Purchases.addCustomerInfoUpdateListener((customerInfo) async {
        checkSubscription(customerInfo);

        if (SessionManager.shared.getUserID() != 0 &&
            SessionManager.shared.getUser()?.isVerified != 2) {
          UserService.shared.editProfile(
            isVerified: isSubscribe ? 3 : 0,
            completion: (p0) {},
          );
        }
      });
    } on PlatformException catch (e) {
      log('RevenueCat Error : ${e.message}');
    }
  }

  /// تسجيل الدخول في RevenueCat
  Future<LogInResult?> login(String appUserID) async {
    if (!isPurchaseConfig) return null;
    return await Purchases.logIn(appUserID);
  }

  /// استرجاع المشتريات
  Future<(CustomerInfo?, String?)> restorePurchase() async {
    if (!isPurchaseConfig) {
      return (null, 'Purchases not configured');
    }

    try {
      CustomerInfo restoredInfo = await Purchases.restorePurchases();
      return (restoredInfo, null);
    } on PlatformException catch (e) {
      return (null, e.message);
    }
  }

  /// جلب الباقات
  Future<(Offering?, String?)> fetchOfferings() async {
    if (!isPurchaseConfig) {
      log('⚠️ fetchOfferings skipped: Purchases not configured');
      return (null, 'Purchases not configured');
    }

    try {
      Offerings offerings = await Purchases.getOfferings();
      packages = offerings.current?.availablePackages ?? [];
      return (offerings.current, null);
    } on PlatformException catch (e) {
      log(e.message.toString());
      return (null, e.message);
    }
  }

  /// فحص حالة الاشتراك الحالية
  Future<bool?> checkSubscriptionStatus() async {
    if (!isPurchaseConfig) return false;

    try {
      CustomerInfo customerInfo = await Purchases.getCustomerInfo();
      return checkSubscription(customerInfo);
    } on PlatformException catch (e) {
      log(e.message.toString());
    }
    return null;
  }

  /// تنفيذ عملية شراء
  Future<bool?> makePurchase(Package package) async {
    if (!isPurchaseConfig) {
      log('❌ Purchase attempted without configuration');
      return null;
    }

    try {
      CustomerInfo customerInfo =
          (await Purchases.purchasePackage(package)).customerInfo;
      return checkSubscription(customerInfo);
    } on PlatformException catch (e) {
      log(e.toString());
      return null;
    }
  }
}
