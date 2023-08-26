import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:nova_pos/Screens/home/add_expense/add_expense.dart';
import 'package:nova_pos/Screens/home/oders/add_transaction/add_transaction.dart';
import 'package:nova_pos/class/model/list_item_model.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sizer/sizer.dart';

import '../../../db/sqldb.dart';
import '../add_expense/add_revenue/add_revenue.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  SqlDb sqlDb = SqlDb();
  List<dynamic> cartList = [];
  List<ListItem> cart = [];
  List<ListItem> temp = [];
  List<ListItem> addcartList = [];

  cartData() async {
    var data = await sqlDb.readData("Select * from all_cart");
    var dataa = await sqlDb.readData("Select * from active_cart");

    setState(() {
      cartList = data;

      Logger().d(dataa);
    });
  }

  @override
  void initState() {
    cartData();
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
      body: Stack(
        children: [
          Column(children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.rightToLeft,
                            duration: Duration(milliseconds: 400),
                            child: AddExpense(),
                            inheritTheme: true,
                            ctx: context),
                      );
                    },
                    child: Container(
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
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.rightToLeft,
                            duration: Duration(milliseconds: 400),
                            child: AddRevenue(),
                            inheritTheme: true,
                            ctx: context),
                      );
                    },
                    child: Container(
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
                  ),
                ],
              ),
            ),
            SizedBox(
              height: h / 60,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    PageTransition(
                        type: PageTransitionType.rightToLeft,
                        duration: Duration(milliseconds: 400),
                        child: AddTransaction(
                          loadCart: cartData,
                          myList: [],
                          priceFromeHome: '0',
                        ),
                        inheritTheme: true,
                        ctx: context),
                  );
                },
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
                    children: [
                      cartList.isEmpty
                          ? Column(
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
                                )
                              ],
                            )
                          : SizedBox(
                              height: h / 6,
                              child: ListView.builder(
                                itemCount: cartList.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: InkWell(
                                      onTap: () async {
                                        setState(() {
                                          addcartList = [];
                                        });
                                        localCart(cartList[index]['id'].toString(), cartList[index]['price'].toString());
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(8.0),
                                        height: h / 6,
                                        width: w / 4,
                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Color.fromARGB(255, 246, 251, 255)),
                                        child: Column(
                                          children: [
                                            FittedBox(
                                              child: Text(
                                                cartList[index]['cart_time'],
                                                style: TextStyle(fontSize: 9.sp, color: Color(0xff626a7c)),
                                              ),
                                            ),
                                            Spacer(),
                                            Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                FittedBox(
                                                  child: Text(
                                                    "${cartList[index]['items']} item(s)",
                                                    style: TextStyle(fontSize: 9.sp, color: Color(0xff626a7c)),
                                                  ),
                                                ),
                                                FittedBox(
                                                  child: Text(
                                                    "\$${cartList[index]['price']}",
                                                    style: TextStyle(fontSize: 9.sp, color: Color(0xff626a7c)),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Spacer(),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )
                    ],
                  ),
                ],
              ),
            ),
          ]),
        ],
      ),
    );
  }

  localCart(String id, String price) async {
    print(id);
    List data = await sqlDb.readData("Select * from active_cart where all_cart_id = '$id'  ");

    List cartData = data;
    print(cartData);

    List.generate(cartData.length, (index) {
      int item = int.parse(cartData[index]['item']);
      int cart_price = int.parse(cartData[index]['price']);
      List<ListItem> cart = [
        ListItem(
          cartData[index]['cart_id'],
          cartData[index]['cart_name'],
          cartData[index]['c_name'],
          cartData[index]['item_price'],
          item,
          cart_price,
        ),
      ];

      setState(() {
        addcartList.addAll(cart);
      });
    });

    Navigator.push(
      context,
      PageTransition(
          type: PageTransitionType.rightToLeft,
          duration: Duration(milliseconds: 400),
          child: AddTransaction(
            loadCart: () {},
            myList: addcartList,
            priceFromeHome: price,
          ),
          inheritTheme: true,
          ctx: context),
    );
  }
}
