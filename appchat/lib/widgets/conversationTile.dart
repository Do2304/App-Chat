import '/utils/storageService.dart';
import '/models/modelConversation.dart';
import '/pages/ChatScreen.dart';
import 'package:flutter/material.dart';

class ConversationTile extends StatelessWidget {
  final Conversation conversation;
  final String? selectedConversation;
  final ValueChanged<String> onSelect;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ConversationTile({
    super.key,
    required this.conversation,
    required this.selectedConversation,
    required this.onSelect,
    required this.onEdit,
    required this.onDelete,
  });

  void handleOnTap(BuildContext context) async {
    onSelect(conversation.id);
    await StorageService.saveSelectedConversationId(conversation.id);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(conversationId: conversation.id),
      ),
    );
  }

  void handleOnLongPress(BuildContext context) async {
    onSelect(conversation.id);
    await StorageService.saveSelectedConversationId(conversation.id);

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text("Edit"),
                onTap: () {
                  onEdit();
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text(
                  "Delete",
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  Navigator.pop(context);
                  onDelete();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.message),
      title: Text(conversation.title),
      selected: selectedConversation == conversation.id,
      selectedColor: Colors.black,
      selectedTileColor: Colors.grey.shade300,
      onTap: () => handleOnTap(context),
      onLongPress: () => handleOnLongPress(context),
    );
  }
}
