

import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static SharedPreferences prefs;

  static Future<void> setInstance() async{
    if(prefs == null){
      prefs = await SharedPreferences.getInstance();
    }
  }
  static Future<void> setUid(newUllid) async{
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('uid', newUllid);
      // await prefs.setString('ulid', '1');
  }

  static Future getUid() async{
    final prefs = await SharedPreferences.getInstance();
    final String uid = prefs.getString('uid');
    return  uid;
  }
}
