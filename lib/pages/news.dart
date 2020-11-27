import 'package:corona/component/UpNavBar.dart';
import 'package:corona/pages/firstLaunch/splash.dart';
import 'package:corona/pages/newsDetails.dart';
import 'package:flutter/material.dart';

class NewsScreen extends StatefulWidget {
  final String test;
  NewsScreen({this.test});

  @override
  State<StatefulWidget> createState() {
    return _NewsScreenState();
  }
}

class _NewsScreenState extends State<NewsScreen> {
  List<Map<String, String>> data;
  int status = 0;

  void getData() async {
    await Future.delayed(Duration(milliseconds: 1500));
    data = List<Map<String, String>>();
    setState(() {
      data.add({
        'status': 'data loaded successfully',
        'title': 'خمسةإصابات جديدة',
        'image': 'assets/images/sun boy.jpg',
        'details': 'هذه تفاصيل هذا الخبر وتعليماته'
      });
      data.add({
        'status': 'data loaded successfully',
        'title': 'خبر جديد',
        'image': 'assets/images/sun boy.jpg',
        'details': 'هذه تفاصيل هذا الخبر وتعليماته'
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
                                    ClipRRect(
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(15),
                                          bottomRight: Radius.circular(15)),
                                      child: Image(
                                        image: AssetImage(
                                            'assets/images/sun boy.jpg'),
                                        width: 100,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Expanded(
                                      child: Column(
                                        textDirection: TextDirection.rtl,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            data[index]['title'],
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
                                                          NewsDetailsScreen(
                                                            data: data[index],
                                                          )));
                                            },
                                            child: Text(
                                              'اقرأ المزيد ..',
                                              textDirection: TextDirection.rtl,
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
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
                    iconData: 'assets/icons/notifications.svg',
                    bgColor: Theme.of(context).primaryColor,
                    txtColor: Colors.white,
                    onIconPressed: () {
                      print('notifications pressed');
                    },
                  ),
                ],
              ),
      ),
    );
  }
}
