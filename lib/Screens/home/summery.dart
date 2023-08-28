import 'package:flutter/material.dart';
import 'package:nova_pos/curruncy/curruncy.dart';
import 'package:sizer/sizer.dart';

import '../../color/colors.dart';
import '../../db/sqldb.dart';
import '../../widgets/drawer_row.dart';

class Summery extends StatefulWidget {
  const Summery({super.key});

  @override
  State<Summery> createState() => _SummeryState();
}

class _SummeryState extends State<Summery> {
  SqlDb sqlDb = SqlDb();
  List<Map<String, dynamic>> actionList = [];
  List<Map<String, dynamic>> product = [];
  final TextEditingController searchController = TextEditingController();
  int total = 0;
  int unSettle = 0;
  int revenueTotal = 0;
  int finalTotal = 0;
  int expenseTotal = 0;
  int cost = 0;
  int profit = 0;
  List topProduct = [];
  data() async {
    List<Map<String, dynamic>> data = await sqlDb.readData("  SELECT *FROM trance_action_expense ");
    topProduct = await sqlDb.readData("  SELECT *FROM active_cart  group by cart_name");

    print(topProduct);

    List.generate(data.length, (index) {
      int x = int.parse(data[index]['sub_total']);

      x += total;
      total = x;
      int u = int.parse(data[index]['change']);

      u += unSettle;
      unSettle = u;
      int r = int.parse(data[index]['revenue']);

      r += revenueTotal;
      revenueTotal = r;
      int e = int.parse(data[index]['expense']);

      e += expenseTotal;
      expenseTotal = e;
      int c = data[index]['cost'];

      c += cost;
      cost = c;
    });
    profit = (revenueTotal + total) - expenseTotal - cost - unSettle;
    finalTotal = revenueTotal + total;

    setState(() {
      expenseTotal;
      finalTotal;

      revenueTotal;

      unSettle;

      product = data;

      actionList = data;
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
                  "Summery",
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
                        SummeryRow(text: "transaction", onTap: () {}, color: Color(0xff757575), text2: "${actionList.length.toString()}"),
                        Divider(
                          color: Color.fromARGB(255, 243, 237, 237),
                        ),
                        SummeryRow(text: "Unsettled", onTap: () {}, color: Color(0xff757575), text2: unSettle.toString()),
                        Divider(
                          color: Color.fromARGB(255, 243, 237, 237),
                        ),
                        SummeryRow(text: "Revenue", onTap: () {}, color: Color(0xff4bb0bb), text2: finalTotal.toString()),
                        Divider(
                          color: Color.fromARGB(255, 243, 237, 237),
                        ),
                        SummeryRow(text: "Expense", onTap: () {}, color: Color(0xffed7774), text2: expenseTotal.toString()),
                        Divider(
                          color: Color.fromARGB(255, 243, 237, 237),
                        ),
                        SummeryRow(text: "Profit", onTap: () {}, color: Color(0xff4bb0bb), text2: profit.toString())
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
                          Icons.inventory,
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
                width: w,
                alignment: Alignment.center,
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: white, border: Border.all(color: Color.fromARGB(95, 198, 194, 194)), borderRadius: BorderRadius.circular(15)),
                child: Column(
                  children: [
                    topProduct.isEmpty
                        ? Text(
                            "No Data",
                            style: TextStyle(fontSize: 13.sp, color: Color(0xff757575), fontWeight: FontWeight.normal),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount: topProduct.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            topProduct[index]['cart_name'],
                                            style: TextStyle(fontSize: 13.sp, color: Color(0xff757575), fontWeight: FontWeight.normal),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                                            decoration:
                                                BoxDecoration(color: Color.fromARGB(95, 198, 194, 194), borderRadius: BorderRadius.circular(5)),
                                            child: Text(
                                              topProduct[index]['c_name'],
                                              style: TextStyle(fontSize: 8.sp, color: Color.fromARGB(255, 70, 70, 70), fontWeight: FontWeight.normal),
                                            ),
                                          )
                                        ],
                                      ),
                                      Text(
                                        "$currency  ${topProduct[index]['item_price']}",
                                        style: TextStyle(fontSize: 8.sp, color: Color.fromARGB(255, 59, 199, 217), fontWeight: FontWeight.normal),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          )
                  ],
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
