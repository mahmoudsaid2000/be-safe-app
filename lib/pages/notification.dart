import 'package:corona/component/UpNavBar.dart';
import 'package:corona/pages/firstLaunch/splash.dart';
import 'package:corona/pages/notificationDetails.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {


  List<Map<String, String>> data;

  void setData(Map<String, String> message){
    data.add({
      'title': message['title'],
      'details': message['text'],
    });
    print("added");
  }

  @override
  State<StatefulWidget> createState() {
    return _NotificationScreenState(data: data);
  }
}

class _NotificationScreenState extends State<NotificationScreen> {
  int status = 0;

  _NotificationScreenState({this.data});
  List<Map<String, dynamic>> data;

  void getData() async {
    await Future.delayed(Duration(milliseconds: 1500));
//    data = List<Map<String, String>>();
    setState(() {
      data.add({
        'status': 'data loaded successfully',
        'title': 'خمسةإصابات جديدة',
        'image': 'assets/images/sun boy.jpg',
        'details': 'هذه تفاصيل هذا الخبر وتعليماته',
      });
      data.add({
        'status': 'data loaded successfully',
        'title': 'تعليمات جديدة',
        'image': 'assets/images/board1.png',
        'details': 'هذه تفاصيل هذا الخبر وتعليماته',
      });
    });
    print(data[0]);
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: data == null
            ? SplashScreen()
            : Stack(
                alignment: Alignment.topCenter,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 100,
                        ),
                        Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              return Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 10),
                                margin: EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black12,
                                          offset: Offset(0, 3),
                                          blurRadius: 6)
                                    ]),
                                child: Row(
                                  textDirection: TextDirection.rtl,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        textDirection: TextDirection.rtl,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            data[0]['title'],
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700),
                                            textAlign: TextAlign.right,
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          NotificationDetailsScreen(
                                                            data: data[index],
                                                          )));
                                            },
                                            child: Text(
                                              data[index]['details'],
                                              textDirection: TextDirection.rtl,
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          '20:05 pm',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                        Container(
                                          width: 50,
                                          height: 50,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              color: Colors.redAccent),
                                          child: Icon(
                                            Icons.notifications,
                                            size: 40,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  UpNavBar(
                    title: 'الاشعارات',
                    bgColor: Theme.of(context).primaryColor,
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
