import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

class AuthService {
  signInWithGoogle() async {
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication gAuth = await gUser!.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Sign in with email and password
  Future<User?> signInWithEmailPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      print("Error signing in: $e");
      return null;
    }
  }

  // Send OTP via Email
  Future<void> sendEmailOTP(String email) async {
    try {
      // Generate 6-digit OTP
      final otp = (100000 + Random().nextInt(900000)).toString();

      // Save OTP to Firestore with expiration (5 minutes)
      await _firestore.collection('email_otp').doc(email).set({
        'otp': otp,
        'createdAt': FieldValue.serverTimestamp(),
        'expiresAt': DateTime.now().add(const Duration(minutes: 5)),
      });

      // In production: Send email with OTP using your email service
      // This should be replaced with your actual email sending logic
      print("OTP for $email is $otp"); // For development only
    } catch (e) {
      print("Error sending email OTP: $e");
      rethrow;
    }
  }

  // Verify Email OTP
  Future<bool> verifyEmailOTP(String email, String otp) async {
    try {
      final doc = await _firestore.collection('email_otp').doc(email).get();

      if (!doc.exists) return false;

      final data = doc.data()!;
      final savedOtp = data['otp'] as String;
      final expiresAt = (data['expiresAt'] as Timestamp).toDate();

      // Delete OTP after verification attempt
      await _firestore.collection('email_otp').doc(email).delete();

      // Check if OTP matches and not expired
      return savedOtp == otp && DateTime.now().isBefore(expiresAt);
    } catch (e) {
      print("Error verifying email OTP: $e");
      return false;
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
