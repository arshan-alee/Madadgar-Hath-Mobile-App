import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SubmitProposalScreen extends StatelessWidget {
  final Map<String, dynamic> jobData;
  final String workerPhoneNumber;
  final String workerEmail;
  final double workerHourlyRate;
  final String workerDescription;
  final String workerId;
  final String workerName;

  const SubmitProposalScreen({
    Key? key,
    required this.jobData,
    required this.workerPhoneNumber,
    required this.workerEmail,
    required this.workerHourlyRate,
    required this.workerDescription,
    required this.workerId,
    required this.workerName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(
          'Submit Proposal',
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 2.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'Applying for: ${jobData['needProfession']}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Job Provider: ${jobData['fullName']}',
                    style: TextStyle(fontSize: 14),
                  ),
                  Text(
                    'Job Hours: ${jobData['jobHours']}',
                    style: TextStyle(fontSize: 14),
                  ),
                  Text(
                    'Address: ${jobData['address']}',
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(height: 50),
                  Center(
                    child: Text(
                      'Cover Letter:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    initialValue: workerDescription,
                    decoration: InputDecoration(
                      labelText: 'Cover Letter',
                      prefixIcon: Icon(Icons.description),
                    ),
                    maxLines: 5,
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    initialValue: workerHourlyRate.toString(),
                    decoration: InputDecoration(
                      labelText: 'Hourly Rate',
                      prefixIcon: Icon(Icons.attach_money),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      _submitProposal(context);
                    },
                    child: Text('Submit'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _submitProposal(BuildContext context) async {
    final customerUserId = jobData['userId'] as String;
    final customerName = jobData['fullName'] as String;

    final proposalData = {
      'customerUserId': customerUserId,
      'customerName': customerName,
      'workerUserId': workerId,
      'workerName': workerName, // Replace with the actual worker's name
      'hourlyRate': workerHourlyRate,
      'totalJobHours': jobData['jobHours'],
    };

    try {
      await FirebaseFirestore.instance
          .collection('proposals')
          .add(proposalData);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Proposal submitted successfully')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit proposal. Please try again.')),
      );
      print('Error submitting proposal: $error');
    }
  }
}
