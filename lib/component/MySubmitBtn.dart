import 'package:flutter/material.dart';

class MySubmitBtn extends StatelessWidget {
  final String text;
  final Function toDo;

  LinearGradient checkDisability(context) {
    if (toDo == null) {
      return LinearGradient(
        colors: [Color(0xFFEFEFEF), Color(0xFFEFEFEF)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    } else {
      return LinearGradient(
        colors: [Theme.of(context).primaryColor, Theme.of(context).accentColor],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    }
  }

  double checkShadow(context) {
    if (toDo == null) {
      return 0;
    } else {
      return 5;
    }
  }

  MySubmitBtn({this.text, this.toDo});
  @override
  Widget build(Object context) {
    return MaterialButton(
      child: Container(
        height: 58,
        width: 260,
        decoration: BoxDecoration(
//          boxShadow: [
//            BoxShadow(
//              color: Theme.of(context).primaryColor,
//              offset: Offset(0.0, checkShadow(context)),
//              blurRadius: checkShadow(context),
//            )
//          ],
          borderRadius: BorderRadius.circular(30),
          color: Theme.of(context).primaryColor
          //gradient: checkDisability(context),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
          ),
        ),
      ),
      onPressed: toDo,
    );
  }
}
