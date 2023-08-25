import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nova_pos/class/model/list_item_model.dart';
import 'package:nova_pos/widgets/mainButton.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sizer/sizer.dart';

import '../../../widgets/receipt_button.dart';
import '../oders/add_transaction/add_transaction.dart';
import 'print/print.dart';

class Receipt extends StatefulWidget {
  const Receipt({super.key, required this.payment, required this.rest, required this.total, required this.change, required this.summery});
  final String total;
  final String payment;
  final String rest;
  final bool change;
  final List<ListItem> summery;

  @override
  State<Receipt> createState() => _ReceiptState();
}

class _ReceiptState extends State<Receipt> {
  DateTime selectedDate = DateTime.now();
  String formattedDate = "";
  data() {
    formattedDate = DateFormat('yyyyMMddHHmss').format(selectedDate);
    setState(() {
      formattedDate;
    });
    print(formattedDate);
  }

  back() {
    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.pop(context);
  }

  @override
  void initState() {
    data();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () {
        return back();
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SizedBox(
            width: w,
            child: Column(
              children: [
                SizedBox(
                  height: 25,
                ),
                Container(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                        onPressed: () {
                          back();
                        },
                        icon: Icon(Icons.close))),
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    "TRANSACTION",
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.normal,
                      color: Colors.black54,
                    ),
                  ),
                ),
                Text(
                  "Nova-Pos/$formattedDate-lk",
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    widget.change ? Icons.check_circle_sharp : Icons.query_builder,
                    size: 50.sp,
                    color: Colors.black54,
                  ),
                ),
                Text(
                  widget.change ? "PAID" : "UNSETTLED",
                  style: TextStyle(
                    fontSize: 25.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total",
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.normal,
                          color: Colors.black54,
                        ),
                      ),
                      Text(
                        "\$${widget.total}",
                        style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.normal, color: Color.fromARGB(255, 125, 185, 234)),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Payment",
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.normal,
                          color: Colors.black54,
                        ),
                      ),
                      Text(
                        "\$${widget.payment}",
                        style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.normal, color: Color.fromARGB(255, 125, 185, 234)),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.change ? "Change" : "Due",
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.normal,
                          color: Colors.black54,
                        ),
                      ),
                      Text(
                        "\$${widget.rest}",
                        style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.normal, color: Color.fromARGB(255, 125, 185, 234)),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        bottomSheet: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ReceiptButton(
                  buttonHeight: h / 13,
                  color: Color.fromARGB(255, 104, 234, 108),
                  onTap: () {
                    Navigator.push(
                      context,
                      PageTransition(
                          type: PageTransitionType.rightToLeft,
                          duration: Duration(milliseconds: 400),
                          child: Print(
                            rId: formattedDate,
                            change: widget.change,
                            summery: widget.summery,
                            payment: widget.payment,
                            rest: widget.rest,
                            total: widget.total.toString(),
                          ),
                          inheritTheme: true,
                          ctx: context),
                    );
                  },
                  text: "RECEIPT",
                  width: w),
              SizedBox(
                height: 10,
              ),
              MainButton(
                  buttonHeight: h / 13,
                  color: Color.fromARGB(255, 104, 234, 108),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  text: "FINISH",
                  width: w),
            ],
          ),
        ),
      ),
    );
  }
}
