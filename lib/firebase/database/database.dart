import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spaza/models/local_user.dart';


class Database{

  static final _storage = FirebaseFirestore.instance;

 static Future<void> writeUser(LocalUser user,  BuildContext context)async{

   //show loading dialog
   showDialog(context: context, builder: (context) => AlertDialog(
     title: Text('Loading'),
     content: Text('Please wait while we set everything up for you'),
     actions: [
       TextButton(onPressed: () => Navigator.pop(context), child: Text('Ok'))
     ],));

    try{
      await _storage.collection('users').doc(user.uid!).set(user.toJson());
    Navigator.pop(context);
    }
        on FirebaseException catch (e) {
          Navigator.pop(context);
        showDialog(context: context, builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text(e.message!),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text('Ok'))
          ],));
        }
 }



  //get user from firestore
  static Future<LocalUser> getUserFromFirestore(
      String id, BuildContext context) async {
    try {
      late final LocalUser newUser;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(id)
          .get()
          .then((value) {
        newUser = LocalUser.fromJson(value.data()!);
      });

      //await LocalStorage.writeUserToLocalStorage(newUser);

      //Provider.of<UserProvider>(context, listen: false).setUser(newUser);

      return newUser;
    } catch (e) {
      print('Error' + e.toString());
      return LocalUser(
          uid: '',
          name: '',
          email: '',
          isAdmin: false,);
    }
  }

  static Future<LocalUser> getUser(String id) async{
    return _storage
        .collection('users')
        .doc(id)
        .get()
        .then((value) {
          if (value.data() == null) {
            print ('User not found');
          }
          else{
            print('User found');
          }
          return LocalUser.fromJson(value.data()!);
        });
  }
  



}
