import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../color/colors.dart';
import '../../widgets/drawer_row.dart';

class Summery extends StatefulWidget {
  const Summery({super.key});

  @override
  State<Summery> createState() => _SummeryState();
}

class _SummeryState extends State<Summery> {
  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    var p = MediaQuery.paddingOf(context).top;
    return Scaffold(
      backgroundColor: Color(0xfff8f8f8),
      appBar: AppBar(
        backgroundColor: Color(0xff93dc8a),
        actions: [
          IconButton(
            icon: Icon(
              Icons.tune,
            ),
            onPressed: () {},
          ),
        ],
        leading: Padding(
          padding: const EdgeInsets.only(
            left: 12,
            top: 0,
          ),
          child: Container(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Sumery",
                  style: TextStyle(fontSize: 17.sp, color: Color(0xff1a6216), fontWeight: FontWeight.bold),
                ),
                Text(
                  "Transaction & Expense",
                  style: TextStyle(fontSize: 9.sp, color: Color(0xff1a6216), fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
        leadingWidth: w,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: white, border: Border.all(color: Color.fromARGB(96, 175, 169, 169)), borderRadius: BorderRadius.circular(15)),
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SummeryRow(text: "transaction", onTap: () {}, color: Color(0xff757575), text2: "0"),
                        Divider(
                          color: Color.fromARGB(255, 243, 237, 237),
                        ),
                        SummeryRow(text: "Unsettled", onTap: () {}, color: Color(0xff757575), text2: "0.00"),
                        Divider(
                          color: Color.fromARGB(255, 243, 237, 237),
                        ),
                        SummeryRow(text: "Revenue", onTap: () {}, color: Color(0xff4bb0bb), text2: "0.00"),
                        Divider(
                          color: Color.fromARGB(255, 243, 237, 237),
                        ),
                        SummeryRow(text: "Expense", onTap: () {}, color: Color(0xffed7774), text2: "0.00"),
                        Divider(
                          color: Color.fromARGB(255, 243, 237, 237),
                        ),
                        SummeryRow(text: "Profit", onTap: () {}, color: Color(0xff4bb0bb), text2: "0.00")
                      ])),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.calendar_today,
                          color: Color(0xff757575),
                          size: 19.sp,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          "TOP PRODUCTS",
                          style: TextStyle(fontSize: 15.sp, color: Color(0xff757575), fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.double_arrow_rounded,
                        color: Color(0xff757575),
                        size: 19,
                      ),
                    )
                  ],
                ),
              ),
              Container(
                height: h / 6,
                width: w,
                alignment: Alignment.center,
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: white, border: Border.all(color: Color.fromARGB(95, 198, 194, 194)), borderRadius: BorderRadius.circular(15)),
                child: Text(
                  "No Data",
                  style: TextStyle(fontSize: 13.sp, color: Color(0xff757575), fontWeight: FontWeight.normal),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.category,
                          color: Color(0xff757575),
                          size: 19.sp,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          "TOP CATEGORIES",
                          style: TextStyle(fontSize: 15.sp, color: Color(0xff757575), fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.double_arrow_rounded,
                        color: Color(0xff757575),
                        size: 19,
                      ),
                    )
                  ],
                ),
              ),
              Container(
                height: h / 6,
                width: w,
                alignment: Alignment.center,
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: white, border: Border.all(color: Color.fromARGB(95, 198, 194, 194)), borderRadius: BorderRadius.circular(15)),
                child: Text(
                  "No Data",
                  style: TextStyle(fontSize: 13.sp, color: Color(0xff757575), fontWeight: FontWeight.normal),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
