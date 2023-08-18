import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({super.key, required this.edit, required this.type});
  final TextEditingController edit;
  final TextInputType type;

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    return SizedBox(
      height: h / 15,
      child: TextField(
        controller: edit,
        keyboardType: type,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          enabledBorder:
              OutlineInputBorder(borderRadius: BorderRadius.circular(20.0), borderSide: BorderSide(color: Color.fromARGB(255, 120, 125, 120))),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0), borderSide: BorderSide(color: Colors.green)),
          filled: true,
          hintStyle: TextStyle(color: Colors.grey[800]),
          fillColor: Colors.white70,
        ),
      ),
    );
  }
}
