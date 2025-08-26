import 'dart:convert';
import 'package:appchat/utils/storageService.dart';
import 'package:appchat/widgets/conversationTile.dart';

import '/api/conversationApi.dart';
import '../pages/ChatScreen.dart';
import '/models/modelConversation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ChatDrawerBody extends StatefulWidget {
  const ChatDrawerBody({super.key});

  @override
  State<ChatDrawerBody> createState() => _ChatDrawerBodyState();
}

class _ChatDrawerBodyState extends State<ChatDrawerBody> {
  late Future<List<Conversation>> _conversations;
  String? selectedConversation;

  Future<List<Conversation>> getListConversation() async {
    final response = await ConversationApi.getListConversations();

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> conversations = data["listConversationId"];

      return conversations
          .map((conversation) => Conversation.fromJson(conversation))
          .toList();
    } else {
      throw Exception("Failed to fetch conversations: ${response.body}");
    }
  }

  Future<void> _loadSelectedConversation() async {
    final selectedId = await StorageService.getSelectedConversationId();
    setState(() {
      selectedConversation = selectedId;
    });
  }

  void editConversation(String id, String title) async {
    final TextEditingController inputController = TextEditingController(
      text: title,
    );

    final newTitle = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Rename ConverSation"),
          content: TextField(
            controller: inputController,
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Enter...',
              suffixIcon: Icon(Icons.abc),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, inputController.text);
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
    // print(newTitle);
    if (newTitle != null && newTitle.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token");
      final responseRenameConversation = await http.put(
        Uri.parse("http://10.0.2.2:3001/v1/rename-conversation"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({"id": id, "newTitle": newTitle}),
      );

      // print(responseRenameConversation.statusCode);
      if (responseRenameConversation.statusCode == 200) {
        setState(() {
          _conversations = getListConversation();
        });
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(conversationId: id),
          ),
        );
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Rename successfully")));
      }
    }
  }

  void deleteConversation(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    final responseDeleteConversation = await http.delete(
      Uri.parse("http://10.0.2.2:3001/v1/conversation/$id"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (responseDeleteConversation.statusCode == 200) {
      setState(() {
        _conversations = getListConversation();
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ChatScreen(conversationId: "")),
      );
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Delete successfully")));
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Delete failed!!!")));
    }
  }

  @override
  void initState() {
    super.initState();
    _conversations = getListConversation();
    _loadSelectedConversation();
  }

  @override
  Widget build(BuildContext context) {
    // _conversations.then((data) {
    //   print(data);
    // });
    return Expanded(
      child: FutureBuilder(
        future: _conversations,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No conversations"));
          }

          final conversations = snapshot.data!;
          return ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: conversations.length,
            itemBuilder: (context, index) {
              final conversation = conversations[index];
              return ConversationTile(
                conversation: conversation,
                selectedConversation: selectedConversation,
                onSelect: (id) {
                  setState(() {
                    selectedConversation = id;
                  });
                },
                onEdit: () =>
                    editConversation(conversation.id, conversation.title),
                onDelete: () => deleteConversation(conversation.id),
              );
            },
          );
        },
      ),
    );
  }
}
