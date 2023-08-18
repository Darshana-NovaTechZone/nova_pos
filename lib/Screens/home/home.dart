import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    var p = MediaQuery.paddingOf(context).top;
    return Scaffold(
      backgroundColor: Color(0xfff8f8f8),
      appBar: AppBar(
        backgroundColor: Color(0xfff8f8f8),
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Text(
            "Nova Pos",
            style: TextStyle(fontSize: 25.sp, fontFamily: "CabinSketch", color: Color.fromARGB(255, 110, 227, 95)),
          ),
        ),
        leadingWidth: w,
      ),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: h / 14,
                width: w / 2.2,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Color(0xfff77575),
                ),
                child: Row(children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Icon(Icons.note_add, color: Color(0xff6d1c1b)),
                  ),
                  Text(
                    "Expenses",
                    style: TextStyle(fontSize: 11.sp, color: Color(0xff6d1c1b), fontWeight: FontWeight.bold),
                  ),
                ]),
              ),
              Container(
                height: h / 14,
                width: w / 2.2,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: const Color(0xff93dc8a),
                ),
                child: Row(children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Icon(Icons.monetization_on, color: Color(0xff21651b)),
                  ),
                  Text(
                    "Revenue",
                    style: TextStyle(fontSize: 11.sp, color: Color(0xff21651b), fontWeight: FontWeight.bold),
                  ),
                ]),
              ),
            ],
          ),
        ),
        SizedBox(
          height: h / 60,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Container(
            height: h / 9,
            width: w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: const Color(0xff9ab0ea),
            ),
            child: Row(children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Icon(Icons.shopping_cart_outlined, color: Color(0xff29395b)),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "New Order",
                    style: TextStyle(fontSize: 11.sp, color: Color(0xff29395b), fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Create new transaction with products",
                    style: TextStyle(fontSize: 11.sp, color: Color(0xff405587)),
                  ),
                ],
              ),
            ]),
          ),
        ),
        SizedBox(
          height: h / 60,
        ),
        Container(
          height: h / 4,
          width: w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: const Color(0xffdde5f8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  "ACTIVE CARTS",
                  style: TextStyle(fontSize: 14.sp, color: Color(0xff29395b), fontWeight: FontWeight.bold),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.lock,
                          color: Color(0xff676b74),
                          size: 25.sp,
                        )),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      "You have no active cart",
                      style: TextStyle(fontSize: 13.sp, color: Color(0xff626a7c)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
