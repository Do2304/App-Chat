import '/utils/storageService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'pages/ChatScreen.dart';
import 'pages/loginPage.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await dotenv.load(fileName: ".env");
  final token = await StorageService.getToken();
  // print("------$token");
  runApp(MyApp(initialRoute: token == null ? '/login' : '/chat'));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.initialRoute});
  final String initialRoute;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: ChatScreen(),
      initialRoute: initialRoute,
      routes: {
        '/login': (context) => const LoginPage(),
        '/chat': (context) => ChatScreen(conversationId: ""),
      },
    );
  }
}
