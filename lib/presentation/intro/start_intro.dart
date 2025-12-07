import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:skills_swap/animations/default_anim.dart';
import 'package:skills_swap/common/app_colors.dart';
import 'package:skills_swap/presentation/auth/sign_in/signin_screen.dart';
import 'package:skills_swap/presentation/auth/sign_up/signup_screen.dart';
import 'package:skills_swap/Languages/app_language.dart';
import 'package:shared_preferences/shared_preferences.dart';


class StartIntro extends StatefulWidget {
  const StartIntro({super.key});

  @override
  State<StartIntro> createState() => _StartIntroState();
}

class _StartIntroState extends State<StartIntro> {
  String currentLang = 'en'; // اللغة الحالية (en أو ar)

  @override
  void initState() {
    super.initState();
    _loadLanguage();
  }

  void _loadLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedLang = prefs.getString('lang');

    setState(() {
      currentLang = savedLang ?? 'ar';
    });
  }

  @override
  Widget build(BuildContext context) {
    // تغيير لون شريط الحالة
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // صورة البداية
              Image.asset(
                "assets/images/screen5_onboard.png",
                width: double.infinity,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 1),

              // العنوان الرئيسي
              Text(
                AppLanguage.translate('welcome', currentLang),
                textAlign: currentLang == 'ar' ? TextAlign.right : TextAlign.left,
                style: TextStyle(
                  
                  color: AppColors.text_black,
                  fontSize: 44,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              // النص الفرعي
              Text(
                currentLang == 'ar'
                    ? "افتح فرصًا جديدة من خلال تبادل المهارات بسهولة عبر فريقكم"
                    : "Unlock opportunities by exchanging skills effortlessly with !",
                style: TextStyle(
                  color: AppColors.text_black,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: currentLang == 'ar' ? TextAlign.right : TextAlign.left,
              ),
              const SizedBox(height: 24),

              // زر إنشاء حساب
              InkWell(
                onTap: () => DefaultAnim(context, const SignupScreen()),
                child: Container(
                  width: double.infinity,
                  height: 55,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: AppColors.primaryGradient,
                  ),
                  child: Center(
                    child: Text(
                      AppLanguage.translate('signup', currentLang),
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // لديك حساب بالفعل؟
              Directionality(
                                  textDirection: currentLang == 'ar' ?TextDirection.rtl:TextDirection.ltr,

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text( AppLanguage.translate('already_have', currentLang),
                      style: TextStyle(
                        color: AppColors.text_black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    InkWell(
                      onTap: () => DefaultAnim(context, const SigninScreen()),
                      child: ShaderMask(
                        shaderCallback: (bounds) =>
                            AppColors.primaryGradient.createShader(bounds),
                        child: Text(
                          " ${AppLanguage.translate('login', currentLang)}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // const SizedBox(height: 24),

              // // زر تغيير اللغة
              // Center(
              //   child: ElevatedButton(
              //     style: ElevatedButton.styleFrom(
              //       backgroundColor: AppColors.oange,
              //       padding:
              //       const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(12),
              //       ),
              //     ),
              //     onPressed: () {
              //       setState(() {
              //         currentLang = currentLang == 'en' ? 'ar' : 'en';
              //       });
              //     },
              //     child: Text(
              //       currentLang == 'ar'
              //           ? "تبديل إلى الإنجليزية"
              //           : "Switch to Arabic",
              //       style: const TextStyle(
              //         fontSize: 16,
              //         color: Colors.white,
              //         fontWeight: FontWeight.w600,
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
