import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_onboard/flutter_onboard.dart';
import 'package:intro_screen_onboarding_flutter/introduction.dart';
import 'package:intro_screen_onboarding_flutter/introscreenonboarding.dart';
import 'package:nova_pos/Screens/Splash/splash.dart';
import 'package:nova_pos/Screens/get_details/get_deatails.dart';
import 'package:nova_pos/color/colors.dart';
import 'package:sizer/sizer.dart';

import '../../widgets/mainButton.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  final PageController _pageController = PageController();
  int x = 0;
  bool tap = false;
  Timer? timer;
  int y = 0;
  @override
  void initState() {
    // TODO: implement initState

    _pageController.addListener(() {
      var n = _pageController.page!.toStringAsFixed(0);
      if (n == "0") {
        setState(() {
          x = 0;
          print(_pageController.page!.toStringAsFixed(0));
          print(x);
        });
      }
      if (n == "1") {
        setState(() {
          x = 1;
        });
      } else if (n == "2") {
        setState(() {
          x = 2;
        });
      }
    });
    super.initState();
  }

  onInit() {
    y = y + 1;
    if (y == 1) {
      print(y);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('To exit app, press back one more time.'),
      ));
      timer = Timer.periodic(const Duration(seconds: 5), (Timer t) {
        print('TImer active');
        y = 0;
        timer!.cancel();
      });
    } else if (y >= 2) {
      exit(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    var p = MediaQuery.paddingOf(context).top;
    return WillPopScope(
      onWillPop: () {
        return onInit();
      },
      child: Scaffold(
        backgroundColor: x == 0
            ? Color(0xffe1fadd)
            : x == 1
                ? Color(0xffdde5f8)
                : Color(0xfff4e1d3),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: p + 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Text(
                "Nova Pos",
                style: TextStyle(
                    fontSize: 25.sp,
                    fontFamily: "CabinSketch",
                    color: x == 0
                        ? Color(0xff93dc8a)
                        : x == 1
                            ? Color(0xff9ab0ea)
                            : Color(0xffde9d73)),
              ),
            ),
            Expanded(
              child: OnBoard(
                pageController: _pageController,
                imageHeight: h / 4,
                imageWidth: w / 1.3,
                // Either Provide onSkip Callback or skipButton Widget to handle skip state
                onSkip: () {
                  // print('skipped');
                },
                // Either Provide onDone Callback or nextButton Widget to handle done state
                onDone: () {
                  print('done tapped');
                },

                onBoardData: onBoardData,
                titleStyles: TextStyle(
                  color: x == 0
                      ? Color(0xff4b7a47)
                      : x == 1
                          ? Color(0xff333e57)
                          : Color(0xff795c48),
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.15,
                ),
                descriptionStyles: TextStyle(
                  fontSize: 16,
                  color: x == 0
                      ? Color(0xff749e74)
                      : x == 1
                          ? Color(0xff687086)
                          : Color(0xff907d6f),
                ),
                pageIndicatorStyle: PageIndicatorStyle(
                  width: 100,
                  inactiveColor: const Color.fromARGB(255, 166, 162, 161),
                  activeColor: x == 0
                      ? Color(0xff93dc8a)
                      : x == 1
                          ? Color(0xff9ab0ea)
                          : Color(0xffde9d73),
                  inactiveSize: Size(8, 8),
                  activeSize: Size(12, 12),
                ),
                // Either Provide onSkip Callback or skipButton Widget to handle skip state
                skipButton: Container(),

                // Either Provide onDone Callback or nextButton Widget to handle done state
                nextButton: OnBoardConsumer(
                  builder: (context, ref, child) {
                    final state = ref.watch(onBoardStateProvider);
                    return InkWell(
                      splashColor: Colors.transparent,
                      overlayColor: MaterialStatePropertyAll(Colors.transparent),
                      borderRadius: BorderRadius.circular(30),
                      onTap: () {
                        print(state);
                        print(_pageController.page);
                        _onNextTap(state);
                      },
                      onTapDown: (_) {
                        setState(() {
                          tap = true;
                        });
                      },
                      onSecondaryTapDown: (_) {
                        setState(() {
                          tap = true;
                        });
                      },
                      onSecondaryTapUp: (_) {
                        setState(() {
                          tap = false;
                        });
                      },
                      onTapUp: (_) {
                        setState(() {
                          tap = false;
                        });
                      },
                      onTapCancel: () {
                        setState(() {
                          tap = false;
                        });
                      },
                      child: AnimatedScale(
                        scale: tap ? 0.8 : 1,
                        duration: Duration(milliseconds: 500),
                        child: Container(
                          width: w / 1.5,
                          height: h / 15,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: x == 0
                                  ? Color(0xff93dc8a)
                                  : x == 1
                                      ? Color(0xff9ab0ea)
                                      : Color(0xffde9d73)),
                          child: Text(
                            state.isLastPage ? "GET STARTED" : "Next",
                            style: TextStyle(color: Color.fromARGB(255, 80, 67, 67), fontWeight: FontWeight.bold, fontSize: 14.sp),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(
              height: h / 8,
            )
          ],
        ),
      ),
    );
  }

  void _onNextTap(OnBoardState onBoardState) {
    print(onBoardState.page);
    if (!onBoardState.isLastPage) {
      _pageController.animateToPage(
        onBoardState.page + 1,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutSine,
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => GetDetails()),
      );
      //print("nextButton pressed");
    }
  }

  final List<OnBoardModel> onBoardData = [
    const OnBoardModel(
      title: "Quick Checkout",
      description: "Have a lot of products to sell?Utilize the barcode scanner and reduce your checkout time drastically!",
      imgUrl: "assets/1.PNG",
    ),
    const OnBoardModel(
      title: "Easy Sharing",
      description: "Multiple convenient ways for you to share the transaction receipt with your customers",
      imgUrl: "assets/3.PNG",
    ),
    const OnBoardModel(
      title: "Track Your Profit",
      description: "Revenue and expense record help you to make your pivotal business decision better.",
      imgUrl: "assets/2.PNG",
    ),
  ];
}
