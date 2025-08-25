import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class AuthApi {
  static final String baseUrl = dotenv.env['API_BASE_URL'] ?? "";
  static Future<http.Response> loginUser({
    required String email,
    required String displayName,
    required String photoURL,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "name": displayName,
        "photoURL": photoURL,
      }),
    );
    return response;
  }
}
