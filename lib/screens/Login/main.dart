import 'package:flutter/material.dart';
import 'package:bob/screens/Login/signup.dart';
import 'package:bob/screens/Login/login.dart';

class LoginBase extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.all(30),
        child: Column(
          children: [
            SizedBox(height: 200),
            Image.asset('asset/images/logo.png'),
            SizedBox(height: 50),
            OutlinedButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> Login()));
            }, child: Text('이메일로 로그인'),
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.all(15),
                minimumSize: const Size.fromHeight(10)
              )
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(onPressed: (){}, child: Text('회원가입')),
                VerticalDivider(thickness: 1,color: Colors.grey),
                TextButton(onPressed: (){}, child: Text('로그인 문의'))
              ],
            )

          ],
        )
      )
    );
  }

}