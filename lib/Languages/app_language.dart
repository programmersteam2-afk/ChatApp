import 'package:skills_swap/Languages/ar.dart';
import 'package:skills_swap/Languages/en.dart';

class AppLanguage {
  static String translate(String key, String lang) {
    if (lang == 'ar') {
      return ArLanguage.messages[key] ?? key;
    } else {
      return EnLanguage.messages[key] ?? key;
    }
  }
}
