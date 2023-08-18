import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../color/colors.dart';

class Product extends StatefulWidget {
  const Product({super.key});

  @override
  State<Product> createState() => _ProductState();
}

class _ProductState extends State<Product> {
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
          IconButton(onPressed: () {}, icon: Icon(Icons.upload_file_outlined)),
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.category,
              ))
        ],
        leading: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Container(
            alignment: Alignment.centerLeft,
            child: Text(
              "Product(0)",
              style: TextStyle(fontSize: 17.sp, color: Color(0xff1a6216), fontWeight: FontWeight.bold),
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xff9ab0ea),
        onPressed: () {},
        child: Icon(Icons.add),
      ),
      body: SizedBox(
          width: w,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
            Image.asset("assets/q.PNG"),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "You haven't added any product",
                style: TextStyle(fontSize: 13.sp, color: Color(0xff7c7c7c), fontWeight: FontWeight.normal),
              ),
            ),
          ])),
    );
  }
}
