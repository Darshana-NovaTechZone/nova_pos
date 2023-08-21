import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../color/colors.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  bool add = false;
  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    var p = MediaQuery.paddingOf(context).top;
    List catlist = [
      {
        "icon": Icon(
          Icons.settings,
          color: Color(0xff737373),
        ),
        "text": "Settings"
      },
      {
        "icon": Icon(
          Icons.group,
          color: Color(0xff737373),
        ),
        "text": "Customer"
      },
      {
        "icon": Icon(
          Icons.quiz_sharp,
          color: Color(0xff737373),
        ),
        "text": "FAQ"
      },
      {
        "icon": Icon(
          Icons.local_offer,
          color: Color(0xff737373),
        ),
        "text": "Discount"
      },
      {
        "icon": Icon(
          Icons.square_foot_outlined,
          color: Color(0xff737373),
        ),
        "text": "Unit"
      },
      {
        "icon": Icon(
          Icons.payment,
          color: Color(0xff737373),
        ),
        "text": "Payment Label"
      },
      {
        "icon": Icon(
          Icons.cloud_upload,
          color: Color(0xff737373),
        ),
        "text": "Backup"
      },
      {
        "icon": Icon(
          Icons.import_export_outlined,
          color: Color(0xff737373),
        ),
        "text": "Import Products"
      },
      {
        "icon": Icon(
          Icons.print,
          color: Color(0xff737373),
        ),
        "text": "Printer"
      },
      {
        "icon": Icon(
          Icons.gpp_maybe,
          color: Color(0xff737373),
        ),
        "text": "Privacy Policy"
      },
      {
        "icon": Icon(
          Icons.email,
          color: Color(0xff737373),
        ),
        "text": "Contact Us"
      },
    ];

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(
            height: p,
          ),
          add
              ? Container()
              : Container(
                  width: w,
                  height: h / 7,
                  padding: EdgeInsets.only(left: 12, bottom: 15),
                  decoration: BoxDecoration(color: Color(0xfffac02e), borderRadius: BorderRadius.circular(10)),
                  child: Stack(
                    children: [
                      Positioned(
                          right: 0,
                          child: IconButton(
                              onPressed: () {
                                setState(() {
                                  add = true;
                                });
                              },
                              icon: Icon(Icons.close))),
                      Positioned(
                        top: 20,
                        right: 0,
                        left: 0,
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(
                            "New in v2.5",
                            style: TextStyle(fontSize: 15.sp, color: Color(0xff75550f), fontWeight: FontWeight.bold),
                          ),
                          FittedBox(
                            child: Text(
                              "REvap Discount REoder Feature,Wi-Fi /...",
                              style: TextStyle(fontSize: 10.sp, color: Color(0xff75550f)),
                            ),
                          ),
                        ]),
                      ),
                    ],
                  ),
                ),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: catlist.length,
              itemBuilder: (context, index) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: w / 5,
                      height: w / 5,
                      child: catlist[index]['icon'],
                      decoration:
                          BoxDecoration(border: Border.all(color: const Color.fromARGB(96, 112, 110, 110)), borderRadius: BorderRadius.circular(15)),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    FittedBox(
                      child: Text(
                        catlist[index]['text'],
                        style: TextStyle(fontSize: 10.sp, color: Color(0xff737373), fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                );
              },
            ),
          )
        ]),
      ),
    );
  }
}
