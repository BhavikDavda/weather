import 'dart:async';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 5),
          () {
        Navigator.of(context).pushReplacementNamed('/');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Image.asset(
                "assets/images/a0e28308aec61e34cd8a60daa918c9fc.png",
                height: 300,
                width: 300,
              ),
            ),
          ],
        ),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0F2027), Color(0xFFFFFFFF), Color(0xFF2C5364),

            ],
          ),
        ),
      ),
    );
  }
}
