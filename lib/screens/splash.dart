import 'package:flutter/material.dart';
import 'package:madadgarhath/screens/loginpage.dart';
import 'dart:async';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 5000), () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginPage(),
          ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color.fromARGB(255, 134, 201, 255),
        body: Center(
          child: Image.asset(
            "images/logo.png",
            width: 220,
            height: 220,
          ),
        ),
      ),
    );
  }
}
