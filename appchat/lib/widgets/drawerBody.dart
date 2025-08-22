import 'dart:convert';
import '/ChatScreen.dart';
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
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    final response = await http.get(
      Uri.parse("http://10.0.2.2:3001/v1/conversation"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

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
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedConversation = prefs.getString("selectedConversationId");
    });
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
              return ListTile(
                leading: const Icon(Icons.message),
                title: Text(conversation.title),
                selected: selectedConversation == conversation.id,
                selectedColor: Colors.black,
                selectedTileColor: Colors.grey.shade300,
                onTap: () async {
                  // print("Tapped conversation: ${conversation.id}");
                  setState(() {
                    selectedConversation = conversation.id;
                  });
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setString(
                    "selectedConversationId",
                    conversation.id,
                  );
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ChatScreen(conversationId: conversation.id),
                    ),
                  );
                },
                onLongPress: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return SafeArea(
                        child: Wrap(
                          children: [
                            ListTile(
                              leading: const Icon(Icons.edit),
                              title: Text("Edit"),
                              onTap: () {
                                print("---edit---");
                                Navigator.pop(context);
                              },
                            ),
                            ListTile(
                              leading: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              title: Text("Delete"),
                              onTap: () {
                                print("---delete---");
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
