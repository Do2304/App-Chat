import 'package:flutter/material.dart';

class ChatDrawerBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          ListTile(title: Text("Conversation 1"), leading: Icon(Icons.message)),
          ListTile(title: Text("Conversation 2"), leading: Icon(Icons.message)),
          ListTile(title: Text("Conversation 3"), leading: Icon(Icons.message)),
        ],
      ),
    );
  }
}
