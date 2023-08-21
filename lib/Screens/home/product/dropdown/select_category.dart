import 'dart:math';

import 'package:flutter/material.dart';
import 'package:nova_pos/color/colors.dart';
import 'package:sizer/sizer.dart';

import '../../../../db/sqldb.dart';

class SelectCategory extends StatefulWidget {
  const SelectCategory({super.key, required this.selectedCat});
  final Function selectedCat;

  @override
  State<SelectCategory> createState() => _SelectCategoryState();
}

class _SelectCategoryState extends State<SelectCategory> {
  SqlDb sqlDb = SqlDb();
  TextEditingController name = TextEditingController();

  List dataList = [];
  List selected = [];
  int value = Colors.red.value;
  bool redButton = false;

  getData() async {
    dataList = await sqlDb.readData("Select * from add_cat ");
    selected = await sqlDb.readData("Select * from selected_cat ");
    print(selected);
    if (selected.isNotEmpty) {
      setState(() {
        selected;
      });
      if (selected[0]["cat_id"].toString() == "001") {
        setState(() {
          redButton = false;

          print("gggggggg");
        });
      } else {
        setState(() {
          redButton = true;
          print("ffffffffffffffffffffffffffffff");
        });
      }
    } else {}

    setState(() {
      dataList;
    });
  }

  sendId(String catName) {
    widget.selectedCat(catName);
    Navigator.pop(context);
  }

  @override
  void initState() {
    getData();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xff9ab0ea),
        onPressed: () {
          addCat();
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        backgroundColor: Color(0xff93dc8a),
        title: Text(
          "Category",
          style: TextStyle(fontSize: 17.sp, color: Color(0xff1a6216), fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Stack(children: [
          SizedBox(
            height: h,
            child: ListView.builder(
              itemCount: dataList.length,
              itemBuilder: (context, index) {
                Color newColor = Color(dataList[index]['color']);
                return Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () async {
                          if (selected.isEmpty) {
                            var res = await sqlDb.insertData('INSERT INTO selected_cat ("cat_id") VALUES("${dataList[index]["id"]}")');
                            print(res);
                            sendId(dataList[index]["name"]);
                            print(dataList[index]["name"]);
                          } else {
                            await sqlDb.updateData('UPDATE selected_cat  SET cat_id ="${dataList[index]["id"]}" where id = "1" ');
                            sendId(dataList[index]["name"]);
                            print(dataList[index]["name"]);
                          }
                        },
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                          Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
                              child: Icon(
                                Icons.circle,
                                size: 18,
                                color: newColor,
                              )),
                          SizedBox(
                            width: w / 1.5,
                            child: Text(
                              dataList[index]['name'],
                              style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 118, 117, 117),
                                  overflow: TextOverflow.fade),
                            ),
                          ),
                        ]),
                      ),
                      selected.any((element) => element["cat_id"].toString() == dataList[index]["id"].toString())
                          ? Icon(Icons.check, color: Color.fromARGB(255, 118, 117, 117))
                          : Container()
                    ],
                  ),
                );
              },
            ),
          ),
          redButton == false
              ? Container()
              : Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: ClipRRect(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: w / 5),
                      child: Container(
                        height: h / 13,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: red),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.close),
                              onPressed: () async {
                                await sqlDb.updateData('UPDATE selected_cat  SET cat_id ="001" where id = "1" ');
                                sendId("Unclassified");
                              },
                            ),
                            Text(
                              "Unclassified",
                              style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
        ]),
      ),
    );
  }

  addCat() {
    showDialog(
      context: context,
      builder: (context) {
        var h = MediaQuery.of(context).size.height;

        return AlertDialog(
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "CANCEL",
                style: TextStyle(
                  color: Color.fromARGB(255, 2, 232, 10),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                var generatedColor = Random().nextInt(Colors.primaries.length);
                Colors.primaries[generatedColor];
                var res =
                    await sqlDb.insertData('INSERT INTO add_cat ("name","color") VALUES("${name.text}","${Colors.primaries[generatedColor].value}")');
                print(res);
                List data = await sqlDb.readData("Select * from add_cat ");
                print(data);
                getData();
                name.clear();
                Navigator.pop(context);
              },
              child: Text(
                "ADD",
                style: TextStyle(
                  color: Color.fromARGB(255, 2, 232, 10),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ],
          shape: RoundedRectangleBorder(),
          content: Container(
            child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                "Add Category",
                style: TextStyle(
                  color: Color.fromARGB(255, 118, 117, 117),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: h / 60,
              ),
              Text(
                "Name",
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.normal,
                ),
              ),
              SizedBox(
                height: h / 90,
              ),
              SizedBox(
                height: h / 15,
                child: TextField(
                  controller: name,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    enabledBorder:
                        OutlineInputBorder(borderRadius: BorderRadius.circular(20.0), borderSide: BorderSide(color: Color.fromARGB(255, 2, 232, 10))),
                    focusedBorder:
                        OutlineInputBorder(borderRadius: BorderRadius.circular(20.0), borderSide: BorderSide(color: Color.fromARGB(255, 2, 232, 10))),
                    filled: true,
                    hintStyle: TextStyle(color: Colors.grey[800]),
                    fillColor: Colors.white70,
                  ),
                ),
              )
            ]),
          ),
        );
      },
    );
  }
}
