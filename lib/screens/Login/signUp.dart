import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bob/screens/Login/find_logininfo.dart';
import 'package:bob/widgets/appbar.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:bob/models/model.dart';
import 'package:bob/screens/BaseWidget.dart';

class SignUp extends StatefulWidget{
  @override
  _SignUp createState() => _SignUp();
}

class _SignUp extends State<SignUp>{
  final dio = Dio();    // 서버와 통신을 하기 위해 필요한 패키지
  late TextEditingController idController;
  late TextEditingController passController;
  static final storage = FlutterSecureStorage(); // 토큰 값과 로그인 유지 정보를 저장, SecureStorage 사용
  @override
  void initState() {
    super.initState();
    idController = TextEditingController();
    passController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: renderAppbar('이메일 로그인'),
      body: Container(
        margin: const EdgeInsets.all(30),
        child:
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  CupertinoTextField(
                    controller: idController,
                    placeholder: "아이디",
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                      border: Border.all(width: 0.5)
                    ),
                    onChanged: (text){
                      setState(() {

                      });
                    },
                  ),
                  const SizedBox(height: 15),
                  CupertinoTextField(
                    controller: passController,
                    placeholder: "패스워드",
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(width: 0.5)
                    ),
                    onChanged: (text){
                      setState(() {

                      });
                    },
                  ),
                  const SizedBox(height: 30),
                  CupertinoButton(
                      color:Colors.black,
                      borderRadius: BorderRadius.circular(12),
                      onPressed: _isValid()? _login : null,
                      child: const Text('로그인')

                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(onPressed: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const FindLogInfo(0)),
                        );
                      }, child: const Text('아이디 찾기',style: TextStyle(color: Colors.black))),
                      Container(
                        width: 1,
                        height: 15,
                        color: Colors.grey,
                      ),
                      TextButton(onPressed: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const FindLogInfo(1)),
                        );
                      }, child: const Text('비밀번호 찾기',style: TextStyle(color: Colors.black))),
                    ],
                  )
                ],
              )
            )
      )
    );
  }

  bool _isValid(){
    return (idController.text.length>=4 && passController.text.length >=4);
  }
  void _login() async{
    // 1. validate
    String id = idController.text;
    if(!RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(id.trim())){
      _showDialog("올바른 ID 형식이 아닙니다");
      idController.clear();
      passController.clear();
      return;
    }
    // 2. Login
    //Response response = await dio.post('http://20.249.219.241:8000/api/user/login/', data:{'email' : "hehe@kyonggi.ac.kr", 'password': "qwe123!@#"});
    Response response = await dio.post('http://20.249.219.241:8000/api/user/login/', data:{'email' : id, 'password': passController.text});
    if(response.statusCode == 200){
      _showDialog('환영합니다');
      String token = response.data['access_token']; // response의 token키에 담긴 값을 token 변수에 담아서
      Map<dynamic, dynamic> payload = Jwt.parseJwt(token);
      // 로그인 정보 저장
      User uinfo = User(response.data['email'], passController.text, response.data['name'], "01092982310");    // response.data['phone']
      Login loginInfo = Login(token, payload['user_id'], uinfo);
      await storage.write(key: 'login', value: jsonEncode(loginInfo));
      Navigator.pushReplacement(
          context,
          CupertinoPageRoute(builder: (context)=> BaseWidget(uinfo))
      );
    }else{
      print(response.statusCode.toString());
      _showDialog("등록된 사용자가 아닙니다");
      idController.clear();
      passController.clear();
    }
  }
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    idController.dispose();
    passController.dispose();
    super.dispose();
  }
  void _showDialog(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}

