import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:madadgarhath/screens/workerhomepage.dart';

class WorkerProfileScreen extends StatefulWidget {
  final String workerId;

  const WorkerProfileScreen({Key? key, required this.workerId})
      : super(key: key);

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

  final List<String> _professionOptions = [
    'Maid',
    'Driver',
    'Plumber',
    'Electrician',
    'Mechanic',
    'Chef',
    'Daycare',
    'Attendant',
    'Tutor',
    'Gardener',
    'Sewerage Cleaner',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: CurvedNavigationBar(
        color: const Color.fromARGB(255, 1, 31, 56),
        height: 65,
        backgroundColor: Colors.transparent,
        index: 1,
        items: <Widget>[
          Icon(Icons.search, color: Colors.white, size: 30),
          Icon(Icons.settings, color: Colors.white, size: 30),
          Icon(Icons.compare_arrows, color: Colors.white, size: 30),
        ],
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WorkerHomePage(workerId: widget.workerId),
              ),
            );
          }
        },
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('worker')
            .doc(widget.workerId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final workerData = snapshot.data!.data() as Map<String, dynamic>;

            // Retrieve worker details from Firestore
            final fullName = workerData['fullName'] as String;
            final email = workerData['email'] as String;
            final phoneNumber = workerData['phoneNumber'] as String;
            final profession = workerData['profession'] as String;
            _isAvailable = workerData['isAvailable'] as bool? ?? false;

            // Update the local variables with retrieved values
            _fullName = fullName;
            _email = email;
            _phoneNumber = phoneNumber;
            _profession = profession;

            return SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Full Name',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
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
                          'Email',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextFormField(
                          initialValue: _email,
                          enabled: false,
                          style: TextStyle(
                            color: Colors.grey,
                          ),
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
                          value: _profession,
                          items: _professionOptions.map((String profession) {
                            return DropdownMenuItem<String>(
                              value: profession,
                              child: Text(profession),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _profession = value!;
                            });
                          },
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
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _submitForm,
                          child: Text('Update Profile'),
                        ),
                      ],
                    ),
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
          .doc(widget.workerId)
          .update({
        'phoneNumber': _phoneNumber,
        'profession': _profession,
        'isAvailable': _isAvailable,
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
    }
  }
}
