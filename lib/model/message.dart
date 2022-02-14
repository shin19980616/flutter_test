
import 'package:cloud_firestore/cloud_firestore.dart';

class Message{
  String message;
  bool isMe;
  Timestamp sendTime;

  Message({String message,bool isMe,Timestamp sendTime}){
    this.message=message;
    this.isMe=isMe;
    this.sendTime=sendTime;
  }

 }
