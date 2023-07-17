import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:madadgarhath/screens/worker/workerprofile.dart';
import 'package:madadgarhath/screens/worker/yourproposals.dart';
import 'jobdetailscreen.dart';

class WorkerHomePage extends StatefulWidget {
  final String userId;

  const WorkerHomePage({Key? key, required this.userId}) : super(key: key);

  @override
  _WorkerHomePageState createState() => _WorkerHomePageState();
}

class _WorkerHomePageState extends State<WorkerHomePage> {
  String _workerName = '';
  String _profession = '';
  bool _availability = false;
  String _workerphoneNumber = '';
  double _workerhourlyRate = 0.0;
  String _workeremail = '';
  String _workerdescription = '';
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
      _workerphoneNumber = snapshot.docs.first.get('phoneNumber') ?? '';
      _workeremail = snapshot.docs.first.get('email') ?? '';
      _workerhourlyRate = snapshot.docs.first.get('hourlyRate') ?? 0.0;
      _workerdescription = snapshot.docs.first.get('description') ?? '';
      _availability = snapshot.docs.first.get('availability') ?? false;
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
            Icon(Icons.assignment, color: Colors.white, size: 30),
            Icon(Icons.settings, color: Colors.white, size: 30),
          ],
          onTap: (index) {
            if (index == 2) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      WorkerProfileScreen(userId: widget.userId),
                ),
              );
            }
            if (index == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      YourProposalScreen(userId: widget.userId),
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
                        fontFamily: 'Manrope-Bold',
                      ),
                    ),
                    Text(
                      'Check out these available jobs',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                          fontFamily: 'Manrope-Regular'),
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
                            final jobHours = jobData['jobHours'] as double;
                            return Card(
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => JobDetailsScreen(
                                          workerId: widget.userId,
                                          jobData: jobData,
                                          workerProfession: _profession,
                                          workerAvailability: _availability,
                                          workerPhoneNumber: _workerphoneNumber,
                                          workerEmail: _workeremail,
                                          workerHourlyRate: _workerhourlyRate,
                                          workerDescription: _workerdescription,
                                          workerName: _workerName),
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
                                        SizedBox(height: 6),
                                        Text('Job Hours: $jobHours'),
                                        SizedBox(height: 2),
                                        Text('Address: $customerAddress'),
                                        SizedBox(height: 2),
                                        Text('Provider: $customerFullName'),
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
