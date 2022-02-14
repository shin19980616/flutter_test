import 'dart:io';

import 'package:chat_app/utill/function_utill.dart';
import 'package:chat_app/utill/widget_utills.dart';
import 'package:chat_app/view/time_line/screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

import 'acount.dart';
class EditAccount extends StatefulWidget {
  const EditAccount({Key key}) : super(key: key);

  @override
  _EditAccountState createState() => _EditAccountState();
}

class _EditAccountState extends State<EditAccount> {
  //マイアカウント取得
  Account myAccount = Authentication.myAccount;

  TextEditingController nameController = TextEditingController();
  TextEditingController userIdController = TextEditingController();
  TextEditingController selfIntroductionController = TextEditingController();
  File image;
  ImageProvider getImage(){
    if(image == null){
      return NetworkImage(myAccount.image_path);
    }else{
      return FileImage(image);
    }
  }
  @override
  void initState(){
    super.initState();
    nameController = TextEditingController(text: myAccount.name);
    userIdController = TextEditingController(text:myAccount.userId);
    selfIntroductionController = TextEditingController(text: myAccount.self_introduction);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidetUtils.createAppbar('編集画面'),
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
                  foregroundImage:getImage(),
                  radius: 40,
                  child: Icon(Icons.add),
                ),
              ),
             TextField(
                controller: userIdController,
                decoration: InputDecoration(
                    hintText: 'ユーザーID'
                ),
              ),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                    hintText: '名前'
                ),
              ),
              TextField(
                controller: selfIntroductionController,
                decoration: InputDecoration(
                    hintText: '自己紹介'
                ),
              ),
              ElevatedButton(onPressed: () async{
                if(userIdController.text.isNotEmpty && selfIntroductionController.text.isNotEmpty){
                  //前の画面に戻る
                  String imagePath = '';
                  if(image == null){
                    imagePath = myAccount.image_path;
                  }else{
                    var result = await FunctionUtill.uploadImg(myAccount.id, image);
                    imagePath = result;
                  }
                  Account updateAccount = Account(
                    id: myAccount.id,
                    name:nameController.text,
                    userId: userIdController.text,
                    self_introduction: selfIntroductionController.text,
                    image_path: imagePath
                  );
                  var result = await UserFireStore.updateUser(updateAccount);
                  if(result == true){
                    await Navigator.push(context, MaterialPageRoute(builder: (context)=> AccountPage()));
                  }
                }
              }, child: Text('アカウント更新'))
            ],
          ),
        ),
      ),
    );
  }
}
