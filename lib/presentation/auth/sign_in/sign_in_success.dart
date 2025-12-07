import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skills_swap/Languages/app_language.dart';
import 'package:skills_swap/common/app_colors.dart';
import 'package:skills_swap/routes/routing_string.dart'; // 👈 مهم

class SignInSuccess extends StatefulWidget {
  const SignInSuccess({super.key});

  @override
  State<SignInSuccess> createState() => _SignInSuccessState();
}

class _SignInSuccessState extends State<SignInSuccess> {
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
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: AppColors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 2),
            CircleAvatar(
              radius: 140,
              backgroundColor: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.orange.withOpacity(0.3),
                      Colors.pink.withOpacity(0.5)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                ),
                child: CircleAvatar(
                  radius: 120,
                  backgroundColor: Colors.transparent,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.orange.withOpacity(0.4),
                          Colors.pink.withOpacity(0.6)
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: CircleAvatar(
                      radius: 100,
                      backgroundColor: Colors.transparent,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.orange.withOpacity(0.5),
                              Colors.pink.withOpacity(0.8)
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: const CircleAvatar(
                          radius: 80,
                          backgroundColor: Colors.transparent,
                          child: Icon(Icons.gpp_good_outlined,
                              size: 80, color: AppColors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              AppLanguage.translate('signin_success', currentLang),
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: AppColors.text_black),
            ),
            const SizedBox(height: 30),
            const SizedBox(height: 20),
            const Spacer(flex: 2),

            // زر المتابعة
            InkWell(
              onTap: () {
                // ✅ انتقل بالـ route name بدل HomePage()
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(HomePageScreenroute, (_) => false);
              },
              child: Container(
                width: double.infinity,
                height: 45,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  gradient: AppColors.primaryGradient,
                ),
                child: Center(
                  child: Text(
                    AppLanguage.translate('continue', currentLang),
                    style: TextStyle(
                        color: AppColors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
