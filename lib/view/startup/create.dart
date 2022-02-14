import 'dart:io';
import 'package:chat_app/model/account.dart';
import 'package:chat_app/util/users.dart';
import 'package:chat_app/utill/authentication.dart';
import 'package:chat_app/utill/function_utill.dart';
import 'package:chat_app/utill/widget_utills.dart';
import 'package:chat_app/view/startup/start_up.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
class Create extends StatefulWidget {
  const Create({Key key}) : super(key: key);

  @override
  _CreateState createState() => _CreateState();
}

class _CreateState extends State<Create> {
  TextEditingController nameController = TextEditingController();
  TextEditingController userIdController = TextEditingController();
  TextEditingController selfIntroductionController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  File image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:WidetUtils.createAppbar('新規登録'),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          child: Column(
            children: [
              SizedBox(height: 30,),
              GestureDetector(
                onTap: () async{
                  var result = await FunctionUtill.getImageFromGallery();
                    setState(() {
                      image = File(result.path);
                    });
                },
                child: CircleAvatar(
                  foregroundImage: image == null ? null : FileImage(image),
                  radius: 40,
                  child: Icon(Icons.add),
                ),
              ),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: '名前'
                ),
              ),TextField(
                controller: userIdController,
                decoration: InputDecoration(
                    hintText: 'ユーザーID'
                ),
              ),
              TextField(
                controller: selfIntroductionController,
                decoration: InputDecoration(
                    hintText: '自己紹介'
                ),
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                    hintText: 'email'
                ),
              ),
              TextField(
                controller: passController,
                decoration: InputDecoration(
                    hintText: 'パスワード'
                ),
              ),
              ElevatedButton(onPressed: () async{
                if(nameController.text.isNotEmpty && userIdController.text.isNotEmpty && passController.text.isNotEmpty && emailController.text.isNotEmpty){
                  //前の画面に戻る
                  var result = await Authentication.sigunup(email: emailController.text,pass: passController.text);
                  if(result is UserCredential){
                    //画像保存処理
                  String downloadUrl = await FunctionUtill.uploadImg(result.user.uid,image);
                  Account newAccount = Account(
                    id: result.user.uid,
                    name: nameController.text,
                    userId: userIdController.text,
                    self_introduction: selfIntroductionController.text,
                      image_path: downloadUrl
                  );
                  var _result = await UserFireStore.setUser(newAccount);
                  if(_result == true){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => StartUp()));
                  }
                  }
                }
              }, child: Text('アカウント作成'))
            ],
          ),
        ),
      ),
    );
  }
}

