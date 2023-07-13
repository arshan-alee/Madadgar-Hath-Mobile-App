import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:madadgarhath/screens/customerhomepage.dart';
import 'package:madadgarhath/screens/customerlogin.dart';

class CustomerRegisterForm extends StatefulWidget {
  const CustomerRegisterForm({Key? key}) : super(key: key);

  @override
  _CustomerRegisterFormState createState() => _CustomerRegisterFormState();
}

class _CustomerRegisterFormState extends State<CustomerRegisterForm> {
  final _formKey = GlobalKey<FormState>();

  String _cfullName = '';
  String _cemail = '';
  String _cpassword = '';
  String _cphoneNumber = '';
  String _caddress = '';
  int _ccnic = 0;

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Form is valid, perform registration logic here

      // Access the Firebase Authentication instance
      final auth = FirebaseAuth.instance;
      final firestore = FirebaseFirestore.instance;

      try {
        // Create the user with email and password
        final userCredential = await auth.createUserWithEmailAndPassword(
          email: _cemail,
          password: _cpassword,
        );

        // Retrieve the user ID
        final userId = userCredential.user!.uid;

        // Create a document reference for the customer registration data
        final docRef = await firestore.collection('customer').add({
          'userId': userId,
          'fullName': _cfullName,
          'email': _cemail,
          'password': _cpassword,
          'phoneNumber': _cphoneNumber,
          'address': _caddress,
          'cnic': _ccnic,
        });

        // Retrieve the newly created document ID
        final documentId = docRef.id;

        // Display a success message
        _showRegistrationSuccessSnackBar();

        // Delay navigation to the homepage
        Future.delayed(Duration(seconds: 5), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => CustomerHomePage(userId: userId),
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
                            'Customer Registration',
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
                              _cfullName = value;
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
                              // Add password validation logic here if needed
                              return null;
                            },
                            onChanged: (value) {
                              _cpassword = value;
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
                              _ccnic = int.parse(value);
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
                              _cphoneNumber = value;
                            },
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Address',
                              prefixIcon: Icon(Icons.location_on),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your address';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              _caddress = value;
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
                                      builder: (context) => CustomerLoginForm(),
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
