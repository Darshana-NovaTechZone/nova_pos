import 'dart:io';
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:fdottedline_nullsafety/fdottedline__nullsafety.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nova_pos/class/model/list_item_model.dart';
import 'package:nova_pos/color/colors.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sizer/sizer.dart';
import 'package:path/path.dart';
import '../../../class/modal.dart';
import '../../../curruncy/curruncy.dart';
import '../../../db/sqldb.dart';
import '../../../widgets/mainButton.dart';
import '../payment/receipt.dart';

class ActionDetails extends StatefulWidget {
  const ActionDetails(
      {super.key,
      required this.cartId,
      required this.inId,
      required this.ggTotal,
      required this.sgTotal,
      required this.payment,
      required this.status,
      required this.pCost,
      required this.propit,
      required this.inDate,
      required this.actionCompleteDate,
      required this.note,
      required this.change,});
  final String cartId;

  final String inDate;
  final String inId;
  final String note;
  final String sgTotal;
  final String ggTotal;
  final String payment;
  final String status;
  final String pCost;
  final String propit;
  final String actionCompleteDate;
  final String change;
 

  @override
  State<ActionDetails> createState() => _ActionDetailsState();
}

class _ActionDetailsState extends State<ActionDetails> with SingleTickerProviderStateMixin {
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
  int ActionDetails = 0;
  bool change = false;
  int index = 0;
  List<ActionItem> addcartList = [];
  final ImagePicker picker = ImagePicker();
  //we can upload image from camera or from gallery based on parameter
  List catList = [];
  int value = const Color.fromRGBO(244, 67, 54, 1).value;
  int cost = 0;
  int profit = 0;
  localCart() async {
    List data = await sqlDb.readData(
        "Select * from active_cart LEFT JOIN add_product ON  active_cart.cart_id =add_product.id where all_cart_id = '${widget.cartId}' and status = '1' ");

    List cartData = data;
    print(cartData);

    List.generate(cartData.length, (index) {
      int item = int.parse(cartData[index]['item']);
      int cart_price = int.parse(cartData[index]['price']);
      int cart_cost = int.parse(cartData[index]['product_cost']);
      cost += cart_cost;

      List<ActionItem> cart = [
        ActionItem(cartData[index]['cart_id'], cartData[index]['cart_name'], cartData[index]['c_name'], cartData[index]['item_price'], item,
            cart_price, cartData[index]['img']),
      ];
      addcartList.addAll(cart);
    });
    int producPrice = int.parse(widget.sgTotal);
    int change = int.parse(widget.change);

    profit = (producPrice - change) - cost;
    print(cost);
    setState(() {
      profit;
      cost;
      addcartList;
    });
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  @override
  void initState() {
    localCart();
    super.initState();
    _tabController = new TabController(
      vsync: this,
      length: 3,
      initialIndex: 0,
    );

    setState(() {
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
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Transaction",
                    style: TextStyle(fontSize: 17.sp, color: Color(0xff1a6216), fontWeight: FontWeight.normal),
                  ),
                  Text(
                    "Transactiossdsn",
                    style: TextStyle(fontSize: 8.sp, color: Color(0xff1a6216), fontWeight: FontWeight.normal),
                  ),
                ],
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
                                  Icons.description_outlined,
                                  size: 17,
                                  color: Color(0xff1a6216),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text("PRODUCT", style: TextStyle(color: Color(0xff1a6216))),
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
                                  Icons.history,
                                  size: 17,
                                  color: Color(0xff1a6216),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "HISTORY",
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Invoice Date",
                              style: TextStyle(color: const Color.fromARGB(255, 121, 121, 121), fontSize: 8.sp, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              widget.inDate,
                              style: TextStyle(color: const Color.fromARGB(255, 121, 121, 121), fontSize: 10.sp, fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                        Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Invoice Number",
                              style: TextStyle(color: const Color.fromARGB(255, 121, 121, 121), fontSize: 8.sp, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              widget.inId,
                              style: TextStyle(color: const Color.fromARGB(255, 121, 121, 121), fontSize: 10.sp, fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                        Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Note",
                              style: TextStyle(color: const Color.fromARGB(255, 121, 121, 121), fontSize: 8.sp, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              widget.note,
                              style: TextStyle(color: const Color.fromARGB(255, 121, 121, 121), fontSize: 10.sp, fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          width: w,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Color.fromARGB(255, 182, 247, 190)),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                child: Row(
                                  children: [
                                    Icon(Icons.note),
                                    SizedBox(width: 8),
                                    Text(
                                      "SUMMARY",
                                      style: TextStyle(color: Colors.brown, fontSize: 13.sp, fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Sub Total",
                                      style: TextStyle(color: Colors.brown, fontSize: 9.sp, fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      "$currency ${widget.sgTotal}",
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
                                      "Grand Total",
                                      style: TextStyle(color: Colors.brown, fontSize: 9.sp, fontWeight: FontWeight.bold),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(7), color: Colors.green),
                                      child: Text(
                                        "$currency ${widget.ggTotal}",
                                        style: TextStyle(color: Colors.brown, fontSize: 13.sp, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                child: Row(
                                  children: [
                                    Icon(Icons.payment),
                                    SizedBox(width: 8),
                                    Text(
                                      "PAYMENT",
                                      style: TextStyle(color: Colors.brown, fontSize: 13.sp, fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Total Paid",
                                      style: TextStyle(color: Colors.brown, fontSize: 9.sp, fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      "$currency ${widget.payment}",
                                      style: TextStyle(color: Colors.brown, fontSize: 13.sp, fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Change",
                                      style: TextStyle(color: Colors.brown, fontSize: 9.sp, fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      "$currency ${widget.change}",
                                      style: TextStyle(color: Colors.brown, fontSize: 13.sp, fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Status",
                                      style: TextStyle(color: Colors.brown, fontSize: 9.sp, fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      widget.status == "true" ? "PAID" : "UNSETTLED",
                                      style: TextStyle(color: Colors.brown, fontSize: 13.sp, fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                          child: Row(
                            children: [
                              Icon(Icons.account_balance_wallet_rounded),
                              SizedBox(width: 8),
                              Text(
                                "REVENUE",
                                style: TextStyle(color: Colors.brown, fontSize: 13.sp, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Grand Total",
                                style: TextStyle(color: Colors.brown, fontSize: 9.sp, fontWeight: FontWeight.w600),
                              ),
                              Text(
                                "$currency ${widget.ggTotal}",
                                style: TextStyle(color: Colors.brown, fontSize: 13.sp, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Total Paid",
                                style: TextStyle(color: Colors.brown, fontSize: 9.sp, fontWeight: FontWeight.w600),
                              ),
                              Text(
                                "$currency ${widget.payment}",
                                style: TextStyle(color: Colors.brown, fontSize: 13.sp, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "product Cost",
                                style: TextStyle(color: Colors.brown, fontSize: 9.sp, fontWeight: FontWeight.w600),
                              ),
                              Text(
                                "$currency $cost",
                                style: TextStyle(color: Colors.brown, fontSize: 13.sp, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "profit",
                                style: TextStyle(color: Colors.brown, fontSize: 9.sp, fontWeight: FontWeight.w600),
                              ),
                              Text(
                                "$currency ${profit.toString()}",
                                style: TextStyle(color: Colors.brown, fontSize: 13.sp, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 150,
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
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: addcartList.length,
                            itemBuilder: (context, index) {
                              print(addcartList[index].img);
                              print("fffffffffffffffffffffff");
                              return Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 50,
                                          width: 50,
                                          child: ClipRRect(
                                            borderRadius: BorderRadiusDirectional.circular(10),
                                            child: addcartList[index].img == ""
                                                ? Image.asset("assets/q.PNG")
                                                : Image.file(
                                                    File('/storage/emulated/0/Android/data/com.example.nova_pos/files/img/${addcartList[index].img}'),
                                                    fit: BoxFit.fill,
                                                  ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Expanded(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(addcartList[index].pName,
                                                      style: TextStyle(
                                                        fontSize: 12.sp,
                                                        color: Color(0xff7c7c7c),
                                                        fontWeight: FontWeight.bold,
                                                      )),
                                                  Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Text(addcartList[index].cName,
                                                          style: TextStyle(
                                                            fontSize: 8.sp,
                                                            color: Color(0xff7c7c7c),
                                                            fontWeight: FontWeight.bold,
                                                          )),
                                                      SizedBox(
                                                        width: 8,
                                                      ),
                                                      Text("$currency ${addcartList[index].pcs}",
                                                          style: TextStyle(
                                                            fontSize: 8.sp,
                                                            color: Color(0xff7c7c7c),
                                                            fontWeight: FontWeight.bold,
                                                          ))
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                width: 50,
                                              ),
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  Text("${addcartList[index].qnt.toString()} pcs",
                                                      style: TextStyle(
                                                        fontSize: 8.sp,
                                                        color: Color(0xff7c7c7c),
                                                        fontWeight: FontWeight.bold,
                                                      )),
                                                  SizedBox(
                                                    width: 8,
                                                  ),
                                                  Text("$currency ${addcartList[index].cartP}",
                                                      style: TextStyle(
                                                        fontSize: 12.sp,
                                                        color: Color.fromARGB(255, 56, 192, 213),
                                                        fontWeight: FontWeight.bold,
                                                      )),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                ),
// ActionDetailsent Area ------------------------------------------------------------------------------------------------------------------------------------------------------
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SizedBox(
                    height: h,
                    child: SizedBox(
                      height: 150,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 65,
                            top: 10,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("CREATED",
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      color: Color.fromARGB(255, 180, 113, 19),
                                      fontWeight: FontWeight.normal,
                                    )),
                                Text(widget.actionCompleteDate,
                                    style: TextStyle(
                                      fontSize: 8.sp,
                                      fontWeight: FontWeight.normal,
                                    )),
                              ],
                            ),
                          ),
                          Positioned(
                            left: 65,
                            top: h / 4,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("PAYMENT",
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      color: Color.fromARGB(255, 180, 113, 19),
                                      fontWeight: FontWeight.normal,
                                    )),
                                Text(widget.actionCompleteDate,
                                    style: TextStyle(
                                      fontSize: 8.sp,
                                      fontWeight: FontWeight.normal,
                                    )),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: 50,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CircleAvatar(backgroundColor: Color(0xffdda071), child: Icon(Icons.point_of_sale)),
                                  Container(height: 100, width: 3, color: Color(0xffdda071)),
                                  CircleAvatar(backgroundColor: Color(0xffdda071), child: Icon(Icons.attach_money)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
            bottomSheet: Container(
                padding: EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
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
                      mainAxisSize: MainAxisSize.min,
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
                      mainAxisSize: MainAxisSize.min,
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
                      mainAxisSize: MainAxisSize.min,
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
                ))),
      ),
    );
  }
}
