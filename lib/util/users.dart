import 'package:chat_app/model/account.dart';
import 'package:chat_app/utill/authentication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserFireStore {

  static final _firestoreInstance = FirebaseFirestore.instance;
  static final CollectionReference users = _firestoreInstance.collection(
      'users');

  static Future<dynamic> setUser(Account newAccount) async {
    try {
      await users.doc(newAccount.id).set(
          {
            'name': newAccount.name,
            'user_id': newAccount.userId,
            'image_path': newAccount.image_path,
            'self_introduction':newAccount.self_introduction,
            'update_time': Timestamp.now(),
            'created_time': Timestamp.now(),
          }
      );
      print('新規ユーザー作成完了');
      return true;
    } on FirebaseException catch (e) {
      print('err $e');
      return false;
    }
  }

  static Future<dynamic> getUser(String uid) async{
    try{
    DocumentSnapshot documentSnapshot = await users.doc(uid).get();
    Map<String,dynamic> data = documentSnapshot.data() as Map<String,dynamic>;
    Account myAccount = Account(
      id: uid,
      name: data['user_id'],
      userId: data['user_id'],
      self_introduction: data['self_introduction'],
        image_path: data['image_path'],
      createdTime: data['created_time'],
      updateTime: data['updateTime']
    );
    Authentication.myAccount = myAccount;
    return true;
    }on FirebaseException catch(e){
      print('user get error $e');

          return false;
    }
  }
  static Future<dynamic> updateUser(Account updateAccount) async{
    try{
    users.doc(updateAccount.id).update({
      'name': updateAccount.name,
      'image_path':updateAccount.image_path,
      'user_id':updateAccount.userId,
      'self_introduction': updateAccount.self_introduction,
      'updated_time':Timestamp.now()
    });
    Authentication.myAccount = updateAccount;
    print('更新完了');
    return true;
    } on FirebaseException catch(e){
    return false;
    }
  }
  static Future<Map<String,Account>> getPostUserMap(List<String> accountIds) async{
    Map<String,Account> map = {};
    try{
      await Future.forEach(accountIds, (String accountID) async{
        var doc = await users.doc(accountID).get();
        Map<String,dynamic> data = doc.data() as Map<String,dynamic>;
        Account postAccount = Account(
          id:accountID,
          name: data['name'],
          image_path: data['image_path'],
          self_introduction: data['self_introduction'],
          createdTime: data['createdTim'],
          updateTime: data['updateTime']
        );
        map[accountID] = postAccount;
      });
      return map;
    }on FirebaseException catch(e){
    return null;
    }
  }
}