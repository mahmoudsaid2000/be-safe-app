import 'package:shared_preferences/shared_preferences.dart';

class Storge{
  Storge(this.key,);
  String key;

  savePref(String input)async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(key, input);
    print(preferences.getString(key));
  }
  saveList(List<String> list)async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setStringList(key, list);
  }


}