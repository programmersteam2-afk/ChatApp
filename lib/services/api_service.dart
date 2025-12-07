import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // رابط API الأساسي
  static const String baseUrl = "https://team.nana20.com";

  static Future<bool> registerUser(String username, String email, String password) async {
    final url = Uri.parse("$baseUrl/register.php");

    final response = await http.post(
      url,
      body: {
        "username": username,
        "email": email,
        "password": password,
      },
    );

    print("SERVER RESPONSE: ${response.body}");

    if (response.statusCode == 200) {
      try {
        final data = jsonDecode(response.body);
        return data["success"] == true;
      } catch (e) {
        print("❗الاستجابة ليست JSON");
        return false;
      }
    } else {
      print("❗Error: ${response.statusCode}");
      return false;
    }
  }
}
