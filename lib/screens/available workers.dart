import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AvailableWorkersPage extends StatelessWidget {
  final String profession;
  final String userId;

  const AvailableWorkersPage({
    Key? key,
    required this.profession,
    required this.userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(
          'Available $profession',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('worker')
            .where('availability', isEqualTo: true)
            .where('profession', isEqualTo: profession)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final workerDocs = snapshot.data!.docs;
            if (workerDocs.isEmpty) {
              return Center(
                child: Text(
                  'No available $profession at the moment.',
                  style: TextStyle(fontSize: 16),
                ),
              );
            }
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: workerDocs.length,
                itemBuilder: (context, index) {
                  final workerData = workerDocs[index].data();
                  final workerName = workerData['fullName'] as String;
                  final workerPhoneNumber = workerData['phoneNumber'] as String;
                  final workerHourlyRate = workerData['hourlyRate'] as double;
                  final workerEmail = workerData['email'] as String;
                  return Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          title: Text(
                            workerName,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 2),
                              Text(
                                  'Hourly Rate: \$${workerHourlyRate.toStringAsFixed(2)}'),
                              SizedBox(height: 2),
                              Text('Phone: $workerPhoneNumber'),
                              SizedBox(height: 2),
                              Text('Email: $workerEmail'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
