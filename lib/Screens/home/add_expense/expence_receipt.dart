import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:nova_pos/class/model/list_item_model.dart';
import 'package:nova_pos/widgets/mainButton.dart';
import 'package:sizer/sizer.dart';
import '../../../db/sqldb.dart';

class ExpenceReceipt extends StatefulWidget {
  const ExpenceReceipt({
    super.key,
    required this.nominal,
    required this.note,
  });
  final String nominal;
  final String note;

  @override
  State<ExpenceReceipt> createState() => _ExpenceReceiptState();
}

class _ExpenceReceiptState extends State<ExpenceReceipt> {
  DateTime selectedDate = DateTime.now();
  String formattedDate = "";
  SqlDb sqlDb = SqlDb();
  data() {
    formattedDate = DateFormat('yyyyMMddHHmss').format(selectedDate);
    setState(() {
      formattedDate;
    });
    print(formattedDate);
  }

  back() {
    Navigator.pop(context);
    Navigator.pop(context);
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
    return WillPopScope(
      onWillPop: () {
        return back();
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SizedBox(
            width: w,
            child: Column(
              children: [
                SizedBox(
                  height: 25,
                ),
                Container(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                        onPressed: () {
                          back();
                        },
                        icon: Icon(Icons.close))),
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    "EXPENSE",
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.normal,
                      color: Colors.black54,
                    ),
                  ),
                ),
                Text(
                  "Nova-Pos/$formattedDate-lk",
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.check_circle_sharp,
                    size: 55.sp,
                    color: Colors.black54,
                  ),
                ),
                Text(
                  "PAID",
                  style: TextStyle(
                    fontSize: 25.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total",
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.normal,
                          color: Colors.black54,
                        ),
                      ),
                      Text(
                        "\$${widget.nominal}",
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.normal,
                          color: Color(0xfff77575),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomSheet: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 10,
              ),
              MainButton(
                  buttonHeight: h / 13,
                  color: Color(0xfff77575),
                  onTap: () async {
                    saveData();
                  },
                  text: "FINISH",
                  width: w),
            ],
          ),
        ),
      ),
    );
  }

  saveData() async {
    DateTime now = DateTime.now();

    String date = DateFormat('d MMM,h:mm a').format(now);

    var transId;

    transId = await sqlDb.insertData(
        'INSERT INTO trance_action_expense("date","r_id","note","sub_total","grand_total","payment","change","status","is_expense","is_revenue","expense","revenue","cost") VALUES ("$date","Nova-Pos/$formattedDate-lk","${widget.note}","0","0","0","0","true","1","0","${widget.nominal}","0","0")');

    print(transId);

    var data = await sqlDb.readData("Select * from active_cart ");
    Navigator.pop(context);
    Navigator.pop(context);
    Logger().d(data);
    // await sqlDb.updateData(' UPDATE  all_cart SET  items = "$y" WHERE id = "$cart_id"');
  }
}
