import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:madadgarhath/screens/customerhomepage.dart';
import 'package:madadgarhath/screens/customerlogin.dart';

class CustomerProfileScreen extends StatefulWidget {
  final String userId;

  const CustomerProfileScreen({Key? key, required this.userId})
      : super(key: key);

  @override
  _CustomerProfileScreenState createState() => _CustomerProfileScreenState();
}

class _CustomerProfileScreenState extends State<CustomerProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  String _fullName = '';
  String _email = '';
  String _phoneNumber = '';
  String _address = '';

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
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    CustomerHomePage(customerId: widget.userId),
              ),
            );
          }
        },
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('customer')
            .where('userId', isEqualTo: widget.userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final customerData =
                snapshot.data!.docs[0].data() as Map<String, dynamic>;

            // Retrieve customer details from Firestore
            final fullName = customerData['fullName'] as String;
            final email = customerData['email'] as String;
            final phoneNumber = customerData['phoneNumber'] as String;
            final address = customerData['address'] as String;

            // Update the local variables with retrieved values
            _fullName = fullName;
            _email = email;
            _phoneNumber = phoneNumber;
            _address = address;

            return SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: CircleAvatar(
                              radius: 50.0,
                              // You can use an image here by specifying the 'backgroundImage' property
                              // backgroundImage: AssetImage('path_to_image'),
                              child: Icon(
                                Icons.person,
                                size: 50.0,
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
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
                            'Address',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextFormField(
                            initialValue: _address,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your address';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              _address = value;
                            },
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: _submitForm,
                            child: Text('Update Profile'),
                          ),
                          SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: _signOut,
                            child: Text('Sign Out'),
                          ),
                        ],
                      ),
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
      // You can access the entered values using the _phoneNumber and _address variables
      // Add your update logic here

      // Update the customer document in Firestore
      FirebaseFirestore.instance
          .collection('customer')
          .doc(widget.userId)
          .update({
        'phoneNumber': _phoneNumber,
        'address': _address,
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

  void _signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => CustomerLoginForm(),
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
