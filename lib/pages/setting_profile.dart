
import 'dart:io';

import 'package:chat_app/model/user.dart';
import 'package:chat_app/util/firebase.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
class SettingProfile extends StatefulWidget {
  const SettingProfile({Key key}) : super(key: key);

  @override
  _SettingProfileState createState() => _SettingProfileState();
}

class _SettingProfileState extends State<SettingProfile> {
  File image;
  @override
  ImagePicker picker = ImagePicker();
  String ImagePath;
  TextEditingController text_controller = TextEditingController();
  Future<String> uploadImagePath() async {
    final ref = FirebaseStorage.instance.ref('test/test_image.png');
    final storageImage = await ref.putFile(image);
    ImagePath = await loadImage(storageImage);
    return ImagePath;
  }

  Future<void> getImageFromGallery() async{
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if(pickedFile != null){
      setState(() {
        image = File(pickedFile.path);
        uploadImagePath();
        setState(() {
        });
      });
    }
  }
  Future<String> loadImage(TaskSnapshot storegeImage) async{
    String downloadUrl = await storegeImage.ref.getDownloadURL();
    return downloadUrl;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('プロフィール編集'),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Container(width: 100,child: Text('名前'),),
              Expanded(child: TextField(
                controller: text_controller,
              )),
            ],
          ),
          SizedBox(height: 50,),
          image == null ? Container() : Container(
            width: 200,
            height: 200,
            child: Image.file(image,fit: BoxFit.cover,),
          ),
          Row(
            children: [
            Container(width: 100,child: Text('サムネイル'),),
              Container(
                width: 150,height: 40,
                child: Container(
                  child: ElevatedButton(onPressed: (){
                    getImageFromGallery();
                  }, child: Text('画像選択')),
                ),
              )
            ],
          ),
          SizedBox(height: 30,),
          ElevatedButton(onPressed:(){
            User newProfile = User(
              name : text_controller.text,
              imagePath: ImagePath
            );
            Firestore.updateProfile(newProfile);
          },child: Text('編集')
          ,)
        ],
      ),
    );
  }
}
