import '/utils/storageService.dart';
import '/utils/appSnackBar.dart';
import '/api/authApi.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:convert';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  Future<void> loginWithGoogle(BuildContext context) async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      await googleSignIn.signOut();
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

      final response = await AuthApi.loginUser(
        email: user.email!,
        displayName: user.displayName!,
        photoURL: user.photoURL!,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // print("data: ${data}");
        final token = data["token"];
        // print("token: ${token}");
        await StorageService.saveToken(token);

        AppSnackBar.showSnackBar(context, "Login successfully", 1);
        Navigator.pushReplacementNamed(context, '/chat');
      } else {
        throw Exception("Backend login failed: ${response.body}");
      }
    } catch (e) {
      print("Error during Google login: $e");
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
