import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:madadgarhath/screens/customerhomepage.dart';
import 'package:madadgarhath/screens/getstarted.dart';
import 'package:madadgarhath/screens/onboarding.dart';
import 'package:madadgarhath/screens/splash.dart';
import 'package:madadgarhath/screens/workerhomepage.dart';
import 'package:madadgarhath/screens/workerlogin.dart';
import 'package:madadgarhath/screens/workerprofile.dart';
import 'package:madadgarhath/screens/workerregisteration.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: WorkerProfileScreen(
        workerId: 'AoN7awzD9EGDEEyZCuRa',
      ),
    );
  }
}
