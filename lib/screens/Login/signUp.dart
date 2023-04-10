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
        margin: const EdgeInsets.all(30),
        child:
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  getLoginForm(idController, "아이디", false, TextInputType.emailAddress),
                  const SizedBox(height: 15),
                  getLoginForm(passController, "패스워드", true, TextInputType.text),
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
          borderRadius: BorderRadius.circular(12),
          border: Border.all(width: 0.5)
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
        // 1. baby relation도 받아오기
        Baby_relation relation;
        if(babyList[i]['relation']==0) {
          relation = Baby_relation(babyList[i]['baby'], babyList[i]['relation'], 255,"","");
        } else {
          relation = Baby_relation.fromJson(babyList[i]);
        }
        // 2. 아기 등록
        var baby = await getBaby(babyList[i]['baby']);
        baby['relationInfo'] = relation.toJson();
        MyBabies.add(Baby.fromJson(baby));
      }
      GET.Get.snackbar('로그인 성공', '환영합니다', snackPosition: GET.SnackPosition.TOP, duration: const Duration(seconds: 2));
      GET.Get.to(()=> BaseWidget(userInfo, MyBabies));
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