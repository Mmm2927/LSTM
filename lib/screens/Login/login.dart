import 'package:flutter/material.dart';


class Login extends StatefulWidget{
  @override
  _LoginBase createState()=> _LoginBase();
}
class _LoginBase  extends State<Login>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("로그인")),
        body: Container(
          margin: EdgeInsets.all(25),
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: '이메일'
                )
              ),
            ],
          )
        )
    );
  }

}