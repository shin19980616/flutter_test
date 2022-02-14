import 'package:flutter/material.dart';
class WidetUtils{
  static Widget createAppbar(String title){
  return AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.black),
    title: Text(title,style: TextStyle(color: Colors.black),),
    centerTitle: true,
  );
  }
}