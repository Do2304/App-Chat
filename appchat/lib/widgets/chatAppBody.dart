import '/models/message.dart';
import 'package:flutter/material.dart';

class ChatAppBody extends StatelessWidget {
  final List<Message> messages;
  final ScrollController scrollController;
  final TextEditingController inputController;
  final VoidCallback onSend;

  const ChatAppBody({
    super.key,
    required this.messages,
    required this.scrollController,
    required this.inputController,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
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
              onPressed: onSend,
            ),
          ],
        ),
      ],
    );
  }
}
