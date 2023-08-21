import 'package:flutter/material.dart';
import '../../db/sqldb.dart';
import '../onboarding/onboarding.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  String devise = '';
  String ip = '';
  SqlDb sqlDb = SqlDb();
  List dataList = [
    {"name": "pcs", "status": "Integer"},
    {"name": "mg", "status": "Fractional"},
    {"name": "g", "status": "Fractional"},
    {"name": "Kg", "status": "Fractional"},
    {"name": "oz", "status": "Fractional"},
    {"name": "lb", "status": "Fractional"},
    {"name": "mL", "status": "Fractional"},
    {"name": "L", "status": "Fractional"},
    {"name": "qt", "status": "Fractional"},
    {"name": "gal", "status": "Fractional"},
    {"name": "cm", "status": "Fractional"},
    {"name": "m", "status": "Fractional"},
    {"name": "in", "status": "Fractional"},
    {"name": "ft", "status": "Fractional"},
  ];

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
  addunit() async {
    List data = await sqlDb.readData("Select * from add_unit");
    if (data.isEmpty) {
      dataList.forEach((element) async {
        var res = await sqlDb.insertData('INSERT INTO add_unit ("name","status") VALUES("${element["name"]}","${element["status"]}")');
        print(res);
        print(element["status"]);
      });
    }
    Future.delayed(
      const Duration(seconds: 2),
      () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Onboarding()),
        );
      },
    );

    data = await sqlDb.readData("Select * from add_unit");
    print(data);
  }

  @override
  void initState() {
    addunit();

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
