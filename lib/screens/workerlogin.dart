import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:madadgarhath/screens/WorkerRegisteration.dart';
import 'package:madadgarhath/screens/customerhomepage.dart';
import 'package:madadgarhath/screens/getstarted.dart';
import 'package:madadgarhath/screens/workerhomepage.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../widgets/CustomSignInButton.dart';

class WorkerLoginForm extends StatefulWidget {
  const WorkerLoginForm({Key? key}) : super(key: key);

  @override
  _WorkerLoginFormState createState() => _WorkerLoginFormState();
}

class _WorkerLoginFormState extends State<WorkerLoginForm> {
  final _formKey = GlobalKey<FormState>();

  String _wemail = '';
  String _wpassword = '';

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Form is valid, perform sign-in logic here
      // You can access the entered values using the _wemail and _wpassword variables
      // Add your sign-in logic here
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _wemail,
          password: _wpassword,
        );
        final userId = userCredential.user!.uid;
        // Login successful
        _showLoginSuccessSnackBar();
        Future.delayed(Duration(seconds: 5), () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => WorkerHomePage(userId: userId)),
          );
        });
      } catch (e) {
        // Login failed
        _showLoginFailureSnackBar();
      }
    }
  }

  void _showLoginSuccessSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Login successful',
          textAlign: TextAlign.center,
        ),
        duration: Duration(seconds: 5),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showLoginFailureSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Invalid email or password',
          textAlign: TextAlign.center,
        ),
        duration: Duration(seconds: 5),
        backgroundColor: Colors.red,
      ),
    );
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
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => GetStarted()),
            );
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
          Center(
            child: SingleChildScrollView(
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
                          'Sign In',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20),
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
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _submitForm,
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            backgroundColor:
                                const Color.fromARGB(255, 1, 31, 56),
                          ),
                          child: Text('Log In'),
                        ),
                        // SizedBox(height: 10),
                        // Text(
                        //   'Or connect using',
                        //   style: TextStyle(fontSize: 16, color: Colors.grey),
                        // ),
                        // SizedBox(height: 10),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: [
                        //     CustomButton(
                        //       icon: 'images/google.png',
                        //       text: "Log In with Google",
                        //       bgcolor: Color(0xFFCE1010),
                        //       txtcolor: Colors.white,
                        //       onPressed: () {
                        //         Navigator.push(
                        //           context,
                        //           MaterialPageRoute(
                        //               builder: (context) => WorkerHomePage()),
                        //         );
                        //       },
                        //     ),
                        //     SizedBox(width: 20),
                        //     CustomButton(
                        //       icon: 'images/facebook.png',
                        //       text: "Log In with Facebook",
                        //       bgcolor: Colors.blue,
                        //       txtcolor: Colors.white,
                        //       onPressed: () {
                        //         Navigator.push(
                        //           context,
                        //           MaterialPageRoute(
                        //               builder: (context) => WorkerHomePage()),
                        //         );
                        //       },
                        //     ),
                        //   ],
                        // ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Don't have an account?"),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          WorkerRegisterForm()),
                                );
                              },
                              child: Text('Register Now'),
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
        ],
      ),
    );
  }
}
