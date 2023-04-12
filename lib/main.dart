import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:bob/screens/BaseWidget.dart';
import 'package:bob/screens/Login/initPage.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import 'package:bob/services/backend.dart';
import 'models/model.dart';
import 'package:bob/services/storage.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:get/get.dart' as GET;
import 'package:dio/dio.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GET.GetMaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ko', ''),
        Locale('en', ''),
      ],
      theme: ThemeData(
        fontFamily: 'basic',
      ),
      debugShowCheckedModeBanner: false,
      home: const Splash(),
    );
  }
}
class Splash extends StatefulWidget {
  const Splash({super.key});
  @override
  State<Splash> createState() => _Splash();
}
class _Splash extends State<Splash> {
  late Future InitInfo;
  var logger = Logger();
  @override
  void initState() {
    super.initState();
    InitInfo = getInitInfo();
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: InitInfo,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData == false){
          return Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xfffa625f),
            ),
              child : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/baby.png', width: 150),
                  const SizedBox(height: 50),
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(
                      Colors.white,
                    ),
                  ),
                ],
              )
          );
        }
        else if(snapshot.hasError){
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Error: ${snapshot.error}', // 에러명을 텍스트에 뿌려줌
              style: const TextStyle(fontSize: 15),
            ),
          );
        }
        else{
          if(snapshot.data is LoginInit){
            return const Scaffold(
                body: LoginInit()
            );
          }
          return Scaffold(
            body: BaseWidget(snapshot.data[0], snapshot.data[1] as List<Baby>)
          );
        }
      },
    );
  }
  Future getInitInfo() async{
    var autoLogin = await storage.read(key: "login");
    if(autoLogin != null){
      logger.i("자동 login");
      Login loginInfo = Login.fromJson(jsonDecode(autoLogin));
      var loginData = await loginService(loginInfo.userEmail, loginInfo.userPassword);
      String token = loginData['access_token']; // response의 token키에 담긴 값을 token 변수에 담아서
      Map<dynamic, dynamic> payload = Jwt.parseJwt(token);
      User uinfo = User(loginData['email'], loginInfo.userPassword, loginData['name'], loginData['phone']);
      // 로그인 정보 저장
      Login newloginInfo = Login(token, loginData['refresh_token'], payload['user_id'], loginData['email'], loginInfo.userPassword);
      await writeLogin(newloginInfo);
      // 2. babyList 가져오기
      List<Baby> MyBabies = [];
      List<dynamic> babyList = await getMyBabies();
      print(babyList);
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
      return [uinfo, MyBabies];
    }else{
      logger.i("로그인 정보 X");
      return const LoginInit();
    }
  }
}
