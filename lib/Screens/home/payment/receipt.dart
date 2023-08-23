import 'package:flutter/material.dart';
import 'package:nova_pos/widgets/mainButton.dart';
import 'package:sizer/sizer.dart';

class Receipt extends StatefulWidget {
  const Receipt({super.key});

  @override
  State<Receipt> createState() => _ReceiptState();
}

class _ReceiptState extends State<Receipt> {
  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SizedBox(
          width: w,
          child: Column(
            children: [
              SizedBox(
                height: 25,
              ),
              Container(alignment: Alignment.centerLeft, child: IconButton(onPressed: () {}, icon: Icon(Icons.close))),
              Container(
                alignment: Alignment.center,
                child: Text(
                  "TRANSACTION",
                  style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.normal),
                ),
              ),
              Text(
                "IN/1451515151515111/Qxx-Aon",
                style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.check_circle_sharp,
                  size: 50.sp,
                ),
              ),
              Text(
                "PAID",
                style: TextStyle(fontSize: 25.sp, fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total",
                    style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "PAID",
                    style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomSheet: MainButton(buttonHeight: h / 13, color: Colors.black54, onTap: () {}, text: "FINISH", width: w),
    );
  }
}
