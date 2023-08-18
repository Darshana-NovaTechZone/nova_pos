import 'package:flutter/material.dart';
import 'package:nova_pos/Screens/onboarding/onboarding.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  String devise = '';
  String ip = '';

  // userStatus() async {
  //   List userStatus = await sqlDb.readData("Select * from user_status");

  //   if (userStatus.isEmpty) {

  //     Future.delayed(
  //       const Duration(seconds: 2),
  //       () {
  //         Future.delayed(
  //           const Duration(seconds: 2),
  //           () {
  //             Navigator.push(
  //               context,
  //               MaterialPageRoute(builder: (context) => Welcome()),
  //             );
  //           },
  //         );
  //       },
  //     );
  //   } else {

  //     Future.delayed(
  //       const Duration(seconds: 2),
  //       () {
  //         Navigator.push(
  //           context,
  //           MaterialPageRoute(builder: (context) => Home()),
  //         );
  //       },
  //     );
  //   }
  // }

  @override
  void initState() {
    Future.delayed(
      const Duration(seconds: 2),
      () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Onboarding()),
        );
      },
    );
    //   }
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color(0xffe1f6f4),
      body: SizedBox(
          width: w,
          height: h,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  height: h / 4,
                  child: Center(
                    child: Image.asset(
                      'assets/Capture.PNG',
                    ),
                  )),
            ],
          )),
    );
  }
}
