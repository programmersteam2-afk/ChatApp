import 'package:flutter/services.dart';

class ChatSoundManager {
  static final ChatSoundManager shared = ChatSoundManager._internal();

  ChatSoundManager._internal();

  /// 🔔 صوت محادثة خفيف مثل واتساب (صوت النظام)
  void playIncomingMessage() {
    try {
      SystemSound.play(SystemSoundType.click);
    } catch (_) {}
  }

  /// 🔊 صوت أقوى (اختياري – إذا احتجته لاحقًا)
  void playAlert() {
    try {
      SystemSound.play(SystemSoundType.alert);
    } catch (_) {}
  }
}
