import 'package:chat_app/model/talk_room.dart';
import 'package:chat_app/model/user.dart';
import 'package:chat_app/pages/setting_profile.dart';
import 'package:chat_app/pages/talk_room_page.dart';
import 'package:chat_app/util/firebase.dart';
import 'package:chat_app/util/shaered_prefs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

class TopPage extends StatefulWidget {
  @override
  _TopPageState createState() => _TopPageState();
}

class _TopPageState extends State<TopPage> {
  int _count = 0;
  List<TalkRoomM> talkList = [];

  Future<void> createRooms() async {
    String myuid = '';
    myuid = await SharedPrefs.getUid();
    talkList = await Firestore.getRooms(myuid);
  }

  @override
  _TopPageState createState() => _TopPageState();

  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
        appBar: AppBar(
        title: const Text('chat app'),
    actions: <Widget>[
    IconButton(
    icon: const Icon(Icons.settings),
    tooltip: 'Open shopping cart',
    onPressed: () {
    Navigator.push(context, MaterialPageRoute(builder: (context)=> SettingProfile()));
    },
    ),
    ],
    ),
    body:StreamBuilder<QuerySnapshot>(
      stream: Firestore.roomSnapshot,
      builder: (context, snapshot) {
        return FutureBuilder(
        future: createRooms(),
        builder:(context,snapshot){
        if(snapshot.connectionState == ConnectionState.done){
        return ListView.builder(
        itemCount: talkList?.length,
        itemBuilder: (context,index){
        return InkWell(
        onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> TalkRoom(talkList[index])));
        },
        child: Container(
        child: Row(
        children: [
        Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child:CircleAvatar(backgroundImage: NetworkImage(talkList[index].talkUser.imagePath),
        // child:CircleAvatar(backgroundImage: NetworkImage('https://cdn-ssl-devio-img.classmethod.jp/wp-content/uploads/2020/02/flutter.png'),
        radius: 30,
        ),
        ),
        Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        Text(talkList[index].talkUser.name,style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold),),
        Text('',style: TextStyle(color:Colors.grey),),
        ],
        )
        ],
        )
        ),
        );
        });
        }else{

          return CircularProgressIndicator();
        }
        }
        );
      }
    ),
    ),
    );
  }
}
