import 'package:circular_reveal_animation/circular_reveal_animation.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:nova_pos/Screens/Splash/splash.dart';
import 'package:nova_pos/Screens/Splash/testing.dart';
import 'package:nova_pos/Screens/get_details/get_deatails.dart';
import 'package:nova_pos/Screens/home/product/product.dart';
import 'package:nova_pos/Screens/home/summery.dart';
import 'package:nova_pos/Screens/home/today.dart';
import 'package:nova_pos/color/colors.dart';
import 'package:nova_pos/widgets/mainButton.dart';
import 'package:sizer/sizer.dart';

import '../../widgets/home_button.dart';
import 'home.dart';
import 'menu.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;

  late AnimationController animationController;
  late Animation<double> animation;
  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.w600, color: black);
  static const List<Widget> _widgetOptions = <Widget>[
    Home(),
    Product(),
    Today(),
    Summery(),
    Menu(),
  ];
  bool button2 = true;
  bool button3 = false;
  bool button4 = false;
  bool button5 = false;
  bool page = false;
  int x = 0;
  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );
    animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeIn,
    );
    if (animationController.status == AnimationStatus.forward || animationController.status == AnimationStatus.completed) {
      animationController.reverse();
    } else {
      animationController.forward();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    var p = MediaQuery.paddingOf(context).top;
    return Stack(
      children: [
        Scaffold(
            backgroundColor: Color(0xfff8f8f8),
            body: Stack(
              children: [
                _widgetOptions.elementAt(_selectedIndex),
                page
                    ? Container()
                    : Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          height: h / 12,
                          decoration: BoxDecoration(
                            color: white,
                          ),
                          child: GNav(
                            backgroundColor: white,
                            gap: 8,
                            activeColor: const Color.fromARGB(255, 62, 61, 61),
                            iconSize: 24,
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                            duration: Duration(milliseconds: 400),
                            tabBackgroundColor: Color.fromARGB(255, 81, 188, 85),
                            color: white,
                            textStyle: TextStyle(color: white),
                            tabBorderRadius: 15,
                            tabs: [
                              GButton(
                                iconColor: textBlack,
                                icon: Icons.adf_scanner_outlined,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              GButton(
                                iconColor: textBlack,
                                icon: Icons.eleven_mp_outlined,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              GButton(
                                iconColor: textBlack,
                                icon: Icons.event_note_outlined,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              GButton(
                                iconColor: textBlack,
                                icon: Icons.piano_sharp,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              GButton(
                                iconColor: textBlack,
                                icon: Icons.menu,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ],
                            selectedIndex: _selectedIndex,
                            onTabChange: (index) {
                              setState(() {
                                _selectedIndex = index;
                              });
                            },
                          ),
                        ),
                      ),

                //   Alignment(-0.85, 0.9),Alignment(-0.4, 0.9),Alignment(0, 0.9),Alignment(0.45, 0.9), Alignment(0.85, 0.9),
                page
                    ? Container()
                    : CircularRevealAnimation(
                        centerAlignment: x == 0
                            ? Alignment(-0.4, 0.9)
                            : x == 1
                                ? Alignment(0, 0.9)
                                : x == 2
                                    ? Alignment(0.45, 0.9)
                                    : Alignment(0.85, 0.9),
                        animation: animation,
                        child: GestureDetector(
                          onTap: () {},
                          child: Container(
                            width: w,
                            height: h,
                            color: Colors.black.withOpacity(0.6),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 25),
                              child: Column(mainAxisAlignment: MainAxisAlignment.end, crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Text(
                                  "Tips",
                                  style: TextStyle(fontSize: 17.sp, color: white, fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: h / 65,
                                ),
                                Text(
                                  x == 0
                                      ? "Add, edit, delete your products on the\nProduct page."
                                      : x == 1
                                          ? "See all of your transactions and expenses\non the History page."
                                          : x == 2
                                              ? "Gain insight from your transactions on the\nAnalytics page."
                                              : "More features, such as discounts and\ncustomers,are available hear",
                                  style: TextStyle(fontSize: 11.sp, color: white, fontWeight: FontWeight.normal),
                                ),
                                SizedBox(
                                  height: h / 85,
                                ),
                                InkWell(
                                  onTap: () {
                                    if (animationController.status == AnimationStatus.forward ||
                                        animationController.status == AnimationStatus.completed) {
                                      animationController.reverse().then((value) => animationController.forward());

                                      print('fffffffffffffffffffff');
                                    } else {
                                      print('fffffffffddfdfdfffffffffffff');
                                      animationController.forward().then((value) => animationController.reverse());
                                    }

                                    x = x + 1;
                                    print(x);

                                    if (x == 1) {
                                      setState(() {
                                        button2 = false;
                                        button3 = true;
                                      });
                                    }
                                    if (x == 2) {
                                      setState(() {
                                        button2 = false;
                                        button3 = false;
                                        button4 = true;
                                      });
                                    }
                                    if (x == 3) {
                                      setState(() {
                                        button2 = false;
                                        button3 = false;
                                        button4 = false;
                                        button5 = true;
                                      });
                                    }
                                    if (x == 4) {
                                      setState(() {
                                        page = true;
                                      });
                                    }
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      "UNDERSTAND",
                                      style: TextStyle(fontSize: 13.sp, color: black, fontWeight: FontWeight.bold),
                                    ),
                                    height: h / 15,
                                    width: w / 2.3,
                                    decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(15)),
                                  ),
                                ),
                                SizedBox(
                                  height: h / 7,
                                )
                              ]),
                            ),
                          ),
                        ),
                      ),
                page
                    ? Container()
                    : Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              HomeButton(
                                button: false,
                                icon: Icons.eleven_mp_outlined,
                              ),
                              HomeButton(
                                button: button2,
                                icon: Icons.event_note_outlined,
                                //     ));
                              ),
                              HomeButton(
                                button: button3,
                                icon: Icons.event_note_outlined,
                              ),
                              HomeButton(
                                button: button4,
                                icon: Icons.piano_sharp,
                              ),
                              HomeButton(
                                button: button5,
                                icon: Icons.menu,
                              ),
                            ],
                          ),
                        ),
                      )
              ],
            ),
            bottomNavigationBar: page
                ? Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    height: h / 12,
                    decoration: BoxDecoration(
                      color: white,
                    ),
                    child: GNav(
                      backgroundColor: white,
                      gap: 8,
                      activeColor: const Color.fromARGB(255, 62, 61, 61),
                      iconSize: 24,
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      duration: Duration(milliseconds: 400),
                      tabBackgroundColor: Color.fromARGB(255, 81, 188, 85),
                      color: white,
                      textStyle: TextStyle(color: white),
                      tabBorderRadius: 15,
                      tabs: [
                        GButton(
                          iconColor: textBlack,
                          icon: Icons.adf_scanner_outlined,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        GButton(
                          iconColor: textBlack,
                          icon: Icons.eleven_mp_outlined,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        GButton(
                          iconColor: textBlack,
                          icon: Icons.event_note_outlined,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        GButton(
                          iconColor: textBlack,
                          icon: Icons.piano_sharp,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        GButton(
                          iconColor: textBlack,
                          icon: Icons.menu,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ],
                      selectedIndex: _selectedIndex,
                      onTabChange: (index) {
                        setState(() {
                          _selectedIndex = index;
                        });
                      },
                    ),
                  )
                : null),
      ],
    );
  }
}
