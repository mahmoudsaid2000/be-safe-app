import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BottomNavBar extends StatelessWidget {
  final Size size;
  final BuildContext context;
  final Function onHomePressed;
  final Function onWalletPressed;
  final Function onCartPressed;
  final Function onFavoritePressed;
  final Function onAccountPressed;
  final int activeIcon;

//  onHomePressed() => Navigator.push(
//      context, MaterialPageRoute(builder: (context) => HomeScreen()));
//  onWalletPressed() => Navigator.push(
//      context, MaterialPageRoute(builder: (context) => MyActivityScreen()));
//  onCartPressed() => Navigator.push(
//      context, MaterialPageRoute(builder: (context) => CartScreen()));
//  onFavoritePressed() => Navigator.push(
//      context, MaterialPageRoute(builder: (context) => FavoriteScreen()));
//  onAccountPressed() => Navigator.push(
//      context, MaterialPageRoute(builder: (context) => AccountScreen()));

  BottomNavBar(
      {this.size,
      this.context,
      this.activeIcon,
      this.onHomePressed,
      this.onCartPressed,
      this.onAccountPressed,
      this.onFavoritePressed,
      this.onWalletPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: AlignmentDirectional.bottomCenter,
      height: size.height,
      width: size.width,
      child: Stack(alignment: AlignmentDirectional.bottomCenter, children: [
        //layer 1 with ro of icons
        Container(
          padding: EdgeInsets.only(bottom: 15, left: 15, right: 15),
          width: MediaQuery.of(context).size.width,
          height: 65,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              )),
          child: Row(
            textDirection: TextDirection.rtl,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                child: Container(
                  padding: EdgeInsets.only(top: 15),
                  color: Colors.white,
                  width: 50,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SvgPicture.asset(
                        'assets/icons/home.svg',
                        color: activeIcon == 0
                            ? Theme.of(context).accentColor
                            : Colors.grey,
                      ),
                      activeIcon == 0
                          ? Container(
                              width: 4,
                              height: 4,
                              decoration: BoxDecoration(
                                  color: Theme.of(context).accentColor,
                                  shape: BoxShape.circle),
                            )
                          : Container(),
                    ],
                  ),
                ),
                onTap: onHomePressed,
              ),
              GestureDetector(
                child: Container(
                  padding: EdgeInsets.only(top: 15),
                  color: Colors.white,
                  width: 50,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SvgPicture.asset(
                        'assets/icons/scanner.svg',
                        color: activeIcon == 1
                            ? Theme.of(context).accentColor
                            : Colors.grey,
                      ),
                      activeIcon == 1
                          ? Container(
                              width: 4,
                              height: 4,
                              decoration: BoxDecoration(
                                  color: Theme.of(context).accentColor,
                                  shape: BoxShape.circle),
                            )
                          : Container()
                    ],
                  ),
                ),
                onTap: onWalletPressed,
              ),
              GestureDetector(
                child: Container(
                  padding: EdgeInsets.only(top: 15),
                  color: Colors.white,
                  width: 50,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SvgPicture.asset(
                        'assets/icons/news.svg',
                        color: activeIcon == 2
                            ? Theme.of(context).accentColor
                            : Colors.grey,
                      ),
                      activeIcon == 2
                          ? Container(
                              width: 4,
                              height: 4,
                              decoration: BoxDecoration(
                                  color: Theme.of(context).accentColor,
                                  shape: BoxShape.circle),
                            )
                          : Container()
                    ],
                  ),
                ),
                onTap: onFavoritePressed,
              ),
              GestureDetector(
                child: Container(
                  padding: EdgeInsets.only(top: 15),
                  color: Colors.white,
                  width: 50,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SvgPicture.asset(
                        'assets/icons/user.svg',
                        color: activeIcon == 3
                            ? Theme.of(context).accentColor
                            : Colors.grey,
                      ),
                      activeIcon == 3
                          ? Container(
                              width: 4,
                              height: 4,
                              decoration: BoxDecoration(
                                  color: Theme.of(context).accentColor,
                                  shape: BoxShape.circle),
                            )
                          : Container()
                    ],
                  ),
                ),
                onTap: onAccountPressed,
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
