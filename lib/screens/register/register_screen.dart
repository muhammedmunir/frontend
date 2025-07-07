import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frontend/components/my_button.dart';
//import 'package:frontend/components/my_square.dart';
import 'package:frontend/components/my_textfield.dart';

class RegisterScreen extends StatefulWidget {
  final Function()? onTap;
  const RegisterScreen({super.key, required this.onTap});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Controllers for the text fields
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmpasswordController = TextEditingController();
  final fullNameController = TextEditingController();
  final usernameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();

  // Function to handle user registration
  void register() async {
    // Show loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(
            color: Colors.red,
          ),
        );
      },
    );

    try {
      // Check if passwords match
      if (passwordController.text != confirmpasswordController.text) {
        // Pop the loading circle
        Navigator.pop(context);
        // Show error message
        showErrorMessage("Passwords don't match!");
        return; // Stop the function execution
      }

      // Create the user with email and password
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // After creating the user, create a new document in Cloud Firestore
      // for the user with additional details.
      if (userCredential.user != null) {
        await FirebaseFirestore.instance
            .collection("users")
            .doc(userCredential.user!.uid)
            .set({
          'uid': userCredential.user!.uid,
          'email': emailController.text.trim(),
          'fullName': fullNameController.text.trim(),
          'username': usernameController.text.trim(),
          'phone': phoneController.text.trim(),
          'address': addressController.text.trim(),
          'role': 'staff', // Default role for new users
        });
      }

      // Pop the loading circle
      if (mounted) Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      // Pop the loading circle
      Navigator.pop(context);
      // Show error message from Firebase
      showErrorMessage(e.message ?? "An unknown error occurred.");
    }
  }

  // Function to show a generic error message dialog
  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 155, 22, 12),
          title: Center(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    // Dispose controllers when the widget is removed from the widget tree
    emailController.dispose();
    passwordController.dispose();
    confirmpasswordController.dispose();
    fullNameController.dispose();
    usernameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 25),
                // Logo
                Image.asset(
                  'assets/images/logo.png',
                  width: 100,
                  height: 100,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.person, size: 100); // Placeholder
                  },
                ),
                const SizedBox(height: 25),
                // Title
                const Text(
                  'Create an Account',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 25),

                // Full Name Textfield
                MyTextfield(
                  controller: fullNameController,
                  hintText: 'Full Name',
                  obscureText: false,
                ),
                const SizedBox(height: 10),

                // Username Textfield
                MyTextfield(
                  controller: usernameController,
                  hintText: 'Username',
                  obscureText: false,
                ),
                const SizedBox(height: 10),

                // Email Textfield
                MyTextfield(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                ),
                const SizedBox(height: 10),

                // Phone Number Textfield
                MyTextfield(
                  controller: phoneController,
                  hintText: 'No. Phone',
                  obscureText: false,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 10),

                // Address Textfield
                MyTextfield(
                  controller: addressController,
                  hintText: 'Alamat Rumah (Home Address)',
                  obscureText: false,
                ),
                const SizedBox(height: 10),

                // Password Textfield
                MyTextfield(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),
                const SizedBox(height: 10),

                // Confirm Password Textfield
                MyTextfield(
                  controller: confirmpasswordController,
                  hintText: 'Confirm Password',
                  obscureText: true,
                ),
                const SizedBox(height: 20),

                // Register Button
                MyButton(
                  text: 'Register',
                  onTap: register,
                ),
                const SizedBox(height: 30),

                // Login redirect
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already have an account?',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        'Login now',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
