import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class PostJobScreen extends StatefulWidget {
  final String userId;

  const PostJobScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _PostJobScreenState createState() => _PostJobScreenState();
}

class _PostJobScreenState extends State<PostJobScreen> {
  final List<String> _professionOptions = [
    'Maid',
    'Driver',
    'Plumber',
    'Mechanic',
    'Chef',
    'Babysitter',
    'Electrician',
    'Attendant',
    'Tutor',
    'Painter',
    'Gardener',
    'Sewerage Cleaner'
  ];

  final _formKey = GlobalKey<FormState>();

  bool _jobAvailability = false;
  String _needProfession = '';
  String _jobHours = '';
  String _jobDescription = '';

  bool _isJobPosted = false;

  void _postJob() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isJobPosted = true;
      });

      final firestore = FirebaseFirestore.instance;
      final jobData = {
        'userId': widget.userId,
        'jobAvailability': _jobAvailability,
        'needProfession': _needProfession,
        'jobHours': _jobHours,
        'jobDescription': _jobDescription,
      };
      firestore
          .collection('customer')
          .doc(widget.userId)
          .update(jobData)
          .then((_) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Success'),
              content: Text('Job posted successfully.'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop(); // Pop back to home screen
                  },
                ),
              ],
            );
          },
        );
      }).catchError((error) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Failed to post job. Please try again later.'),
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
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(
          'Post A Job',
          style: TextStyle(
            color: const Color.fromARGB(255, 1, 31, 56),
            fontFamily: 'Manrope-Bold',
          ),
        ),
        centerTitle: true,
      ),
      bottomNavigationBar: CurvedNavigationBar(
        color: const Color.fromARGB(255, 1, 31, 56),
        height: 65,
        backgroundColor: Colors.transparent,
        items: <Widget>[
          Icon(Icons.search, color: Colors.white, size: 30),
          Icon(Icons.assignment_add, color: Colors.white, size: 30),
          Icon(Icons.settings, color: Colors.white, size: 30),
        ],
        onTap: (index) {
          if (index == 0) {
            // Handle search icon tapped
          } else if (index == 2) {
            // Handle settings icon tapped
          }
        },
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: _isJobPosted ? _buildPostedJobsCard() : _buildJobForm(),
      ),
    );
  }

  Widget _buildPostedJobsCard() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Posted Jobs',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Job Availability:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            StatefulBuilder(
              builder: (context, setState) {
                return Row(
                  children: [
                    Checkbox(
                      value: _jobAvailability,
                      onChanged: (value) {
                        setState(() {
                          _jobAvailability = value!;
                        });
                      },
                    ),
                    Text(_jobAvailability ? 'Available' : 'Unavailable'),
                  ],
                );
              },
            ),
            SizedBox(height: 10),
            Text(
              'Job Title: $_needProfession',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Job Hours: $_jobHours',
            ),
            Text(
              'Job Description: $_jobDescription',
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isJobPosted = false;
                });
              },
              child: Text('Update'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJobForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Job Availability',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          StatefulBuilder(
            builder: (context, setState) {
              return Row(
                children: [
                  Checkbox(
                    value: _jobAvailability,
                    onChanged: (value) {
                      setState(() {
                        _jobAvailability = value!;
                      });
                    },
                  ),
                  Text('Available'),
                ],
              );
            },
          ),
          SizedBox(height: 10),
          Text(
            'Looking for',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          DropdownButtonFormField<String>(
            value: _professionOptions.contains(_needProfession)
                ? _needProfession
                : null,
            items: _professionOptions.map((String profession) {
              return DropdownMenuItem<String>(
                value: profession,
                child: Text(profession),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _needProfession = value!;
              });
            },
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.work),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select a profession';
              }
              return null;
            },
          ),
          SizedBox(height: 10),
          Text(
            'Job Hours',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          TextFormField(
            onChanged: (value) {
              _jobHours = value;
            },
            decoration: InputDecoration(
              hintText: 'Enter job hours',
              prefixIcon: Icon(Icons.access_time),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter job hours';
              }
              return null;
            },
          ),
          SizedBox(height: 10),
          Text(
            'Job Description',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          TextFormField(
            onChanged: (value) {
              _jobDescription = value;
            },
            decoration: InputDecoration(
              hintText: 'Enter job description',
              prefixIcon: Icon(Icons.description),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter job description';
              }
              return null;
            },
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _postJob,
            child: Text('Post Job'),
          ),
        ],
      ),
    );
  }
}
