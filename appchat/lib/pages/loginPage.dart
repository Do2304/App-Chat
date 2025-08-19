import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  Future<void> loginWithGoogle(BuildContext context) async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final googleUser = await googleSignIn.signIn();

      if (googleUser == null) return;

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential);

      final user = userCredential.user!;
      print("Đăng nhập thành công: ${user.email} - ${user.displayName}");

      final response = await http.post(
        Uri.parse("http://10.0.2.2:3001/v1/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": user.email,
          "name": user.displayName,
          "photoURL": user.photoURL,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data["token"];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("token", token);

        Navigator.pushReplacementNamed(context, '/chat');
      } else {
        throw Exception("Backend login failed: ${response.body}");
      }
    } catch (e) {
      print("Error during Google login: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error during Google login: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Center(
        child: ElevatedButton(
          child: const Text("Login With Google"),
          onPressed: () => loginWithGoogle(context),
        ),
      ),
    );
  }
}
