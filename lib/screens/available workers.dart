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
        title: Text('Available Workers'),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('worker')
            .where('profession', isEqualTo: profession)
            .where('availability', isEqualTo: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final workerDocs = snapshot.data!.docs;
            return ListView.builder(
              itemCount: workerDocs.length,
              itemBuilder: (context, index) {
                final workerData = workerDocs[index].data();
                final workerName = workerData['fullName'] as String;
                final workerPhoneNumber = workerData['phoneNumber'] as String;
                final workerHourlyRate = workerData['hourlyRate'] as double;
                final workerProfession = workerData['profession'] as String;
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
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
