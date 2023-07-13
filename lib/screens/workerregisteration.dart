import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:madadgarhath/screens/workerhomepage.dart';
import 'package:madadgarhath/screens/workerlogin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WorkerRegisterForm extends StatefulWidget {
  const WorkerRegisterForm({Key? key}) : super(key: key);

  @override
  _WorkerRegisterFormState createState() => _WorkerRegisterFormState();
}

class _WorkerRegisterFormState extends State<WorkerRegisterForm> {
  final _formKey = GlobalKey<FormState>();

  String _wfullName = '';
  String _wemail = '';
  String _wpassword = '';
  String _wphoneNumber = '';
  String _wprofession = '';
  int _wcnic = 0;
  double _whourlyRate = 0.0;
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

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Form is valid, perform registration logic here

      // Access the Firebase Authentication instance
      final auth = FirebaseAuth.instance;
      final firestore = FirebaseFirestore.instance;

      try {
        // Create the user with email and password
        final userCredential = await auth.createUserWithEmailAndPassword(
          email: _wemail,
          password: _wpassword,
        );

        // Retrieve the user ID
        final userId = userCredential.user!.uid;

        // Create a document reference for the worker registration data
        final docRef = await firestore.collection('worker').add({
          'userId': userId,
          'fullName': _wfullName,
          'email': _wemail,
          'password': _wpassword,
          'phoneNumber': _wphoneNumber,
          'profession': _wprofession,
          'cnic': _wcnic,
          'hourlyRate': _whourlyRate,
          'availability': _isAvailable
        });

        // Retrieve the newly created document ID
        final documentId = docRef.id;

        // Display a success message
        _showRegistrationSuccessSnackBar();

        // Delay navigation to the homepage
        Future.delayed(Duration(seconds: 5), () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WorkerHomePage(userId: userId),
            ),
          );
        });
      } catch (e) {
        // Handle any errors that occur during data saving
        print('Error saving data: $e');
        // Display an error message
        _showErrorSnackBar();
      }
    }
  }

  void _showRegistrationSuccessSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Registration successful',
          textAlign: TextAlign.center,
        ),
        duration: Duration(seconds: 5),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showErrorSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Error occurred during registration',
          textAlign: TextAlign.center,
        ),
        duration: Duration(seconds: 5),
        backgroundColor: Colors.red,
      ),
    );
  }

  Future<Map<String, dynamic>> _fetchWorkerData(String workerId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('worker')
        .doc(workerId)
        .get();
    return snapshot.data() as Map<String, dynamic>;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0, // Remove the app bar shadow
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/texture2.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Center(
                child: Card(
                  margin: EdgeInsets.all(20),
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Worker Registration',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Full Name',
                              prefixIcon: Icon(Icons.person),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your full name';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              _wfullName = value;
                            },
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Email',
                              prefixIcon: Icon(Icons.email),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter an email address';
                              }
                              // Add email validation logic here if needed
                              return null;
                            },
                            onChanged: (value) {
                              _wemail = value;
                            },
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Password',
                              prefixIcon: Icon(Icons.lock),
                            ),
                            obscureText: true,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter a password';
                              }
                              // Add password validation logic here if needed
                              return null;
                            },
                            onChanged: (value) {
                              _wpassword = value;
                            },
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'CNIC',
                              prefixIcon: Icon(Icons.credit_card),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your CNIC';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              _wcnic = int.parse(value);
                            },
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Phone Number',
                              prefixIcon: Icon(Icons.phone),
                            ),
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter a phone number';
                              }
                              // Add phone number validation logic here if needed
                              return null;
                            },
                            onChanged: (value) {
                              _wphoneNumber = value;
                            },
                          ),
                          DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              labelText: 'Profession',
                              prefixIcon: Icon(Icons.work),
                            ),
                            items: _professionOptions.map((String profession) {
                              return DropdownMenuItem<String>(
                                value: profession,
                                child: Text(profession),
                              );
                            }).toList(),
                            validator: (value) {
                              if (value == null) {
                                return 'Please select a profession';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              setState(() {
                                _wprofession = value!;
                              });
                            },
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Hourly Rate',
                              prefixIcon: Icon(Icons.attach_money),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter an hourly rate';
                              }
                              // Add hourly rate validation logic here if needed
                              return null;
                            },
                            onChanged: (value) {
                              _whourlyRate = double.parse(value);
                            },
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: _submitForm,
                            child: Text('Register'),
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              backgroundColor:
                                  const Color.fromARGB(255, 1, 31, 56),
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Already have an account?"),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => WorkerLoginForm(),
                                    ),
                                  );
                                },
                                child: Text('Log In'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
