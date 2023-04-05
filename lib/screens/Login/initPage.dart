import 'package:flutter/material.dart';
import 'package:bob/screens/Login/SignIn.dart';
import 'package:bob/screens/Login/signUp.dart';
import 'package:bob/screens/BaseWidget.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginInit extends StatefulWidget{
  @override
  _LoginInit createState() => _LoginInit();

}
class _LoginInit extends State<LoginInit>{
  static final storage = new FlutterSecureStorage(); //flutter_secure_storage 사용을 위한 초기화 작업
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.all(30),
        child: Center(
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 300),
              Image.asset('assets/images/logo.png',scale: 12,),
              const SizedBox(height: 100),
              OutlinedButton(child: const Text('이메일로 로그인',style: TextStyle(color: Colors.black)),
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUp()),
                    );
                  },
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50)
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignIn()),
                    );
                  }, child: const Text('회원가입',style: TextStyle(color: Colors.black))),
                  const VerticalDivider(thickness: 1, color: Colors.grey),
                  TextButton(onPressed: (){}, child: const Text('로그인 문의',style: TextStyle(color: Colors.black))),
                ],
              )
            ]
          )
        )
      )
    );

  }
  
}