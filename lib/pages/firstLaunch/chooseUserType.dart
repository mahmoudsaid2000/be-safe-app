import 'package:corona/component/MySubmitBtn.dart';
import 'package:corona/pages/firstLaunch/signUpPlace.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

import '../signIn.dart';

class ChooseUserTypeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(top: 40),
              alignment: AlignmentDirectional.center,
              height: size.height * 0.23,
              child: Image(
                image: AssetImage('assets/images/logo.png'),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              height: size.height * 0.6,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Image(
                      image: AssetImage('assets/images/userType.png'),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  MySubmitBtn(
                    text: 'مستخدم',
                    toDo: () async {
                      SharedPreferences preferences =
                          await SharedPreferences.getInstance();
                      await preferences.setString('userType', '0');
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignInScreen()));
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  MySubmitBtn(
                    text: 'صاحب مكان',
                    toDo: () async {
                      SharedPreferences preferences =
                          await SharedPreferences.getInstance();
                      await preferences.setString('userType', '1');

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignUpPlaceScreen()));
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
