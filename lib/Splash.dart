import 'package:ats/Login.dart';
import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    // Add any initialization logic here
    // For example, you can navigate to the next screen after a delay
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() async {
    // Simulate a delay, e.g., waiting for data to load
    await Future.delayed(Duration(seconds: 2));

    // Navigate to the next screen (replace it with your actual screen)
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset('assets/splash.png'),
      ),
    );
  }
}
