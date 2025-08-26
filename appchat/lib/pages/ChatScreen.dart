import 'dart:convert';
import '/widgets/chatAppBody.dart';
import '/widgets/chatAppBar.dart';
import '/utils/storageService.dart';
import '/api/chatApi.dart';
import 'package:flutter/material.dart';
import '../models/message.dart';
import '../services/chat_service.dart';
import '/widgets/appDrawer.dart';
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
    if (widget.conversationId == "") {
      conversationById = uuid.v4();
    } else {
      conversationById = widget.conversationId;
    }

    final response = await ChatApi.getListMessages(conversationById);
    // print(response.statusCode);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List listMessages = data["messages"];
      // print(data["messages"]);
      setState(() {
        messages = listMessages
            .map((mess) => Message(mess['role'] == "User", mess["content"]))
            .toList()
            .reversed
            .toList();
      });
    }
  }

  void sendMsg() async {
    final text = inputController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      messages.insert(0, Message(true, text));
      messages.insert(0, Message(false, ""));
      inputController.clear();
      isTyping = true;
    });
    await StorageService.saveSelectedConversationId(conversationById);

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

  void startNewConversation() async {
    // final prefs = await SharedPreferences.getInstance();
    // await prefs.remove('selectedConversationId');
    setState(() {
      conversationById = uuid.v4();
      messages.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ChatAppBar(
        hasMessages: messages.isNotEmpty,
        startNewConversation: startNewConversation,
        selectedModel: selectedModel,
        onChanged: (val) => setState(() => selectedModel = val!),
      ),
      body: ChatAppBody(
        messages: messages,
        scrollController: scrollController,
        inputController: inputController,
        onSend: sendMsg,
      ),
      drawer: Appdrawer(startNewConversation: startNewConversation),
    );
  }
}
