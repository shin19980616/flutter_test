import 'package:chat_app/util/users.dart';
import 'package:chat_app/utill/authentication.dart';
import 'package:chat_app/view/startup/create.dart';
import 'package:chat_app/view/time_line/screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class StartUp extends StatefulWidget {
  const StartUp({Key key}) : super(key: key);

  @override
  _StartUpState createState() => _StartUpState();
}

class _StartUpState extends State<StartUp> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passContoroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Container(
        width: double.infinity,
        child: Column(
          children: [
            Text('flutter labo sns'),
            Container(
              child: TextField(
                controller: emailController,
                decoration: InputDecoration(hintText: 'email'),
              ),
            ),
            Container(
                child: TextField(
              controller: passContoroller,
              decoration: InputDecoration(hintText: 'password'),
            )),
            RichText(
              text: TextSpan(
                style: TextStyle(color: Colors.black),
                children: [
                  TextSpan(
                    text: 'アカウント作成していない方はこちら ',
                  ),
                  TextSpan(
                    text: 'こちら',
                    style: TextStyle(color: Colors.blue),
                    recognizer: TapGestureRecognizer()..onTap = ()
                    {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Create()));
                    }
                    ),
                ],
              ),
            ),
            ElevatedButton(onPressed: () async{
              var result = await Authentication.siginin(email: emailController.text,pass: passContoroller.text);
              if(result is UserCredential){
                var result_user = await UserFireStore.getUser(result.user.uid);
                if(result_user == true){
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Screen()));
                }
              }
            }, child: Text('emailでログイン'))
          ],
        ),

      ),
    ));
  }
}
