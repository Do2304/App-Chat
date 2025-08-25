import 'package:flutter/material.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool hasMessages;
  final VoidCallback startNewConversation;
  final String selectedModel;
  final ValueChanged<String?> onChanged;

  const ChatAppBar({
    super.key,
    required this.hasMessages,
    required this.startNewConversation,
    required this.selectedModel,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
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
      actions: hasMessages
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
                onChanged: onChanged,
              ),
            ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
