import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class SummeryRow extends StatelessWidget {
  const SummeryRow({super.key, required this.text, required this.onTap, required this.color, required this.text2});
  final String text;
  final String text2;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                text,
                style: TextStyle(fontSize: 9.sp, color: Color.fromARGB(255, 113, 114, 113), fontWeight: FontWeight.normal),
              ),
              Text(
                "\$$text2",
                style: TextStyle(fontSize: 17.sp, color: color, fontWeight: FontWeight.bold),
              )
            ]),
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Icon(
                Icons.arrow_forward_ios_sharp,
                color: Color(0xff6f6f6f),
                size: 19,
              ),
            )
          ],
        ));
  }
}
