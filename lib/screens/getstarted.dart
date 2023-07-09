import 'package:flutter/material.dart';
import 'package:madadgarhath/screens/customerlogin.dart';
import 'package:madadgarhath/screens/workerlogin.dart';
import 'package:madadgarhath/screens/workerregisteration.dart';

class GetStarted extends StatelessWidget {
  const GetStarted({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          textTheme: const TextTheme(
            bodyLarge: TextStyle(
              fontFamily: 'Manrope-Medium',
            ),
            titleMedium: TextStyle(
              fontFamily: 'Manrope-Bold',
            ),
            titleLarge: TextStyle(
              fontFamily: 'Manrope-Bold',
            ),
            headlineMedium: TextStyle(
              fontFamily: 'Manrope-Bold',
            ),
            headlineSmall: TextStyle(
              fontFamily: 'Manrope-Bold',
            ),
          ),
        ),
        home: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
              image: AssetImage("images/texture2.jpg"),
              fit: BoxFit.cover,
            )),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'images/logo2.png',
                      width: 200,
                      height: 200,
                    ),
                    SizedBox(height: 30),
                    Text(
                      'Madadgar Hath',
                      style: TextStyle(
                          fontSize: 32,
                          fontFamily: 'Manrope-ExtraBold',
                          color: const Color.fromARGB(255, 1, 31, 56)),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Aapke Kaam Main Hum Madadgar',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 22,
                          fontFamily: 'Manrope-Bold',
                          color: Color.fromARGB(255, 3, 67, 119)),
                    ),
                    SizedBox(height: 125),
                    Text(
                      'Choose your role:',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: const Color.fromARGB(255, 1, 31, 56)),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 40),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => WorkerLoginForm()),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 1, 31, 56),
                            ),
                            child: Text('Worker',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(color: Colors.white))),
                        SizedBox(width: 20),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CustomerLoginForm()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 1, 31, 56),
                          ),
                          child: Text('Customer',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(color: Colors.white)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )));
  }
}
