import 'dart:io';

import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
import 'add_unit/add_unit.dart';
import 'dropdown/select_category.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key, required this.loadData});
  final Function loadData;

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> with SingleTickerProviderStateMixin {
  TextEditingController productName = TextEditingController();
  TextEditingController catName = TextEditingController(text: "Unclassified");
  TextEditingController sku = TextEditingController();
  TextEditingController barcode = TextEditingController();
  TextEditingController salePrice = TextEditingController(text: '0');
  TextEditingController productCost = TextEditingController();
  // final salePrice = MoneyMaskedTextController(initialValue: 0);
  TextEditingController unit = TextEditingController(text: "pcs");
  // final productCost = MoneyMaskedTextController(initialValue: 0);
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
    getCategory();
    super.initState();
    _tabController = new TabController(
      vsync: this,
      length: 3,
      initialIndex: 0,
    );
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
              title: Text(
                "Add Product",
                style: TextStyle(fontSize: 17.sp, color: Color(0xff1a6216), fontWeight: FontWeight.normal),
              ),
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.close)),
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
                                  Icons.info,
                                  size: 17,
                                  color: Color(0xff1a6216),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text("INFO",
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
                                  Icons.monetization_on,
                                  size: 17,
                                  color: Color(0xff1a6216),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text("PRICE", style: TextStyle(color: Color(0xff1a6216))),
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
                                  Icons.extension,
                                  size: 17,
                                  color: Color(0xff1a6216),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "OPTIONS",
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
                        Text(
                          "Product Name",
                          style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.normal),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        SizedBox(
                          height: h / 15,
                          child: TextField(
                            controller: productName,
                            decoration: InputDecoration(
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
                            onChanged: (value) {
                              if (value.isNotEmpty) {
                                setState(() {
                                  button = false;
                                });
                              } else {
                                setState(() {
                                  button = true;
                                });
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Category",
                          style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.normal),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        SizedBox(
                          height: h / 15,
                          child: TextField(
                            controller: catName,
                            readOnly: true,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(left: 12, top: 8, bottom: 8),
                              prefixIcon: Icon(Icons.category),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 18,
                                ),
                                onPressed: () {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                        type: PageTransitionType.rightToLeft,
                                        duration: Duration(milliseconds: 400),
                                        child: SelectCategory(selectedCat: selectedCat),
                                        inheritTheme: true,
                                        ctx: context),
                                  );
                                },
                              ),
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
                            onChanged: (value) {
                              if (value.isNotEmpty) {
                                setState(() {
                                  button = false;
                                });
                              } else {
                                setState(() {
                                  button = true;
                                });
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Set as Featured product",
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Enable variant",
                              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.normal),
                            ),
                            Switch(
                              value: variant,
                              onChanged: (value) {
                                setState(() {
                                  variant = value;
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
                        Row(
                          children: [
                            Icon(Icons.sticky_note_2_outlined),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              "DETAILS (OPTIONAL)",
                              style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Image",
                          style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.normal),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        image != null
                            ? Container(
                                height: h / 7,
                                width: w / 3.5,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5), color: const Color.fromARGB(255, 110, 245, 115).withOpacity(0.6)),
                                child: Image.file(
                                  //to show image, you type like this.
                                  File(image!.path),
                                  fit: BoxFit.cover,
                                  width: MediaQuery.of(context).size.width,
                                  height: 300,
                                ),
                              )
                            : InkWell(
                                onTap: () {
                                  setState(() {
                                    FocusManager.instance.primaryFocus?.unfocus();
                                  });
                                  bottomDialog(context);
                                },
                                child: Container(
                                  height: h / 7,
                                  width: w / 3.5,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5), color: const Color.fromARGB(255, 110, 245, 115).withOpacity(0.6)),
                                  child: Center(
                                    child: Center(
                                        child: Opacity(
                                      opacity: 0.8,
                                      child: Icon(
                                        Icons.add_a_photo,
                                        size: 25.sp,
                                      ),
                                    )),
                                  ),
                                ),
                              ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "SKU",
                          style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.normal),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        CustomTextField(edit: sku, type: TextInputType.name),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Barcode",
                          style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.normal),
                        ),
                        SizedBox(
                          height: h / 15,
                          child: TextField(
                            controller: barcode,
                            readOnly: true,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(left: 12, top: 8, bottom: 8),
                              suffixIcon: InkWell(
                                borderRadius: BorderRadius.circular(20.0),
                                onTap: () async {
                                  var res = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const SimpleBarcodeScannerPage(),
                                      ));
                                  setState(() {
                                    if (res is String) {
                                      if (res[0] == "-") {
                                        result = "";
                                      } else {
                                        result = res;
                                      }
                                    }
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.qr_code_scanner_outlined,
                                        color: Color.fromARGB(255, 104, 234, 108),
                                      ),
                                      SizedBox(
                                        width: 12,
                                      ),
                                      Text(
                                        "Scan",
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.normal,
                                          color: Color.fromARGB(255, 104, 234, 108),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
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
                          height: 150,
                        )
                      ],
                    ),
                  ),
                ),

                //  price screen area -------------------------------------------------------------------------------------------------------------------------------------------------------------------

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
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Sales Price",
                                    style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.normal),
                                  ),
                                  SizedBox(
                                    height: h / 15,
                                    width: w / 1.8,
                                    child: TextField(
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        // Fit the validating format.
                                        //fazer o formater para dinheiro
                                      ],
                                      controller: salePrice,
                                      decoration: InputDecoration(
                                        prefixIcon: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Text(
                                            '\$',
                                            textAlign: TextAlign.start,
                                          ),
                                        ),
                                        contentPadding: EdgeInsets.only(left: 12, top: 8, bottom: 8),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(20.0),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(20.0),
                                            borderSide: BorderSide(color: Color.fromARGB(255, 120, 125, 120))),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(20.0), borderSide: BorderSide(color: Colors.green)),
                                        filled: true,
                                        hintStyle: TextStyle(color: Colors.grey[800]),
                                        fillColor: Colors.white70,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Spacer(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Unit",
                                    style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.normal),
                                  ),
                                  SizedBox(
                                    height: h / 15,
                                    width: w / 3.2,
                                    child: TextField(
                                      readOnly: true,
                                      controller: unit,
                                      decoration: InputDecoration(
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            size: 18,
                                          ),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              PageTransition(
                                                  type: PageTransitionType.rightToLeft,
                                                  duration: Duration(milliseconds: 400),
                                                  child: AddUnit(selectUnit: selectedUnit),
                                                  inheritTheme: true,
                                                  ctx: context),
                                            );
                                          },
                                        ),
                                        contentPadding: EdgeInsets.only(left: 12, top: 8, bottom: 8),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(20.0),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(20.0),
                                            borderSide: BorderSide(color: Color.fromARGB(255, 120, 125, 120))),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(20.0), borderSide: BorderSide(color: Colors.green)),
                                        filled: true,
                                        hintStyle: TextStyle(color: Colors.grey[800]),
                                        fillColor: Colors.white70,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Price per nnnn",
                              style: TextStyle(fontSize: 9.sp, fontWeight: FontWeight.normal),
                            ),
                          ),
                          Text(
                            "Product Cost (Optional)",
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
                              controller: productCost,
                              decoration: InputDecoration(
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Text(
                                    '\$',
                                    textAlign: TextAlign.start,
                                  ),
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
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Price per nnnn",
                              style: TextStyle(fontSize: 9.sp, fontWeight: FontWeight.normal),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Wholesale Price",
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Enable stock calculation",
                                style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.normal),
                              ),
                              Switch(
                                value: variant,
                                onChanged: (value) {
                                  setState(() {
                                    variant = value;
                                  });
                                },
                                activeColor: Color.fromARGB(255, 233, 149, 233),
                                inactiveThumbColor: white,
                              )
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
// option Area ------------------------------------------------------------------------------------------------------------------------------------------------------
                SizedBox(
                  height: h - 200,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: h / 10,
                          width: w,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Color(0xff9ab0ea)),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: Icon(Icons.add_box),
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "New Option",
                                    style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "Add an extra option for this product",
                                    style: TextStyle(fontSize: 9.sp, fontWeight: FontWeight.normal),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: h / 2.5,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          width: w,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Color(0xffe1fadd)),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                child: Icon(Icons.quiz_sharp),
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Using Options",
                                    style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "Need to change more for that extra \ncheese? Create options to add additional\n surcharge",
                                    style: TextStyle(fontSize: 9.sp, fontWeight: FontWeight.normal),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
            bottomSheet: AbsorbPointer(
              absorbing: button,
              child: Container(
                padding: EdgeInsets.all(12),
                child: MainButton(
                  color: button ? Color.fromARGB(255, 181, 175, 175) : Color.fromARGB(255, 104, 234, 108),
                  buttonHeight: h / 14,
                  onTap: _tabController!.index == 2
                      ? () async {
                          var res = await sqlDb.insertData(
                              'INSERT INTO add_product ("product_name","pro_cat","img","sku","barcode","sales_prise","unit","product_cost") VALUES("${productName.text}","${catName.text}","$imgName","${sku.text}","${barcode.text}","${salePrice.text}","${unit.text}","${productCost.text}")');
                          print(res);
                          List data = await sqlDb.readData("Select * from add_product ");
                          print(data);

                          load(context);
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
                  text: _tabController!.index == 2 ? "Save" : "Next",
                  width: w,
                ),
              ),
            )),
      ),
    );
  }

  load(BuildContext context) {
    widget.loadData();

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
