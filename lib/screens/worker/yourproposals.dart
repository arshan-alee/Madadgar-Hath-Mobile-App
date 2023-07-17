import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:madadgarhath/screens/worker/workerhomepage.dart';
import 'package:madadgarhath/screens/worker/workerprofile.dart';

class YourProposalScreen extends StatelessWidget {
  final String userId;

  YourProposalScreen({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(
          'Your Proposal',
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
      bottomNavigationBar: CurvedNavigationBar(
        color: const Color.fromARGB(255, 1, 31, 56),
        height: 65,
        backgroundColor: Colors.transparent,
        index: 1,
        items: <Widget>[
          Icon(Icons.search, color: Colors.white, size: 30),
          Icon(Icons.assignment, color: Colors.white, size: 30),
          Icon(Icons.settings, color: Colors.white, size: 30),
        ],
        onTap: (index) {
          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WorkerProfileScreen(userId: userId),
              ),
            );
          }
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WorkerHomePage(userId: userId),
              ),
            );
          }
        },
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('proposals')
            .where('workerUserId', isEqualTo: userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('No proposals found.'),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final proposalData =
                  snapshot.data!.docs[index].data() as Map<String, dynamic>;
              final customerName = proposalData['customerName'] ?? '';
              final hourlyRate = proposalData['hourlyRate'] ?? '';
              final totalJobHours = proposalData['totalJobHours'] ?? '';
              return Card(
                child: ListTile(
                  title: Text('Customer: $customerName'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Hourly Rate: $hourlyRate'),
                      Text('Total Job Hours: $totalJobHours'),
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
