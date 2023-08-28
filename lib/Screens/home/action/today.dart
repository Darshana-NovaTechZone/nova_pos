import 'package:flutter/material.dart';
import 'package:nova_pos/Screens/home/action/action_details.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sizer/sizer.dart';

import '../../../color/colors.dart';
import '../../../curruncy/curruncy.dart';
import '../../../db/sqldb.dart';

class Today extends StatefulWidget {
  const Today({
    super.key,
  });

  @override
  State<Today> createState() => _TodayState();
}

class _TodayState extends State<Today> {
  List<Map<String, dynamic>> actionList = [];
  List<Map<String, dynamic>> product = [];
  SqlDb sqlDb = SqlDb();
  final TextEditingController searchController = TextEditingController();
  data() async {
    List<Map<String, dynamic>> data = await sqlDb.readData("  SELECT *FROM trance_action_expense ");

    setState(() {
      if (data.isNotEmpty) {
        product = data;
        actionList = data;
      }
    });
  }

  void _runFilter(String enteredKeyword) {
    print(enteredKeyword);
    product = actionList;
    List<Map<String, dynamic>> results = [];
    if (enteredKeyword.isEmpty) {
      print('ddddddddddddddddddddd');
      // if the search field is empty or only contains white-space, we'll display all users
      results = actionList;
    } else {
      print('dddaaaaaaaaaaaaaadddddddddddddddddd');
      print(product);
      setState(() {
        results = product.where((user) {
          return user["note"].toLowerCase().contains(enteredKeyword.toLowerCase()) ||
              user["r_id"].toLowerCase().contains(enteredKeyword.toLowerCase()) ||
              user["r_id"].toLowerCase().contains(enteredKeyword.toLowerCase());
        }).toList();
      });
    }

    // Refresh the UI
    setState(() {
      product = results;
      print(product);
    });
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
                onChanged: (value) => _runFilter(value),
                controller: searchController,
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
                    hintText: "Invoice / Notes"),
              ),
            ),
          ),
        ),
      ),
      body: SizedBox(
          width: w,
          height: h,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  product.isEmpty
                      ? Center(
                          child: SizedBox(
                            height: h / 1.5,
                            child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset("assets/r.PNG"),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "no transaction",
                                      style: TextStyle(fontSize: 13.sp, color: Color(0xff7c7c7c), fontWeight: FontWeight.normal),
                                    ),
                                  ),
                                ]),
                          ),
                        )
                      : SizedBox(
                          height: h - 250,
                          child: ListView.builder(
                            itemCount: product.length,
                            itemBuilder: (context, index) {
                              print(product[index]);
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                        type: PageTransitionType.rightToLeft,
                                        duration: Duration(milliseconds: 400),
                                        child: ActionDetails(
                                          change: product[index]['change'],
                                          actionCompleteDate: product[index]['date'].toString(),
                                          cartId: product[index]['id'].toString(),
                                          ggTotal: product[index]['grand_total'].toString(),
                                          inDate: product[index]['date'],
                                          inId: product[index]['r_id'],
                                          note: product[index]['note'],
                                          pCost: product[index]['product_cost'].toString(),
                                          payment: product[index]['payment'].toString(),
                                          propit: product[index]['price'].toString(),
                                          sgTotal: product[index]['sub_total'].toString(),
                                          status: product[index]['status'].toString(),
                                        ),
                                        inheritTheme: true,
                                        ctx: context),
                                  );
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        product[index]['is_expense'] != "1"
                                            ? Icon(
                                                Icons.arrow_circle_down,
                                                size: 30,
                                                color: blue,
                                              )
                                            : Icon(
                                                Icons.arrow_circle_up_outlined,
                                                size: 30,
                                                color: red,
                                              ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                product[index]['is_expense'] == "1" ? "${product[index]['note']}" : "Transaction",
                                                style: TextStyle(fontSize: 13.sp, color: Color(0xff7c7c7c), fontWeight: FontWeight.bold),
                                              ),
                                              Text(
                                                "${product[index]['r_id']}",
                                                style: TextStyle(fontSize: 8.sp, color: Color(0xff7c7c7c), fontWeight: FontWeight.normal),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      product[index]['is_revenue'] == "1"
                                          ? "$currency ${product[index]['revenue']}"
                                          : product[index]['is_expense'] == "1"
                                              ? "$currency ${product[index]['expense']}"
                                              : "$currency ${product[index]['grand_total']}",
                                      style: TextStyle(
                                          fontSize: 13.sp,
                                          color: product[index]['is_expense'] != "1" ? Color.fromARGB(255, 94, 182, 255) : red,
                                          fontWeight: FontWeight.normal),
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                  SizedBox(
                    height: 150,
                  )
                ],
              ),
            ),
          )),
    );
  }
}
