import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:get/get.dart' as GET;
import 'package:bob/screens/Login/find_logininfo.dart';
import 'package:bob/screens/BaseWidget.dart';
import 'package:bob/widgets/appbar.dart';
import 'package:bob/services/backend.dart';
import 'package:bob/services/storage.dart';
import 'package:bob/models/model.dart';
import 'package:bob/models/validate.dart';

import '../MyPage/addBaby.dart';

class SignUp extends StatefulWidget{
  const SignUp({super.key});
  @override
  State<SignUp> createState() => _SignUp();
}
class _SignUp extends State<SignUp>{
  late TextEditingController idController;
  late TextEditingController passController;

  @override
  void initState() {
    super.initState();
    idController = TextEditingController();
    passController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: renderAppbar('이메일 로그인', true),
      body: Container(
        margin: const EdgeInsets.all(20),
        child:
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Sign In', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text('서비스 사용을 위해 로그인 해주세요'),
                  const SizedBox(height: 30),
                  getLoginForm(idController, "ID(email)", false, TextInputType.emailAddress),
                  const SizedBox(height: 10),
                  getLoginForm(passController, "Password", true, TextInputType.text),
                  const SizedBox(height: 40),
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
                        GET.Get.to(() => FindLogInfo(0));
                      }, child: const Text('아이디 찾기',style: TextStyle(color: Colors.black))),
                      Container(
                        width: 1,
                        height: 10,
                        color: Colors.grey,
                      ),
                      TextButton(onPressed: (){
                        GET.Get.to(() => FindLogInfo(1));
                      }, child: const Text('비밀번호 찾기',style: TextStyle(color: Colors.black))),
                    ],
                  )
                ],
              )
            )
      )
    );
  }
  Widget getLoginForm(contoller, title, isOb, keyType){
    return CupertinoTextField(
      keyboardType: keyType,
      obscureText: isOb,
      controller: contoller,
      placeholder: title,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Color(0xffe8e8e8),
          borderRadius: BorderRadius.circular(50),
      ),
      onChanged: (val){
          setState(() {});
      },
    );
  }
  // 로그인 폼 입력값 형식 체크
  bool _isValid(){
    return (validateEmail(idController.text.trim()) && validatePassword(passController.text.trim()));
  }
  // 로그인 수행
  void _login() async{
    var loginData = await loginService(idController.text.trim(), passController.text.trim());
    if(loginData != null){
      // 2. 로그인 저장
      String token = loginData['access_token'];   // response의 token키에 담긴 값을 token 변수에 담아서
      Map<dynamic, dynamic> payload = Jwt.parseJwt(token);
      User userInfo = User(loginData['email'], passController.text, loginData['name'], loginData['phone']);
      Login loginInfo = Login(token, loginData['refresh_token'], payload['user_id'],loginData['email'], passController.text);
      await writeLogin(loginInfo);
      // 2. babyList 가져오기
      List<Baby> MyBabies = [];
      List<dynamic> babyList = await getMyBabies();
      for(int i=0; i<babyList.length;i++){
        // 2. 아기 등록
        Baby_relation relation = Baby_relation.fromJson(babyList[i]);
        var baby = await getBaby(babyList[i]['baby']);
        baby['relationInfo'] = relation.toJson();
        MyBabies.add(Baby.fromJson(baby));
      }
      GET.Get.snackbar('로그인 성공', '환영합니다', snackPosition: GET.SnackPosition.TOP, duration: const Duration(seconds: 2));
      if(MyBabies.isEmpty){
        GET.Get.to(()=> AddBaby(userInfo, MyBabies));
      }
      else{
        GET.Get.to(()=> BaseWidget(userInfo, MyBabies));
      }
    }
    else{
      GET.Get.snackbar('로그인 실패', '등록된 사용자가 아닙니다', snackPosition: GET.SnackPosition.TOP, duration: const Duration(seconds: 2));
      idController.clear();
      passController.clear();
    }
  }
  @override
  void dispose() {
    idController.dispose();
    passController.dispose();
    super.dispose();
  }
}