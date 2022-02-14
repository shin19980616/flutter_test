import 'package:chat_app/model/message.dart';
import 'package:chat_app/model/talk_room.dart';
import 'package:chat_app/model/user.dart';
import 'package:chat_app/util/firebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';




class TalkRoom extends StatefulWidget {
  final TalkRoomM talkUser;
  // final String talkUser;
  TalkRoom(this.talkUser);



  @override
  _TalkRoomState createState() => _TalkRoomState();

}

class _TalkRoomState extends State<TalkRoom> {
  List<Message> messageList = [];
  TextEditingController text_controller = TextEditingController();
  Future<void> getMessage() async{
    messageList = await Firestore.getMessage(widget.talkUser.roomId);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
  backgroundColor: Colors.green,
      appBar: AppBar(
        title: Text(widget.talkUser.talkUser.name),
      ),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 60.0),
              child: StreamBuilder<QuerySnapshot>(
                stream: Firestore.messageSnapshot(widget.talkUser.roomId),
                builder: (context, snapshot) {
                  return FutureBuilder(
                    future: getMessage(),
                    builder: (context,snapshot){
                    return ListView.builder(
                      shrinkWrap: true,
                      reverse: true,
                      itemCount: messageList.length,
                      itemBuilder:(context,index){
                        Message _message = messageList[index];
                        DateTime sendTime = _message.sendTime.toDate();
                      return Padding(
                        padding: const EdgeInsets.only(top:10.0,right:10.0,left:10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          textDirection: messageList[index].isMe == true ?  TextDirection.rtl:TextDirection.ltr,
                          children: [
                            Container(
                                constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width*0.7),
                                color: messageList[index].isMe == true ? Colors.green : Colors.white,
                                child: Text(messageList[index].message.toString())),
                            // Text(intl.DateFormat('HH:mm').format(messageList[index].sendTime)),
                          ],
                        ),
                      );
                    },
                    );
                    }
                  );
                }
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 60,color: Colors.white,
                child: Row(
                  children: [
                  Expanded(child: TextField(
                    controller: text_controller,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'message',
                    ),
                  )),
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () {
                        if(text_controller.text.isNotEmpty){
                          Firestore.addMessage(widget.talkUser.roomId, text_controller.text);
                          text_controller.clear();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
    );
  }
}
