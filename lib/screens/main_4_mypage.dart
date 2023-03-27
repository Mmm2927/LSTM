import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:bob/screens/Login/initPage.dart';
import 'package:bob/screens/MyPage/manage_baby.dart';
import '../models/model.dart';

class Main_Mypage extends StatefulWidget{
  final User userinfo;
  Main_Mypage(this.userinfo, {Key?key}):super(key:key);

  @override
  _Main_Mypage createState() => _Main_Mypage();
}
class _Main_Mypage extends State<Main_Mypage>{
  static final storage = FlutterSecureStorage();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('4. MyPAGE'),
        ElevatedButton(
            onPressed: ()=> logout(),
            child: const Text('로그아웃')
        ),
        ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context)=> ManageBabyWidget())
              );
            },
            child: const Text('아이 정보 > ')
        )
      ],
    );
  }
  logout() async{
    await storage.delete(key: 'user');
    Navigator.pushReplacement(
        context,
        CupertinoPageRoute(builder: (context)=> LoginInit())
    );
  }
}