import 'package:flutter/material.dart';

class MyDecoration {
  final bool readOnly;
  MyDecoration({this.readOnly});
  InputDecoration getInputDecoration(hintText) {
    return InputDecoration(
        filled: true,
        fillColor: readOnly ? Color(0x11CB4594) : Color(0xFFEFEFEF),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(style: BorderStyle.none, width: 0.0),
        ),
        hintText: hintText);
  }
}
