import 'package:flutter/material.dart';

AppBar renderAppbar(String title){
  return AppBar(
      backgroundColor: Colors.white,
      elevation: 0.5,
      iconTheme : const IconThemeData(color: Colors.black),
      title: Text(title,style: TextStyle(color: Colors.black,fontSize: 15))
  );
}