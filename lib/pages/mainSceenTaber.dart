import 'package:corona/component/BottomNavBar.dart';
import 'package:corona/pages/account.dart';
import 'package:corona/pages/home.dart';
import 'package:corona/pages/news.dart';
import 'package:corona/utility/ScannerPage.dart';
import 'package:flutter/material.dart';

class MainScreenTaber extends StatefulWidget {
  @override
  _MainScreenTaber createState() => _MainScreenTaber();
}

class _MainScreenTaber extends State<MainScreenTaber> {
  int index = 0;

  List<dynamic> tabs = [
    HomeScreen(
      test: 'home',
    ),
    ScanPage(),
    NewsScreen(),
    AccountScreen(),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Padding(padding: EdgeInsets.only(bottom: 65), child: tabs[index]),
            //start bottom nav bar
            BottomNavBar(
              activeIcon: index,
              size: size,
              context: context,
              onHomePressed: () {
                setState(() {
                  index = 0;
                });
              },
              onWalletPressed: () {
                setState(() {
                  index = 1;
                });
              },
              onFavoritePressed: () {
                setState(() {
                  index = 2;
                });
              },
              onAccountPressed: () {
                setState(() {
                  index = 3;
                });
              },
            ),
            //end bottom nav bar
          ],
        ),
      ),
    );
  }
}
