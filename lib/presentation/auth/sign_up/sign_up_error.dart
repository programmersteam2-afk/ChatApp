import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skills_swap/Languages/app_language.dart';
import 'package:skills_swap/common/app_colors.dart';
import 'package:skills_swap/routes/routing_string.dart';

class SignUpError extends StatefulWidget {
  const SignUpError({super.key});

  @override
  State<SignUpError> createState() => _SignUpErrorState();
}

class _SignUpErrorState extends State<SignUpError> {
  String currentLang = "en";
  @override
  void initState() {
    super.initState();
    _loadLanguage();
  }

  void _loadLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedLang = prefs.getString('lang');

    setState(() {
      currentLang = savedLang ?? 'en';
    });
  }

  @override
  Widget build(BuildContext context) {
    // تعديل لون شريط الحالة
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),

              // كود الخطأ
              Text(
                '404',
                style: TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.w600,
                  color: AppColors.text_black,
                ),
              ),
              const SizedBox(height: 8),

              // العنوان
              Text(
                AppLanguage.translate('sign_up_failed', currentLang),
                style: TextStyle(
                  fontSize: 26,
                  color: AppColors.text_black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),

              // الأنيميشن
              Lottie.asset(
                'assets/lotties/anim2.json',
                height: 250,
                width: 250,
                repeat: true,
              ),
              const SizedBox(height: 16),

              // التفاصيل
              Text(
                AppLanguage.translate('error_m1', currentLang),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: AppColors.greySHADE500,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 30),

              // زر المحاولة مجددًا
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, SignUpScreenroute);
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: AppColors.primaryGradient,
                  ),
                  child: Center(
                    child: Text(
                      AppLanguage.translate('retry', currentLang),
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
