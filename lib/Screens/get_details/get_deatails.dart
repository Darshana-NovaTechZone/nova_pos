import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nova_pos/Screens/home/navigation.dart';
import 'package:nova_pos/color/colors.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import '../../widgets/custom_textfield.dart';
import '../../widgets/mainButton.dart';

class GetDetails extends StatefulWidget {
  const GetDetails({super.key});

  @override
  State<GetDetails> createState() => _GetDetailsState();
}

class _GetDetailsState extends State<GetDetails> {
  Timer? timer;
  int y = 0;
  final TextEditingController name = TextEditingController();
  final TextEditingController address = TextEditingController();
  final TextEditingController address2 = TextEditingController();
  final TextEditingController phone = TextEditingController();
  onInit() {
    y = y + 1;
    if (y == 1) {
      print(y);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('To exit app, press back one more time.'),
      ));
      timer = Timer.periodic(const Duration(seconds: 5), (Timer t) {
        print('TImer active');
        y = 0;
        timer!.cancel();
      });
    } else if (y >= 2) {
      exit(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    var p = MediaQuery.paddingOf(context).top;
    return Scaffold(
      backgroundColor: Color(0xfff8f8f8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Text(
            "Nova Pos",
            style: TextStyle(fontSize: 25.sp, fontFamily: "CabinSketch", color: Color.fromARGB(255, 110, 227, 95)),
          ),
        ),
        leadingWidth: w,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: SizedBox(
            height: h - 100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    "Let's set up your store!",
                    style: TextStyle(fontSize: 14.sp, color: textBlack, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: h / 30,
                ),
                Text(
                  "Store Name",
                  style: TextStyle(fontSize: 12.sp, color: textBlack, fontWeight: FontWeight.normal),
                ),
                CustomTextField(
                  edit: name,
                  type: TextInputType.text,
                ),
                SizedBox(
                  height: h / 60,
                ),
                Text(
                  "Store Address",
                  style: TextStyle(fontSize: 12.sp, color: textBlack, fontWeight: FontWeight.normal),
                ),
                CustomTextField(
                  edit: address,
                  type: TextInputType.text,
                ),
                SizedBox(
                  height: h / 60,
                ),
                CustomTextField(
                  edit: address2,
                  type: TextInputType.text,
                ),
                SizedBox(
                  height: h / 60,
                ),
                Text(
                  "Store Phone Number",
                  style: TextStyle(fontSize: 12.sp, color: textBlack, fontWeight: FontWeight.normal),
                ),
                CustomTextField(
                  edit: address,
                  type: TextInputType.text,
                ),
                Spacer(),
                Container(
                  padding: EdgeInsets.all(15.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Color(0xffe8fcdc)),
                  child: Row(
                    children: [
                      Image.asset(
                        "assets/icons8-question-mark-24.png",
                        height: h / 15,
                        fit: BoxFit.fitHeight,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Text(
                          "Your store information will be \nprinted on the receipt",
                          style: TextStyle(fontSize: 11.sp, color: textBlack, fontWeight: FontWeight.normal),
                        ),
                      ),
                    ],
                  ),
                ),
                Spacer(),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    MainButton(
                      color: Color.fromARGB(255, 104, 234, 108),
                      buttonHeight: h / 14,
                      onTap: () {
                        createFolder();
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Navigation()),
                        );
                      },
                      text: "SAVE",
                      width: w,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        alignment: Alignment.center,
                        child: TextButton(
                          onPressed: () {},
                          child: Text(
                            "Skip",
                            style: TextStyle(fontSize: 12.sp, color: textBlack, fontWeight: FontWeight.normal),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<String> createFolder() async {
    final dir = Directory((Platform.isAndroid
                ? await getExternalStorageDirectory() //FOR ANDROID
                : await getApplicationSupportDirectory() //FOR IOS
            )!
            .path +
        '/img');
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    if ((await dir.exists())) {
      print(dir.path);
      return dir.path;
    } else {
      dir.create();
      print('bvbvfvfv f');
      return dir.path;
    }
  }
}
