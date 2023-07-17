import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:madadgarhath/screens/customer/customerhomepage.dart';
import 'package:madadgarhath/screens/customer/customerprofile.dart';

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
  double _jobHours = 0.0;
  String _jobDescription = '';

  bool _isJobPosted = false;

  @override
  void initState() {
    super.initState();
    _fetchJobData();
  }

  void _fetchJobData() {
    FirebaseFirestore.instance
        .collection('customer')
        .where('userId', isEqualTo: widget.userId)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        final customerData = snapshot.docs[0].data() as Map<String, dynamic>;
        setState(() {
          _jobAvailability = customerData['jobAvailability'] as bool? ?? false;
          _needProfession = customerData['needProfession'] as String? ?? '';
          _jobHours = (customerData['jobHours'] as num?)?.toDouble() ?? 0.0;
          _jobDescription = customerData['jobDescription'] as String? ?? '';
          _isJobPosted = customerData['jobPosted'] as bool? ?? false;
        });
      }
    });
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
        index: 1,
        items: <Widget>[
          Icon(Icons.search, color: Colors.white, size: 30),
          Icon(Icons.assignment_add, color: Colors.white, size: 30),
          Icon(Icons.settings, color: Colors.white, size: 30),
        ],
        onTap: (index) {
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CustomerHomePage(userId: widget.userId),
              ),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    CustomerProfileScreen(userId: widget.userId),
              ),
            );
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
              onPressed: _updateJob,
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
            initialValue: _jobHours.toString(),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {
                _jobHours = double.tryParse(value) ?? 0.0;
              });
            },
            decoration: InputDecoration(
              hintText: 'Enter job hours',
              prefixIcon: Icon(Icons.access_time),
            ),
            validator: (value) {
              if (value == null || value.isEmpty || double.parse(value) < 0.5) {
                return 'Please enter valid job hours';
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
            initialValue: _jobDescription,
            onChanged: (value) {
              setState(() {
                _jobDescription = value;
              });
            },
            decoration: InputDecoration(
              hintText: 'Enter job description',
              prefixIcon: Icon(Icons.description),
            ),
            validator: (value) {
              if (value!.length < 20) {
                return 'Description must be at least 20 characters';
              }
              return null;
            },
            maxLines: _jobAvailability ? null : 1,
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

  void _postJob() {
    if (_formKey.currentState!.validate()) {
      final firestore = FirebaseFirestore.instance;
      final jobData = {
        'jobAvailability': _jobAvailability,
        'needProfession': _needProfession,
        'jobHours': _jobHours,
        'jobDescription': _jobDescription,
        'jobPosted': _isJobPosted
      };

      firestore
          .collection('customer')
          .where('userId', isEqualTo: widget.userId)
          .get()
          .then((snapshot) {
        if (snapshot.docs.isNotEmpty) {
          snapshot.docs.forEach((doc) {
            doc.reference.update(jobData).then((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Job posted successfully'),
                ),
              );
              setState(() {
                _isJobPosted = true;
              });
            }).catchError((error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Failed to post job. Please try again later.'),
                ),
              );
            });
          });
        }
      });
    }
  }

  void _updateJob() {
    if (_formKey.currentState!.validate()) {
      final firestore = FirebaseFirestore.instance;
      final jobData = {
        'jobAvailability': _jobAvailability,
        'needProfession': _needProfession,
        'jobHours': _jobHours,
        'jobDescription': _jobDescription,
        'jobPosted': _isJobPosted
      };

      firestore
          .collection('customer')
          .where('userId', isEqualTo: widget.userId)
          .get()
          .then((snapshot) {
        if (snapshot.docs.isNotEmpty) {
          snapshot.docs.forEach((doc) {
            doc.reference.update(jobData).then((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Job Updated successfully'),
                ),
              );
              setState(() {
                _isJobPosted = false;
                _needProfession = '';
                _jobHours = 0.0;
                _jobDescription = '';
              });
            }).catchError((error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error updating the job'),
                ),
              );
            });
          });
        }
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error fetching the job data'),
          ),
        );
      });
    }
  }
}
