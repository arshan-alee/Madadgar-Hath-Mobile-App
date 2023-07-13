import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:madadgarhath/screens/customerhomepage.dart';
import 'package:madadgarhath/screens/getstarted.dart';
import 'package:madadgarhath/screens/customerregisteration.dart';

class CustomerLoginForm extends StatefulWidget {
  const CustomerLoginForm({Key? key}) : super(key: key);

  @override
  _CustomerLoginFormState createState() => _CustomerLoginFormState();
}

class _CustomerLoginFormState extends State<CustomerLoginForm> {
  final _formKey = GlobalKey<FormState>();

  String _cemail = '';
  String _cpassword = '';

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _cemail,
          password: _cpassword,
        );
        final userId = userCredential.user!.uid;
        _showLoginSuccessSnackBar();
        Future.delayed(Duration(seconds: 5), () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CustomerHomePage(userId: userId),
            ),
          );
        });
      } catch (e) {
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
        elevation: 0,
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
                            return null;
                          },
                          onChanged: (value) {
                            _cemail = value;
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
                            return null;
                          },
                          onChanged: (value) {
                            _cpassword = value;
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
                                        CustomerRegisterForm(),
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
        ],
      ),
    );
  }
}
