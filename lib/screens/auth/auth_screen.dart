import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frontend/screens/auth/Login_or_Register_Screen.dart';
import 'package:frontend/screens/home/home_screen.dart';
//import 'package:frontend/screens/login/login_screen.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return HomeScreen(); // Replace with your home screen widget
          } else {
            return LoginOrRegisterScreen();
          }
        },
      ),
    );
  }
}
