import 'package:flutter/material.dart';

class ShowAlertDialog {
  Function toDo;
  ShowAlertDialog({this.toDo});

  showAlertDialog(BuildContext context) {
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text('make a choice'),
      content: SingleChildScrollView(
        child: ListBody(
          children: [
            GestureDetector(
              onTap: () {
                toDo(source: 'gallary');
                Navigator.of(context).pop();
              },
              child: Text('Gallary'),
            ),
            Divider(),
            GestureDetector(
              onTap: () {
                toDo(source: 'camera');
                Navigator.of(context).pop();
              },
              child: Text('Camera'),
            )
          ],
        ),
      ),
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
