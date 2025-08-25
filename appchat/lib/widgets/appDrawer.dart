import '/widgets/drawerFooter.dart';
import '/widgets/chatNew.dart';
import '/widgets/drawerBody.dart';
import '/widgets/drawerHeader.dart';
import 'package:flutter/material.dart';

class Appdrawer extends StatelessWidget {
  final VoidCallback startNewConversation;
  const Appdrawer({super.key, required this.startNewConversation});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const ChatDrawerHeader(),
          ChatNew(startNewConversation: startNewConversation),
          Divider(height: 0),
          ChatDrawerBody(),
          Divider(color: Colors.black, thickness: 1),
          const chatDrawerFooter(),
        ],
      ),
    );
  }
}
