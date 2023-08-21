import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../../db/sqldb.dart';

class AddUnit extends StatefulWidget {
  const AddUnit({super.key, required this.selectUnit});
  final Function selectUnit;

  @override
  State<AddUnit> createState() => _AddUnitState();
}

class _AddUnitState extends State<AddUnit> {
  SqlDb sqlDb = SqlDb();

  TextEditingController name = TextEditingController();
  List dataList = [];
  List selected = [];
  bool? check1 = false;

  int value = Colors.red.value;

  getData() async {
    List data = await sqlDb.readData("Select * from add_unit");
    List unit = await sqlDb.readData("Select * from selected_unit");
    if (unit.isEmpty) {
      var res = await sqlDb.insertData('INSERT INTO selected_unit ("unit_id") VALUES("1")');
      unit = await sqlDb.readData("Select * from selected_unit");
      setState(() {
        selected = unit;
      });
    } else {
      setState(() {
        selected = unit;
      });
    }

    setState(() {
      dataList = data;
    });
  }

  sendId(String unitName) {
    widget.selectUnit(unitName);
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
          addUnit();
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        backgroundColor: Color(0xff93dc8a),
        title: Text(
          "Select Unit",
          style: TextStyle(fontSize: 17.sp, color: Color(0xff1a6216), fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(children: [
        Expanded(
          child: ListView.builder(
            itemCount: dataList.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () async {
                  if (selected.isNotEmpty) {
                    await sqlDb.updateData('UPDATE selected_unit  SET unit_id ="${dataList[index]["id"]}" where id = "1" ');
                  }
                  sendId(dataList[index]['name']);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                  child: Container(
                    width: w,
                    height: h / 12,
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            dataList[index]['name'],
                            style: TextStyle(
                                fontSize: 12.sp, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 118, 117, 117), overflow: TextOverflow.fade),
                          ),
                          Text(
                            dataList[index]['status'],
                            style: TextStyle(
                              fontSize: 9.sp,
                              fontWeight: FontWeight.normal,
                              color: Color.fromARGB(255, 118, 117, 117),
                              overflow: TextOverflow.fade,
                            ),
                          )
                        ],
                      ),
                      selected.any((element) => element["unit_id"].toString() == dataList[index]["id"].toString())
                          ? Icon(Icons.check, color: Color.fromARGB(255, 118, 117, 117))
                          : Container()
                    ]),
                  ),
                ),
              );
            },
          ),
        )
      ]),
    );
  }

  addUnit() {
    showDialog(
        context: context,
        builder: (context) {
          var h = MediaQuery.of(context).size.height;
          return StatefulBuilder(
            builder: (context, setState) {
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
                      String status = check1! ? "Fractional" : "Integer";
                      var res = await sqlDb.insertData('INSERT INTO add_unit ("name","status") VALUES("${name.text}","$status")');
                      print(res);
                      List data = await sqlDb.readData("Select * from add_unit ");
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
                      "Add Unit",
                      style: TextStyle(
                        color: Color.fromARGB(255, 118, 117, 117),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
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
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0), borderSide: BorderSide(color: Color.fromARGB(255, 2, 232, 10))),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0), borderSide: BorderSide(color: Color.fromARGB(255, 2, 232, 10))),
                          filled: true,
                          hintStyle: TextStyle(color: Colors.grey[800]),
                          fillColor: Colors.white70,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Checkbox(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                            //only check box
                            value: check1, //unchecked
                            onChanged: (bool? value) {
                              //value returned when checkbox is clicked
                              setState(() {
                                check1 = value;
                              });
                            }),
                        Text(
                          "Fractional",
                          style: TextStyle(
                            color: Color.fromARGB(255, 118, 117, 117),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ]),
                ),
              );
            },
          );
        });
  }
}
