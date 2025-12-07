import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:skills_swap/animations/default_anim.dart';
import 'package:skills_swap/common/app_colors.dart';
import 'package:skills_swap/presentation/intro/start_intro.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String appLang = 'en'; // اللغة الافتراضية

  @override
  void initState() {
    super.initState();
    _loadLanguage();
  }

  // تحميل اللغة المحفوظة
  void _loadLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedLang = prefs.getString('lang');

    setState(() {
      appLang = savedLang ?? 'en';
    });

    // إذا اللغة مخزنة سابقاً → روح مباشرة
    if (savedLang != null) {
      Future.delayed(const Duration(seconds: 2), () {
        DefaultAnim(context, StartIntro());
      });
    }
  }

  // حفظ اللغة
  void _saveLanguage(String lang) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('lang', lang);
    setState(() {
      appLang = lang;
    });

    // بعد اختيار اللغة → انتقل فوراً
    DefaultAnim(context, StartIntro());
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: AppColors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.orange.withOpacity(1),
              Colors.pink.withOpacity(1),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(flex: 3),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Skill",
                    style: TextStyle(
                      color: AppColors.cream,
                      fontSize: 48,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    "Swap",
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),

              Spacer(flex: 2),

              // === زر اختيار اللغة ===
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => _saveLanguage('ar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                    ),
                    child: Text("العربية"),
                  ),
                  SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () => _saveLanguage('en'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                    ),
                    child: Text("English"),
                  ),
                ],
              ),

              SizedBox(height: 20),

              Align(
                alignment: Alignment.bottomCenter,
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),

              Spacer(flex: 1),

              Text(
                "Powered by AIK",
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 14,
                ),
              ),

              SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
