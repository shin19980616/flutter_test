import 'package:chat_app/model/message.dart';
import 'package:chat_app/model/talk_room.dart';
import 'package:chat_app/model/user.dart';
import 'package:chat_app/util/shaered_prefs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Firestore {
  static FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  static final userRef = _firebaseFirestore.collection('users');
  static final roomRef = _firebaseFirestore.collection('room');
  static final roomSnapshot = roomRef.snapshots();

  static Future<void> addUser() async {
    try {
      final newDoc = await userRef.add({
        'name': '名無し',
        'image_path': 'aaaaaaa',
      });
      print('アカウント作成成功');
      // _incrementCounter();
      print(newDoc.id);
      await SharedPrefs.setUid(newDoc.id);
      // final uid = SharedPrefs.getUid();
      String id = await SharedPrefs.getUid();
      print(id);
      List<String> userIds = await getUser();
      userIds.forEach((user) {
        if (user != newDoc.id) {
          roomRef.add({
            'joined_user_ids': [user, newDoc.id],
            'update_time': Timestamp.now()
          });
        }
      });
      print('room作成完了');
    } catch (e) {
      print('アカウント作成失敗');
    }
  }

  static Future getUser() async {
    try {
      final snapshot = await userRef.get();
      List<String> userIds = [];
      snapshot.docs.forEach((user) {
        userIds.add(user.id);
        print('document_id ${user.id}');
      });
      print('sucsess');
      return userIds;
    } catch (e) {
      print('error${e}');
    }
    return null;
  }

  static Future<User> getProfile(String ulid) async {
    final profile = await userRef.doc(ulid).get();
    User myProfile = User(
      name: profile.data()['name'],
      imagePath: profile.data()['image_path'],
      uid: ulid,
    );
    return myProfile;
  }

  static Future<List<TalkRoomM>> getRooms(String myulid) async {
    final snapshot = await roomRef.get();
    List<TalkRoomM> roomList = [];
    await Future.forEach<QueryDocumentSnapshot<Map<String, dynamic>>>(
        snapshot.docs, (doc) async {
      if (doc.data()['joined_user_ids'] != null) {
        if (doc.data()['joined_user_ids'].contains(myulid)) {
          String yourUid = '';
          doc.data()['joined_user_ids'].forEach((id) {
            if (id != myulid) {
              yourUid = id;
              return;
            }
          });
          User yourProfile = await getProfile(yourUid);
          TalkRoomM room = TalkRoomM(
              roomId: doc.id,
              talkUser: yourProfile,
              lastmessage: doc.data()['last_message'] ?? '');
          roomList.add(room);
        }
      }
    });
    print('${roomList.length}aaaaaa');
    return roomList;
  }

  static Future<List<Message>> getMessage(String roomId) async {
    final message = roomRef.doc(roomId).collection('message');
    List<Message> messageList = [];
    final snapshot = await message.get();
    SharedPreferences prefs;
    prefs = await SharedPreferences.getInstance();
    await Future.forEach(snapshot.docs, (doc) {
      bool isMe;
      final String uid = prefs.getString('uid');
      if (doc.data()['sender_id'] == uid) {
        isMe = true;
      } else {
        isMe = false;
      }
      Message message = Message(
        message: doc.data()['message'],
        isMe:isMe,
        sendTime: doc.data()['send_time']
      );
      messageList.add(message);
    });
    return messageList;
  }


  static Future<void> addMessage(String roomId,String message) async{
    final messageRef = roomRef.doc(roomId).collection('message');
    SharedPreferences prefs;
    prefs = await SharedPreferences.getInstance();
    final String uid = prefs.getString('uid');
    await messageRef.add({
    'message': message,
      'sender_id' : uid ,
      'send_time': Timestamp.now()
    });
  }
  static Stream<QuerySnapshot> messageSnapshot(String roomId){
    return roomRef.doc(roomId).collection('message').snapshots();
  }


  static Future<void> updateProfile(User newProfile) async{
    SharedPreferences prefs;
    prefs = await SharedPreferences.getInstance();
    final String uid = prefs.getString('uid');
    userRef.doc(uid).update({
      'name':newProfile.name,
      'image_path':newProfile.imagePath
    });
  }
}
