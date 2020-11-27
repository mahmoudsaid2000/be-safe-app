import 'dart:io';
import 'package:corona/component/MySubmitBtn.dart';
import 'package:corona/component/UpNavBar.dart';
import 'package:corona/component/api_data.dart';
import 'package:corona/decoration/MyDecoration.dart';
import 'package:corona/pages/mainSceenTaber.dart';
import 'package:corona/utility/MyImagePicker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image/image.dart' as Img;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'notification.dart';
import 'storge_data.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class UpdateUserScreen extends StatefulWidget {
  @override
  _UpdateUserScreen createState() => _UpdateUserScreen();
}

class _UpdateUserScreen extends State<UpdateUserScreen> {
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
  TextEditingController _lNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _idController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _regionController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();


  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();


  Future<Data> _numValue ;
  Future<Data> _idValue ;
  Future<Data> _nameValue ;

  String nameData;
  String cityData;
  String regionData;
  String id;
  String number;

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

  getPref()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    cityData = preferences.getString("city");
    regionData = preferences.getString("region");
    nameData = preferences.getString("name");
    id = preferences.getString("id");
    number = preferences.getString("phoneNumber");
    print(cityData );
    print(regionData);
    print(nameData);
    print(id);
    print(number);
  }

  void setInitialData() async {
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      data = {
        'first_name': nameData==null?'':nameData,
        'last_name': '',
        'phoneNumber': number==null?'':number,
        'email': '',
        'id': id==null?'':id,
        'birthday': '2020-08-01',
        'nationality_name': 'palestine',
        'gender': 'male',
        'avatar_url': '',
        'city' : cityData==null?'':cityData,
        'region' : regionData==null?'':regionData,
      };
      _fNameController.text = data['first_name'];
      _lNameController.text = data['last_name'];
      _emailController.text = data['email'];
      _idController.text = data['id'];
      _cityController.text = data['city'];
      _regionController.text = data['region'];
      _mobileController.text = data['phoneNumber'];
    });
  }

  @override
  void initState() {
    super.initState();
    setInitialData();
    getPref();
   // initializing();
  }

  @override
  void deactivate() {
    super.deactivate();
    pickedImage = null;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;


    final _firestore = FirebaseFirestore.instance;


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
                  FormBuilder(
                    key: _fbKey,
                    readOnly: false,
                    child: Container(
                      height: size.height,
                      width: size.width,
                      child: ListView(
                        padding:
                            EdgeInsets.symmetric(vertical: 0, horizontal: 50),
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
                                                    'assets/images/account.png'),
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
                            height: 55,
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
                          Container(
                            height: 55,                            child: FormBuilderTextField(
                              textAlign: TextAlign.right,
                              textDirection: TextDirection.rtl,
                              readOnly: readOnly,
                              keyboardType: TextInputType.number,
                              attribute: 'ID',
                              controller: _idController,
                              validators: [
                                FormBuilderValidators.required(
                                    errorText: 'Empty!'),
                                FormBuilderValidators.numeric(),
                                FormBuilderValidators.maxLength(9,
                                    errorText: 'Length <= 9'),
                                FormBuilderValidators.minLength(9,
                                    errorText: 'Length >= 9')
                              ],
                              decoration: MyDecoration(readOnly: readOnly)
                                  .getInputDecoration('رقم الهوية'),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Container(
                            height: 55,
                            //width: MediaQuery.of(context).size.width * 0.3,
                            child: FormBuilderTextField(
                              textAlign: TextAlign.right,
                              textDirection: TextDirection.rtl,
                              readOnly: readOnly,
                              attribute: 'city',
                              controller: _cityController,
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
                            height: 55,
                            //width: MediaQuery.of(context).size.width * 0.3,
                            child: FormBuilderTextField(
                              textAlign: TextAlign.right,
                              textDirection: TextDirection.rtl,
                              readOnly: readOnly,
                              attribute: 'region',
                              controller: _regionController,
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
                          Container(
                            height: 55,
                            child: FormBuilderTextField(
                              textAlign: TextAlign.right,
                              textDirection: TextDirection.rtl,
                              readOnly: readOnly,
                              keyboardType: TextInputType.number,
                              attribute: 'mobile',
                              controller: _mobileController,
                              validators: [
                                FormBuilderValidators.required(
                                    errorText: 'الحقل فارغ'),
                                FormBuilderValidators.numeric(),
                                FormBuilderValidators.maxLength(9,
                                    errorText: 'Length <= 10'),
                                FormBuilderValidators.minLength(9,
                                    errorText: 'Length >= 10')
                              ],
                              decoration: MyDecoration(readOnly: readOnly)
                                  .getInputDecoration('رقم الجوال'),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          MySubmitBtn(
                            text: 'حفظ',
                            toDo: () {

                              _firebaseMessaging.getToken().then((token){
                                _firestore.collection('tokens').add({
                                  'id': _idController.text,
                                  'phone_number' : _mobileController.text,
                                  'token' : token,
                                });
                              });
                              setState(() {
                                Storge("phoneNumber").savePref(_mobileController.text);
                                Storge("id").savePref(_idController.text);
                                Storge("name").savePref(_fNameController.text);
                                Storge("city").savePref(_cityController.text);
                                Storge("region").savePref(_regionController.text);

                              });
                              Navigator.pop(context);

//                              Navigator.pushAndRemoveUntil(
//                                  context,
//                                  MaterialPageRoute(
//                                      builder: (context) => MainScreenTaber()),
//                                  (r) => false);
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
                    title: 'تعديل بياناتك',
                    bgColor: Theme.of(context).primaryColor,
                    txtColor: Colors.white,
                    onBackPressed: () {
                      Navigator.pop(context);
                    },
                  ),
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
