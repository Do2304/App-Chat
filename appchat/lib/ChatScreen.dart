import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'message.dart';
import 'chat_service.dart';
import '/widgets/appDrawer.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class ChatScreen extends StatefulWidget {
  final String conversationId;
  const ChatScreen({super.key, required this.conversationId});
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController inputController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  List<Message> messages = [];
  bool isTyping = false;

  String selectedModel = "gpt-4.1";
  final uuid = Uuid();
  late String conversationById;

  @override
  void initState() {
    super.initState();
    loadMessages();
  }

  Future<void> loadMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    if (widget.conversationId == "") {
      conversationById = uuid.v4();
    } else {
      conversationById = widget.conversationId;
    }

    final response = await http.get(
      Uri.parse("http://10.0.2.2:3001/v1/chat/$conversationById"),
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer $token",
      },
    );
    // print(response.statusCode);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List listMessages = data["messages"];
      print(data["messages"]);
      setState(() {
        messages = listMessages
            .map((mess) => Message(mess['role'] == "User", mess["content"]))
            .toList()
            .reversed
            .toList();
      });
    }
  }

  void sendMsg() {
    final text = inputController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      messages.insert(0, Message(true, text));
      messages.insert(0, Message(false, ""));
      inputController.clear();
      isTyping = true;
    });

    ChatService.streamChat(selectedModel, text, conversationById).listen(
      (chunk) {
        setState(() {
          messages[0].msg += chunk;
        });
      },
      onDone: () {
        setState(() {
          isTyping = false;
        });
      },
      onError: (e) {
        setState(() {
          messages[0].msg = "Error: $e";
          isTyping = false;
        });
      },
    );
  }

  void startNewConversation() {
    setState(() {
      conversationById = uuid.v4();
      messages.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat with OniAI"),
        leading: Builder(
          builder: (context) {
            return IconButton(
              onPressed: () async {
                print("click");
                Scaffold.of(context).openDrawer();
              },
              icon: Icon(Icons.menu),
            );
          },
        ),
        actions: messages.isNotEmpty
            ? [
                IconButton(
                  onPressed: () async {
                    startNewConversation();
                  },
                  icon: Icon(Icons.edit_note),
                ),
              ]
            : [
                DropdownButton<String>(
                  value: selectedModel,
                  items: const [
                    DropdownMenuItem(value: "gpt-4.1", child: Text("GPT-4.1")),
                    DropdownMenuItem(
                      value: "claude-opus-4",
                      child: Text("Claude Opus 4"),
                    ),
                    DropdownMenuItem(
                      value: "gemini-2.5-pro",
                      child: Text("Gemini 2.5 Pro"),
                    ),
                  ],
                  onChanged: (val) => setState(() => selectedModel = val!),
                ),
              ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              controller: scrollController,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                return Container(
                  alignment: msg.isSender
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  padding: const EdgeInsets.all(8),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: msg.isSender
                          ? Colors.blue.shade100
                          : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(msg.msg),
                  ),
                );
              },
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    controller: inputController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Enter message...",
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send, color: Colors.blue),
                onPressed: sendMsg,
              ),
            ],
          ),
        ],
      ),
      drawer: Appdrawer(startNewConversation: startNewConversation),
    );
  }
}
