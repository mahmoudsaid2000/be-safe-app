import 'package:corona/component/AccountElement.dart';
import 'package:corona/pages/updateUser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
class AccountScreen extends StatefulWidget {
  @override
  _AccountScreen createState() => _AccountScreen();
}

class _AccountScreen extends State<AccountScreen> {
  List<Map<String, String>> data;
  int status = 0;
  bool value = true;
  int type;
  var cityData = 'غزة';
  var regionData = 'غزة';
  var nameData = 'مستخدم جديد';
  var governorate = 'غزة';
  getPref()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    cityData = preferences.getString("city");
    regionData = preferences.getString("region");
    governorate = preferences.getString("governorate");
    nameData = preferences.getString("name");
    print(cityData );
    print(regionData);
    print(nameData);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    type = int.parse(prefs.getString('userType'));

  }

  void getData() async {
    await Future.delayed(Duration(milliseconds: 1500));
    data = List<Map<String, String>>();
    setState(() {
      data.add({
        'status': 'data loaded successfully',
        'fName': nameData==null ? 'مستخدم جديد' : nameData,
        'address': cityData==null||regionData==null?'غزة-غزة':'$cityData-$regionData',
        'placeAddress': cityData==null||governorate==null ?'غزة-غزة':'$cityData-$governorate',
        'avatar_url': ''
      });
    });
    print(data[0]);
  }

  @override
  void initState() {
    getData();
    getPref();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: SafeArea(
            child: data == null
                ? Center(
                    child: SpinKitThreeBounce(
                      color: Theme.of(context).accentColor,
                      size: 30.0,
                    ),
                  )
                : Container(
                    child: Stack(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 0, horizontal: size.width * 0.075),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 30,
                              ),
//                              Text(
//                                'My Account',
//                                //textAlign: TextAlign.start,
//                                style: TextStyle(
//                                    color: Color(0xFF2E3748),
//                                    fontSize: 25,
//                                    fontWeight: FontWeight.bold),
//                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Center(
                                child: Column(
                                  children: [
                                    Container(
                                      height: 88,
                                      width: 88,
                                      child: ClipOval(
                                        //clipper: MyClipper(ize: _imageH),
                                        child: data[0]['avatar_url'] == ''
                                            ? Image(
                                                image: AssetImage(
                                                    'assets/images/account.png'),
                                              )
                                            : Image.network(
                                                data[0]['avatar_url'],
                                                fit: BoxFit.cover,
                                                loadingBuilder:
                                                    (BuildContext context,
                                                        Widget child,
                                                        ImageChunkEvent
                                                            loadingProgress) {
                                                  if (loadingProgress == null)
                                                    return child;
                                                  return Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                      value: loadingProgress
                                                                  .expectedTotalBytes !=
                                                              null
                                                          ? loadingProgress
                                                                  .cumulativeBytesLoaded /
                                                              loadingProgress
                                                                  .expectedTotalBytes
                                                          : null,
                                                    ),
                                                  );
                                                },
                                              ),
//
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      '${data[0]['fName']}',
                                      style: TextStyle(
                                          color: Color(0xFF2E3748),
                                          fontSize: 25,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    Text(
                                      type==0
                                      ?'${data[0]['address']}'
                                      :'${data[0]['placeAddress']}',
                                      style: TextStyle(
                                          color: Color(0xFF9FA5BB),
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: ListView(
//                      padding: EdgeInsets.symmetric(
//                          vertical: 0, horizontal: size.width * 0.075),
                                  children: [
                                    AccountElement(
                                      size: size,
                                      icon: Icons.account_circle_outlined,
                                      title: 'تعديل المعلومات الشخصية',
                                      toDo: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  UpdateUserScreen(),
                                            ));
                                      },
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    notificationElement(
                                      size: size,
                                      icon: Icons.notifications_outlined,
                                      title: 'الاشعارات',
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    AccountElement(
                                      toDo: () {},
                                      size: size,
                                      icon: Icons.phone_android_outlined,
                                      title: 'أرقام التواصل',
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    AccountElement(
                                      size: size,
                                      icon: Icons.playlist_add_check,
                                      title: 'حول التطبيق',
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
//                                    AccountElement(
//                                      size: size,
//                                      icon: Icons.logout,
//                                      title: 'تسجيل الخروج',
//                                      toDo: () async {
//                                        SharedPreferences prefs =
//                                            await SharedPreferences
//                                                .getInstance();
//                                        prefs.remove('firstLaunch');
//
//                                        Navigator.pop(context);
//                                      },
//                                    ),
                                    SizedBox(
                                      height: 130,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )));
  }

  Widget notificationElement({size, icon, title, subtitle, level, toDo}) {
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
            Expanded(child: Container()),
            Switch(
                value: value,
                onChanged: (v) {
                  setState(() {
                    value = v;
                  });
                })
          ],
        ),
      ),
    );
  }
}
