import 'package:flutter/material.dart';
import 'package:pokemon/Ui/Screens/home_screen.dart';
import 'package:pokemon/core/const/text_style.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 3), () {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return const HomeScreen();
      },));
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
}
