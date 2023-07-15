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
  late Stream<List<DocumentSnapshot>> _availableJobsStream;

  @override
  void initState() {
    super.initState();
    _fetchUserName();
    _fetchAvailableJobs();
  }

  void _fetchUserName() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('worker')
        .where('userId', isEqualTo: widget.userId)
        .get();

    setState(() {
      _workerName = snapshot.docs.first.get('fullName') ?? '';
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
        extendBody: true,
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
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          'Hello $_workerName !',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
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
                    ],
                  ),
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
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListTile(
                                  title: Text(
                                    'Job Title: $customerProfessionNeed',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
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
