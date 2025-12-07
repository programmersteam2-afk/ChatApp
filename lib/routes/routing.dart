import 'package:flutter/material.dart';
import 'package:skills_swap/routes/routing_string.dart';

// Screens
import 'package:skills_swap/presentation/intro/start_intro.dart';
import 'package:skills_swap/presentation/splash/splash_screen.dart';
import 'package:skills_swap/presentation/auth/sign_up/signup_screen.dart';
import 'package:skills_swap/presentation/auth/sign_up/sign_up_success.dart';
import 'package:skills_swap/presentation/auth/sign_up/sign_up_error.dart';
import 'package:skills_swap/presentation/auth/sign_in/signin_screen.dart';
import 'package:skills_swap/presentation/auth/sign_in/sign_in_success.dart';
import 'package:skills_swap/presentation/auth/sign_in/sign_in_error.dart';
import 'package:skills_swap/presentation/auth/forgot/forgot_email.dart';
import 'package:skills_swap/presentation/auth/forgot/forgot_success.dart';
import 'package:skills_swap/presentation/auth/forgot/forgot_error_screen.dart';
import 'package:skills_swap/presentation/fragments/ProfileFragment/friends_list.dart';
import 'package:skills_swap/presentation/fragments/PostFragment/create_post.dart';
import 'package:skills_swap/presentation/fragments/PostFragment/see_profile_details.dart';

// Import HomePage فقط بالـ alias لتفادي أي تعارض أسماء
import 'package:skills_swap/home_page.dart' as pages;

class Routing {
  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
    // ======================
    // Intro
    // ======================
      case IntroScreenroute:
        return MaterialPageRoute(
          builder: (_) => const StartIntro(),
          settings: const RouteSettings(name: IntroScreenroute),
        );

    // ======================
    // Auth
    // ======================
      case SignUpScreenroute:
        return MaterialPageRoute(
          builder: (_) => const SignupScreen(),
          settings: const RouteSettings(name: SignUpScreenroute),
        );

      case SignUpSuccessScreenroute:
        return MaterialPageRoute(
          builder: (_) => const SignUpSuccess(),
          settings: const RouteSettings(name: SignUpSuccessScreenroute),
        );

      case SignUpErrorScreenroute:
        return MaterialPageRoute(
          builder: (_) => const SignUpError(),
          settings: const RouteSettings(name: SignUpErrorScreenroute),
        );

      case SignInScreenroute:
        return MaterialPageRoute(
          builder: (_) => const SigninScreen(),
          settings: const RouteSettings(name: SignInScreenroute),
        );

      case SignInSuccessScreenroute:
        return MaterialPageRoute(
          builder: (_) => const SignInSuccess(),
          settings: const RouteSettings(name: SignInSuccessScreenroute),
        );

      case SignInErrorScreenroute:
        return MaterialPageRoute(
          builder: (_) => const SignInError(),
          settings: const RouteSettings(name: SignInErrorScreenroute),
        );

      case ForgotEmailScreenroute:
        return MaterialPageRoute(
          builder: (_) => const ForgotEmail(),
          settings: const RouteSettings(name: ForgotEmailScreenroute),
        );

      case ForgotSuccessScreenroute:
        return MaterialPageRoute(
          builder: (_) => const ForgotSuccess(),
          settings: const RouteSettings(name: ForgotSuccessScreenroute),
        );

      case ForgotErrorScreenroute:
        return MaterialPageRoute(
          builder: (_) => const ForgotErrorScreen(),
          settings: const RouteSettings(name: ForgotErrorScreenroute),
        );

    // ======================
    // Home
    // ======================
      case HomePageScreenroute:
        return MaterialPageRoute(
          builder: (_) => const pages.HomePage(), // 👈 مهم
          settings: const RouteSettings(name: HomePageScreenroute),
        );

    // ======================
    // Profile Fragment
    // ======================
      case friendsListScreenroute:
        return MaterialPageRoute(
          builder: (_) => const FriendsList(),
          settings: const RouteSettings(name: friendsListScreenroute),
        );

    // ======================
    // Post Fragment
    // ======================
      case PostCreateScreenroute:
        return MaterialPageRoute(
          builder: (_) => const CreatePost(),
          settings: const RouteSettings(name: PostCreateScreenroute),
        );

      case SeeProfileDetailsScreenroute:
        return MaterialPageRoute(
          builder: (_) => const SeeProfileDetails(),
          settings: const RouteSettings(name: SeeProfileDetailsScreenroute),
        );

    // ======================
    // Default → Splash
    // ======================
      default:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
          settings: const RouteSettings(name: SplashScreenroute),
        );
    }
  }
}
