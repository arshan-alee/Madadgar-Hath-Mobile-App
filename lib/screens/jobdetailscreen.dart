import 'package:flutter/material.dart';
import 'package:madadgarhath/screens/submitproposal.dart';

class JobDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> jobData;
  final String workerProfession;
  const JobDetailsScreen(
      {Key? key, required this.jobData, required this.workerProfession})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final customerFullName = jobData['fullName'] as String;
    final customerAddress = jobData['address'] as String;
    final customerPhoneNumber = jobData['phoneNumber'] as String;
    final customerEmail = jobData['email'] as String;
    final jobDescription = jobData['jobDescription'] as String;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(
          'Job Details',
          style: TextStyle(color: Colors.black, fontFamily: 'Manrope-Bold'),
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
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Job Title: ${jobData['needProfession']}',
                          style: TextStyle(
                            fontSize: 30,
                            fontFamily: 'Manrope-ExtraBold',
                          ),
                        ),
                        SizedBox(height: 8),
                        Text('Provider: $customerFullName'),
                        SizedBox(height: 8),
                        Text('Address: $customerAddress'),
                        SizedBox(height: 8),
                        Text('Phone: $customerPhoneNumber'),
                        SizedBox(height: 8),
                        Text('Email: $customerEmail'),
                        SizedBox(height: 8),
                        Text(
                          'Job Description:',
                        ),
                        SizedBox(height: 4),
                        Text(jobDescription),
                        SizedBox(height: 4)
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  _navigateToSubmitProposal(context);
                },
                child: Text('Apply Now'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToSubmitProposal(BuildContext context) {
    final needProfession = jobData['needProfession'] as String;
    if (workerProfession == needProfession) {
      // Worker's profession matches the required profession
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SubmitProposalScreen(jobData: jobData),
        ),
      );
    } else {
      // Worker's profession doesn't match the required profession
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Cannot Apply'),
            content: Text(
              'You cannot apply for this job as it requires a different profession.',
            ),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }
}
