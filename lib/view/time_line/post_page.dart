import 'package:chat_app/model/post.dart';
import 'package:chat_app/util/users.dart';
import 'package:chat_app/utill/authentication.dart';
import 'package:chat_app/utill/posts.dart';
import 'package:chat_app/view/time_line/time_line.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PostPage extends StatefulWidget {
  const PostPage({key}) : super(key: key);

  @override
  PostPage_State createState() => PostPage_State();
}

class PostPage_State extends State<PostPage> {
  TextEditingController text_controller = TextEditingController();
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      centerTitle: true,
        title: Text('新規投稿'),
        backgroundColor: Theme.of(context).canvasColor,
        elevation: 2,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          TextField(
            controller: text_controller,
          ),
          SizedBox(height: 20),
          ElevatedButton(onPressed: () async{
          if(text_controller.text.isNotEmpty){
            Post newPost = Post(
              content: text_controller.text,
              postAccountId: Authentication.myAccount.id
            );
            var result = await postsFireStore.addPost(newPost);
          if(result == true){
          Navigator.push(context, MaterialPageRoute(builder: (context)=> TimeLine()));
          }
          }
          }, child: Text('投稿'))
        ],
      ),
    );
  }
}
