import 'package:flutter/material.dart';

import 'package:sizer/sizer.dart';

import '../../color/colors.dart';

class HomeButton extends StatefulWidget {

  final IconData icon;
  final bool button;

  const HomeButton({Key? key, required this.icon,  required this.button}) : super(key: key);

  @override
  _HomeButtonState createState() => _HomeButtonState();
}

class _HomeButtonState extends State<HomeButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool tap = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(microseconds: 200),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 1.0,
      end: 0.7,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
    _controller.repeat(
      reverse: true,
      period: Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return GestureDetector(
 
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
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Transform.scale(
              scale: _animation.value,
              child: widget.button
                  ? CircleAvatar(
                      child: Icon(
                        Icons.event_note_outlined,
                      ),
                    )
                  : Container());
        },
        // child: widget.text,
      ),
    );
  }
}
