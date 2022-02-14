import 'package:cloud_firestore/cloud_firestore.dart';

class Account{
  String id;
  String name;
  String image_path;
  String userId;
  String self_introduction;
  Timestamp createdTime;
  Timestamp updateTime;
  Account({this.id,this.image_path,this.name,this.createdTime,this.updateTime,this.userId,this.self_introduction});
}
