import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nova_pos/Screens/home/payment/pay.dart';
import 'package:nova_pos/Screens/home/summery.dart';
import 'package:nova_pos/widgets/mainButton.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sizer/sizer.dart';

class AddRevenue extends StatefulWidget {
  const AddRevenue({super.key});

  @override
  State<AddRevenue> createState() => _AddRevenueState();
}

class _AddRevenueState extends State<AddRevenue> {
  TextEditingController sPrice = TextEditingController();
  TextEditingController pCost = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String _inputValue = '';

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // The form is valid, do something with the input value.
      print("Input value: $_inputValue");
    }
  }

  @override
  void initState() {
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
          backgroundColor: Color(0xff93dc8a),
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
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    width: w,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Color(0xffe1fadd)),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          child: Icon(Icons.quiz_sharp),
                        ),
                        Text(
                          "This transaction does not have any product",
                          style: TextStyle(fontSize: 9.sp, fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    "Sales Price",
                    style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.normal),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: SizedBox(
                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Must be greater than 0';
                        }
                        return null; // Return null if the input is valid
                      },
                      onChanged: (value) {
                        setState(() {
                          _inputValue = value;
                        });
                      },
                      controller: sPrice,
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
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0), borderSide: BorderSide(color: Colors.green)),
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
                    "Product Cost",
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
                      controller: pCost,
                      keyboardType: TextInputType.number,
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
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0), borderSide: BorderSide(color: Colors.green)),
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
                SizedBox(
                  height: 5,
                ),
              ],
            ),
          ),
        ),
        bottomSheet: Padding(
          padding: const EdgeInsets.all(12.0),
          child: MainButton(
              buttonHeight: h / 13,
              color: Color.fromARGB(255, 104, 234, 108),
              onTap: () {
                // Replace with your numeric string
                if (sPrice.text.isNotEmpty) {
                  int total = int.parse(sPrice.text);
                  Navigator.push(
                    context,
                    PageTransition(
                        type: PageTransitionType.rightToLeft,
                        duration: Duration(milliseconds: 400),
                        child: Pay(summery: [], total: total),
                        inheritTheme: true,
                        ctx: context),
                  );
                } else {
                  _submitForm();
                }
              },
              text: "SAVE",
              width: w),
        ),
      ),
    );
  }
}
