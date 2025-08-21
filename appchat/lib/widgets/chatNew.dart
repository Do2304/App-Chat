import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatNew extends StatelessWidget {
  final VoidCallback startNewConversation;

  const ChatNew({super.key, required this.startNewConversation});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.add_box_rounded),
      title: Text(
        "New Conversation",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
      ),
      onTap: () async {
        // print("Click");
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove("selectedConversationId");
        Navigator.pop(context);
        startNewConversation();
      },
    );
  }
}
