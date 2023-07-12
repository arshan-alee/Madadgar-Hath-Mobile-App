import 'package:flutter/material.dart';
import 'package:madadgarhath/screens/getstarted.dart';

import 'workerlogin.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({super.key});

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  late PageController _pageController;
  int _pageIndex = 0;

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

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
          body: SafeArea(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Expanded(
                      child: PageView.builder(
                          itemCount: onboard_data.length,
                          controller: _pageController,
                          onPageChanged: (index) {
                            setState(() {
                              _pageIndex = index;
                            });
                          },
                          itemBuilder: (context, index) => OnboardContent(
                              title: onboard_data[index].title,
                              image: onboard_data[index].image,
                              description: onboard_data[index].description)),
                    ),
                    Stack(
                      children: [
                        // Other widgets in the Stack
                        Positioned.fill(
                          child: Align(
                            alignment: Alignment.center,
                            child: Container(
                              height: 100,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ...List.generate(
                                    onboard_data.length,
                                    (index) => Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: DotIndicator(
                                        isActive: index == _pageIndex,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            _pageIndex != onboard_data.length - 1
                                ? Container(
                                    margin: EdgeInsets.all(8),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  GetStarted(),
                                            ));
                                      },
                                      child: Text(
                                        "SKIP",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge!
                                            .copyWith(
                                                color: const Color.fromARGB(
                                                    255, 1, 31, 56)),
                                      ),
                                    ),
                                  )
                                : Spacer(),
                            Spacer(),
                            Container(
                              height: 60,
                              width: 60,
                              child: ElevatedButton(
                                onPressed: () {
                                  _pageIndex == onboard_data.length - 1
                                      ? Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => GetStarted(),
                                          ))
                                      : _pageController.nextPage(
                                          duration: Duration(milliseconds: 300),
                                          curve: Curves.ease,
                                        );
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: CircleBorder(),
                                  backgroundColor:
                                      const Color.fromARGB(255, 1, 31, 56),
                                ),
                                child: Image.asset(
                                  "images/arrowwhite.png",
                                  height: double.infinity,
                                  width: double.infinity,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )),
        ),
      ),
    );
  }
}

class DotIndicator extends StatelessWidget {
  const DotIndicator({
    super.key,
    this.isActive = false,
  });
  final bool isActive;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: isActive ? 16 : 8,
      width: 6,
      decoration: BoxDecoration(
        color: isActive
            ? const Color.fromARGB(255, 1, 31, 56)
            : Color.fromARGB(255, 76, 137, 187),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }
}

class OnboardContent extends StatelessWidget {
  const OnboardContent({
    super.key,
    required this.title,
    required this.image,
    required this.description,
  });
  final String title, image, description;
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Spacer(),
      Text(title,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 26,
              fontFamily: 'Manrope-ExtraBold',
              color: const Color.fromARGB(255, 1, 31, 56))),
      SizedBox(
        height: 10,
      ),
      Image.asset(
        image,
        height: 300,
      ),
      SizedBox(
        height: 10,
      ),
      Text(description,
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(color: Color.fromARGB(255, 3, 67, 119))),
      Spacer()
    ]);
  }
}

class Onboard {
  final String title, image, description;

  Onboard(
      {required this.title, required this.image, required this.description});
}

final List<Onboard> onboard_data = [
  Onboard(
      title: "Welcome to \n MADADGAR HATH",
      image: "images/cleaner.png",
      description:
          "Find reliable professionals for all your housekeeping needs. From maids to plumbers, we've got you covered"),
  Onboard(
      title: "Easy and Convenient",
      image: "images/caretaker.png",
      description:
          "We provide a platform that simplifies the process, saving you time and effort."),
  Onboard(
      title: "Verified Professionals",
      image: "images/plumber.png",
      description:
          "Say goodbye to worries about reliability and authenticity. We pre-verify all our service providers, ensuring you get trustworthy professionals for your tasks."),
  Onboard(
      title: "Customized Services",
      image: "images/gardener.png",
      description:
          "Tailor your search based on timings, tasks, rates, and even gender preferences. We strive to provide you with the perfect professional to meet your specific needs."),
];
