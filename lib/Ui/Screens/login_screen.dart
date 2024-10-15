import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // For custom fonts
import 'package:flutter_signin_button/flutter_signin_button.dart'; // For Google sign-in button

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // For custom fonts
import 'package:flutter_signin_button/flutter_signin_button.dart'; // For Google sign-in button
import 'package:firebase_auth/firebase_auth.dart'; // Firebase Authentication
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pokemon/Ui/Screens/home_screen.dart'; // Google Sign-in

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  // Google sign-in logic
// Google sign-in logic
  Future<User?> _signInWithGoogle(BuildContext context) async {
    try {
      // Sign out from the previous session to ensure the popup appears again
      await GoogleSignIn().signOut();

      // Trigger the Google Authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        // The user canceled the sign-in
        print('Sign in aborted by user');
        return null;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credentials
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      print('Sign in failed: $e');
      // Optionally show an error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign in failed. Please try again.')),
      );
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF00c6ff),
                  Color(0xFF0072ff)
                ], // Gradient colors
              ),
            ),
          ),
          // Content
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // App logo or name
              const Spacer(flex: 2),
              Text(
                'Pokémon World',
                style: GoogleFonts.poppins(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              // Sign-in button
              // Sign-in button
              SignInButton(
                Buttons.Google,
                text: "Sign in with Google",
                onPressed: () async {
                  User? user = await _signInWithGoogle(context);
                  if (user != null) {
                    // Navigate to Home Page after successful login
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const HomeScreen();
                    }));
                  }
                },
              ),
              const Spacer(flex: 2),
            ],
          ),
        ],
      ),
    );
  }
}
