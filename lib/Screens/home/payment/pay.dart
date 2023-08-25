import 'dart:io';

import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:fdottedline_nullsafety/fdottedline__nullsafety.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nova_pos/Screens/home/payment/receipt.dart';
import 'package:nova_pos/class/model/list_item_model.dart';
import 'package:nova_pos/color/colors.dart';
import 'package:nova_pos/widgets/custom_textfield.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path_provider/path_provider.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';
import 'package:sizer/sizer.dart';
import 'package:path/path.dart';

import '../../../class/curruncy.dart';
import '../../../db/sqldb.dart';
import '../../../widgets/mainButton.dart';
import '../oders/add_transaction/add_transaction.dart';
import '../product/add_unit/add_unit.dart';
import '../product/dropdown/select_category.dart';

class Pay extends StatefulWidget {
  const Pay({super.key, required this.summery, required this.total});
  final List<ListItem> summery;
  final int total;

  @override
  State<Pay> createState() => _PayState();
}

class _PayState extends State<Pay> with SingleTickerProviderStateMixin {
  TextEditingController productName = TextEditingController();
  TextEditingController catName = TextEditingController(text: "Unclassified");
  TextEditingController sku = TextEditingController();
  TextEditingController barcode = TextEditingController();
  final salePrice = MoneyMaskedTextController(initialValue: 0);
  TextEditingController unit = TextEditingController(text: "pcs");
  final productCost = MoneyMaskedTextController(initialValue: 0);
  TabController? _tabController;
  bool setpro = false;
  bool variant = false;
  String result = "";
  SqlDb sqlDb = SqlDb();
  XFile? image;
  bool button = true;
  int _currentTabIndex = 0;
  bool tabEnd = false;
  String imgName = "";
  int duePrice = 0;
  int pay = 0;
  bool change = false;
  int index = 0;

  final ImagePicker picker = ImagePicker();

  //we can upload image from camera or from gallery based on parameter

  List catList = [];

  int value = Colors.red.value;

  getCategory() async {
    catList = await sqlDb.readData("Select * from add_cat ");
    setState(() {
      catList;
    });
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  @override
  void initState() {
    print(widget.summery);
    // getCategory();
    super.initState();
    _tabController = new TabController(
      vsync: this,
      length: 3,
      initialIndex: 0,
    );

    setState(() {
      duePrice = widget.total;
      pay = widget.total;
      duePrice = 0;
      pay = widget.total;
      change = true;
    });
    _tabController!.addListener(() {
      if (_tabController!.index == 0) {
        setState(() {
          print('ssssddsssssssssssss');
          tabEnd = false;
        });
      }
      if (_tabController!.index == 1) {
        setState(() {
          print('sssssssssssfnfndnsssss');
          tabEnd = false;
        });
      }
      if (_tabController!.index == 2) {
        setState(() {
          index = 2;
          print('ssssssssssssssss');
          tabEnd = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    TextEditingController barcode = TextEditingController(text: result);
    var p = MediaQuery.paddingOf(context).top;
    return GestureDetector(
      //onTap: () => FocusScope.of(context).unfocus(),
      /// > flutter 2.0
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
            backgroundColor: Color(0xfff8f8f8),
            appBar: AppBar(
              backgroundColor: Color(0xff93dc8a),
              actions: [IconButton(onPressed: () {}, icon: Icon(Icons.save))],
              title: Text(
                "Summary",
                style: TextStyle(fontSize: 17.sp, color: Color(0xff1a6216), fontWeight: FontWeight.normal),
              ),
              bottom: TabBar(
                  controller: _tabController,
                  unselectedLabelColor: Color(0xff1a6216),
                  indicatorSize: TabBarIndicatorSize.label,
                  indicator: BoxDecoration(borderRadius: BorderRadius.circular(5), color: white),
                  indicatorColor: Colors.transparent,
                  dividerColor: Colors.transparent,
                  indicatorPadding: EdgeInsets.only(bottom: 8),
                  padding: EdgeInsets.only(right: 3),
                  tabs: [
                    Tab(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _tabController!.index = 0;
                          });
                        },
                        child: Container(
                          child: Align(
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.pending_actions_rounded,
                                  size: 17,
                                  color: Color(0xff1a6216),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text("PRODUCT",
                                    style: TextStyle(
                                      color: Color(0xff1a6216),
                                    )),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Tab(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _tabController!.index = 1;
                          });
                        },
                        child: Container(
                          child: Align(
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.description_outlined,
                                  size: 17,
                                  color: Color(0xff1a6216),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text("DETAILS", style: TextStyle(color: Color(0xff1a6216))),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Tab(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _tabController!.index = 2;
                          });
                        },
                        child: Container(
                          child: Align(
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.payment,
                                  size: 17,
                                  color: Color(0xff1a6216),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "PAYMENT",
                                  style: TextStyle(
                                    color: Color(0xff1a6216),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ]),
            ),
            body: TabBarView(
              controller: _tabController,
              children: <Widget>[
                //  info screen area -------------------------------------------------------------------------------------------------------------------------------------------------------------------
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SingleChildScrollView(
                    keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          width: w,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Color(0xfff4e1d3)),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListView.builder(
                                shrinkWrap: true,
                                itemCount: widget.summery.length,
                                itemBuilder: (context, index) {
                                  print(widget.summery[index]);
                                  return Container(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              widget.summery[index].pName,
                                              style: TextStyle(color: Colors.brown, fontWeight: FontWeight.bold, fontSize: 15.sp),
                                            ),
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  "${widget.summery[index].qnt.toString()} pcs",
                                                  style: TextStyle(color: Colors.brown, fontWeight: FontWeight.bold, fontSize: 13.sp),
                                                ),
                                                Container(
                                                  alignment: Alignment.centerRight,
                                                  width: w / 5,
                                                  child: FittedBox(
                                                    child: Text(
                                                      "\$ ${widget.summery[index].cartP.toString()}",
                                                      style: TextStyle(color: Colors.brown, fontWeight: FontWeight.bold, fontSize: 13.sp),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "${widget.summery[index].cName.toString()} ",
                                              style: TextStyle(color: Colors.brown, fontSize: 9.sp, fontWeight: FontWeight.w600),
                                            ),
                                            Text(
                                              "• \$ ${widget.summery[index].pcs}",
                                              style: TextStyle(color: Colors.brown, fontSize: 9.sp, fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                              widget.summery.isEmpty
                                  ? Container()
                                  : FDottedLine(
                                      color: Color.fromARGB(255, 207, 175, 163),
                                      width: w,
                                      strokeWidth: 2.0,
                                      dottedLength: 10.0,
                                      space: 2.0,
                                    ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Subtotal",
                                      style: TextStyle(color: Colors.brown, fontSize: 13.sp, fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      "\$${widget.total.toString()}",
                                      style: TextStyle(color: Colors.brown, fontSize: 13.sp, fontWeight: FontWeight.w600),
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
                                      "Grandtotal",
                                      style: TextStyle(color: Colors.brown, fontSize: 15.sp, fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "\$${widget.total.toString()}",
                                      style: TextStyle(color: Colors.brown, fontSize: 15.sp, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: h / 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                InkWell(
                                  borderRadius: BorderRadius.circular(10),
                                  onTap: () {},
                                  child: Container(
                                    height: w / 5.2,
                                    width: w / 5.2,
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.black26)),
                                    child: Icon(
                                      Icons.delivery_dining,
                                      size: 25.sp,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "Delivery",
                                  style: TextStyle(color: const Color.fromARGB(255, 121, 121, 121), fontSize: 10.sp, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                InkWell(
                                  borderRadius: BorderRadius.circular(10),
                                  onTap: () {},
                                  child: Container(
                                    height: w / 5.2,
                                    width: w / 5.2,
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.black26)),
                                    child: Icon(
                                      Icons.local_offer,
                                      size: 25.sp,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "Discount",
                                  style: TextStyle(color: const Color.fromARGB(255, 121, 121, 121), fontSize: 10.sp, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                InkWell(
                                  borderRadius: BorderRadius.circular(10),
                                  onTap: () {},
                                  child: Container(
                                    height: w / 5.2,
                                    width: w / 5.2,
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.black26)),
                                    child: Icon(
                                      Icons.volunteer_activism,
                                      size: 25.sp,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "Service",
                                  style: TextStyle(color: const Color.fromARGB(255, 121, 121, 121), fontSize: 10.sp, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                InkWell(
                                  borderRadius: BorderRadius.circular(10),
                                  onTap: () {},
                                  child: Container(
                                    height: w / 5.2,
                                    width: w / 5.2,
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.black26)),
                                    child: Icon(
                                      Icons.account_balance,
                                      size: 25.sp,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "Tex",
                                  style: TextStyle(color: const Color.fromARGB(255, 121, 121, 121), fontSize: 10.sp, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),

                //  Details screen area -------------------------------------------------------------------------------------------------------------------------------------------------------------------

                SizedBox(
                  height: h,
                  width: w,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: SingleChildScrollView(
                      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Custom date and time",
                                style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.normal),
                              ),
                              Switch(
                                value: setpro,
                                onChanged: (value) {
                                  setState(() {
                                    setpro = value;
                                  });
                                },
                                activeColor: Color.fromARGB(255, 233, 149, 233),
                                inactiveThumbColor: white,
                              )
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Notes (Optional)",
                            style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.normal),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          SizedBox(
                            height: h / 15,
                            width: w,
                            child: TextField(
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.note),
                                contentPadding: EdgeInsets.only(left: 12, top: 8, bottom: 8),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0), borderSide: BorderSide(color: Color.fromARGB(255, 120, 125, 120))),
                                focusedBorder:
                                    OutlineInputBorder(borderRadius: BorderRadius.circular(20.0), borderSide: BorderSide(color: Colors.green)),
                                filled: true,
                                hintStyle: TextStyle(color: Colors.grey[800]),
                                fillColor: Colors.white70,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Checkbox(
                                value: true,
                                onChanged: (value) {},
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Include notes on the receipt",
                                  style: TextStyle(fontSize: 9.sp, fontWeight: FontWeight.normal),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            "Customer",
                            style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.normal),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          SizedBox(
                            height: h / 15,
                            width: w,
                            child: TextField(
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.person),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    Icons.arrow_forward_ios_sharp,
                                    size: 18,
                                  ),
                                  onPressed: () {},
                                ),
                                contentPadding: EdgeInsets.only(left: 12, top: 8, bottom: 8),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0), borderSide: BorderSide(color: Color.fromARGB(255, 120, 125, 120))),
                                focusedBorder:
                                    OutlineInputBorder(borderRadius: BorderRadius.circular(20.0), borderSide: BorderSide(color: Colors.green)),
                                filled: true,
                                hintStyle: TextStyle(color: Colors.grey[800]),
                                fillColor: Colors.white70,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Custom Invoice Number",
                                style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.normal),
                              ),
                              Switch(
                                value: setpro,
                                onChanged: (value) {
                                  setState(() {
                                    setpro = value;
                                  });
                                },
                                activeColor: Color.fromARGB(255, 233, 149, 233),
                                inactiveThumbColor: white,
                              )
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Queue Number",
                            style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.normal),
                          ),
                          SizedBox(
                            height: 5,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
// Payent Area ------------------------------------------------------------------------------------------------------------------------------------------------------
                SizedBox(
                  height: h - 200,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          width: w,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Color(0xfff4e1d3)),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    " Grand Total",
                                    style: TextStyle(color: Colors.brown, fontWeight: FontWeight.normal, fontSize: 13.sp),
                                  ),
                                  Container(
                                    alignment: Alignment.centerRight,
                                    width: w / 5,
                                    child: FittedBox(
                                      child: Text(
                                        "\$ ${widget.total}",
                                        style: TextStyle(color: Colors.brown, fontWeight: FontWeight.bold, fontSize: 13.sp),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    " Payment",
                                    style: TextStyle(color: Colors.brown, fontWeight: FontWeight.normal, fontSize: 13.sp),
                                  ),
                                  Container(
                                    alignment: Alignment.centerRight,
                                    width: w / 5,
                                    child: FittedBox(
                                      child: Text(
                                        "\$ ${pay.toString()}",
                                        style: TextStyle(color: Colors.brown, fontWeight: FontWeight.bold, fontSize: 13.sp),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    change ? " Change" : " Due",
                                    style: TextStyle(color: Colors.brown, fontWeight: FontWeight.normal, fontSize: 13.sp),
                                  ),
                                  Container(
                                    alignment: Alignment.centerRight,
                                    width: w / 5,
                                    child: FittedBox(
                                      child: Text(
                                        "\$ ${duePrice.toString()}",
                                        style: TextStyle(color: Colors.brown, fontWeight: FontWeight.bold, fontSize: 13.sp),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Payment Label",
                          style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.normal),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        SizedBox(
                          height: h / 15,
                          width: w,
                          child: TextField(
                            readOnly: true,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: "Cash",
                              suffixIcon: IconButton(
                                icon: Icon(
                                  Icons.keyboard_arrow_down,
                                  size: 18,
                                ),
                                onPressed: () {},
                              ),
                              contentPadding: EdgeInsets.only(left: 12, top: 8, bottom: 8),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0), borderSide: BorderSide(color: Color.fromARGB(255, 120, 125, 120))),
                              focusedBorder:
                                  OutlineInputBorder(borderRadius: BorderRadius.circular(20.0), borderSide: BorderSide(color: Colors.green)),
                              filled: true,
                              hintStyle: TextStyle(color: Colors.grey[800]),
                              fillColor: Colors.white70,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Total Paid",
                          style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.normal),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        SizedBox(
                          height: h / 15,
                          width: w,
                          child: TextField(
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.attach_money,
                                size: 18,
                              ),
                              contentPadding: EdgeInsets.only(left: 12, top: 8, bottom: 8),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0), borderSide: BorderSide(color: Color.fromARGB(255, 120, 125, 120))),
                              focusedBorder:
                                  OutlineInputBorder(borderRadius: BorderRadius.circular(20.0), borderSide: BorderSide(color: Colors.green)),
                              filled: true,
                              hintStyle: TextStyle(color: Colors.grey[800]),
                              fillColor: Colors.white70,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  duePrice = widget.total;
                                  pay = 0;
                                  change = false;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Color.fromARGB(255, 102, 214, 85)),
                                child: Text(
                                  "0%",
                                  style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  var x = 25 / 100 * widget.total;
                                  var y = 75 / 100 * widget.total;
                                  duePrice = y.toInt();
                                  pay = x.toInt();
                                  change = false;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Color.fromARGB(255, 102, 214, 85)),
                                child: Text(
                                  "25%",
                                  style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  var x = 50 / 100 * widget.total;
                                  var y = 50 / 100 * widget.total;
                                  duePrice = x.toInt();
                                  pay = y.toInt();
                                  change = false;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Color.fromARGB(255, 102, 214, 85)),
                                child: Text(
                                  "50%",
                                  style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  duePrice = 0;
                                  pay = widget.total;
                                  change = true;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 8),
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Color.fromARGB(255, 102, 214, 85)),
                                child: Text(
                                  "100%",
                                  style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            bottomSheet: Container(
              padding: EdgeInsets.all(12),
              child: MainButton(
                color: Color.fromARGB(255, 104, 234, 108),
                buttonHeight: h / 14,
                onTap: _tabController!.index == 2
                    ? () async {
                        Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.rightToLeft,
                              duration: Duration(milliseconds: 400),
                              child: Receipt(
                                  payment: pay.toString(),
                                  rest: duePrice.toString(),
                                  total: widget.total.toString(),
                                  change: change,
                                  summery: widget.summery),
                              inheritTheme: true,
                              ctx: context),
                        );
                      }
                    : () {
                        setState(() {
                          FocusManager.instance.primaryFocus?.unfocus();
                        });
                        _tabController!.index += 1;

                        if (_tabController!.index == 2) {
                          setState(() {
                            tabEnd = true;
                          });
                        }
                      },
                text: "PAY FULL",
                width: w,
              ),
            )),
      ),
    );
  }

  load(BuildContext context) {
    Navigator.pop(context);
  }

  selectedCat(String id) {
    print(id);
    setState(() {
      FocusManager.instance.primaryFocus?.unfocus();
      catName.text = id;
    });
  }

  selectedUnit(String id) {
    print(id);
    setState(() {
      FocusManager.instance.primaryFocus?.unfocus();
      unit.text = id;
    });
  }

  Future getImage(ImageSource media) async {
    var img = await picker.pickImage(source: media);

    setState(() {
      image = img;
    });
    saveImagePermanently(img!.path);
  }

  Future<File?> saveImagePermanently(String? imagePath) async {
    // final directory = await getApplicationSupportDirectory();
    // print(directory.path);
    print("dndhbchdbhcbdhbc");
    final directory = "/storage/emulated/0/Android/data/com.example.nova_pos/files/img";
// /storage/emulated/0/Android/data/com.example.nova_pos/files/imgf/img/IMG_20230821_101421.jpg

    imgName = basename(imagePath!);
    setState(() {
      imgName;
      print(imgName);
    });
    print(imgName);

    final image = File('${directory}/$imgName');
    return File(imagePath).copy(image.path);
  }

  bottomDialog(BuildContext context) {
    return showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(1.0),
        ),
        context: context,
        builder: (context) {
          var h = MediaQuery.of(context).size.height;
          var w = MediaQuery.of(context).size.width;
          return Container(
            padding: EdgeInsets.all(8),
            width: w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Select An Image",
                  style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w400),
                ),
                SizedBox(
                  height: h / 30,
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    getImage(ImageSource.camera);
                  },
                  child: Container(
                    height: h / 12,
                    child: Row(
                      children: [
                        Icon(
                          Icons.camera_alt,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          "Use Camera ",
                          style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    getImage(ImageSource.gallery);
                  },
                  child: Container(
                    height: h / 12,
                    child: Row(
                      children: [
                        Icon(
                          Icons.photo_library_outlined,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          "Pick From Gallery ",
                          style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: h / 30,
                ),
              ],
            ),
          );
        });
  }
}
