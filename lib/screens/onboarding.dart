import 'package:flutter/material.dart';

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
              Row(
                children: [
                  ...List.generate(
                      onboard_data.length,
                      (index) => Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: DotIndicator(
                              isActive: index == _pageIndex,
                            ),
                          )),
                  Spacer(),
                  Container(
                    margin: EdgeInsets.all(8),
                    height: 60,
                    width: 60,
                    child: ElevatedButton(
                      onPressed: () {
                        _pageController.nextPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.ease);
                      },
                      style: ElevatedButton.styleFrom(
                          shape: CircleBorder(),
                          backgroundColor:
                              const Color.fromARGB(255, 1, 31, 56)),
                      child: Image.asset("images/logo2.png"),
                    ),
                  ),
                ],
              )
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
            : const Color.fromARGB(255, 1, 31, 56).withOpacity(0.4),
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
      title: "Page 1",
      image: "images/logo2.png",
      description:
          'Reprehenderit officia aute commodo ex fugiat nulla quis consequat laboris eiusmod exercitation enim culpa. Sit Lorem cillum Lorem.'),
  Onboard(
      title: "Page 2",
      image: "images/logo2.png",
      description:
          'Reprehenderit officia aute commodo ex fugiat nulla quis consequat laboris eiusmod exercitation enim culpa. Sit Lorem cillum Lorem.'),
  Onboard(
      title: "Page 3",
      image: "images/logo2.png",
      description:
          'Reprehenderit officia aute commodo ex fugiat nulla quis consequat laboris eiusmod exercitation enim culpa. Sit Lorem cillum Lorem.'),
  Onboard(
      title: "Page 4",
      image: "images/logo2.png",
      description:
          'Reprehenderit officia aute commodo ex fugiat nulla quis consequat laboris eiusmod exercitation enim culpa. Sit Lorem cillum Lorem.'),
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
      Image.asset(
        image,
        height: 250,
      ),
      Spacer(), // Image.asset
      Text(
        title,
        textAlign: TextAlign.center,
        style: Theme.of(context)
            .textTheme
            .headlineSmall!
            .copyWith(fontWeight: FontWeight.w500),
      ),
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
