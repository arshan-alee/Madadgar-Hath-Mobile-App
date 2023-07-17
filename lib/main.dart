import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:madadgarhath/screens/customer/customerhomepage.dart';
import 'package:madadgarhath/screens/worker/workerhomepage.dart';

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
        home: WorkerHomePage(
      userId: 'gIW2fRF7RjRjBpaWQA2S1sekTrH3',
    ));
  }
}
