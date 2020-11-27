import 'dart:io';
import 'package:corona/component/MySubmitBtn.dart';
import 'package:corona/component/UpNavBar.dart';
import 'package:corona/decoration/MyDecoration.dart';
import 'package:corona/pages/mainSceenTaber.dart';
import 'package:corona/utility/MyImagePicker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image/image.dart' as Img;
import 'package:path_provider/path_provider.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreen createState() => _SignUpScreen();
}

class _SignUpScreen extends State<SignUpScreen> {
  dynamic data;

  double _imageH = 88;
  double _imageW = 88;

  IconData navIcon = Icons.edit;

  //image picker
  File pickedImage;

  //end image picker

  //form builder var
  bool autoValidate = true;
  bool readOnly = false;

  // bool showSegmentedControl = true;
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  var genderOptions = ['male', 'female'];
  TextEditingController _fNameController = TextEditingController();
  TextEditingController _idController = TextEditingController();

  //end form var

  bool isUpdated = true;
  bool _validationError = false;
  int pickCounter = 0;

  Future pickImage({String source}) async {
    PickedFile pic;
    if (source == 'gallary') {
      pic = await ImagePicker().getImage(source: ImageSource.gallery);
    } else {
      pic = await ImagePicker().getImage(source: ImageSource.camera);
    }
    if (pic != null) {
      File pImageFile = File(pic.path);
      Img.Image picTemp = Img.decodeImage(pImageFile.readAsBytesSync());
      Img.Image resizedImg = Img.copyResize(picTemp, width: 200);

      Directory tempDir = await getTemporaryDirectory();
      String tempPath = tempDir.path;
      pickedImage = await File('$tempPath/thumbnail${pickCounter + 1}.jpg')
          .writeAsBytes(Img.encodeJpg(resizedImg), mode: FileMode.write);
      pickCounter++;
      setState(() {});

      print('finish');
    }
  }

  void onEditPressed() {
    setState(() {
      readOnly = false;
      navIcon = Icons.save;
    });
    print('edit');
  }

  void onSavePressed() async {
    var imageResponse;
    var profileResponse;
    if (_fbKey.currentState.saveAndValidate()) {
      showAlert(isUpdated);

      if (pickedImage != null) {
        // write upload image code here
      }

      if (profileResponse.statusCode != 200 && imageResponse != 200) {
        setState(() {
          isUpdated = false;
          Navigator.pop(context);
          showAlert(isUpdated);
        });
        await Future.delayed(Duration(milliseconds: 1500));
      } else {
        if (pickedImage != null) {
          pickedImage.delete();
        }
        isUpdated = true;
        setState(() {
          readOnly = true;
          navIcon = Icons.edit;
          _validationError = false;
        });
        print('saved');
      }
      Navigator.pop(context);
    } else {
      _validationError = true;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void deactivate() {
    super.deactivate();
    pickedImage = null;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        body: SafeArea(
      child: Container(
        child: Stack(
          children: [
            FormBuilder(
              key: _fbKey,
              readOnly: false,
              child: Container(
                height: size.height,
                width: size.width,
                child: ListView(
                  padding: EdgeInsets.symmetric(vertical: 0, horizontal: 40),
                  children: [
                    SizedBox(
                      height: 120,
                    ),
                    Center(
                      child: Stack(
                          alignment: AlignmentDirectional.bottomEnd,
                          children: [
                            Container(
                              height: _imageH,
                              width: _imageW,
                              child: ClipOval(
                                  //clipper: MyClipper(ize: _imageH),
                                  child: pickedImage != null
                                      ? Image(
                                          image: FileImage(pickedImage),
                                          fit: BoxFit.cover,
                                        )
                                      : Image(
                                          image: AssetImage(
                                              'assets/images/logo.png'),
                                        )
//                                              : Image.network(
//                                                  _imageURL,
//                                                  fit: BoxFit.cover,
//                                                  loadingBuilder:
//                                                      (BuildContext context,
//                                                          Widget child,
//                                                          ImageChunkEvent
//                                                              loadingProgress) {
//                                                    if (loadingProgress == null)
//                                                      return child;
//                                                    return Center(
//                                                      child:
//                                                          CircularProgressIndicator(
//                                                        value: loadingProgress
//                                                                    .expectedTotalBytes !=
//                                                                null
//                                                            ? loadingProgress
//                                                                    .cumulativeBytesLoaded /
//                                                                loadingProgress
//                                                                    .expectedTotalBytes
//                                                            : null,
//                                                      ),
//                                                    );
//                                                  },
//                                                ),
//
                                  ),
                            ),
                            GestureDetector(
                              onTap: () {
                                ShowAlertDialog(toDo: pickImage)
                                    .showAlertDialog(context);

                                print('proflile');
                              },
                              child: Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        offset: Offset(0, 3),
                                        blurRadius: 6,
                                      )
                                    ],
                                    color: Color(0xFFF4F8FF),
                                    shape: BoxShape.circle),
                                child: Icon(
                                  Icons.edit,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ]),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    _validationError
                        ? Text(
                            'some fields needed or uncorrect',
                            style: TextStyle(color: Colors.red),
                          )
                        : Container(
                            height: 0,
                            width: 0,
                          ),
                    Container(
                      //width: MediaQuery.of(context).size.width * 0.3,
                      child: FormBuilderTextField(
                        textAlign: TextAlign.right,
                        textDirection: TextDirection.rtl,
                        readOnly: readOnly,
                        attribute: 'fName',
                        controller: _fNameController,
                        validators: [
                          FormBuilderValidators.required(
                              errorText: 'الحقل فارغ')
                        ],
                        decoration: InputDecoration(
                            focusColor: Colors.red,
                            filled: true,
                            fillColor: Color(0xFFEFEFEF),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide: BorderSide(
                                  style: BorderStyle.none, width: 0.0),
                            ),
                            hintText: 'الاسم'),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    FormBuilderTextField(
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.rtl,
                      readOnly: readOnly,
                      keyboardType: TextInputType.number,
                      attribute: 'ID',
                      controller: _idController,
                      validators: [
                        FormBuilderValidators.required(errorText: 'Empty!'),
                        FormBuilderValidators.numeric(),
                        FormBuilderValidators.maxLength(9,
                            errorText: 'Length <= 9'),
                        FormBuilderValidators.minLength(9,
                            errorText: 'Length >= 9')
                      ],
                      decoration: MyDecoration(readOnly: readOnly)
                          .getInputDecoration('رقم الهوية'),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      //width: MediaQuery.of(context).size.width * 0.3,
                      child: FormBuilderTextField(
                        textAlign: TextAlign.right,
                        textDirection: TextDirection.rtl,
                        readOnly: readOnly,
                        attribute: 'city',
                        controller: _fNameController,
                        validators: [
                          FormBuilderValidators.required(
                              errorText: 'الحقل فارغ')
                        ],
                        decoration: InputDecoration(
                            focusColor: Colors.red,
                            filled: true,
                            fillColor: Color(0xFFEFEFEF),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide: BorderSide(
                                  style: BorderStyle.none, width: 0.0),
                            ),
                            hintText: 'المحافظة'),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      //width: MediaQuery.of(context).size.width * 0.3,
                      child: FormBuilderTextField(
                        textAlign: TextAlign.right,
                        textDirection: TextDirection.rtl,
                        readOnly: readOnly,
                        attribute: 'st',
                        controller: _fNameController,
                        validators: [
                          FormBuilderValidators.required(
                              errorText: 'الحقل فارغ')
                        ],
                        decoration: InputDecoration(
                            focusColor: Colors.red,
                            filled: true,
                            fillColor: Color(0xFFEFEFEF),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide: BorderSide(
                                  style: BorderStyle.none, width: 0.0),
                            ),
                            hintText: 'الحي'),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    FormBuilderTextField(
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.rtl,
                      readOnly: readOnly,
                      keyboardType: TextInputType.number,
                      attribute: 'mobile',
                      controller: _idController,
                      validators: [
                        FormBuilderValidators.required(errorText: 'Empty!'),
                        FormBuilderValidators.numeric(),
                        FormBuilderValidators.maxLength(9,
                            errorText: 'Length <= 10'),
                        FormBuilderValidators.minLength(9,
                            errorText: 'Length >= 10')
                      ],
                      decoration: MyDecoration(readOnly: readOnly)
                          .getInputDecoration('رقم الجوال'),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    MySubmitBtn(
                      text: 'حفظ',
                      toDo: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MainScreenTaber()),
                            (r) => false);
                      },
                    ),
                    SizedBox(
                      height: 100,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.27,
            ),

            //start up nav bar
            UpNavBar(
              title: 'مستخدم جديد',
              bgColor: Colors.white,
              txtColor: Colors.black,
            )

            //end up nav Bar
          ],
        ),
      ),
    ));
  }

  void showAlert(isUpdated) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            content: Padding(
              padding: const EdgeInsets.symmetric(vertical: 66),
              child: isUpdated
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        SpinKitThreeBounce(
                          color: Theme.of(context).accentColor,
                          size: 30.0,
                        ),
                        Text('profile updating..'),
                      ],
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(
                          Icons.sms_failed_outlined,
                          color: Colors.red,
                          size: 30.0,
                        ),
                        Text('updating failed'),
                      ],
                    ),
            ),
          );
        });
  }
}
