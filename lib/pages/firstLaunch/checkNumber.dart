import 'package:corona/pages/mainSceenTaber.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'dart:async';
import 'package:flutter/services.dart';

class CheckNumberScreen extends StatefulWidget {
  @override
  _CheckNumberScreen createState() => _CheckNumberScreen();
}

class _CheckNumberScreen extends State<CheckNumberScreen> {
  bool hasError = false;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  String currentCode;
  StreamController<ErrorAnimationType> errorController;
  FocusNode _focusNode = FocusNode();
  final pinController = TextEditingController();

  @override
  void initState() {
    super.initState();
    errorController = StreamController<ErrorAnimationType>();
  }

  @override
  void dispose() {
    errorController.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      key: scaffoldKey,
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
                    'أدخل الكود الذي وصلك من الرسالة',
                    textAlign: TextAlign.right,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Form(
                    key: formKey,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 10),
                      child: PinCodeTextField(
                          backgroundColor: Colors.white10,
                          focusNode: _focusNode,
                          autoFocus: true,
                          controller: pinController,
                          errorAnimationController: errorController,
                          keyboardType: TextInputType.number,
                          textStyle: TextStyle(
                              height: 1.5,
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                          enableActiveFill: true,
                          pinTheme: PinTheme(
                            shape: PinCodeFieldShape.circle,
                            //borderRadius: BorderRadius.circular(10),
                            fieldHeight: 55,
                            fieldWidth: 55,
                            //borderWidth: null,
                            //disabledColor: Colors.grey,
                            activeFillColor: hasError
                                ? Colors.redAccent
                                : Theme.of(context).primaryColor,
                            inactiveFillColor: Color(0xFFeeeeee),
                            selectedFillColor: Theme.of(context).accentColor,
                            selectedColor: Theme.of(context).accentColor,
                            activeColor: hasError
                                ? Colors.redAccent
                                : Theme.of(context).primaryColor,
                            inactiveColor:
                                hasError ? Colors.redAccent : Color(0xFFeeeeee),
                          ),
                          appContext: context,
                          length: 4,
                          onChanged: (value) {
                            print('changed');
                            setState(() {
                              hasError = false;
                              currentCode = value;
                            });
                          },
                          onCompleted: (value) {
                            formKey.currentState.validate();
                            if (value != '1234') {
                              errorController.add(ErrorAnimationType
                                  .shake); // Triggering error shake animation
                              setState(() {
                                hasError = true;
                              });
                            } else {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MainScreenTaber()));
                            }
                          }),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Text(
                      hasError ? "الكود خاطئ" : "",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          color: Colors.redAccent,
                          fontSize: 12,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  Text(
                    'إعادة الإرسال بعد 10 ثواني',
                    textAlign: TextAlign.right,
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
