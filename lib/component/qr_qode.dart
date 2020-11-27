import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrImageData extends StatelessWidget {
  QrImageData({@required this.status});

  Color color;
  int status;

  Color getColor(int status){
    if(status==0){
      color = Colors.green;
    }else if(status==1){
      color = Colors.orangeAccent;
    }else{
      color = Colors.redAccent;
    }
    return color;
  }
  final String qrData = "https://githup.com/neon97";
  @override
  Widget build(BuildContext context) {
    return QrImage(data: qrData,size: 200.0,foregroundColor: getColor(status));
  }
}