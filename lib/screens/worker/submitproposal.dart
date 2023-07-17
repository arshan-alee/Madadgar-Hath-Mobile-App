import 'package:flutter/material.dart';

class SubmitProposalScreen extends StatelessWidget {
  final Map<String, dynamic> jobData;

  const SubmitProposalScreen({Key? key, required this.jobData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Implement the UI for submitting the proposal
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(
          'Submit Proposal',
          style: TextStyle(
              color: const Color.fromARGB(255, 1, 31, 56),
              fontFamily: 'Manrope-Bold'),
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
        child: Text('Submit Proposal Form'),
      ),
    );
  }
}
