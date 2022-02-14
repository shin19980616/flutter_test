import 'package:chat_app/model/account.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Authentication{
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static User currentFirebaseUser;
  static Account myAccount;
  static Future<dynamic> sigunup({String email,String pass}) async{
  try{
    UserCredential newAccount =await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: pass);
    print('auth 登録完了');
    return newAccount;
  }on FirebaseException catch(e){
  print(e);
  return false;
  }
  }


  static Future<dynamic> siginin({String email,String pass}) async{
    try{
      final UserCredential _result = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: pass);
      currentFirebaseUser = _result.user;
      print('authサインイン完了');
      return _result;
    }on FirebaseAuthException catch(e){
      print('authサインエラー:$e');
      return false;
    }

  }
}