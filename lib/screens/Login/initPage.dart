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
  static final storage =
    new FlutterSecureStorage(); //flutter_secure_storage 사용을 위한 초기화 작업
  @override
  void initState() {
    super.initState();
    //비동기로 flutter secure storage 정보를 불러오는 작업.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _asyncMethod();
    });
  }
  _asyncMethod() async {
    //read 함수를 통하여 key값에 맞는 정보를 불러오게 됩니다. 이때 불러오는 결과의 타입은 String 타입임을 기억해야 합니다.
    //(데이터가 없을때는 null을 반환을 합니다.)
    var userInfo = await storage.read(key: "login");
    //user의 정보가 있다면 바로 로그아웃 페이지로 넝어가게 합니다.
    if (userInfo != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('환영합니다')));
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => BaseWidget()),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(30),
        child: Center(
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 300),
              Image.asset('assets/images/logo.png',scale: 12,),
              SizedBox(height: 100),
              OutlinedButton(child: Text('이메일로 로그인',style: TextStyle(color: Colors.black)),
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUp()),
                    );
                  },
                style: OutlinedButton.styleFrom(
                  minimumSize: Size.fromHeight(50)
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignIn()),
                    );
                  }, child: Text('회원가입',style: TextStyle(color: Colors.black))),
                  VerticalDivider(thickness: 1, color: Colors.grey),
                  TextButton(onPressed: (){}, child: Text('로그인 문의',style: TextStyle(color: Colors.black))),
                ],
              )
            ]
          )
        )
      )
    );

  }
  
}