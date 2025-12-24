import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/common/managers/session_manager.dart';
import 'package:untitled/common/api_service/common_service.dart';
import 'package:untitled/common/api_service/user_service.dart';
import 'package:untitled/common/controller/base_controller.dart';
import 'package:untitled/screens/block_by_admin_screen/block_by_admin_screen.dart';
import 'package:untitled/screens/interests_screen/interests_screen.dart';
import 'package:untitled/screens/on_boarding_screen/on_boarding_screen.dart';
import 'package:untitled/screens/profile_picture_screen/profile_picture_screen.dart';
import 'package:untitled/screens/tabbar/tabbar_screen.dart';
import 'package:untitled/screens/username_screen/username_screen.dart';

class SplashController extends BaseController {
  @override
  void onInit() async {
    debugPrint('🟡 Splash: بدء onInit');
    await SessionManager.shared.restoreSession();
    debugPrint('🟢 Splash: تم استرجاع الجلسة من التخزين');
    fetchSettings();
    super.onInit();
  }

  void fetchUser(Function() completion) {
    final storedUser = SessionManager.shared.getUser();

    debugPrint('🔵 Splash: فحص المستخدم المخزّن');
    debugPrint('🔵 Splash: user = ${storedUser?.toJson()}');

    if (storedUser != null && storedUser.id != null && storedUser.id! > 0) {
      debugPrint('🟢 Splash: يوجد مستخدم، سيتم جلب الملف الشخصي من API');

      UserService.shared.fetchMyProfile(
        userID: storedUser.id!,
        completion: (user) {
          debugPrint('🟢 Splash: تم جلب الملف الشخصي بنجاح');
          debugPrint('🟢 Splash: user من السيرفر = ${user.toJson()}');

          SessionManager.shared.setUser(user);
          completion();
        },
      );
    } else {
      debugPrint('🔴 Splash: لا يوجد مستخدم مخزّن');
      completion();
    }
  }

  void fetchSettings() {
    debugPrint('🟡 Splash: جلب الإعدادات العامة');
    fetchUser(() {
      CommonService.shared.fetchGlobalSettings((success) {
        debugPrint('🟢 Splash: fetchGlobalSettings = $success');
        if (success) {
          final view = gotoView();
          debugPrint('🟣 Splash: الانتقال إلى ${view.runtimeType}');
          Get.offAll(() => view);
        }
      });
    });
  }

  Widget gotoView() {
    debugPrint('🟡 Splash: الدخول إلى gotoView');

    // ===== فحص تسجيل الدخول =====
    if (!SessionManager.shared.isLogin()) {
      debugPrint('🔴 Splash: المستخدم غير مسجّل دخول');
      return const OnBoardingScreen();
    }

    final user = SessionManager.shared.getUser();

    if (user == null || user.id == null || user.id! <= 0) {
      debugPrint('🔴 Splash: user null أو id غير صالح');
      return const OnBoardingScreen();
    }

    debugPrint('🟢 Splash: المستخدم مسجّل دخول');
    debugPrint('🟢 Splash: بيانات المستخدم = ${user.toJson()}');

    // ===== محظور =====
    if (user.isBlock == 1) {
      debugPrint('🔴 Splash: المستخدم محظور من الإدارة');
      return const BlockedByAdminScreen();
    }

    // ===== الاهتمامات =====
    final List interestIds = (user.interestIds is List) ? user.interestIds as List : [];

    final List interests = (user.interest is List) ? user.interest as List : [];

    debugPrint('🟡 Splash: interest_ids = $interestIds');
    debugPrint('🟡 Splash: interest = $interests');

    // ❗ لا نرجع InterestScreen إلا إذا المستخدم جديد فعلاً
    final bool isNewUser = user.createdAt != null && user.updatedAt != null ? user.createdAt == user.updatedAt : false;

    if (isNewUser && interestIds.isEmpty && interests.isEmpty) {
      debugPrint('🔴 Splash: مستخدم جديد بدون اهتمامات → InterestScreen');
      return InterestScreen();
    }

    debugPrint('🟢 Splash: الاهتمامات متجاوزة');

    // ===== اسم المستخدم =====
    if (user.username == null || user.username!.trim().isEmpty) {
      debugPrint('🔴 Splash: اسم المستخدم غير مكتمل → UserNameScreen');
      return const UserNameScreen();
    }

    // ===== الصورة =====
    if (user.profile == null || user.profile!.trim().isEmpty) {
      debugPrint('🔴 Splash: صورة الملف الشخصي غير موجودة → ProfilePictureScreen');
      return const ProfilePictureScreen();
    }

    debugPrint('🟢 Splash: كل البيانات مكتملة → TabBarScreen');
    return TabBarScreen();
  }
}
