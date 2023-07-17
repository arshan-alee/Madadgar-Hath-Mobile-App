import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class YourOrderScreen extends StatelessWidget {
  final String userId;

  YourOrderScreen({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(
          'Your Order',
          style: TextStyle(
            color: const Color.fromARGB(255, 1, 31, 56),
            fontFamily: 'Manrope-Bold',
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
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where('workeruserid', isEqualTo: userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('No orders found.'),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final orderData =
                  snapshot.data!.docs[index].data() as Map<String, dynamic>;
              final customerName = orderData['customernameid'] ?? '';
              final workerProfession = orderData['workerprofession'] ?? '';
              final hourlyRate = orderData['workerhourlyrate'] ?? '';
              final totalJobHours = orderData['customerjobhours'] ?? '';
              final totalAmount = orderData['totalamount'] ?? '';
              return Card(
                child: ListTile(
                  title: Text('Customer: $customerName'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Worker Profession: $workerProfession'),
                      Text('Hourly Rate: $hourlyRate'),
                      Text('Total Job Hours: $totalJobHours'),
                      Text('Total Amount: $totalAmount'),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
