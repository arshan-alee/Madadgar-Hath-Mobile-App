import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class CustomerHomePage extends StatefulWidget {
  const CustomerHomePage({super.key});

  @override
  State<CustomerHomePage> createState() => _CustomerHomePageState();
}

class _CustomerHomePageState extends State<CustomerHomePage> {
  Stream<QuerySnapshot<Map<String, dynamic>>>? workerStream;
  @override
  void initState() {
    super.initState();
    // Retrieve the worker registration documents from Firestore
    final firestore = FirebaseFirestore.instance;
    workerStream = firestore.collection('worker').snapshots();
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
            Icon(Icons.compare_arrows, color: Colors.white, size: 30),
          ],
          onTap: (index) {
            //Handle button tap
          },
        ),
        body: SafeArea(
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Search',
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (value) {
                  // Handle search query
                },
              ),
              SizedBox(height: 20),
              StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: workerStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final workerDocs = snapshot.data!.docs;
                    return ListView.builder(
                      itemCount: workerDocs.length,
                      itemBuilder: (context, index) {
                        final workerData = workerDocs[index].data();
                        final workerName = workerData['fullName'] as String;
                        final workerPhoneNumber =
                            workerData['phoneNumber'] as String;
                        final workerHourlyRate =
                            workerData['hourlyRate'] as double;
                        final workerProfession =
                            workerData['profession'] as String;
                        return Card(
                          child: ListTile(
                            title: Text(workerName),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Profession: $workerProfession'),
                                Text('Phone: $workerPhoneNumber'),
                                Text(
                                    'Hourly Rate: \$${workerHourlyRate.toStringAsFixed(2)}'),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
