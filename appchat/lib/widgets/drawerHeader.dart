import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatDrawerHeader extends StatelessWidget {
  const ChatDrawerHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return SizedBox(
      height: 120,
      child: DrawerHeader(
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        // decoration: BoxDecoration(color: Colors.blue),
        child: SizedBox.expand(
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8, bottom: 10),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(user!.photoURL!),
                  radius: 28,
                ),
              ),
              SizedBox(width: 6),
              Expanded(
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        user.displayName!,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),

                    Align(
                      alignment: Alignment.centerLeft,

                      child: Text(
                        user.email!,
                        style: TextStyle(color: Colors.black),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
