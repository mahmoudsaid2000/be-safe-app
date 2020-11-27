import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class UpNavBar extends StatelessWidget {
  final Function onBackPressed;
  final Function onIconPressed;
  final String title;
  final String iconData;
  final Color bgColor;
  final Color txtColor;

  UpNavBar(
      {this.title,
      this.iconData,
      this.onBackPressed,
      this.onIconPressed,
      this.bgColor,
      this.txtColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: AlignmentDirectional.bottomCenter,
      padding: EdgeInsets.only(top: 20, right: 25, left: 25),
      width: MediaQuery.of(context).size.width,
      height: 76,
      decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          )),
      child: Row(
        textDirection: TextDirection.rtl,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          onBackPressed == null
              ? Container(
                  width: 25,
                )
              : GestureDetector(
                  child: Container(
                      width: 50,
                      height: 50,
                      color: bgColor,
                      padding: EdgeInsets.all(12),
                      child: Icon(Icons.arrow_forward_ios_rounded,
                          textDirection: TextDirection.rtl, color: txtColor)),
                  onTap: onBackPressed,
                ),
          title == null
              ? Container()
              : Text(
                  title,
                  style: TextStyle(
                      color: txtColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w700),
                ),
          onIconPressed == null
              ? Container(
                  width: 25,
                )
              : GestureDetector(
                  child: Container(
                    width: 50,
                    height: 50,
                    child: Stack(
                      alignment: AlignmentDirectional.topEnd,
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          color: bgColor,
                          padding: EdgeInsets.all(12),
                          child: SvgPicture.asset(
                            iconData,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(2),
                          //alignment: Alignment.topCenter,
                          decoration: BoxDecoration(
                              color: bgColor, shape: BoxShape.circle),
                          child: Container(
                            padding: EdgeInsets.all(5),
                            //alignment: Alignment.topCenter,
                            decoration: BoxDecoration(
                                //color: Color(0xFFFF2D55),
                                color: Theme.of(context).accentColor,
                                shape: BoxShape.circle),
                            child: Text(
                              '2',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  onTap: onIconPressed,
                ),
        ],
      ),
    );
  }
}
