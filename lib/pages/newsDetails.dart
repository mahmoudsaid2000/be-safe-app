import 'package:corona/component/UpNavBar.dart';
import 'package:flutter/material.dart';

class NewsDetailsScreen extends StatelessWidget {
  final Map<String, String> data;
  NewsDetailsScreen({this.data});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      Image(
                        image: AssetImage('assets/images/sun boy.jpg'),
                        width: size.width,
                        fit: BoxFit.fitWidth,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned.fill(
              child: Align(
                alignment: AlignmentDirectional.bottomCenter,
                child: Container(
                  padding: EdgeInsets.only(top: 20, right: 20, left: 20),
                  alignment: AlignmentDirectional.center,
                  width: size.width,
                  height: size.height * 0.6,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(30),
                          topLeft: Radius.circular(30))),
                  child: Column(
                    children: [
                      Text(
                        data['title'],
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(data['details']),
                    ],
                  ),
                ),
              ),
            ),
            UpNavBar(
              //bgColor: Colors.white,
              txtColor: Colors.white,
              onBackPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
