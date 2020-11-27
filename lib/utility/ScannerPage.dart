import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:barcode_scan/barcode_scan.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:corona/component/MySubmitBtn.dart';
import 'package:corona/component/UpNavBar.dart';
import 'package:corona/component/api_data.dart';
import 'package:corona/pages/storge_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity/connectivity.dart';
import 'package:corona/component/custom_dialog.dart';

class ScanPage extends StatefulWidget {
  @override
  _ScanPage createState() => _ScanPage();
}

class _ScanPage extends State<ScanPage> {
  String codeResult = 'أعد المحاولة';
  bool isComplete = false;
  String id;
  String placeSub = '';
  String place = '';
  bool firstRun = true;
  Future<Data> _scanValue ;
  String place_id;
  String place_id2;
  String checkSub;
  String personSub;
  String number;
  String comma;
  List<String> listScanIn = ["0"];
  List<String> listScanOut = ["0"];
  List<String> listTimeIn = ["0"];
  List<String> listTimeOut = ["0"];
  String name='';
  String city='';
  String region='';
  String status;
  String id1='';
  String phone='';
  String type;
  bool showMessage = false;
  bool ifOwner = false;

  Data person = new Data();

  getPref()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    id = preferences.getString("id");
    number = preferences.getString("phoneNumber");
    type = preferences.getString('userType');
    if(!preferences.containsKey("placeId")){
      showMessage = true;
    }else{
      place_id2 = preferences.getString("placeId");
    }
    if(preferences.containsKey("listScanIn")){
      listScanIn = preferences.getStringList("listScanIn");
    }
    if(preferences.containsKey("ListTimeIn")){
      listTimeIn = preferences.getStringList("ListTimeIn");
    }
    if(preferences.containsKey("listScanOut")){
      listScanOut = preferences.getStringList("listScanOut");
      listTimeOut = preferences.getStringList("listTimeOut");
    }
    print(id);
    print(number);
  }

  void show(String details,int a){
    id1 = details.substring(0,9);
    print(id1);
    for (int i = a; i < details.length; i++) {
      if(details.substring(i,i+1)==','){
        name = details.substring(a,i);
        a = i+1;
        print(name);
        break;
      }
    }
    for (int i = a; i < details.length; i++) {
      if(details.substring(i,i+1)==','){
        phone = details.substring(a,i);
        a = i+1;
        print(phone);
        break;
      }
    }
    for (int i = a; i < details.length; i++) {
      if(details.substring(i,i+1)==','){
        city = details.substring(a,i);
        a = i+1;
        print(city);
        break;
      }
    }
    for (int i = a; i < details.length; i++) {
      if(details.substring(i,i+1)==','){
        region = details.substring(a,i);
        a = i+1;
        print(region);
        break;
      }
    }
  }
  void scanOwner()async{
    String codeScanner = await BarcodeScanner.scan();
    place_id = codeScanner.substring(2,8);

  }

    void startScan() async {
    try {
      String codeScanner = await BarcodeScanner.scan();
      var ifConnected = await Connectivity().checkConnectivity();
      if (codeScanner != null) {
        comma = codeScanner.substring(8,9);
        personSub =  codeScanner.substring(9,10);
        if(comma==','){
          String currentTime = DateTime.now().toString();
          print(currentTime.toString());
          print(codeScanner);
          // print(codeScanner.substring(0,1)as int);
          setState(() async{
            codeResult = codeScanner;
            isComplete = true;
            placeSub = codeScanner.substring(9);
            place = placeSub;
            place_id = codeScanner.substring(2,8);
            checkSub =  codeScanner.substring(0,1);
            if(checkSub=='1'){
                if(ifConnected== ConnectivityResult.wifi || ifConnected == ConnectivityResult.mobile) {
                //_scanValue = Data(id: id, number: number, scanData: place_id,checkin_time: currentTime).checkIn();
                Data(id: id, number: number,scanData: place_id).sendSingle(currentTime);
                print('check: ''$checkSub');
                print("done check in!");
              }else {
                listScanIn.add(place_id);
                listScanIn.add(currentTime);
                Storge("listScanIn").saveList(listScanIn);
                print("saved checkin!");
              }
              if(showMessage){
                SharedPreferences preferences = await SharedPreferences.getInstance();
                preferences.setString("placeId", place_id);
              }
            }else{
              if(ifConnected== ConnectivityResult.wifi || ifConnected == ConnectivityResult.mobile) {
                _scanValue = Data(id: id, number: number, scanData: place_id).checkOut();
                print("done check out !");
                print('check: ''$checkSub');
              }else {
                listScanOut.add(place_id);
                Storge("listScanOut").saveList(listScanOut);
                listTimeOut.add(currentTime);
                Storge("ListTimeOut").saveList(listTimeOut);
                print("saved checkout!");
              }
            }
          });
        }else if(personSub == ','){
          isComplete = true;
          show(codeScanner,10);
          http.Response response =  await http.post(
            'http://www.coronagaza.site/health_status',
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, String>{
              'person_id' : id1,
            }),
          );
          if (response.statusCode == 200) {
            Map<String,dynamic> y = json.decode(response.body);
            status = y["status"];
            print("Status is $status");
          }
          print(person.status);
          print("status $status");
          String currentTime = DateTime.now().toString();
          Data(id: id1, number: phone,scanData: place_id2).sendSingle(currentTime);

        }else{
          codeResult = 'الرجاء مسح الكود المطلوب';
          isComplete = false;
        }
      }else{
        setState(() {
          codeResult = '';
          isComplete = false;
        });
      }

      //Navigator.pop(context, qrCodeResult);
    } catch (e) {
      print(BarcodeScanner.CameraAccessDenied);
      //we can print that user has denied for the permisions
      //BarcodeScanner.UserCanceled;   we can print on the page that user has cancelled
    }
    setState(() {
      firstRun = false;
    });
  }

  @override
  void initState() {
    super.initState();
    startScan();
    getPref();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SafeArea(
          child: Stack(
            children: [
              Column(
                children: <Widget>[
                  UpNavBar(
                    title: 'نتيجة ماسح الكود',
                    txtColor: Colors.white,
                    bgColor: Theme.of(context).primaryColor,
                  ),
                  SizedBox(height: 20,),
                  isComplete
                      ? Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(20),
                          width: 138,
                          height: 138,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(100),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black12,
                                    offset: Offset(0, 3),
                                    blurRadius: 6)
                              ]),
                          child: SvgPicture.asset(
                            'assets/icons/done.svg',
                            height: 75,
                          ),
                        ),
                        SizedBox(height: 20,),
                        if(checkSub =='1')
                          Text(
                            'أهلاً بك في',
                            //   :'رافقتك السلامة',
                            style: TextStyle(),
                            textAlign: TextAlign.center,
                          ),
                        if(checkSub =='1')
                          Text(
                            place,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        if(checkSub =='1')
                          Text(
                            'تم تسجيل دخولك بنجاح',
                            //:'تم تسجيل خروجك بنجاح',
                            style: TextStyle(color: Colors.red),
                            textAlign: TextAlign.center,
                          ),
                        if(personSub==',')
                          Text(name,
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        if(personSub==',')
                          if(status=='healthy')Text(
                            'سليم',
                            style: TextStyle(color:Colors.green,fontSize: 20, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        if(personSub==',')
                          if(status=='infected')Text(
                            'مصاب',
                            style: TextStyle(color:Colors.redAccent,fontSize: 20, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        if(personSub==',')
                          if(status=='in_contact')Text(
                            'مخالط',
                            style: TextStyle(color:Colors.redAccent,fontSize: 20, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),

                        if(personSub==',')
                          Text(city,
                            textAlign: TextAlign.center,
                          ),
                        if(personSub==',')
                          Text(region,
                            textAlign: TextAlign.center,
                          ),
                        SizedBox(height: 20,),
                        MySubmitBtn(
                          text: 'تسجيل دخول آخر',
                          toDo: () {
                            checkSub = ' ';
                            startScan();
                          },
                        ),
                        SizedBox(height: 10,),
                        if(type=='1')
                          if(checkSub=='1')
                            if(showMessage)
                              MySubmitBtn(
                                text: 'مسح كود المكان الخاص بك',
                                toDo: () {
                                  startScan();
                                },
                              ),
                      ],
                    ),
                  )
                      : Expanded(
                    flex: 4,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 30,
                        ),
                        firstRun
                            ? Container()
                            : Icon(
                          Icons.sms_failed_rounded,
                          color: Colors.red,
                          size: 100.0,
                        ),
                        Text(codeResult, style: TextStyle(fontSize: 20)),
                        SizedBox(

                          height: 35,
                        ),

                        Expanded(
                          flex : 1,
                          child: MySubmitBtn(
                            text: 'امسح كود',
                            toDo: () {
                              startScan();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

//its quite simple as that you can use try and catch statements too for platform exception

  Widget showAlert(){
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            content:
                Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(20),
                        width: 138,
                        height: 138,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(100),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black12,
                                  offset: Offset(0, 3),
                                  blurRadius: 6)
                            ]),
                        child: SvgPicture.asset(
                          'assets/images/logo.bng',
                          height: 75,
                        ),
                      ),
                    ],
                  ),
          );
        });
  }
}
