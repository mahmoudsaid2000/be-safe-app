import 'package:corona/component/api_data.dart';
import 'package:corona/pages/firstLaunch/checkNumber.dart';
import 'package:corona/component/MySubmitBtn.dart';
import 'package:flutter/material.dart';
import 'package:international_phone_input/international_phone_input.dart';
import 'storge_data.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreen createState() => _SignInScreen();
//  String phone = _SignInScreen().phoneNumber;
}

class _SignInScreen extends State<SignInScreen> {
  String phoneNumber;
  String phoneIsoCode;
  bool visible = false;
  String confirmedNumber = '';
  Future<Data> _numData ;

  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> loginUser(String phone,BuildContext context)async{
    _auth.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: Duration(seconds: 60),
        verificationCompleted: (AuthCredential credential)async{
          var result = _auth.signInWithCredential(credential);
          

        },
        verificationFailed: null,
        codeSent: null,
        codeAutoRetrievalTimeout: null,
    );
  }

  void onPhoneNumberChange(
      String number, String internationalizedPhoneNumber, String isoCode) {
    print(number);
    print(internationalizedPhoneNumber);
    if (internationalizedPhoneNumber != '') {
      setState(() {
        phoneNumber = number;
        phoneIsoCode = isoCode;
        visible = true;
        _numData = Data(number: number).checkIn();
        Storge("phoneNumber").savePref(number);
      });
    } else {
      setState(() {
        visible = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(top: 40),
              alignment: AlignmentDirectional.center,
              height: size.height * 0.23,
              child: Image(
                image: AssetImage('assets/images/logo.png'),
              ),
            ),
            SizedBox(
              height: 70,
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20.0),
                children: [
                  Text(
                    'أهلاً بك في تطبيق خليك بأمان',
                    textAlign: TextAlign.right,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InternationalPhoneInput(
                    onPhoneNumberChange: onPhoneNumberChange,
                    initialSelection: '+970',
                    //enabledCountries: ['+233', '+1'],
                    labelText: "رقم الجوال",
                    hintText: 'eg. 0591010858',
                    errorText: 'أدخل رقم جوال صحيح',
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Visibility(
                    child: MySubmitBtn(
                      text: 'تحقق من رقم الجوال',
                      toDo: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CheckNumberScreen()));
                      },
                    ),
                    visible: visible,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
