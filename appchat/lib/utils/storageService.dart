import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("token", token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final get = prefs.getString("token");
    return get;
  }

  static Future<void> deleteToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("token");
  }

  static Future<void> saveSelectedConversationId(String id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("selectedConversationId", id);
  }

  static Future<String?> getSelectedConversationId() async {
    final prefs = await SharedPreferences.getInstance();
    final get = prefs.getString("selectedConversationId");
    return get;
  }

  static Future<void> deleteSelectedConversationId() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("selectedConversationId");
  }
}
