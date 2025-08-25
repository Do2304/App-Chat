import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class chatDrawerFooter extends StatelessWidget {
  const chatDrawerFooter({super.key});

  void handleLogout(context) async {
    final confirmLogout = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          actionsAlignment: MainAxisAlignment.center,
          title: Text("Confirm logout?"),
          content: Text("Are you sure you want to logout?"),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: Text("Yes"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: Text("No"),
            ),
          ],
        );
      },
    );

    if (confirmLogout) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove("token");
      await prefs.remove("selectedConversationId");
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().signOut();
      Navigator.pushReplacementNamed(context, "/login");
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text("Logout"),
      leading: const Icon(Icons.logout),
      onTap: () => handleLogout(context),
    );
  }
}
