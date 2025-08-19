import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

Future<String?> getUserIdFromToken() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString("token");

  if (token == null) return null;

  try {
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    return decodedToken["id"];
  } catch (e) {
    print("Error decoding token: $e");
    return null;
  }
}
