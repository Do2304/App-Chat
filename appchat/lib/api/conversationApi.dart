import 'dart:convert';
import '/utils/storageService.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ConversationApi {
  static final String baseUrl = dotenv.env["API_BASE_URL"] ?? "";

  static Future<http.Response> getListConversations() async {
    final token = await StorageService.getToken();

    final response = await http.get(
      Uri.parse("$baseUrl/conversation"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );
    return response;
  }

  static Future<http.Response> renameConversation(
    String id,
    String newTitle,
  ) async {
    final token = await StorageService.getToken();

    final response = await http.put(
      Uri.parse("$baseUrl/rename-conversation"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({"id": id, "newTitle": newTitle}),
    );
    return response;
  }

  static Future<http.Response> deleteConversation(String id) async {
    final token = await StorageService.getToken();

    final response = await http.delete(
      Uri.parse("$baseUrl/conversation/$id"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );
    return response;
  }
}
