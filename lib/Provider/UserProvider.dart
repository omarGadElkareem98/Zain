import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier{
  String uid = '';

  UserProvider({required this.uid});

  changeUserId(String uid){
    this.uid = uid;

    notifyListeners();
  }
}