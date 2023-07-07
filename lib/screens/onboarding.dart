import 'package:flutter/material.dart';

import 'loginpage.dart';

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
      home: Scaffold(
        body: SafeArea(
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
                                padding: const EdgeInsets.only(right: 8.0),
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
                                  _pageController.animateToPage(
                                    onboard_data.length - 1,
                                    duration: Duration(milliseconds: 300),
                                    curve: Curves.ease,
                                  );
                                },
                                child: Text("SKIP"),
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
                                      builder: (context) => LoginPage(),
                                    ))
                                : _pageController.nextPage(
                                    duration: Duration(milliseconds: 300),
                                    curve: Curves.ease,
                                  );
                          },
                          style: ElevatedButton.styleFrom(
                            shape: CircleBorder(),
                            backgroundColor: Color.fromARGB(255, 82, 171, 243),
                          ),
                          child: Image.asset("images/arrow.png"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        )),
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
            : Color.fromARGB(255, 97, 178, 243),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }
}

class Onboard {
  final String title, image, description;

  Onboard(
      {required this.title, required this.image, required this.description});
}

final List<Onboard> onboard_data = [
  Onboard(
      title: "Welcome to MADADGAR HATH",
      image: "images/cleaner.png",
      description:
          " Find reliable professionals for all your housekeeping needs. From maids to plumbers, we've got you covered"),
  Onboard(
      title: "Easy and Convenient",
      image: "images/taxidriver.png",
      description:
          "With MADADGAR HATH, hiring professionals for various day-to-day activities is a breeze. We provide a platform that simplifies the process, saving you time and effort."),
  Onboard(
      title: "Verified Professionals",
      image: "images/logo2.png",
      description:
          "Say goodbye to worries about reliability and authenticity. We pre-verify all our service providers, ensuring you get trustworthy professionals for your tasks."),
  Onboard(
      title: "Customized Services",
      image: "images/logo2.png",
      description:
          "Tailor your search based on timings, tasks, rates, and even gender preferences. We strive to provide you with the perfect professional to meet your specific needs."),
];

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
      Text(
        title,
        textAlign: TextAlign.center,
        style: Theme.of(context)
            .textTheme
            .headlineSmall!
            .copyWith(fontWeight: FontWeight.w500),
      ),
      Spacer(),
      Image.asset(
        image,
        height: 250,
      ),
      Spacer(), // Image.asset

      SizedBox(
        height: 10,
      ),
      Text(
        description,
        textAlign: TextAlign.center,
      ),
      Spacer()
    ]);
  }
}
