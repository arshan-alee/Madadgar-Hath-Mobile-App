import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:madadgarhath/screens/WorkerRegisteration.dart';

import '../widgets/CustomSignInButton.dart';

class WorkerLoginForm extends StatefulWidget {
  const WorkerLoginForm({Key? key}) : super(key: key);

  @override
  _WorkerLoginFormState createState() => _WorkerLoginFormState();
}

class _WorkerLoginFormState extends State<WorkerLoginForm> {
  final _formKey = GlobalKey<FormState>();

  String _email = '';
  String _password = '';

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Form is valid, perform sign-in logic here
      // You can access the entered values using the _email and _password variables
      // Add your sign-in logic here
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
          body: Center(
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
                          _email = value;
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
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          backgroundColor: const Color.fromARGB(255, 1, 31, 56),
                        ),
                        child: Text('Log In'),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Or connect using',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      SizedBox(height: 10),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomButton(
                            icon: 'images/google.png',
                            text: "Log In with Google",
                            bgcolor: Color(0xFFCE1010),
                            txtcolor: Colors.white,
                          ),
                          SizedBox(width: 20),
                          CustomButton(
                            icon: 'images/facebook.png',
                            text: "Log In with Facebook",
                            bgcolor: Colors.blue,
                            txtcolor: Colors.white,
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Don't have an account?"),
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => WorkerRegisterForm(),
                                ),
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
      ),
    );
  }
}