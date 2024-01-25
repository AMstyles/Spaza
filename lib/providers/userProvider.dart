import 'package:flutter/cupertino.dart';
import 'package:spaza/firebase/authentication/Auth.dart';
import 'package:spaza/models/local_user.dart';


class UserProvider extends ChangeNotifier{
  LocalUser? _user = LocalUser(name: 'test', email: 'email@example.com', isAdmin: true, );

  Future<LocalUser>? userFuture;

  LocalUser? get user => _user;


  void setUser(LocalUser user){
    _user = user;
    notifyListeners();
  }

  void signOut()async {
    await Auth.signOut();
  }

}