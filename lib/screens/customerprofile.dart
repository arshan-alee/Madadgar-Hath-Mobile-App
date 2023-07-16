import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:madadgarhath/screens/customerhomepage.dart';
import 'package:madadgarhath/screens/customerlogin.dart';
import 'package:madadgarhath/screens/postjob.dart';

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
  bool _jobAvailability = false;
  String _needProfession = '';

  final List<String> _professionOptions = [
    '---',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(35.0),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          actions: [
            Container(
              margin: EdgeInsets.only(right: 20),
              child: Container(
                width: 85,
                child: ElevatedButton(
                  onPressed: _showSignOutConfirmationDialog,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      children: [
                        Icon(Icons.logout),
                        SizedBox(width: 3),
                        Text("Sign Out",
                            overflow: TextOverflow.clip, softWrap: true),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      extendBody: true,
      bottomNavigationBar: CurvedNavigationBar(
        color: const Color.fromARGB(255, 1, 31, 56),
        height: 65,
        backgroundColor: Colors.transparent,
        index: 2,
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
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PostJobScreen(userId: widget.userId),
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
            _fullName = customerData['fullName'] as String;
            _email = customerData['email'] as String;
            _phoneNumber = customerData['phoneNumber'] as String;
            _address = customerData['address'] as String;
            _jobAvailability =
                customerData['jobAvailability'] as bool? ?? false;
            _needProfession = customerData['needProfession'] as String? ?? '';

            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
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
                                          child: Icon(
                                            Icons.person,
                                            size: 50.0,
                                          ),
                                        ),
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
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextFormField(
                                    initialValue: _fullName,
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                    enabled: false,
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.person),
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
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.phone),
                                    ),
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
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.home),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Container(
                                    width: 120,
                                    child: ElevatedButton(
                                      onPressed: _submitForm,
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Row(
                                          children: [
                                            Icon(Icons.update),
                                            SizedBox(width: 3),
                                            Text(
                                              "Update Profile",
                                              textAlign: TextAlign.center,
                                              softWrap: true,
                                              overflow: TextOverflow.clip,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Container(
                                      width: 120,
                                      child: ElevatedButton(
                                        onPressed: _deleteAccount,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                        ),
                                        child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Row(
                                            children: [
                                              Icon(Icons.delete),
                                              SizedBox(width: 3),
                                              Text(
                                                "Delete Account",
                                                textAlign: TextAlign.center,
                                                softWrap: true,
                                                overflow: TextOverflow.clip,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10),
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

      // Update the customer document in Firestore
      FirebaseFirestore.instance
          .collection('customer')
          .where('userId', isEqualTo: widget.userId)
          .get()
          .then((snapshot) {
        final customerDoc = snapshot.docs.first;
        customerDoc.reference.update({
          'phoneNumber': _phoneNumber,
          'address': _address,
          'jobAvailability': _jobAvailability,
          'needProfession': _needProfession,
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

  void _deleteAccount() async {
    // Show delete confirmation dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Account Deletion'),
          content: Text('Are you sure you want to delete your account?'),
          actions: <Widget>[
            TextButton(
              child: Text('Yes'),
              onPressed: () async {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CustomerLoginForm(),
                  ),
                );
                // Delete user from Firebase Authentication
                final user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  await user.delete();
                }

                // Delete document from 'customer' collection in Firestore
                FirebaseFirestore.instance
                    .collection('customer')
                    .where('userId', isEqualTo: widget.userId)
                    .get()
                    .then((snapshot) {
                  final customerDoc = snapshot.docs.first;
                  customerDoc.reference.delete().then((_) {
                    // Show success message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Account deleted successfully'),
                      ),
                    );
                  }).catchError((error) {
                    // Show error message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error deleting account'),
                      ),
                    );
                  });
                });
                Navigator.pop(context); // Close the confirmation dialog
              },
            ),
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.pop(context); // Close the confirmation dialog
              },
            ),
          ],
        );
      },
    );
  }
}
