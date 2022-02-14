
import 'package:chat_app/util/firebase.dart';
import 'package:chat_app/util/shaered_prefs.dart';
import 'package:chat_app/view/acount/acount.dart';
import 'package:chat_app/view/startup/start_up.dart';
import 'package:chat_app/view/time_line/screen.dart';
import 'package:chat_app/view/time_line/time_line.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'pages/top_page.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // await SharedPrefs.setInstance();
  // checkAccount();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:StartUp(),
    );
  }
}

Future<void> checkAccount() async{
  // String? uid = '';
  final String uid =  await SharedPrefs.getUid();
  print(uid);
  if(uid == '') {
    Firestore.addUser();
  }else{

  }
}
