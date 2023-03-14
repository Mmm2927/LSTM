import 'package:flutter/material.dart';


class SignUp extends StatefulWidget{
  @override
  _SignUp createState()=> _SignUp();
}
class _SignUp  extends State<SignUp>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("회원 가입")),
      body: Container(
        margin: EdgeInsets.all(25),
      )
    );
  }

}