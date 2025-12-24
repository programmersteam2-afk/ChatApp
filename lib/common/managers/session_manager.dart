import 'dart:io';

import 'package:get_storage/get_storage.dart';
import 'package:untitled/localization/allLanguages.dart';
import 'package:untitled/models/registration.dart';
import 'package:untitled/models/setting_model.dart';

class SessionManager {
  static final SessionManager shared = SessionManager();

  final GetStorage storage = GetStorage();
  String conversationId = '';

  /* ================= Language ================= */

  void setLang(Lang lang) {
    storage.write("lang", lang.language.languageCode);
  }

  Lang getLang() {
    return LANGUAGES.firstWhere(
      (e) => e.language.languageCode == (storage.read("lang") ?? LANGUAGES.first.language.languageCode),
    );
  }

  /* ================= Conversation ================= */

  String getStoredConversation() {
    return conversationId;
  }

  void setStoredConversation(String conversation) {
    conversationId = conversation;
  }

  /* ================= Message Read Date ================= */

  DateTime? getLastMessageReadDate({required String spaceId}) {
    final date = storage.read(spaceId);
    if (date is DateTime) {
      return date;
    }
    return null;
  }

  Future<void> restoreSession() async {
    final data = storage.read("user");

    if (data != null && data is Map<String, dynamic>) {
      setUser(User.fromJson(data));
      setLogin(true);
    }
  }

  void setLastMessageReadDate({required String spaceId}) {
    storage.write(spaceId, DateTime.now());
  }

  /* ================= Login ================= */

  bool isLogin() {
    return storage.read(SessionKeys.isLogin) ?? false;
  }

  void setLogin(bool isLog) {
    storage.write(SessionKeys.isLogin, isLog);
  }

  /* ================= User ================= */

  void setUser(User? user) {
    if (user == null) {
      storage.remove("user");
    } else {
      storage.write("user", user.toJson());
    }
  }

  User? getUser() {
    final data = storage.read("user");

    if (data == null) return null;

    if (data is Map<String, dynamic>) {
      return User.fromJson(data);
    }

    return null;
  }

  int getUserID() {
    return (getUser()?.id ?? 0).toInt();
  }

  /* ================= Group Users ================= */

  void setUsersForGroup({
    required String conversationId,
    required List<User> users,
  }) {
    storage.write(
      conversationId,
      users.map((e) => e.toJson()).toList(),
    );
  }

  List<User> getUsersForGroup({required String conversationId}) {
    final users = storage.read(conversationId);

    if (users is List) {
      return users.whereType<Map<String, dynamic>>().map((e) => User.fromJson(e)).toList();
    }

    return [];
  }

  /* ================= Settings ================= */

  void setSettings(Settings settings) {
    storage.write("setting", settings.toJson());
  }

  Settings? getSettings() {
    final data = storage.read("setting");

    if (data is Map<String, dynamic>) {
      return Settings.fromJson(data);
    }

    return null;
  }

  String getBannerAdId() {
    if (Platform.isAndroid) {
      return getSettings()?.adBannerAndroid ?? '';
    } else {
      return getSettings()?.adBannerIOs ?? '';
    }
  }

  String getInterstitialAdId() {
    if (Platform.isAndroid) {
      return getSettings()?.adInterstitialAndroid ?? '';
    } else {
      return getSettings()?.adInterstitialIOs ?? '';
    }
  }

  bool isAdMobOn() {
    return getSettings()?.isAdmobOn == 1;
  }

  /* ================= Clear ================= */

  void clear() {
    storage.erase();
  }
}

class SessionKeys {
  static const String isLogin = "isLogin";
}
