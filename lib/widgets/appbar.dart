import 'package:flutter/material.dart';

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
    backgroundColor: Colors.white,
    elevation: 0.5,
    iconTheme : const IconThemeData(color: Colors.black),
    title: Center(
      child: Text(title,style: const TextStyle(color:Color(0xfffa625f), fontSize: 18, fontWeight: FontWeight.bold)),
    )
  );
}

AppBar renderTitleAppbar(){
  return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      elevation: 0.5,
      iconTheme : const IconThemeData(color: Colors.black),
      title: Center(
        child: Image.asset('assets/icon/bob.png', height: 20),
      )
  );
}