import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:nova_pos/Screens/home/product/add_category.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sizer/sizer.dart';

import '../../../color/colors.dart';
import '../../../db/sqldb.dart';
import 'add_product.dart';

class Product extends StatefulWidget {
  const Product({super.key});

  @override
  State<Product> createState() => _ProductState();
}

class _ProductState extends State<Product> {
  SqlDb sqlDb = SqlDb();
  List product = [];
    final TextEditingController _searchController = TextEditingController();
  loadData() async {
    List data = await sqlDb.readData("Select * from add_product ");
    print(data);

    setState(() {
      product = data;
    });
  }

  final List<String> _results = [];

  void _handleSearch(String input) {
    _results.clear();
    for (var str in product) {
      if (str.toLowerCase().contains(input.toLowerCase())) {
        setState(() {
          _results.add(str);
        });
      }
    }
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
    var p = MediaQuery.paddingOf(context).top;
    return Scaffold(
      backgroundColor: Color(0xfff8f8f8),
      appBar: AppBar(
        backgroundColor: Color(0xff93dc8a),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.upload_rounded)),
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  PageTransition(
                      type: PageTransitionType.rightToLeft,
                      duration: Duration(milliseconds: 400),
                      child: AddCategory(),
                      inheritTheme: true,
                      ctx: context),
                );
              },
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
                onChanged: _handleSearch,
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
        onPressed: () {
          Navigator.push(
            context,
            PageTransition(
                type: PageTransitionType.rightToLeft,
                duration: Duration(milliseconds: 400),
                child: AddProduct(loadData: loadData),
                inheritTheme: true,
                ctx: context),
          );
        },
        child: Icon(Icons.add),
      ),
      body: SizedBox(
          width: w,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
                product.isEmpty
                    ? Column(
                        children: [
                          Image.asset("assets/q.PNG"),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "You haven't added any product",
                              style: TextStyle(fontSize: 13.sp, color: Color(0xff7c7c7c), fontWeight: FontWeight.normal),
                            ),
                          ),
                        ],
                      )
                    : Align(
                        alignment: Alignment.topCenter,
                        child: ListView.builder(
                          shrinkWrap: true,
                          reverse: true,
                          dragStartBehavior: DragStartBehavior.down,
                          itemCount: product.length,
                          itemBuilder: (context, index) {
                            return Column(
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
                                                    File('/storage/emulated/0/Android/data/com.example.nova_pos/files/img/${product[index]['img']}'),
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
                                              decoration:
                                                  BoxDecoration(borderRadius: BorderRadius.circular(5), color: Color.fromARGB(255, 185, 185, 182)),
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
                                      children: [
                                        Text(
                                          "\$ ${product[index]['sales_prise']}",
                                          style: TextStyle(fontSize: 12.sp, color: Color(0xff7c7c7c), fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          "unliited",
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
                            );
                          },
                        ),
                      )
              ]),
            ),
          )),
    );
  }
}
