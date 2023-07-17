import 'package:flutter/material.dart';

import 'checkoutpage.dart';

class HireWorkerScreen extends StatefulWidget {
  final String workerName;
  final double hourlyRate;
  final String phoneNumber;
  final String email;
  final String description;
  final String profession;
  final String customeruserId;
  final String customeruserName;
  final String workeruserId;
  const HireWorkerScreen({
    Key? key,
    required this.workerName,
    required this.hourlyRate,
    required this.phoneNumber,
    required this.email,
    required this.description,
    required this.profession,
    required this.customeruserId,
    required this.customeruserName,
    required this.workeruserId,
  }) : super(key: key);

  @override
  _HireWorkerScreenState createState() => _HireWorkerScreenState();
}

class _HireWorkerScreenState extends State<HireWorkerScreen> {
  double _totalJobHours = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(
          'Hire ${widget.profession}',
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
                              widget.workerName,
                              style: TextStyle(
                                fontSize: 20,
                                fontFamily: 'Manrope-ExtraBold',
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Hourly Rate: \$${widget.hourlyRate.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Phone: ${widget.phoneNumber}',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Email: ${widget.email}',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(height: 10),
                            SizedBox(height: 10),
                            Text(
                              widget.description,
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
                TextFormField(
                  onChanged: (value) {
                    setState(() {
                      _totalJobHours = double.tryParse(value) ?? 0.0;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Total Job Hours',
                    prefixIcon: Icon(Icons.timer),
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 20),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: ElevatedButton(
                      onPressed: () {
                        double totalAmount = widget.hourlyRate * _totalJobHours;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CheckoutScreen(
                              customeruserId: widget.customeruserId,
                              customeruserName: widget.customeruserName,
                              workeruserId: widget.workeruserId,
                              workerName: widget.workerName,
                              totalJobHours: _totalJobHours,
                              hourlyRate: widget.hourlyRate,
                              totalAmount: totalAmount,
                            ),
                          ),
                        );
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
