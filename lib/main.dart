import 'package:flutter/material.dart';
import 'package:madadgarhath/screens/getstarted.dart';
import 'package:madadgarhath/screens/onboarding.dart';
import 'package:madadgarhath/screens/splash.dart';
import 'package:madadgarhath/screens/workerhomepage.dart';
import 'package:madadgarhath/screens/workerlogin.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Splash(),
    );
  }
}
