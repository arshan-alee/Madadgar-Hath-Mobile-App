import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:madadgarhath/screens/workerprofile.dart';

class WorkerHomePage extends StatefulWidget {
  final String userId;

  const WorkerHomePage({Key? key, required this.userId}) : super(key: key);

  @override
  _WorkerHomePageState createState() => _WorkerHomePageState();
}

class _WorkerHomePageState extends State<WorkerHomePage> {
  String _workerName = '';
  String _profession = '';
  late Stream<List<DocumentSnapshot>> _availableJobsStream;

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

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    _fetchAvailableJobs();
  }

  void _fetchUserData() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('worker')
        .where('userId', isEqualTo: widget.userId)
        .get();

    setState(() {
      _workerName = snapshot.docs.first.get('fullName') ?? '';
      _profession = snapshot.docs.first.get('profession') ?? '';
    });
  }

  void _fetchAvailableJobs() {
    _availableJobsStream = FirebaseFirestore.instance
        .collection('customer')
        .where('jobAvailability', isEqualTo: true)
        .snapshots()
        .map((snapshot) => snapshot.docs);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        WorkerProfileScreen(userId: widget.userId),
                  ),
                );
              },
              child: Visibility(
                visible: _professionIcons.containsKey(_profession),
                child: Container(
                  margin: EdgeInsets.only(right: 15),
                  child: CircleAvatar(
                    backgroundImage:
                        AssetImage(_professionIcons[_profession] ?? ''),
                  ),
                ),
              ),
            ),
          ],
        ),
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
                      WorkerProfileScreen(userId: widget.userId),
                ),
              );
            }
          },
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        'Hello $_workerName!',
                        style: TextStyle(
                            fontSize: 20, fontFamily: 'Manrope-ExtraBold'),
                      ),
                    ),
                    SizedBox(height: 15),
                    Text(
                      'Looking for a job?',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Check out these available jobs',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 15),
                  ],
                ),
                Expanded(
                  child: StreamBuilder<List<DocumentSnapshot>>(
                    stream: _availableJobsStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final jobDocs = snapshot.data!;
                        if (jobDocs.isEmpty) {
                          return Center(
                            child: Text(
                              'No available jobs at the moment.',
                              style: TextStyle(fontSize: 16),
                            ),
                          );
                        }

                        return ListView.builder(
                          itemCount: jobDocs.length,
                          itemBuilder: (context, index) {
                            final jobData =
                                jobDocs[index].data() as Map<String, dynamic>;
                            final customerFullName =
                                jobData['fullName'] as String;
                            final customerAddress =
                                jobData['address'] as String;
                            final customerPhoneNumber =
                                jobData['phoneNumber'] as String;
                            final customerProfessionNeed =
                                jobData['needProfession'] as String;
                            return Card(
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => JobDetailsScreen(
                                          jobData: jobData,
                                          workerProfession: _profession),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ListTile(
                                    title: Text(
                                      'Job Title: $customerProfessionNeed',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 2),
                                        Text('Provider: $customerFullName'),
                                        SizedBox(height: 2),
                                        Text('Address: $customerAddress'),
                                        SizedBox(height: 2),
                                        Text('Phone: $customerPhoneNumber'),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('Error: ${snapshot.error}'),
                        );
                      } else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Job Title: ${jobData['needProfession']}'),
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
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(jobDescription),
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
