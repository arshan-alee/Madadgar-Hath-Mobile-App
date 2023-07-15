import 'package:flutter/material.dart';

class HireWorkerScreen extends StatelessWidget {
  final String workerName;
  final double hourlyRate;
  final String phoneNumber;
  final String email;
  final String description;
  final String profession;

  const HireWorkerScreen({
    Key? key,
    required this.workerName,
    required this.hourlyRate,
    required this.phoneNumber,
    required this.email,
    required this.description,
    required this.profession,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(
          'Hire $profession',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Card(
                    elevation: 4,
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Text(
                              workerName,
                              style: TextStyle(
                                fontSize: 30,
                                fontFamily: 'Manrope-ExtraBold',
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Hourly Rate: \$${hourlyRate.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Phone: $phoneNumber',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Email: $email',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(height: 10),
                            SizedBox(height: 10),
                            Text(
                              description,
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: ElevatedButton(
                      onPressed: () {
                        // Add your hire logic here
                        // This button is fixed at the bottom and is not affected by page scroll
                      },
                      child: Text(
                        'Hire',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
