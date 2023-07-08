import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:madadgarhath/screens/workerlogin.dart';

class WorkerRegisterForm extends StatefulWidget {
  @override
  _WorkerRegisterFormState createState() => _WorkerRegisterFormState();
}

class _WorkerRegisterFormState extends State<WorkerRegisterForm> {
  final _formKey = GlobalKey<FormState>();

  String _fullName = '';
  String _email = '';
  String _password = '';
  String _phoneNumber = '';
  String _profession = '';
  String _cnic = '';
  String _username = '';
  double _hourlyRate = 0.0;

  List<String> _professionOptions = [
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

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Form is valid, perform registration logic here
      // You can access the entered values using the _fullName, _email, _password, _phoneNumber, _address, _profilePicture, _profession, _cnic, _username, and _hourlyRate variables
      // Add your registration logic here
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/texture2.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
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
          body: SingleChildScrollView(
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
                            _fullName = value;
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
                            _email = value;
                          },
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Username',
                            prefixIcon: Icon(Icons.person_outline_outlined),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter a username';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            _username = value;
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
                            _password = value;
                          },
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'CNIC',
                            prefixIcon: Icon(Icons.credit_card),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your CNIC';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            _cnic = value;
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
                            _phoneNumber = value;
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
                              _profession = value!;
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
                            _hourlyRate = double.parse(value);
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
                                    ));
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
      ),
    );
  }
}
