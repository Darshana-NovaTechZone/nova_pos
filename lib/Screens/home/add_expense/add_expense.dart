import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nova_pos/Screens/home/payment/receipt.dart';
import 'package:nova_pos/widgets/mainButton.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sizer/sizer.dart';

import '../../../color/colors.dart';

class AddExpense extends StatefulWidget {
  const AddExpense({super.key});

  @override
  State<AddExpense> createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  bool dateTime = false;
  TextEditingController norminal = TextEditingController();
  TextEditingController note = TextEditingController();
  DateTime selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  String formattedDate = "";
  bool labeTap = false;

  Future<void> selectTime(BuildContext context) async {
    TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    ) as TimeOfDay;
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  data() {
    formattedDate = DateFormat(' d E MMM yyyy ').format(selectedDate);
    setState(() {
      formattedDate;
    });
    print(formattedDate);
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
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xfff77575),
          title: Text(
            "Add Expense",
            style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.normal),
          ),
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.close)),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Custom date and time",
                      style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.normal),
                    ),
                    Switch(
                      value: dateTime,
                      onChanged: (value) {
                        setState(() {
                          dateTime = value;
                        });
                      },
                      activeColor: Color.fromARGB(255, 255, 246, 78),
                      inactiveThumbColor: white,
                    )
                  ],
                ),
              ),
              dateTime
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Date",
                                style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.normal),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              InkWell(
                                onTap: () {
                                  selectDate(context);
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Color(0xfff77575)),
                                  child: Row(
                                    children: [
                                      Icon(Icons.calendar_today),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        '$formattedDate',
                                        style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.normal),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Time",
                                style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.normal),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              InkWell(
                                onTap: () {
                                  selectTime(context);
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Color(0xfff77575)),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.query_builder,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        '${_selectedTime.hour}:${_selectedTime.minute}',
                                        style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.normal),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    )
                  : Container(),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  "Nominal",
                  style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.normal),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: SizedBox(
                  height: h / 15,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: 12, top: 8, bottom: 8),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text('\$'),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0), borderSide: BorderSide(color: Color.fromARGB(255, 120, 125, 120))),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0), borderSide: BorderSide(color: Colors.red)),
                      filled: true,
                      hintStyle: TextStyle(color: Colors.grey[800]),
                      fillColor: Colors.white70,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  "Notes",
                  style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.normal),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: SizedBox(
                  height: h / 15,
                  child: TextField(
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: 12, top: 8, bottom: 8),
                      prefixIcon: Icon(
                        Icons.note,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0), borderSide: BorderSide(color: Color.fromARGB(255, 120, 125, 120))),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0), borderSide: BorderSide(color: Colors.red)),
                      filled: true,
                      hintStyle: TextStyle(color: Colors.grey[800]),
                      fillColor: Colors.white70,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Payment Label",
                  style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.normal),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              labeTap
                  ? InkWell(
                      onTap: () {
                        setState(() {
                          FocusScope.of(context).unfocus();
                          labeTap = false;
                        });

                        Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.rightToLeft,
                              duration: Duration(milliseconds: 400),
                              child: Receipt(payment: "", rest: "", total: "", change: true, summery: []),
                              inheritTheme: true,
                              ctx: context),
                        );
                      },
                      child: Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(left: 12),
                        height: h / 13,
                        width: w,
                        child: Text(
                          "Cash",
                          style: TextStyle(color: Colors.grey[800], fontSize: 15.sp),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: SizedBox(
                        height: h / 15,
                        child: TextField(
                          readOnly: true,
                          onTap: () {
                            setState(() {
                              labeTap = true;
                              FocusScope.of(context).unfocus();
                            });
                          },
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: 12, top: 8, bottom: 8),
                            suffixIcon: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Icon(
                                Icons.keyboard_arrow_down_outlined,
                                size: 18,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(labeTap ? 20.0 : 0),
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0), borderSide: BorderSide(color: Color.fromARGB(255, 120, 125, 120))),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(labeTap ? 20.0 : 0), borderSide: BorderSide(color: Colors.red)),
                            filled: true,
                            hintText: "Cash",
                            hintStyle: TextStyle(color: Colors.grey[800]),
                            fillColor: Colors.white70,
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        ),
        bottomSheet: Padding(
          padding: const EdgeInsets.all(12.0),
          child: MainButton(buttonHeight: h / 13, color: Color(0xfff77575), onTap: () {}, text: "SAVE", width: w),
        ),
      ),
    );
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked =
        await showDatePicker(context: context, initialDate: selectedDate, firstDate: DateTime(2015, 8), lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      formattedDate = DateFormat(' d E MMM yyyy ').format(picked);
      setState(() {
        formattedDate;
      });
      print(formattedDate);
    }
  }
}
