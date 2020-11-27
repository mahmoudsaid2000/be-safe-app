import 'package:corona/component/MySubmitBtn.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:ui';
import 'package:flutter/rendering.dart';

class GeneratePage extends StatefulWidget {
  final String qrData;
  GeneratePage({this.qrData});
  @override
  _GeneratePageState createState() => _GeneratePageState();
}

class _GeneratePageState extends State<GeneratePage> {
  String qrData;
//  _GeneratePageState({this.qrData});

  @override
  Widget build(BuildContext context) {
    print(widget.qrData);
    return Scaffold(
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            IconButton(
              padding: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: MediaQuery.of(context).size.height * 0.07,
              ),
              icon: Icon(
                Icons.keyboard_backspace,
                size: 30,
                color: Colors.black,
              ),
              onPressed: () async {
                FocusScope.of(context).unfocus();
                Navigator.pop(context);
              },
            ),
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Generate QR',
                      style: TextStyle(
                          color: Colors.black45,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'your QR code is ready',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black45,
                          fontSize: 16,
                          fontStyle: FontStyle.normal),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 80,
            ),
            Center(
              child: QrImage(
                size: 250,
                //plce where the QR Image will be shown
                data: widget.qrData,
              ),
            ),
            SizedBox(
              height: 50.0,
            ),
            Center(
              child: MySubmitBtn(
                text: 'done',
                toDo: () {
                  Navigator.pop(context);
                },
              ),
            ),
//            Text(
//              "New QR Link Generator",
//              style: TextStyle(fontSize: 20.0),
//            ),
//            TextField(
//              controller: qrdataFeed,
//              decoration: InputDecoration(
//                hintText: "Input your link or data",
//              ),
//            ),
//            Padding(
//              padding: EdgeInsets.fromLTRB(40, 20, 40, 0),
//              child: FlatButton(
//                padding: EdgeInsets.all(15.0),
//                onPressed: () async {
//                  if (qrdataFeed.text.isEmpty) {
//                    //a little validation for the textfield
//                    setState(() {
//                      qrData = "";
//                    });
//                  } else {
//                    setState(() {
//                      qrData = qrdataFeed.text;
//                    });
//                  }
//                },
//                child: Text(
//                  "Generate QR",
//                  style: TextStyle(
//                      color: Colors.blue, fontWeight: FontWeight.bold),
//                ),
//                shape: RoundedRectangleBorder(
//                    side: BorderSide(color: Colors.blue, width: 3.0),
//                    borderRadius: BorderRadius.circular(20.0)),
//              ),
//            )
          ],
        ),
      ),
    );
  }

  final qrdataFeed = TextEditingController();
}
