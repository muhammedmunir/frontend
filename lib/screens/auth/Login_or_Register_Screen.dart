import 'package:flutter/material.dart';
import 'package:frontend/screens/login/login_screen.dart';
import 'package:frontend/screens/register/register_screen.dart';

class LoginOrRegisterScreen extends StatefulWidget {
  const LoginOrRegisterScreen({super.key});

  @override
  State<LoginOrRegisterScreen> createState() => _LoginOrRegisterScreenState();
}

class _LoginOrRegisterScreenState extends State<LoginOrRegisterScreen> {
  bool showLoginScreen = true;
  void toggleScreens() {
    setState(() {
      showLoginScreen = !showLoginScreen;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginScreen) {
      return LoginScreen(
        onTap: toggleScreens,
      );
    } else {
      return RegisterScreen(
        onTap: toggleScreens,
      );
    }
  }
}
