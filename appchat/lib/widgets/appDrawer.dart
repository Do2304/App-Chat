import '/widgets/chatNew.dart';
import '/widgets/drawerBody.dart';
import '/widgets/drawerHeader.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
          ListTile(
            title: Text("Logout"),
            leading: const Icon(Icons.logout),
            onTap: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove("token");
              await prefs.remove("selectedConversationId");
              await FirebaseAuth.instance.signOut();
              await GoogleSignIn().signOut();
              Navigator.pushReplacementNamed(context, "/login");
            },
          ),
        ],
      ),
    );
  }
}
