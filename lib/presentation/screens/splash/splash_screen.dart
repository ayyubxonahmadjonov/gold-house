import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gold_house/presentation/enterance/select_lg.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // 3 sekunddan keyin next screen
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const SelectLgScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // splash fon rangi
      body: Center(
        child: Image.asset(
          "assets/images/app_logo.png", // logoni assetdan oladi
     
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
