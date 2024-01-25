
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spaza/widgets/blob_loader.dart';

class Auth{

  static void login(BuildContext context) async {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    if (user != null) {
      print('User is already logged in');
    } else {
      print(
          'User is not logged in, redirecting to login page');
    }
  }

  static Future<bool> deleteUser()async{

    try{
      final _auth = FirebaseAuth.instance;
      final _user  = _auth.currentUser;
      await _user?.delete();
      print("User deleted");
      return true;
    }
    on FirebaseAuthException catch (e) {
      print(e.message);
      return false;
    }

  }

  static void logout(BuildContext context) async {
    final _auth = FirebaseAuth.instance;
    final _user = _auth.currentUser;
    if (_user != null) {
      await _auth.signOut();
      print('User is logged out');
    } else {
      print('User is not logged in');
    }
  }

  static Future<String?> signupWithEmail(BuildContext context, String email, String password) async{
    showDialog(context: context, builder: (context) => BlobLoader('Signing up...',),);
    final _auth = FirebaseAuth.instance;
    try{
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      if(FirebaseAuth.instance.currentUser!=null){
         Navigator.pop(context);
        return  FirebaseAuth.instance.currentUser!.uid;
      }
      
    Navigator.pop(context);
      return null;
    }
        on FirebaseAuthException catch (e) {
        Navigator.pop(context);
        showDialog(context: context, builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text(e.message!),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text('Ok'))
          ],));
        return 'error';
        }
  }


//   static Future<void> signInWithEmail (String email, String password, BuildContext context)async{

//     final _auth = FirebaseAuth.instance;
//     showDialog(context: context, builder: (context) => BlobLoader('Signing in...'),);
//     try {
//       await _auth.signInWithEmailAndPassword(email: email, password: password);
//       localUser.User mUser = await Database.getUser(email);
//       await LocalStorage.writeUserToLocalStorage(mUser);
//       Provider.of<UserProvider>(context, listen: false).setUser(mUser);
//       Navigator.pop(context);
//       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
//     }
//      on FirebaseAuthException catch (e){
//       Navigator.pop(context);
//       showDialog(context: context, builder: (context) => AlertDialog(
//           title: Text('Error'),
//           content: Text(e.message!),
//           actions: [
//             TextButton(onPressed: () => Navigator.pop(context), child: Text('Ok'))
//           ],) );
//    }

// }

  static Future<String> getUID() async{
    final _auth = FirebaseAuth.instance;
    final _user = _auth.currentUser;
    return _user!.uid;
  }

  static Future<void> signOut(){
    final _auth = FirebaseAuth.instance;
    return _auth.signOut();
  }

  static Future<String> resetPassword(String email) async{
    final _auth = FirebaseAuth.instance;
    try{
      await _auth.sendPasswordResetEmail(email: email);
      return 'success, check your email for a link to reset your password';
    }
    on FirebaseAuthException catch (e){
      return e.message!;
    }
  }

}