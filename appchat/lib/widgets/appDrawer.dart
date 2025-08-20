import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Appdrawer extends StatelessWidget {
  const Appdrawer({super.key});
  @override
  Widget build(BuildContext context) {
    return Drawer(
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
    );
  }
}
