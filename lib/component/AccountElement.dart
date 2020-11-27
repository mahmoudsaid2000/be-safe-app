import 'package:flutter/material.dart';

class AccountElement extends StatelessWidget {
  final Size size;
  final IconData icon;
  final String title;
  final String subtitle;
  final String level;
  final Function toDo;

  AccountElement(
      {this.size, this.icon, this.title, this.subtitle, this.level, this.toDo});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: toDo,
      child: Container(
        padding: EdgeInsets.only(left: 10, right: 20),
        height: 54,
        width: size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          textDirection: TextDirection.rtl,
          children: [
            Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                  color: Color(0xFFF4F8FF), shape: BoxShape.circle),
              child: Icon(icon),
            ),
            SizedBox(
              width: 17,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                      color: Color(0xFF2E3748),
                      fontSize: 12,
                      fontWeight: FontWeight.w500),
                ),
                subtitle == null
                    ? Container(
                        width: 0,
                        height: 0,
                      )
                    : Text(
                        subtitle,
                        style: TextStyle(
                            color: Color(0xFF9FA5BB),
                            fontSize: 12,
                            fontWeight: FontWeight.w500),
                      ),
              ],
            ),
            level == null
                ? Container(
                    width: 0,
                    height: 0,
                  )
                : Expanded(
                    child: Text(
                      '$level \$',
                      textAlign: TextAlign.end,
                      style: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
