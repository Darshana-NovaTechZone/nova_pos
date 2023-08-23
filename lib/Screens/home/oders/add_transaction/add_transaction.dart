import 'dart:io';

import 'package:expandable_bottom_sheet/expandable_bottom_sheet.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:intl/intl.dart';
import 'package:nova_pos/color/colors.dart';

import 'package:page_transition/page_transition.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';
import 'package:sizer/sizer.dart';
import '../../../../db/sqldb.dart';
import '../../../../widgets/mainButton.dart';
import '../../../../widgets/main_button2.dart';
import '../../payment/pay.dart';
import '../../product/add_category.dart';

class AddTransaction extends StatefulWidget {
  const AddTransaction({super.key, required this.loadCart});
  final Function loadCart;

  @override
  State<AddTransaction> createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  SqlDb sqlDb = SqlDb();
  List<Map<String, dynamic>> product = [];
  List<Map<String, dynamic>> allProduct = [];
  final TextEditingController _searchController = TextEditingController();
  String myValue = "";
  String price = "0";
  int y = 0;
  List<ListItem> tempCart = [];
  GlobalKey<ExpandableBottomSheetState> key = new GlobalKey();
  int _contentAmount = 0;
  int x = 0;
  String pName = "";
  String cName = "";
  String pcs = "";
  int Qnt = 0;
  int cartP = 0;
  String id = "";
  ExpansionStatus _expansionStatus = ExpansionStatus.contracted;
  loadData() async {
    allProduct = await sqlDb.readData("Select * from add_product ");
    print(allProduct);

    setState(() {
      product = allProduct;
    });
  }

  loadCart() {
    widget.loadCart();
    Navigator.pop(context);
  }

  // This function is called whenever the text field changes
  void _runFilter(String enteredKeyword) {
    List<Map<String, dynamic>> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = allProduct;
    } else if (allProduct.where((user) => user["product_name"].toLowerCase().contains(enteredKeyword.toLowerCase())).toList().isNotEmpty) {
      results = allProduct.where((user) => user["product_name"].toLowerCase().contains(enteredKeyword.toLowerCase())).toList();
    } else if (allProduct.where((user) => user["barcode"].toLowerCase().contains(enteredKeyword.toLowerCase())).toList().isNotEmpty) {
      results = allProduct.where((user) => user["barcode"].toLowerCase().contains(enteredKeyword.toLowerCase())).toList();
    } else if (allProduct.where((user) => user["sku"].toLowerCase().contains(enteredKeyword.toLowerCase())).toList().isNotEmpty) {
      results = allProduct.where((user) => user["sku"].toLowerCase().contains(enteredKeyword.toLowerCase())).toList();
    }

    // Refresh the UI
    setState(() {
      product = results;
      print(product);
    });
  }

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode('#ff6666', 'Cancel', true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      var scanBarcode = barcodeScanRes;
      print(scanBarcode);
    });
  }

  @override
  void initState() {
    loadData();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Color(0xfff8f8f8),
        appBar: AppBar(
          backgroundColor: Color(0xff93dc8a),
          actions: [
            IconButton(
                onPressed: () async {
                  var res = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SimpleBarcodeScannerPage(),
                      ));
                  setState(() {
                    if (res is String) {
                      myValue = res;
                      _searchController.text = myValue;
                      _runFilter(myValue);
                    }
                  });
                },
                icon: Icon(Icons.qr_code_scanner_outlined)),
          ],
          title: Text(
            "Add Transaction",
            style: TextStyle(fontSize: 17.sp, color: Color(0xff1a6216), fontWeight: FontWeight.normal),
          ),
          bottom: PreferredSize(
            preferredSize: Size(w, h / 10),
            child: Padding(
              padding: const EdgeInsets.only(left: 12, bottom: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: h / 15,
                    width: w / 1.5,
                    child: TextField(
                      onChanged: (value) {
                        _runFilter(value);
                      },
                      controller: _searchController,
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
                          enabledBorder:
                              OutlineInputBorder(borderRadius: BorderRadius.circular(20.0), borderSide: BorderSide(color: Color(0xff93dc8a))),
                          focusedBorder:
                              OutlineInputBorder(borderRadius: BorderRadius.circular(20.0), borderSide: BorderSide(color: Color(0xff93dc8a))),
                          filled: true,
                          hintStyle: TextStyle(color: Color(0xffbfbfbf)),
                          fillColor: Colors.white70,
                          hintText: "Name / SKU / Barcode"),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(onPressed: () {}, icon: Icon(Icons.mode_edit_sharp)),
                      IconButton(onPressed: () {}, icon: Icon(Icons.dashboard)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        body: SizedBox(
          height: h,
          child: ExpandableBottomSheet(
            key: key,
            background: SizedBox(
                width: w,
                child: SingleChildScrollView(
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
                    product.isEmpty
                        ? Container(
                            child: SizedBox(
                              height: h / 1.5,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset("assets/q.PNG"),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "You haven't added any AddTransaction",
                                      style: TextStyle(fontSize: 13.sp, color: Color(0xff7c7c7c), fontWeight: FontWeight.normal),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Align(
                            alignment: Alignment.topCenter,
                            child: ListView.builder(
                              shrinkWrap: true,
                              reverse: true,
                              dragStartBehavior: DragStartBehavior.down,
                              itemCount: product.length,
                              itemBuilder: (context, index) {
                                String str = product[index]['sales_prise'];
                                String substr = ",";
                                String replacement = "";
                                String newStr = str.replaceAll(substr, replacement);
                                String sub = ".";
                                String rep = "";
                                String pPrice = newStr.replaceAll(sub, rep);

                                int n = int.parse(pPrice);
                                // pName = product[index]['product_name'];
                                // cName = product[index]['pro_cat'];
                                // pcs = product[index]['sales_prise'];
                                // Qnt += "1";
                                // cartP = pPrice;
                                List<ListItem> cart = [
                                  ListItem(
                                    product[index]['id'],
                                    product[index]['product_name'],
                                    product[index]['pro_cat'],
                                    product[index]['sales_prise'],
                                    1,
                                    n,
                                  ),
                                  // {
                                  //   id = product[index]['id'].toString(),
                                  //   pName = product[index]['product_name'],
                                  //   cName = product[index]['pro_cat'],
                                  //   pcs = product[index]['sales_prise'],
                                  //   Qnt += "1",
                                  //   cartP = pPrice,
                                  // }
                                ];
                                // var mycart = [
                                //   {
                                //     "id": "${product[index]['id']}",
                                //     "pn": "${product[index]['product_name']}",
                                //     " pc": "${product[index]['pro_cat']}",
                                //     "sp": "${product[index]['sales_prise']}",
                                //     "p": "$1",
                                //     "s": "$x",
                                //   }
                                // ];

                                return InkWell(
                                  onTap: () {
                                    String str = product[index]['sales_prise'];
                                    String substr = ",";
                                    String replacement = "";
                                    String newStr = str.replaceAll(substr, replacement);
                                    String sub = ".";
                                    String rep = "";
                                    String pPrice = newStr.replaceAll(sub, rep);

                                    x = int.parse(pPrice);
                                    y += x;
                                    x = y;

                                    // Update items with the same ID
                                    for (var newItem in cart) {
                                      var existingItem = tempCart.firstWhere((item) => item.id == newItem.id, orElse: () {
                                        tempCart.addAll(cart);
                                        return ListItem(1, pName, cName, pcs, Qnt, cartP);
                                      });
                                      if (existingItem != null) {
                                        existingItem.Qnt += 1;
                                        existingItem.cartP = n + existingItem.cartP;

                                        print(existingItem.pcs);
                                      }
                                    }
                                    setState(() {
                                      price = x.toString();
                                      cart;
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  height: 50,
                                                  width: 50,
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadiusDirectional.circular(10),
                                                    child: product[index]['img'] == ""
                                                        ? Image.asset("assets/q.PNG")
                                                        : Image.file(
                                                            File(
                                                                '/storage/emulated/0/Android/data/com.example.nova_pos/files/img/${product[index]['img']}'),
                                                            fit: BoxFit.fill,
                                                          ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      product[index]['product_name'],
                                                      style: TextStyle(fontSize: 12.sp, color: Color(0xff7c7c7c), fontWeight: FontWeight.bold),
                                                    ),
                                                    Container(
                                                      padding: EdgeInsets.symmetric(horizontal: 3, vertical: 2),
                                                      decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(5), color: Color.fromARGB(255, 185, 185, 182)),
                                                      child: Text(
                                                        product[index]['pro_cat'],
                                                        style: TextStyle(
                                                            fontSize: 8.sp, color: Color.fromARGB(255, 255, 255, 255), fontWeight: FontWeight.normal),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  "\$ ${product[index]['sales_prise']}",
                                                  style: TextStyle(fontSize: 12.sp, color: Color(0xff7c7c7c), fontWeight: FontWeight.bold),
                                                ),
                                                Text(
                                                  "unlimited",
                                                  style: TextStyle(fontSize: 8.sp, color: Color(0xff7c7c7c), fontWeight: FontWeight.normal),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Divider(
                                          color: Color.fromARGB(255, 213, 210, 210),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                  ]),
                )),
            persistentHeader: Container(
              height: 20,
              color: Color(0xfff7f1fb),
              child: Center(
                child: Icon(
                  Icons.drag_handle,
                  color: const Color.fromARGB(255, 197, 196, 195),
                ),
              ),
            ),
            expandableContent: Container(
              height: h - 170,
              width: w,
              color: Color(0xfff7f1fb),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.shopping_cart_checkout,
                          color: Color(0xff7c7c7c),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text("CART",
                            style: TextStyle(
                              fontSize: 15.sp,
                              color: Color(0xff7c7c7c),
                              fontWeight: FontWeight.bold,
                            )),
                      ],
                    ),
                    tempCart.isEmpty
                        ? Container(
                            height: h / 4,
                            alignment: Alignment.bottomCenter,
                            child: Text("No Product",
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: Color(0xff7c7c7c),
                                  fontWeight: FontWeight.normal,
                                )),
                          )
                        : Expanded(
                            child: ListView.builder(
                              itemCount: tempCart.length,
                              itemBuilder: (context, index) {
                                print(tempCart[index].cartP.toString());
                                return Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Container(
                                    padding: const EdgeInsets.all(12.0),
                                    width: w,
                                    decoration:
                                        BoxDecoration(borderRadius: BorderRadius.circular(10), color: const Color.fromARGB(255, 230, 255, 230)),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(tempCart[index].pName,
                                                style: TextStyle(
                                                  fontSize: 12.sp,
                                                  color: Color(0xff7c7c7c),
                                                  fontWeight: FontWeight.bold,
                                                )),
                                            Text(tempCart[index].cartP.toString(),
                                                style: TextStyle(
                                                  fontSize: 12.sp,
                                                  color: Color(0xff7c7c7c),
                                                  fontWeight: FontWeight.bold,
                                                )),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.symmetric(horizontal: 3, vertical: 1),
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(2), color: Color.fromARGB(255, 149, 153, 149)),
                                                  child: Text(tempCart[index].cName,
                                                      style: TextStyle(
                                                        fontSize: 8.sp,
                                                        color: white,
                                                        fontWeight: FontWeight.bold,
                                                      )),
                                                ),
                                                SizedBox(
                                                  width: 8,
                                                ),
                                                Text(tempCart[index].pcs,
                                                    style: TextStyle(
                                                      fontSize: 8.sp,
                                                      color: Color(0xff7c7c7c),
                                                      fontWeight: FontWeight.bold,
                                                    )),
                                              ],
                                            ),
                                            Text(tempCart[index].Qnt.toString(),
                                                style: TextStyle(
                                                  fontSize: 8.sp,
                                                  color: Color(0xff7c7c7c),
                                                  fontWeight: FontWeight.bold,
                                                ))
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                  ],
                ),
              ),
            ),
            persistentContentHeight: 100,
            animationCurveExpand: Curves.easeIn,
            animationDurationContract: Duration(milliseconds: 300),
          ),
        ),
        bottomSheet: Container(
          padding: EdgeInsets.all(12),
          color: Colors.transparent,
          child: Row(
            children: [
              SizedBox(
                height: h / 14,
                width: h / 14,
                child: ClipOval(
                  child: Material(
                    color: Color.fromARGB(255, 210, 240, 210), // Button color
                    child: InkWell(
                      splashColor: Color.fromARGB(255, 104, 234, 108), // Splash color
                      onTap: () async {
                        setState(() {
                          saveData();
                          // key.currentState!.expand();
                        });
                      },
                      child: SizedBox(width: 56, height: 56, child: Icon(Icons.source_outlined)),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 8,
              ),
              Expanded(
                child: MainButton2(
                  color: Color.fromARGB(255, 104, 234, 108),
                  buttonHeight: h / 14,
                  onTap: () {
                    setState(() {
                      if (tempCart.isEmpty) {
                        key.currentState!.expand();
                      } else {
                        Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.rightToLeft,
                              duration: Duration(milliseconds: 400),
                              child: Pay(summery: tempCart, total: x),
                              inheritTheme: true,
                              ctx: context),
                        );
                      }

                      // _expansionStatus = key.currentState!.expansionStatus;
                    });
                  },
                  text: "$price",
                  width: w / 1.5,
                ),
              ),
            ],
          ),
        ));
  }

  saveData() async {
    DateTime now = DateTime.now();

    String formattedDate = DateFormat('d MMM,h:mm a').format(now);
    print(formattedDate);
    List cart = [];
    int y = 0;
    List.generate(tempCart.length, (index) async {
      var list = [
        {
          "id": "${tempCart[index].id}",
          "pName": "${tempCart[index].pName}",
          "cName": "${tempCart[index].cName}",
          "pcs": "${tempCart[index].pcs}",
          //
          "qnt": "${tempCart[index].Qnt}",
          "cartP": "${tempCart[index].cartP}",
          //
          "date_time": "$formattedDate"
        }
      ];
      int x = tempCart[index].Qnt;

      cart.addAll(list);
      y += x;
    });
    print(y);
    var stringList = cart;

    if (tempCart.isNotEmpty) {
      var res =
          await sqlDb.insertData('INSERT INTO cart ("temp_cart","date_time","item","price") VALUES("$stringList","$formattedDate","$y","$price" )');
      print(res);
      List data = await sqlDb.readData("Select * from cart ");
      print(data);
    }
    loadCart();
  }
}

class ListItem {
  int id;
  String pName;
  String cName;
  String pcs;
  int Qnt;
  int cartP;

  // other attributes

  ListItem(
    this.id,
    this.pName,
    this.cName,
    this.pcs,
    this.Qnt,
    this.cartP,
  );
}
