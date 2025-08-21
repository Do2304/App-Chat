import 'package:flutter/material.dart';
import 'ChatScreen.dart';
import 'pages/loginPage.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: ChatScreen(),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/chat': (context) => ChatScreen(conversationId: ""),
      },
    );
  }
}
