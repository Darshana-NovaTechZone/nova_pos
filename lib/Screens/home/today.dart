import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../color/colors.dart';

class Today extends StatefulWidget {
  const Today({super.key});

  @override
  State<Today> createState() => _TodayState();
}

class _TodayState extends State<Today> {
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
          InkWell(
            onTap: () {},
            child: Container(
                height: 50,
                width: 75,
                alignment: Alignment.bottomRight,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Colors.black12),
                child: Icon(Icons.download)),
          ),
          InkWell(
            onTap: () {},
            child: Container(
                height: 50,
                width: 52,
                alignment: Alignment.bottomCenter,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Icon(Icons.tune)),
          ),
        ],
        leading: Padding(
          padding: const EdgeInsets.only(left: 12, top: 0),
          child: Container(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Today",
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
        bottom: PreferredSize(
          preferredSize: Size(w, h / 10),
          child: Padding(
            padding: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
            child: SizedBox(
              height: h / 15,
              child: TextField(
                textAlign: TextAlign.left,
                decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.search,
                      color: Color(0xff939393),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    contentPadding: EdgeInsets.all(8),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0), borderSide: BorderSide(color: Color(0xff93dc8a))),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0), borderSide: BorderSide(color: Color(0xff93dc8a))),
                    filled: true,
                    hintStyle: TextStyle(color: Color(0xffbfbfbf)),
                    fillColor: Colors.white70,
                    hintText: "Name / SKU / Barcode"),
              ),
            ),
          ),
        ),
      ),
      body: SizedBox(
          width: w,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
            Image.asset("assets/r.PNG"),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "no transaction",
                style: TextStyle(fontSize: 13.sp, color: Color(0xff7c7c7c), fontWeight: FontWeight.normal),
              ),
            ),
          ])),
    );
  }
}
