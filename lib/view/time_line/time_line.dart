import 'package:chat_app/model/account.dart';
import 'package:chat_app/model/post.dart';
import 'package:chat_app/util/users.dart';
import 'package:chat_app/utill/authentication.dart';
import 'package:chat_app/utill/posts.dart';
import 'package:chat_app/view/time_line/post_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeLine extends StatefulWidget {
  const TimeLine({key}) : super(key: key);

  @override
  _TimeLineState createState() => _TimeLineState();
}

class _TimeLineState extends State<TimeLine> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('タイムライン'),
        backgroundColor: Theme.of(context).canvasColor,
        elevation: 2,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: postsFireStore.posts.snapshots(),
        builder: (context, postsnapshot) {
          if(postsnapshot.hasData){
            print(postsnapshot);
            List<String> postAccountIds = [];
            postsnapshot.data.docs.forEach((doc) {
              Map<String,dynamic> data = doc.data() as Map<String,dynamic>;
              if(!postAccountIds.contains(data['post_account_id'])){
                postAccountIds.add(data['post_account_id']);
              }
            });
            return FutureBuilder<Map<String,Account>>(
              future: UserFireStore.getPostUserMap(postAccountIds),
              builder: (context, usersnapshot) {
                if(usersnapshot.hasData && usersnapshot.connectionState == ConnectionState.done){
                  return ListView.builder(
                      itemCount: postsnapshot.data.docs.length,
                      itemBuilder:(context,index) {
                        Map<String,dynamic> data = postsnapshot.data.docs[index].data() as Map<String,dynamic>;
                        Post post= Post(
                          id:postsnapshot.data.docs[index].id,
                          content: data['content'],
                          postAccountId: data['postAccountId'],
                          createdTime: data['createdTime']
                        );
                        Account posrAccount = usersnapshot.data[post.postAccountId];
                        return Container(

                          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 15),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 22,
                                backgroundImage: NetworkImage(posrAccount.image_path),
                              ),
                              Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Text(posrAccount.name),
                                            Text(posrAccount.userId),
                                          ],
                                        ),
                                        // Text(DateFormat('M/d/yy').format(post.createdTime))
                                      ],
                                    ),
                                    Text('aaaaaaaaaaaaaaaaaa')
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      });
                }else{
                  return Container();
                }

              }
            );
          }else{
            return Container();
          }

        }
      ),
        floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=> PostPage()));
        },
          child: Icon(Icons.chat_bubble_outline),
    ),
);
  }
  }
