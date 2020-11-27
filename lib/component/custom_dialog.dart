import 'package:corona/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api_data.dart';


class CustomDialog extends StatefulWidget {
  final String title, body, btn1Text, btn2Tetx,imageTitle;
  final Function onTap1;
  final Function onTap2;

  CustomDialog({ this.title, this.body, this.btn1Text, this.btn2Tetx,this.onTap1,this.onTap2,this.imageTitle});

  @override
  _CustomDialogState createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {

  String currentVersion;
  String newVersion;

  getPref()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    currentVersion = preferences.getString("currentVersion");
    newVersion = preferences.getString("newVersion");
  }

  void initState() {
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15)
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: dialogcontent(context),
    );
  }

  dialogcontent(BuildContext context){
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
            top: 100,
            bottom: 15,
            right: 15,
            left: 15,
          ),
          margin: EdgeInsets.only(top: 15),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0.0,10.0),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                widget.title,
                style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20,),
              Text(
                widget.body,
              ),
              SizedBox(height: 20,),
              Align(
                alignment: Alignment.bottomRight,
                child: Row(
                  children: [
                    FlatButton(
                        onPressed: widget.onTap1,
                        child: Text(widget.btn1Text,)),
                    SizedBox(width: 70,),
                    FlatButton(
                        onPressed: widget.onTap2,
                        child: Text(widget.btn2Tetx)),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 0,
          left: 15,
          right: 15,
          child: CircleAvatar(
              backgroundColor: Color(0xFF2FA05E),
              radius: 50,
              child: Image.asset(widget.imageTitle),
            ),
        )
      ],
    );
  }
}



