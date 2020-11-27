import 'package:corona/pages/storge_data.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';


class Data {
  Data({this.scanData,this.name,this.number,this.id,this.token, this.checkin_time,this.checkout_time});
   String scanData;
   String name;
   String number;
   String id;
   String token;
   String checkin_time;
   String checkout_time;
   String status;


  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      scanData: json['place_id'],
      name: json['name'],
      number: json['mobile_num'],
      id: json['person_id'],
      checkin_time: json['checkin_time'],
      checkout_time: json['checkout_time'],

    );
  }
  Future<Data> checkIn() async{
    http.Response response =  await http.post(
    'http://www.coronagaza.site/checkin',
    headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
    'place_id':scanData,
    'mobile_num': number,
    'person_id' : id,
    'checkin_time': checkin_time,
    }),
    );

    if (response.statusCode == 201) {
      return Data.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create album.');
    }
  }

  Future<Data> checkOut() async{
    http.Response response =  await http.post(
      'http://www.coronagaza.site/checkout',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'place_id': scanData,
        'mobile_num': number,
        'person_id' : id,
        'checkout_time': checkout_time,
      }),
    );

    if (response.statusCode == 201) {
      return Data.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create album.');
    }
  }


  Future<String> getVersion()async {
    http.Response response = await http.get(
     Uri.encodeFull("http://www.coronagaza.site/version"),
      headers:{
       "Accept": "application/json"
      }
    );
    List data = json.decode(response.body);
    String version = data[0]["version"];
    Storge("version").savePref(version);

//    if (response.statusCode == 200) {
//      return String.fromCharCode(json.decode(response.body));
//    } else {
//      throw Exception('Failed to create album.');
//    }
  }

  Future<Data> sendToken() async{
    http.Response response =  await http.post(
      'http://www.coronagaza.site/firebase/user/add',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'mobile_num': number,
        'person_id' : id,
        'token' : token,
      }),
    );

    if (response.statusCode == 201) {
      return Data.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create album.');
    }
  }

  Future<Data> getUpdate() async{
    http.Response response =  await http.post(
      'http://www.coronagaza.site/app',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 201) {
      return Data.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create album.');
    }
  }


  sendChekcin(List<String>list){

    for(int i=0;i<list.length;i++){
      Future<Data> _scanValue = test(list[i]);
    }


  }

  Future<Data> test(String data) async{
    http.Response response =  await http.post(
      'http://www.coronagaza.site/checkin',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'place_id': data,
        'mobile_num': number,
        'person_id' : id,
        'checkin_time': checkin_time,
      }),
    );

    if (response.statusCode == 201) {
      return Data.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create album.');
    }
  }
  sendFirebase(List<String>listScan){
    final firestore = FirebaseFirestore.instance;
    for(int i=1;i<listScan.length;i++) {
      if( i%2 != 0){
        firestore.collection('check_in').add({
          'id_person':id,
          'id_place': listScan[i],
          'phone_number':number,
          'time_checkin': listScan[i+1],
        });
        print("send firebase works !");
      }
      }
  }

  sendSingle(String time){
    final firestore = FirebaseFirestore.instance;
    firestore.collection('check_in').add({
      'id_person':id,
      'id_place':scanData,
      'phone_number':number,
      'time_checkin': time,
    });
    print("sendSingle firebase works !");

  }

  Future<Data> checkStatus() async{
    http.Response response =  await http.post(
      'http://www.coronagaza.site/health_status',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
//        'place_id':scanData,
//        'mobile_num': number,
        'person_id' : '1111',
//        'checkin_time': checkin_time,
      }),
    );
    int s = response.statusCode;
    print("response status:$s");
    String x = response.body;
    print("response result:$x");
    if (response.statusCode == 200) {
      Map<String,dynamic> y = json.decode(response.body);
      status = y["status"];
      print("Status is $status");
      setStatus(y["status"]);
      return Data.fromJson(json.decode(response.body));
    }else {
      throw Exception('Failed to create album.');
    }
  }
 void setStatus(String s){
    status = s;
 }
String getStatus(){
    return status;
}

}
