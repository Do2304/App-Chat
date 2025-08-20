import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'message.dart';
import 'chat_service.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController inputController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  List<Message> messages = [];
  bool isTyping = false;

  String selectedModel = "gpt-4.1";

  void sendMsg() {
    final text = inputController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      messages.insert(0, Message(true, text));
      messages.insert(0, Message(false, ""));
      inputController.clear();
      isTyping = true;
    });

    ChatService.streamChat(selectedModel, text).listen(
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
                // final prefs = await SharedPreferences.getInstance();
                // await prefs.remove("token");
                // await FirebaseAuth.instance.signOut();
                // await GoogleSignIn().signOut();
                // Navigator.pushReplacementNamed(context, "/login");
                Scaffold.of(context).openDrawer();
              },
              icon: Icon(Icons.logout),
            );
          },
        ),
        actions: [
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
      drawer: Drawer(
        child: Column(
          children: [
            SizedBox(
              height: 110,
              child: DrawerHeader(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(color: Colors.blue),
                child: SizedBox.expand(
                  child: Text(
                    "Luli",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
            ),
            Container(child: Text("Conversation 1")),
            Container(child: Text("Conversation 2")),
            ListTile(
              title: Text("Logout"),
              leading: const Icon(Icons.logout),
              onTap: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.remove("token");
                await FirebaseAuth.instance.signOut();
                await GoogleSignIn().signOut();
                Navigator.pushReplacementNamed(context, "/login");
              },
            ),
          ],
        ),
      ),
    );
  }
}
