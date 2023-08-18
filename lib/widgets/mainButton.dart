import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../color/colors.dart';

class MainButton extends StatefulWidget {
  const MainButton({super.key, required this.text, required this.onTap, required this.buttonHeight, required this.width,required this.color});
  final String text;
  final VoidCallback onTap;
  final double buttonHeight;
  final double width;
  final Color color;

  @override
  State<MainButton> createState() => _MainButtonState();
}

class _MainButtonState extends State<MainButton> {
  bool tap = false;
  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return InkWell(
      borderRadius: BorderRadius.circular(15),
      onTapDown: (_) {
        setState(() {
          tap = true;
        });
      },
      onSecondaryTapDown: (_) {
        setState(() {
          tap = true;
        });
      },
      onSecondaryTapUp: (_) {
        setState(() {
          tap = false;
        });
      },
      onTapUp: (_) {
        setState(() {
          tap = false;
        });
      },
      onTapCancel: () {
        setState(() {
          tap = false;
        });
      },
      onTap: widget.onTap,
      mouseCursor: MouseCursor.defer,
      child: AnimatedOpacity(
        opacity: tap ? 0.2 : 1,
        duration: Duration(milliseconds: 60),
        child: Container(
            alignment: Alignment.center,
            height: widget.buttonHeight,
            width: widget.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: widget.color
            ),
            child: FittedBox(
              child: Text(
                widget.text,
                style: TextStyle(fontSize: 15.sp, color: textBlack),
              ),
            )),
      ),
    );
  }
}
