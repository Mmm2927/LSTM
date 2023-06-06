import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bob/screens/Login/SignIn.dart';
import 'package:get/get.dart' as GET;
import 'package:get/get.dart';
import 'package:jwt_decode/jwt_decode.dart';

import '../../models/model.dart';
import '../../models/validate.dart';
import '../../services/backend.dart';
import '../../services/storage.dart';
import '../BaseWidget.dart';
import '../MyPage/addBaby.dart';
import 'find_logininfo.dart';

class LoginInit extends StatefulWidget{
  const LoginInit({super.key});
  @override
  State<LoginInit> createState() => _LoginInit();
}

class _LoginInit extends State<LoginInit> {
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
        body: InkWell(
          child: Container(
              child: Center(
                  child:
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 310),
                        Image.asset('assets/icon/bob.png', scale: 8),
                        const SizedBox(height: 10),
                        const Text('Best of Baby : For All Who Love Baby', style: TextStyle(color: Color(0xFF9B9696))),
                        const SizedBox(height: 220),
                        ElevatedButton(
                            style:ElevatedButton.styleFrom(
                              minimumSize: const Size(45, 45),
                                backgroundColor: const Color(0xffFF766A),
                                shape: const CircleBorder(),
                            ),
                            onPressed: (){
                              openBottomSheet();
                            }, child: const Icon(Icons.expand_more_rounded, size: 30)
                        ),
                      ]
                  )
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

  void openBottomSheet() {
    showModalBottomSheet(
        context : context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30)
          )
        ),
        builder: (context) => Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Wrap(
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      const Text('Welcome', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
                      const SizedBox(height: 10),
                      const Text('종합 육아 서비스를 지원하는 BoB입니다.\n생활 기록, 성장 기록, 하루 일기 등의 다양한 기록과 아기의 수면 모니터링을 지원합니다.', style: TextStyle(fontSize: 15, color: Colors.black)),
                      const SizedBox(height: 25),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 20),
                          const Text('Login', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                          const SizedBox(height: 30),
                          getLoginForm(idController, "ID(email)", false, TextInputType.emailAddress),
                          const SizedBox(height: 10),
                          getLoginForm(passController, "Password", true, TextInputType.text),
                          const SizedBox(height: 20),
                          ElevatedButton(
                              style:ElevatedButton.styleFrom(
                                minimumSize: const Size(47, 47),
                                backgroundColor: const Color(0xffFF766A),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)
                                )
                              ),
                              onPressed: _isValid()? _login : null,
                              child: const Text('로그인')
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(onPressed: (){
                            GET.Get.to(() => const SignIn());
                          }, child: const Text('회원가입',style: TextStyle(color: Colors.black))),
                          Container(
                            width: 1,
                            height: 10,
                            color: Colors.grey,
                          ),
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
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          )
      );
  }
}

