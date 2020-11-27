import 'package:connectivity/connectivity.dart';
import 'package:corona/component/UpNavBar.dart';
import 'package:corona/component/api_data.dart';
import 'package:corona/component/custom_dialog.dart';
import 'package:corona/component/qr_qode.dart';
import 'package:corona/pages/firstLaunch/splash.dart';
import 'package:corona/pages/notification.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class HomeScreen extends StatefulWidget {
  final String test;

  HomeScreen({this.test});

  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, String>> data;
  int status = 0;
  int type;
  Color color;
  Future<Data> _scanValue ;
  final firestore = FirebaseFirestore.instance;

  getPref()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    nameData = preferences.getString("name");
    id = preferences.getString("id");
    scanData = preferences.getString("scanResult");
    governorate = preferences.getString("governorate");
    placeName = preferences.getString("placeName");
    number = preferences.getString("phoneNumber");
    print('name:''$nameData');
    print('id:''$id');
    print('scanData:''$scanData');
  }

  var x;
  getStatus()async{
//   final x =await firestore.collection('status').get();
//    for(var m in x.docs)
//      print(m.data());
  await for(var s in firestore.collection('status').snapshots()){
    for(var m in s.docs)
      print(m.data());
  }

   stream(){
    StreamBuilder<QuerySnapshot>(
      stream: firestore.collection('status').snapshots(),
      builder: (context,snapshot){
        if(snapshot.hasData){
          final m = snapshot.data.docs;
          List<Text> ms =[];
          for(var m in ms){
            final mt = m;
          }
        }
        return Text('');
      },
    );
  }
  }


  checkNetwork() async {
    print("network check !");
    var ifConnected = await (Connectivity().checkConnectivity());
      SharedPreferences preferences = await SharedPreferences.getInstance();
      List<String> listScanIn = preferences.getStringList("listScanIn");
        //List<String> listTimeIn = preferences.getStringList("listTimeIn");
        if(listScanIn != null){
          print("scan in not null !");
          //Data(number: number,id: id).sendChekcin(listScanIn);
          if(ifConnected == ConnectivityResult.wifi ||ifConnected == ConnectivityResult.mobile){
            Data(number:number,id:id).sendFirebase(listScanIn);
            preferences.remove("listScanIn");
            // preferences.remove("listTimeIn");
            print("removed in!");
            print("sent to check in!");
          }
        }else{
          print("list is null !");
        }
      if(preferences.containsKey("listScanOut")){
        List<String> listScanOut = preferences.getStringList("listScanOut");
        List<String> listTimeOut = preferences.getStringList("listTimeOut");
        if(listScanOut != null){

          for(int i=1; i < listScanOut.length; i++) {
            _scanValue = Data(id:id, number: number, scanData: listScanOut[i],checkout_time: listTimeOut[i]).checkOut();
            print("sent out :$i");
          }
          preferences.remove("listScanOut");
          preferences.remove("listTimeOut");
          print("removed Out!");
          print("sent to check out!");
        }
      }else{
          print("list out is null !!");
      }
  }

  String nameData ;
  String scanData;
  String number;
  String id;
  String governorate;
  String placeName;

  String checkinTime;
  String checkoutTime;

  void getData() async {
    await Future.delayed(Duration(milliseconds: 1500));
    data = List<Map<String, String>>();
    setState(() {
      data.add({
        'status': 'data loaded successfully',
        'fName': nameData==null ?' مستخدم جديد':nameData,
        'avatar_url': ''
      });
    });
    print(data[0]);
  }


  void getUserType() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    type = int.parse(preferences.getString('userType'));
  }


  bool version;

  checkVersion() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String currentVersion;
    String newVersion = '1.0';
    // preferences.getString("newVersion");
    if(!preferences.containsKey("currentVersion")){
      currentVersion = '1.0';
    }else {
      currentVersion = preferences.getString("currentVersion");
    }


    if(currentVersion != newVersion){
      version = true;
    }else
      version = false;
  }

  bool getVersion(){
    return this.version;
  }


  @override
  void initState() {
    super.initState();
    getPref();
    checkNetwork();
    getData();
    getUserType();
    checkVersion();
    //initializing();
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
                        Row(
                          textDirection: TextDirection.rtl,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              height: 46,
                              width: 46,
                              child: ClipOval(
                                child: data[0]['avatar_url'] == ''
                                    ? Image(
                                        image: AssetImage(
                                            'assets/images/account.png'),
                                      )
                                    : Image.network(
                                        data[0]['avatar_url'],
                                        fit: BoxFit.cover,
                                        loadingBuilder: (BuildContext context,
                                            Widget child,
                                            ImageChunkEvent loadingProgress) {
                                          if (loadingProgress == null)
                                            return child;
                                          return Center(
                                            child: CircularProgressIndicator(
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
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            RichText(
                              text: TextSpan(
                                text: 'أهلاُ بك ',
                                style: DefaultTextStyle.of(context).style,
                                children: <TextSpan>[
                                  TextSpan(
                                      text: '${data[0]['fName']}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 50,
                        ),
//                        Row(
//                          textDirection: TextDirection.rtl,
//                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                          children: [
//                            Container(
//                              height: 105,
//                              width: 105,
//                              padding: EdgeInsets.all(10),
//                              decoration: BoxDecoration(
//                                  color: Colors.white,
//                                  borderRadius: BorderRadius.circular(15),
//                                  boxShadow: [
//                                    BoxShadow(
//                                        color: Colors.black12,
//                                        offset: Offset(0, 3),
//                                        blurRadius: 6)
//                                  ]),
//                              child: Column(
//                                mainAxisAlignment:
//                                    MainAxisAlignment.spaceAround,
//                                children: [
//                                  SvgPicture.asset('assets/images/rVirus.svg'),
//                                  Text(
//                                    'إجمالي الحالات',
//                                    style: TextStyle(
//                                        color: Colors.red,
//                                        fontSize: 12,
//                                        fontWeight: FontWeight.w700),
//                                    textAlign: TextAlign.center,
//                                  ),
//                                  Text(
//                                    '20',
//                                    style: TextStyle(
//                                      color: Colors.red,
//                                    ),
//                                  )
//                                ],
//                              ),
//                            ),
//                            Container(
//                              height: 105,
//                              width: 105,
//                              padding: EdgeInsets.all(10),
//                              decoration: BoxDecoration(
//                                  color: Colors.white,
//                                  borderRadius: BorderRadius.circular(15),
//                                  boxShadow: [
//                                    BoxShadow(
//                                        color: Colors.black12,
//                                        offset: Offset(0, 3),
//                                        blurRadius: 6)
//                                  ]),
//                              child: Column(
//                                mainAxisAlignment:
//                                    MainAxisAlignment.spaceAround,
//                                children: [
//                                  SvgPicture.asset(
//                                    'assets/images/gVirus.svg',
//                                  ),
//                                  Text(
//                                    'حالات اليوم',
//                                    style: TextStyle(
//                                        color: Theme.of(context).primaryColor,
//                                        fontSize: 12,
//                                        fontWeight: FontWeight.w700),
//                                    textAlign: TextAlign.center,
//                                  ),
//                                  Text(
//                                    '20',
//                                    style: TextStyle(
//                                      color: Theme.of(context).primaryColor,
//                                    ),
//                                  )
//                                ],
//                              ),
//                            ),
//                            Container(
//                              height: 105,
//                              width: 105,
//                              padding: EdgeInsets.all(10),
//                              decoration: BoxDecoration(
//                                  color: Colors.white,
//                                  borderRadius: BorderRadius.circular(15),
//                                  boxShadow: [
//                                    BoxShadow(
//                                        color: Colors.black12,
//                                        offset: Offset(0, 3),
//                                        blurRadius: 6)
//                                  ]),
//                              child: Column(
//                                mainAxisAlignment:
//                                    MainAxisAlignment.spaceAround,
//                                children: [
//                                  SvgPicture.asset('assets/images/virus.svg'),
//                                  Text(
//                                    'إجمالي الوفيات',
//                                    style: TextStyle(
//                                        fontSize: 12,
//                                        fontWeight: FontWeight.w700),
//                                    textAlign: TextAlign.center,
//                                  ),
//                                  Text('20')
//                                ],
//                              ),
//                            ),
//                          ],
//                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Expanded(
                          child: ListView(
                            shrinkWrap: true,
                            children: [
                              type == 0
                                  ? Container()
//                                    Container(
//                                      padding: EdgeInsets.symmetric(
//                                          horizontal: 15, vertical: 10),
//                                      height: 120,
//                                      decoration: BoxDecoration(
//                                          color: Colors.white,
//                                          borderRadius:
//                                              BorderRadius.circular(15),
//                                          boxShadow: [
//                                            BoxShadow(
//                                                color: Colors.black12,
//                                                offset: Offset(0, 3),
//                                                blurRadius: 6)
//                                          ]),
//                                      child: Column(
//                                        crossAxisAlignment:
//                                            CrossAxisAlignment.end,
//                                        children: [
//                                          Padding(
//                                            padding: const EdgeInsets.only(left:175.0),
//                                            child: Text(
//                                              'حالتي الصحية',
//                                              textAlign: TextAlign.right,
//                                              style: TextStyle(
//                                                  fontSize: 16,
//                                                  fontWeight: FontWeight.w700),
//                                            ),
//                                          ),
//                                          SizedBox(
//                                            height: 10,
//                                          ),
//                                          Row(
//                                            textDirection: TextDirection.rtl,
//                                            mainAxisAlignment:
//                                                MainAxisAlignment.spaceAround,
//                                            children: [
//                                              Column(
//                                                children: [
//                                                  Container(
//                                                    height: 25,
//                                                    width: 53,
//                                                    decoration: BoxDecoration(
//                                                      color: status == 0
//                                                          ? Colors.green
//                                                          : Colors.grey,
//                                                      borderRadius:
//                                                          BorderRadius.circular(
//                                                              15),
//                                                    ),
//                                                  ),
//                                                  Text(
//                                                    'سليم',
//                                                    style: TextStyle(
//                                                        color: status == 0
//                                                            ? Colors.green
//                                                            : Colors.grey,
//                                                        fontSize: 12,
//                                                        fontWeight:
//                                                            FontWeight.w700),
//                                                    textAlign: TextAlign.center,
//                                                  ),
//                                                  status == 0
//                                                      ? Container(
//                                                          padding:
//                                                              EdgeInsets.only(
//                                                                  top: 10),
//                                                          height: 5,
//                                                          width: 5,
//                                                          decoration:
//                                                              BoxDecoration(
//                                                            color: status == 0
//                                                                ? Colors.green
//                                                                : Colors.grey,
//                                                            borderRadius:
//                                                                BorderRadius
//                                                                    .circular(
//                                                                        15),
//                                                          ),
//                                                        )
//                                                      : Container()
//                                                ],
//                                              ),
//                                              Column(
//                                                children: [
//                                                  Container(
//                                                    height: 25,
//                                                    width: 53,
//                                                    decoration: BoxDecoration(
//                                                      color: status == 1
//                                                          ? Colors.orangeAccent
//                                                          : Colors.grey,
//                                                      borderRadius:
//                                                          BorderRadius.circular(
//                                                              15),
//                                                    ),
//                                                  ),
//                                                  Text(
//                                                    'مخالط',
//                                                    style: TextStyle(
//                                                        color: status == 1
//                                                            ? Colors
//                                                                .orangeAccent
//                                                            : Colors.grey,
//                                                        fontSize: 12,
//                                                        fontWeight:
//                                                            FontWeight.w700),
//                                                    textAlign: TextAlign.center,
//                                                  ),
//                                                  status == 1
//                                                      ? Container(
//                                                          padding:
//                                                              EdgeInsets.only(
//                                                                  top: 10),
//                                                          height: 5,
//                                                          width: 5,
//                                                          decoration:
//                                                              BoxDecoration(
//                                                            color: status == 1
//                                                                ? Colors
//                                                                    .orangeAccent
//                                                                : Colors.grey,
//                                                            borderRadius:
//                                                                BorderRadius
//                                                                    .circular(
//                                                                        15),
//                                                          ),
//                                                        )
//                                                      : Container()
//                                                ],
//                                              ),
//                                              Column(
//                                                children: [
//                                                  Container(
//                                                    height: 25,
//                                                    width: 53,
//                                                    decoration: BoxDecoration(
//                                                      color: status == 2
//                                                          ? Colors.redAccent
//                                                          : Colors.grey,
//                                                      borderRadius:
//                                                          BorderRadius.circular(
//                                                              15),
//                                                    ),
//                                                  ),
//                                                  Text(
//                                                    'مصاب',
//                                                    style: TextStyle(
//                                                        color: status == 2
//                                                            ? Colors.redAccent
//                                                            : Colors.grey,
//                                                        fontSize: 12,
//                                                        fontWeight:
//                                                            FontWeight.w700),
//                                                    textAlign: TextAlign.center,
//                                                  ),
//                                                  status == 2
//                                                      ? Container(
//                                                          padding:
//                                                              EdgeInsets.only(
//                                                                  top: 10),
//                                                          height: 5,
//                                                          width: 5,
//                                                          decoration:
//                                                              BoxDecoration(
//                                                            color: status == 2
//                                                                ? Colors
//                                                                    .redAccent
//                                                                : Colors.grey,
//                                                            borderRadius:
//                                                                BorderRadius
//                                                                    .circular(
//                                                                        15),
//                                                          ),
//                                                        )
//                                                      : Container()
//                                                ],
//                                              ),
//                                            ],
//                                          ),
//                                        ],
//                                      ),
//                                    )
                                  : Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 10),
                                      height: 120,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.black12,
                                                offset: Offset(0, 3),
                                                blurRadius: 6)
                                          ]),
                                      child: Row(
                                        textDirection: TextDirection.rtl,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Image(
                                            image: AssetImage(
                                              'assets/images/logo.png',
                                            ),
                                            width: 120,
                                          ),
                                          Text(
                                            placeName != null
                                            ?placeName
                                            :'',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Row(
                                            textDirection: TextDirection.rtl,
                                            children: [
                                              Icon(
                                                Icons.trending_up,
                                                color: Theme.of(context)
                                                    .accentColor,
                                              ),
                                              Text('21/40',
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontWeight:
                                                          FontWeight.bold))
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                              SizedBox(
                                height: 40,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 15),
                                    child: QrImageData(status:status),
                                    decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 50,
                              ),
                            ],
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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NotificationScreen()));
                    },
                  ),
                  if(getVersion()==true)
                    CustomDialog(title: "تحديث جديد",body: "الرجا تحديث التطبيق",btn1Text: "تحديث",btn2Tetx: "لاحقا",imageTitle: 'assets/images/downlod.png',)
                ],
              ),
      ),
    );
  }

}

