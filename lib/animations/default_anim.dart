// lib/animations/default_anim.dart
import 'package:flutter/material.dart';

/// DefaultAnim
/// دالة مساعدة لفتح صفحة مع حركة دخول (fade + scale).
/// تضع أيضاً RouteSettings.name تلقائياً بقيمة اسم الـ Widget (runtimeType)
/// لكي يظهر اسم الصفحة في أي NavigatorObserver يعتمد على settings.name.
void DefaultAnim(BuildContext context, Widget page) {
  Navigator.push(
    context,
    PageRouteBuilder(
      // نعيّن اسم الراوت تلقائياً لاستخدامه في الـ RouteLogger أو لأي مراقب
      settings: RouteSettings(name: page.runtimeType.toString()),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final scaleTween = Tween(begin: 0.9, end: 1.0);
        final opacityTween = Tween(begin: 0.0, end: 1.0);

        final scaleAnimation = animation.drive(scaleTween);
        final opacityAnimation = animation.drive(opacityTween);

        return FadeTransition(
          opacity: opacityAnimation,
          child: ScaleTransition(
            scale: scaleAnimation,
            child: child,
          ),
        );
      },
    ),
  );
}
