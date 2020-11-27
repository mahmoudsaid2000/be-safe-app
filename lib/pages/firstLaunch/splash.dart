import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
            image: AssetImage('assets/images/logo.png'),
            width: 150,
          ),
          SizedBox(
            height: 20,
          ),
          SpinKitThreeBounce(
            color: Colors.green,
            size: 30,
          ),
        ],
      ),
    );
  }
}
