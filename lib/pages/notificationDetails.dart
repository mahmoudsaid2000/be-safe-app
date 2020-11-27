import 'package:corona/component/MySubmitBtn.dart';
import 'package:corona/component/UpNavBar.dart';
import 'package:flutter/material.dart';

class NotificationDetailsScreen extends StatelessWidget {
  final Map<String, String> data;
  NotificationDetailsScreen({this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  SizedBox(
                    height: 67,
                  ),
                  Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        Image(
                          image: AssetImage('assets/images/info.png'),
                          width: 200,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          data['details'],
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w700),
                          textAlign: TextAlign.right,
                        ),
//                        Text(
//                          data['details'],
//                          style: TextStyle(
//                              fontSize: 14, fontWeight: FontWeight.w700),
//                          textAlign: TextAlign.right,
//                        ),
//                        Text(
//                          data['details'],
//                          style: TextStyle(
//                              fontSize: 14, fontWeight: FontWeight.w700),
//                          textAlign: TextAlign.right,
//                        ),
                        SizedBox(
                          height: 20,
                        ),
//                        MySubmitBtn(
//                          text: 'حجز مسحة',
//                          toDo: () {},
//                        ),
                        SizedBox(
                          height: 50,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            UpNavBar(
              title: 'التعليمات',
              bgColor: Colors.white,
              txtColor: Colors.black,
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
