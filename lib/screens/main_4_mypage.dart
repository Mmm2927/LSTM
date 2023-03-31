import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:bob/screens/Login/initPage.dart';
import 'package:bob/screens/MyPage/manage_baby.dart';
import '../models/model.dart';

class MainMyPage extends StatefulWidget{
  final User userinfo;
  const MainMyPage(this.userinfo, {Key?key}):super(key:key);
  @override
  State<MainMyPage> createState() => _MainMyPage();
}
class _MainMyPage extends State<MainMyPage>{
  static const storage = FlutterSecureStorage();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: const Color(0xfffa625f),
          padding: const EdgeInsets.all(20),
          child : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.userinfo.nickname, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
              const SizedBox(height: 10),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: (){},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.grey,
                      elevation: 0.0,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15))
                      )
                    ),
                    child: const Text('정보 수정'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.grey,
                        elevation: 0.0,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15))
                        )
                    ),
                    onPressed: ()=> logout(),
                    child: const Text('로그아웃'),
                  ),
                ],
              )
            ],
          )
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