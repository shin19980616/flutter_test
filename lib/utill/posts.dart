import 'package:chat_app/model/account.dart';
import 'package:chat_app/model/post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class postsFireStore{
  static final _firestoreInstance = FirebaseFirestore.instance;
  static final CollectionReference posts = _firestoreInstance.collection('posts');


  static Future<dynamic> addPost(Post newPost) async{
  try{
    //メッセージコレクションを取得
    final CollectionReference _userPosts = _firestoreInstance.collection('users').doc(newPost.postAccountId).collection('my_posts');
      
    var result = await posts.add({
      'content':newPost.content,
      'post_aacount_id':newPost.postAccountId,
      'created_time':Timestamp.now()
    });
    _userPosts.doc(result.id).set({
      'post_id':result.id,
      'created_time':Timestamp.now()
    });

    return true;
  }on FirebaseException catch(e){
    print('投稿エラー');
    return false;
  }
  }



  static Future<List<Post>> getPostsFromids(List<String> ids) async{
    List<Post> postList = [];
    try{
      await Future.forEach(ids, (String id) async{
        var doc = await posts.doc(id).get();
        Map<String,dynamic> data = doc.data() as Map<String,dynamic>;
        Post post = Post (
          id :doc.id,
          content: data['content'],
          postAccountId: data['postAccountId'],
          createdTime: data['createdTime']
        );
        postList.add(post);
      });
      print('投稿取得');
      return postList;
    }on FirebaseException catch(e){
    return null;
    }
  }



}