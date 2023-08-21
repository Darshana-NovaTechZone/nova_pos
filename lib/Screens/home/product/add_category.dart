import 'dart:math';

import 'package:flutter/material.dart';
import 'package:nova_pos/color/colors.dart';
import 'package:sizer/sizer.dart';

import '../../../db/sqldb.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({super.key});

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  SqlDb sqlDb = SqlDb();
  TextEditingController name = TextEditingController();

  List dataList = [];
  int value = Colors.red.value;

  getData() async {
    dataList = await sqlDb.readData("Select * from add_cat ");
    setState(() {
      dataList;
    });
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
        child: Column(children: [
          Expanded(
            child: ListView.builder(
              itemCount: dataList.length,
              itemBuilder: (context, index) {
                Color newColor = Color(dataList[index]['color']);
                return Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          print(dataList[index]['id']);
                          editCat(dataList[index]['id'].toString(), dataList[index]['name'].toString());
                        },
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                          Icon(Icons.drag_indicator),
                          Padding(
                              padding: const EdgeInsets.all(8.0),
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
                      IconButton(
                        onPressed: () {
                          delete(dataList[index]['id'].toString(), dataList[index]['name'].toString());
                        },
                        icon: Icon(Icons.delete_forever, color: Color.fromARGB(255, 118, 117, 117)),
                      ),
                    ],
                  ),
                );
              },
            ),
          )
        ]),
      ),
    );
  }

  delete(String id, String text) {
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
                var res = await sqlDb.deleteData(' DELETE FROM add_cat WHERE id = "$id"');
                print(res);
                List data = await sqlDb.readData("Select * from add_cat ");
                print(data);
                getData();
                name.clear();
                Navigator.pop(context);
              },
              child: Text(
                "DELETE",
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
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Icon(
                      Icons.warning_rounded,
                      color: Color.fromARGB(255, 61, 61, 61),
                    ),
                  ),
                  Text(
                    "Delete Category",
                    style: TextStyle(
                      color: Color.fromARGB(255, 61, 61, 61),
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: h / 60,
              ),
              Text(
                "All products associated with ''$text'', will be converted to 'Unclassified'.\ncontinue? ",
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                  color: Color.fromARGB(255, 118, 117, 117),
                ),
              ),
            ]),
          ),
        );
      },
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

  editCat(String id, String text) {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController update = TextEditingController(text: text);
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
                var res = await sqlDb.insertData('UPDATE add_cat  SET name= "${update.text}" WHERE id = "$id"');
                print(res);

                getData();

                Navigator.pop(context);
              },
              child: Text(
                "UPDATE",
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
                "Edit Category",
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
                  controller: update,
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
