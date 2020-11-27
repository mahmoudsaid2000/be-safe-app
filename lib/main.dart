import 'package:connectivity/connectivity.dart';
import 'package:corona/pages/firstLaunch/boardingAndRegister.dart';
import 'package:corona/pages/mainSceenTaber.dart';
import 'package:corona/pages/notification.dart';
import 'package:corona/pages/storge_data.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'component/api_data.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:corona/pages/notificationDetails.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'Cairo',
        primaryColor: Color(0xFF2FA05E),
        accentColor: Color(0xFF00DB75),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'خليك بأمان'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int theFirstRun;
  String phone;

  Future<Data> _response;

  void checkLaunchTime(String token) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    phone = preferences.getString("phoneNumber");
    // var ifConnected = await Connectivity().checkConnectivity();
    if (!preferences.containsKey('firstLaunch')) {
      theFirstRun = 0;
    } else {
      theFirstRun = int.parse(preferences.getString('firstLaunch'));
    }
  }
//  String number;
//  String id;
//  send()async {
//    SharedPreferences preferences = await SharedPreferences.getInstance();
//    List<String> listScanIn = preferences.getStringList("listScanIn");
//    List<String> listTimeIn = preferences.getStringList("listTimeIn");
//    if (listScanIn != null) {
//      number = preferences.getString("phoneNumber");
//      id = preferences.getString("id");
//      Data(number: number, id: id).sendFirebase(listScanIn, listTimeIn);
//      preferences.remove("listScanIn");
//      preferences.remove("listTimeIn");
//    }
//  }

  String _homeScreenText = "waiting for token..";

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  List<Map<String, dynamic>> data;

  String token1;
  @override
  void initState() {
    super.initState();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        NotificationScreen().setData(message);
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: message['title'],
                content: message['text'],
                actions: [
                  FlatButton(
                      onPressed: () {
                        setState(() {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      NotificationDetailsScreen(
                                        data: message,
                                      )));
                        });
                      },
                      child: Text('رؤية الاشعار')),
                ],
              );
            });
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('onlunch works !');
        var nData = message['data']['screen'];
        var view = nData['view'];
        if (view == 'direct') {}
      },
      onResume: (Map<String, dynamic> message) async {
        print('onresume works !');
        var nData = message['data'];
        var view = nData['view'];
        if (view == 'direct') {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => NotificationScreen()));
        }
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(
            sound: true, badge: true, alert: true, provisional: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      checkLaunchTime(token);
      setState(() {
        _homeScreenText = "Push Messaging token: $token";
      });
      print(_homeScreenText);
    });

    _firebaseMessaging.getToken().then((token) {
      update(token);
    });
  }

  update(String token) {
    print("token api:$token");
    token1 = token;
    setState(() {
      _response = Data(token: token, number: phone).sendToken();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Directionality(
          textDirection: TextDirection.rtl,
          child: theFirstRun == 0
              ? BoardingScreen(
                  context: context,
                )
              : MainScreenTaber()),
    );
  }
}
