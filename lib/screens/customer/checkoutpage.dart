import 'package:flutter/material.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CheckoutScreen extends StatelessWidget {
  final String workerName;
  final double totalJobHours;
  final double hourlyRate;
  final double totalAmount;
  final String customeruserId;
  final String customeruserName;
  final String workeruserId;

  const CheckoutScreen({
    Key? key,
    required this.workerName,
    required this.totalJobHours,
    required this.hourlyRate,
    required this.totalAmount,
    required this.customeruserId,
    required this.customeruserName,
    required this.workeruserId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(
          'Checkout',
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Worker: $workerName',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Total Job Hours: $totalJobHours',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
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
                'Total Amount: \$${totalAmount.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Proceed to Payment?'),
                        content:
                            Text('Do you want to proceed with the payment?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context); // Close the dialog
                            },
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () async {
                              Navigator.pop(context); // Close the dialog
                              // Proceed to PayPal UI
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (BuildContext context) => UsePaypal(
                                    sandboxMode: true,
                                    clientId:
                                        "ActIrqbeknPS_Y4OFMPoW7WHTr1pxo7zS8nKYLR-E4Ifppwj73ufqSvu8wHFR_w3YXJhZh_DNifLumfE",
                                    secretKey:
                                        "ELsKI7wn1ezgzMKas7mCVx123UJB2IKVNQNtiwzw9YiXOvH6ZIr5vNte0QA_1Ojhz-3OwcCKhmGqtnTz",
                                    returnURL: "https://samplesite.com/return",
                                    cancelURL: "https://samplesite.com/cancel",
                                    transactions: [
                                      {
                                        "amount": {
                                          "total": totalAmount.toString(),
                                          "currency": "USD",
                                          "details": {
                                            "subtotal": totalAmount.toString(),
                                            "shipping": '0',
                                            "shipping_discount": 0
                                          }
                                        },
                                      }
                                    ],
                                    note:
                                        "Contact us for any questions on your order.",
                                    onSuccess: (Map params) async {
                                      print("onSuccess: $params");
                                    },
                                    onError: (error) {
                                      print("onError: $error");
                                    },
                                    onCancel: (params) {
                                      print('cancelled: $params');
                                    },
                                  ),
                                ),
                              );
                              DocumentReference documentReference =
                                  await FirebaseFirestore.instance
                                      .collection('orders')
                                      .add({
                                'customeruserid': customeruserId,
                                'customernameid': customeruserName,
                                'workeruserid': workeruserId,
                                'workerprofession': workerName,
                                'workerhourlyrate': hourlyRate,
                                'customerjobhours': totalJobHours,
                                'totalamount': totalAmount,
                              });

                              String orderId = documentReference.id;
                            },
                            child: Text('Proceed'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text(
                  'Proceed to Payment',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
