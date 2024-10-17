// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pokemon/Ui/Screens/home_screen.dart';
import 'package:pokemon/Ui/Screens/login_screen.dart';
import 'package:pokemon/core/const/text_style.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    Future.delayed(Duration(seconds: 3), () {
      _checkUserSignIn(context);
    });
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Center(
        child: Stack(children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/splash logo.png'),
            ],
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Text(
                  "Version 1.0.20 ",
                  style: TextStyles.poppins14lightgreyDA6,
                ),
                const SizedBox(height: 20),
                Text(
                  "Copyright @ 2024 Pokemon",
                  style: TextStyles.poppins14lightgreyDA6,
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  void _checkUserSignIn(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 2)); // Simulate loading time

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // User is signed in, navigate to HomeScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      // User is not signed in, navigate to LoginScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }
}
