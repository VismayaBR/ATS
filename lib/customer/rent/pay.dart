import 'package:ats/customer/Cus_Navbar.dart';
import 'package:ats/customer/rent/rentaltab.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Pay extends StatefulWidget {
  const Pay({Key? key}) : super(key: key);

  @override
  State<Pay> createState() => _PayState();
}

class _PayState extends State<Pay> {
  @override
  void initState() {
    super.initState();

    // Delay navigation by 2 seconds
    Future.delayed(Duration(seconds: 2), () {
      // Navigate to another page after 2 seconds
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage()), // Replace YourNextPage with the actual destination page
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Lottie.asset('assets/pay.json'),
      ),
    );
  }
}
