import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:madadgarhath/screens/customer/customerprofile.dart';
import 'package:madadgarhath/screens/customer/postjob.dart';
import 'package:madadgarhath/screens/customer/yourorders.dart';

import 'available workers.dart';

class CustomerHomePage extends StatefulWidget {
  final String userId;

  const CustomerHomePage({Key? key, required this.userId}) : super(key: key);

  @override
  State<CustomerHomePage> createState() => _CustomerHomePageState();
}

class _CustomerHomePageState extends State<CustomerHomePage> {
  String _customerName = '';
  final Map<String, String> _professionIcons = {
    'Maid': 'images/maid.png',
    'Driver': 'images/driver.png',
    'Plumber': 'images/plumber.png',
    'Mechanic': 'images/mechanic.png',
    'Chef': 'images/chef.png',
    'Babysitter': 'images/babysitter.png',
    'Electrician': 'images/electrician.png',
    'Attendant': 'images/attendant.png',
    'Tutor': 'images/tutor.png',
    'Painter': 'images/painter.png',
    'Gardener': 'images/gardenerpfp.png',
    'Sewerage Cleaner': 'images/sewerage cleaner.png',
  };

  final List<String> _professionOptions = [
    'Maid',
    'Driver',
    'Plumber',
    'Mechanic',
    'Chef',
    'Babysitter',
    'Electrician',
    'Attendant',
    'Tutor',
    'Painter',
    'Gardener',
    'Sewerage Cleaner'
  ];

  @override
  void initState() {
    super.initState();
    // Retrieve the customer's name from Firestore
    final firestore = FirebaseFirestore.instance;
    firestore
        .collection('customer')
        .where('userId', isEqualTo: widget.userId)
        .get()
        .then((snapshot) {
      final customerData = snapshot.docs.first.data();
      _customerName = snapshot.docs.first.get('fullName') ?? '';
      setState(() {});
    });
  }

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
            Icon(Icons.assignment_add, color: Colors.white, size: 30),
            Icon(Icons.shopping_cart, color: Colors.white, size: 30),
            Icon(Icons.settings, color: Colors.white, size: 30),
          ],
          onTap: (index) {
            if (index == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PostJobScreen(userId: widget.userId),
                ),
              );
            } else if (index == 2) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => YourOrderScreen(userId: widget.userId),
                ),
              );
            } else if (index == 3) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      CustomerProfileScreen(userId: widget.userId),
                ),
              );
            }
          },
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Hello $_customerName!',
                    style: TextStyle(
                        fontSize: 20, fontFamily: 'Manrope-ExtraBold'),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Looking for a Skilled Professional?',
                  style: TextStyle(fontSize: 20, fontFamily: 'Manrope-Bold'),
                ),
                Text(
                  'Find the perfect worker for your job!',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      fontFamily: 'Manrope-Regular'),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio:
                          0.8, // Adjust this value for card height
                    ),
                    itemCount: _professionOptions.length,
                    itemBuilder: (context, index) {
                      final profession = _professionOptions[index];
                      final iconPath = _professionIcons[profession];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AvailableWorkersPage(
                                profession: profession,
                                customeruserId: widget.userId,
                                customeruserName: _customerName,
                              ),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Card(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 40,
                                  backgroundImage: AssetImage(iconPath!),
                                ),
                                SizedBox(height: 10),
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    profession,
                                    softWrap: true,
                                    overflow: TextOverflow.clip,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
