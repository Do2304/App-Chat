import 'dart:async';
import 'dart:convert';
import 'utils/userService.dart';
import 'package:http/http.dart' as http;

class ChatService {
  static Stream<String> streamChat(String model, String text) async* {
    final userId = await getUserIdFromToken() ?? "guest";
    final uri = Uri.parse(
      "http://10.0.2.2:3001/v1/chat/stream"
      "?model=$model"
      "&messages=${Uri.encodeComponent(jsonEncode(text))}"
      "&conversationId=test123"
      "&userId=$userId",
    );

    final request = http.Request("GET", uri);
    final responseChatAI = await http.Client().send(request);
    // print("ChatResponse: $responseChatAI");

    await for (var chunk in responseChatAI.stream.transform(utf8.decoder)) {
      // print("chunk: $chunk");
      for (var line in chunk.split("\n")) {
        // print("line: $line");
        if (line.trim().isEmpty) continue;
        if (!line.startsWith("data:")) continue;

        final data = line.substring(5).trim();
        // print("SSE raw: $data");

        if (data == "done") return;

        try {
          final decoded = jsonDecode(data);
          if (decoded is Map && decoded.containsKey("message")) {
            final msg = decoded["message"];
            if (msg != null && msg.isNotEmpty) {
              yield msg;
            }
          } else {
            yield data;
          }
        } catch (e) {
          print("JSON decode error: $e");
          yield data;
        }
      }
    }
  }
}
