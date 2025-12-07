import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skills_swap/routes/routing.dart';
import 'package:skills_swap/routes/routing_string.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // تحميل اللغة المختارة مسبقًا (إن وُجدت)
  final prefs = await SharedPreferences.getInstance();
  final savedLang = prefs.getString('appLang') ?? 'en';
  runApp(MyApp(initialLang: savedLang));
}

class MyApp extends StatefulWidget {
  final String initialLang;
  const MyApp({super.key, required this.initialLang});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Locale _locale;

  @override
  void initState() {
    super.initState();
    _locale = Locale(widget.initialLang);
  }

  // 🔄 دالة لتغيير اللغة وحفظها
  Future<void> _changeLanguage(String langCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('appLang', langCode);
    setState(() {
      _locale = Locale(langCode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: _locale,
      supportedLocales: const [
        Locale('en'),
        Locale('ar'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      // اتجاه النص بناءً على اللغة
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supported in supportedLocales) {
          if (supported.languageCode == _locale.languageCode) {
            return supported;
          }
        }
        return supportedLocales.first;
      },
      // الراوتر
      onGenerateRoute: Routing().generateRoute,
      initialRoute: SplashScreenroute,
      navigatorObservers: [RouteLogger()],
    );
  }
}

// 👇 مراقبة التنقل بين الصفحات
class RouteLogger extends NavigatorObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    final name = route.settings.name ?? 'غير معروف';
    debugPrint('📍 تم فتح صفحة: $name');
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    final name = previousRoute?.settings.name ?? 'غير معروف';
    debugPrint('↩️ رجعت إلى صفحة: $name');
    super.didPop(route, previousRoute);
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    final name = newRoute?.settings.name ?? 'غير معروف';
    debugPrint('🔁 تم استبدال الصفحة بـ: $name');
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }
}
