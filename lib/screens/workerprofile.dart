import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:madadgarhath/screens/workerhomepage.dart';
import 'package:madadgarhath/screens/workerlogin.dart';

class WorkerProfileScreen extends StatefulWidget {
  final String userId;

  const WorkerProfileScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _WorkerProfileScreenState createState() => _WorkerProfileScreenState();
}

class _WorkerProfileScreenState extends State<WorkerProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  String _fullName = '';
  String _email = '';
  String _phoneNumber = '';
  String _profession = '';
  bool _isAvailable = false;
  double _hourlyRate = 0.0;
  String _description = '';

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
    'Sewerage Cleaner',
  ];

  final Map<String, String> _professionIcons = {
    'Maid': 'images/maid.png',
    'Driver': 'images/driver.png.png',
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: [
          Container(
            margin: EdgeInsets.only(right: 8),
            child: SizedBox(
              child: ElevatedButton(
                onPressed: _showSignOutConfirmationDialog,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 1, 31, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.logout),
                    SizedBox(width: 3),
                    Text("Sign Out", softWrap: true),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        color: const Color.fromARGB(255, 1, 31, 56),
        height: 65,
        backgroundColor: Colors.transparent,
        index: 1,
        items: <Widget>[
          Icon(Icons.search, color: Colors.white, size: 30),
          Icon(Icons.settings, color: Colors.white, size: 30),
        ],
        onTap: (index) {
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WorkerHomePage(userId: widget.userId),
              ),
            );
          }
        },
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('worker')
            .where('userId', isEqualTo: widget.userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final workerData =
                snapshot.data!.docs[0].data() as Map<String, dynamic>;

            // Retrieve worker details from Firestore
            _fullName = workerData['fullName'] as String;
            _email = workerData['email'] as String;
            _phoneNumber = workerData['phoneNumber'] as String;
            _profession = workerData['profession'] as String;
            _isAvailable = workerData['availability'] as bool? ?? false;
            _hourlyRate = workerData['hourlyRate'] as double? ?? 0.0;
            _description = workerData['description'] as String? ?? '';

            return SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Center(
                            child: SingleChildScrollView(
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Center(
                                      child: Column(
                                        children: [
                                          CircleAvatar(
                                              radius: 50.0,
                                              backgroundImage: AssetImage(
                                                  _professionIcons[
                                                          _profession] ??
                                                      '')),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          Text(
                                            'Signed in as ' + _email,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      'Full Name',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    TextFormField(
                                      initialValue: _fullName,
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                      enabled: false,
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      'Phone Number',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
                                      initialValue: _phoneNumber,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Please enter your phone number';
                                        }
                                        return null;
                                      },
                                      onChanged: (value) {
                                        _phoneNumber = value;
                                      },
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      'Profession',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    DropdownButtonFormField<String>(
                                      value: _professionOptions
                                              .contains(_profession)
                                          ? _profession
                                          : null,
                                      items: _professionOptions
                                          .map((String profession) {
                                        return DropdownMenuItem<String>(
                                          value: profession,
                                          child: Text(profession),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        _profession = value!;
                                      },
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      'Hourly Rate',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
                                      initialValue: _hourlyRate.toString(),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Please enter the hourly rate';
                                        }
                                        return null;
                                      },
                                      onChanged: (value) {
                                        _hourlyRate = double.parse(value);
                                      },
                                      keyboardType: TextInputType.number,
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      'Availability',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    StatefulBuilder(
                                      builder: (context, setState) {
                                        return Row(
                                          children: [
                                            Checkbox(
                                              value: _isAvailable,
                                              onChanged: (value) {
                                                setState(() {
                                                  _isAvailable = value!;
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
                                      'Give a brief description about yourself',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
                                      initialValue: _description,
                                      onChanged: (value) {
                                        _description = value;
                                      },
                                      validator: (value) {
                                        if (_isAvailable &&
                                            value!.length < 50) {
                                          return 'Description must be of least 50 characters';
                                        }
                                        return null;
                                      },
                                      maxLines: _isAvailable ? null : 1,
                                    ),
                                    SizedBox(height: 10),
                                    Container(
                                      width: 150,
                                      child: ElevatedButton(
                                        onPressed: _submitForm,
                                        child: Row(
                                          children: [
                                            Icon(Icons.update),
                                            SizedBox(width: 3),
                                            Text("Update Profile",
                                                softWrap: true),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Form is valid, perform update logic here
      // You can access the entered values using the _phoneNumber and _profession variables
      // Add your update logic here

      // Update the worker document in Firestore
      FirebaseFirestore.instance
          .collection('worker')
          .where('userId', isEqualTo: widget.userId)
          .get()
          .then((snapshot) {
        final workerDoc = snapshot.docs.first;
        workerDoc.reference.update({
          'phoneNumber': _phoneNumber,
          'profession': _profession,
          'availability': _isAvailable,
          'hourlyRate': _hourlyRate,
          'description': _description,
        }).then((_) {
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Profile updated successfully'),
            ),
          );
        }).catchError((error) {
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error updating profile'),
            ),
          );
        });
      });
    }
  }

  void _showSignOutConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Sign Out'),
          content: Text('Are you sure you want to sign out?'),
          actions: <Widget>[
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                _signOut();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => WorkerLoginForm(),
        ),
      );
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error signing out'),
        ),
      );
    }
  }
}
