import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:bob/screens/notice.dart';

AppBar renderAppbar(String title, bool isBack){
  return AppBar(
      automaticallyImplyLeading: isBack,
      backgroundColor: Colors.white,
      elevation: 0.5,
      iconTheme : const IconThemeData(color: Colors.black),
      title: Text(title,style: TextStyle(color: Colors.black,fontSize: 15))
  );
}
AppBar renderAppbar_with_alarm(String title, BuildContext context){
  return AppBar(
    automaticallyImplyLeading: false,
    actions: [
      IconButton(onPressed: (){
        Navigator.push(
            context,
            CupertinoPageRoute(builder: (context)=> Notice()));
      }, icon: const Icon(Icons.notifications_active))
    ],
    backgroundColor: Colors.white,
    elevation: 0.5,
    iconTheme : const IconThemeData(color: Colors.black),
    title: Text(title,style: const TextStyle(color: Colors.black,fontSize: 15)),
  );
}