import 'package:chat_app/model/account.dart';
import 'package:chat_app/model/post.dart';
import 'package:chat_app/util/users.dart';
import 'package:chat_app/utill/authentication.dart';
import 'package:chat_app/utill/posts.dart';
import 'package:chat_app/view/acount/edit_account.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key key}) : super(key: key);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  Account account = Authentication.myAccount;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                Container(
                  // height: MediaQuery.of(context).size.height,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 32,
                                foregroundImage: NetworkImage(account.image_path),
                              ),
                              Column(
                                children: [
                                  Text(account.name),
                                  Text(account.userId)
                                ],
                              )
                            ],
                          ),
                          OutlinedButton(onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => EditAccount() ));
                          }, child: Text('編集'))
                        ],
                      ),
                      SizedBox(height: 15),
                      Text('account self introduction')
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      border:
                          Border(bottom: BorderSide(color: Colors.blue, width: 3))),
                  child: Text(
                    '投稿',
                    style:
                        TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                    child:StreamBuilder<QuerySnapshot>(
                        stream: UserFireStore.users.doc(Authentication.myAccount.id).collection('my_posts').orderBy('created_time',descending: true).snapshots(),
                        builder: (context, snapshot) {
                          if(snapshot.hasData){
                            List <String> myPostId = List.generate(snapshot.data.docs.length, (index) {
                              return snapshot.data.docs[index].id;
                            });
                            return FutureBuilder<List<Post>>(
                                future: postsFireStore.getPostsFromids(myPostId),
                                builder: (context, snapshot) {
                                  if(snapshot.hasData){
                                    return ListView.builder(
                                        itemCount: snapshot.data.length,
                                        itemBuilder:(context,index) {
                                          Post post = snapshot.data[index];
                                          return Container(

                                            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 15),
                                            child: Row(
                                              children: [
                                                CircleAvatar(
                                                  radius: 22,
                                                  backgroundImage: NetworkImage(account.image_path),
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
                                                              Text(account.name),
                                                              Text(account.userId),
                                                            ],
                                                          ),
                                                          // Text(DateFormat('M/d/yy').format(post.createdTime))
                                                        ],
                                                      ),
                                                      Text(post.content)
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
                )],
            ),
          ),
        ),
      ),
      );
  }
}
