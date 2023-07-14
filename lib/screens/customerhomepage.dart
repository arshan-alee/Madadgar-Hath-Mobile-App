import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:madadgarhath/screens/customerprofile.dart';

import 'available workers.dart';

class CustomerHomePage extends StatefulWidget {
  final String userId;

  const CustomerHomePage({Key? key, required this.userId}) : super(key: key);

  @override
  State<CustomerHomePage> createState() => _CustomerHomePageState();
}

class _CustomerHomePageState extends State<CustomerHomePage> {
  late String _customerName;
  final List<String> _professionOptions = [
    'Maid',
    'Driver',
    'Plumber',
    'Electrician',
    'Mechanic',
    'Chef',
    'Daycare',
    'Attendant',
    'Tutor',
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
      _customerName = customerData['fullName'] ?? '';
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
            Icon(Icons.settings, color: Colors.white, size: 30),
          ],
          onTap: (index) {
            if (index == 1) {
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'Hello $_customerName',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Need help? We provide blah blah..',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: _professionOptions.length,
                  itemBuilder: (context, index) {
                    final profession = _professionOptions[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AvailableWorkersPage(
                              profession: profession,
                              userId: widget.userId,
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        child: Card(
                          child: ListTile(
                            leading: CircleAvatar(
                              child: Text(profession[0]),
                            ),
                            title: Text(profession),
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
    );
  }
}
