import 'package:flutter/material.dart';

class ChatDrawerHeader extends StatelessWidget {
  const ChatDrawerHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      child: DrawerHeader(
        margin: EdgeInsets.zero,
        decoration: BoxDecoration(color: Colors.blue),
        child: SizedBox.expand(
          child: Text(
            "Luli",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
