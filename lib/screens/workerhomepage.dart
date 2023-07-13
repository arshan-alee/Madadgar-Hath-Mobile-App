import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:madadgarhath/screens/workerprofile.dart';

class WorkerHomePage extends StatelessWidget {
  final String userId;

  const WorkerHomePage({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        extendBody: true,
        bottomNavigationBar: CurvedNavigationBar(
          color: const Color.fromARGB(255, 1, 31, 56),
          height: 65,
          backgroundColor: Colors.transparent,
          items: <Widget>[
            Icon(Icons.search, color: Colors.white, size: 30),
            Icon(Icons.settings, color: Colors.white, size: 30),
            Icon(Icons.compare_arrows, color: Colors.white, size: 30),
          ],
          onTap: (index) {
            if (index == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WorkerProfileScreen(userId: userId),
                ),
              );
            }
          },
        ),
        body: Container(color: Colors.transparent),
      ),
    );
  }
}
