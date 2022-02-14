

import 'package:chat_app/model/user.dart';
import 'package:chat_app/pages/talk_room_page.dart';

class TalkRoomM{
  String roomId;
  User talkUser;
  String lastmessage;
  TalkRoomM({this.roomId,this.lastmessage,this.talkUser});
}