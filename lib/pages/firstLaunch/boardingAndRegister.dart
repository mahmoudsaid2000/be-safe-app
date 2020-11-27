import 'package:corona/pages/firstLaunch/chooseUserType.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BoardingScreen extends StatelessWidget {
  final BuildContext context;
  BoardingScreen({this.context});

  List<PageViewModel> getPages() {
    return [
      getBoardItem(
          imgSrc: 'assets/images/board1.png',
          txt: 'استخدام الماسح الضوئي للدخول للأماكن العامة'),
      getBoardItem(
          imgSrc: 'assets/images/board2.png', txt: 'احمي نفسك واحمي عائلتك'),
      getBoardItem(
          imgSrc: 'assets/images/board3.png',
          txt: 'يداً بيد من أجل سلامتنا جميعاً'),
    ];
  }

  PageViewModel getBoardItem({String imgSrc, String txt}) {
    Size size = MediaQuery.of(context).size;
    return PageViewModel(
      titleWidget: Container(
        padding: EdgeInsets.only(top: 40),
        alignment: AlignmentDirectional.center,
        height: size.height * 0.23,
        child: Image(
          image: AssetImage('assets/images/logo.png'),
        ),
      ),
      bodyWidget: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        height: size.height * 0.6,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Image(
                image: AssetImage(imgSrc),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              txt,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
      decoration: const PageDecoration(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      globalBackgroundColor: Colors.white,
      pages: getPages(),
      showNextButton: true,
      showSkipButton: true,
      skip: Text("تخطي"),
      done: Text("تم "),
      onDone: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('firstLaunch', '1');

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => ChooseUserTypeScreen()),
            (route) => false);
      },
    );
  }
}
