import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:bob/screens/BaseWidget.dart';
import 'package:bob/screens/Login/initPage.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import 'models/model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ko', ''),
        Locale('en', ''),
      ],
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'basic',
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var logger = Logger();
  static final storage = FlutterSecureStorage(); //flutter_secure_storage 사용을 위한 초기화 작업
  @override
  void initState() {
    super.initState();
        //비동기로 flutter secure storage 정보를 불러오는 작업.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _asyncMethod();
    });
  }
  _asyncMethod() async {
    var tmp = (await storage.read(key: "login"));
    if (tmp != null) {
      Map<String,dynamic> jsonData = jsonDecode(tmp!);
      logger.i("자동 login");
      print(jsonData['userInfo']);
      Login loginInfo = Login.fromJson(jsonData);
      Navigator.pushReplacement(
          context,
          CupertinoPageRoute(
              builder: (context) => BaseWidget(loginInfo.userInfo)
          )
      );
    }
    else{
      logger.i("로그인 정보 X");
      Navigator.pushReplacement(
          context,
          CupertinoPageRoute(
              builder: (context) => LoginInit()
          )
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
      )
    );
  }
}
