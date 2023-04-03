import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:bob/screens/Login/initPage.dart';
import 'package:bob/screens/MyPage/manage_baby.dart';
import '../models/model.dart';
import 'package:bob/screens/MyPage/invitation.dart';
import 'package:bob/screens/MyPage/switchNotice.dart';
import 'package:bob/screens/MyPage/withdraw.dart';

class MainMyPage extends StatefulWidget{
  final User userinfo;
  final List<Baby> babies;
  const MainMyPage(this.userinfo, this.babies, {Key?key}):super(key:key);
  @override
  State<MainMyPage> createState() => _MainMyPage();
}
class _MainMyPage extends State<MainMyPage>{
  Map<String, dynamic> sidePageList = {'withdrawal': WithdrawService(), 'switch_notice': SwitchNotice(), 'invite' : Invitation()};
  static const storage = FlutterSecureStorage();
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          color: const Color(0xffffc8c7),
          padding: const EdgeInsets.all(20),
          child : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15),
              Text(widget.userinfo.nickname, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
              const SizedBox(height: 15),
            ],
          )
        ),
        Container(
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('아이 관리', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 10),
              SizedBox(
                  height: 110,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.babies.length + 1,
                      itemBuilder: (BuildContext context, int index){
                        if(index < widget.babies.length){
                          return drawBaby(widget.babies[index].name);
                        }else{
                          return Container(
                              padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                              child: Column(
                                  children:[
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(width: 0.5, color: Colors.grey),
                                        shape: BoxShape.circle,
                                      ),
                                      child: IconButton(
                                          onPressed: (){
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context)=> ManageBabyWidget())
                                            );
                                          },
                                          iconSize: 40,
                                          color: Colors.grey,
                                          icon: const Icon(Icons.add)),
                                    ),
                                    const SizedBox(height: 8),
                                    const Text('아이 추가')
                                  ]
                              )
                          );
                        }
                      }
                  )
              ),
            ],
          )
        ),
        SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
            child:  Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                getSettingScreen('양육자 / 베이비시터 초대', const Icon(Icons.diamond_outlined),()=> navigatorSide('invite')),
                Divider(thickness: 1, color: Colors.grey[400]),
                getSettingScreen('알림 ON / OFF', const Icon(Icons.notifications_off_outlined),()=> navigatorSide('switch_notice')),
                Divider(thickness: 1, color: Colors.grey[400]),
                const SizedBox(height: 50),
                const Text('Common'),
                const SizedBox(height: 10),
                getSettingScreen('로그아웃', const Icon(Icons.logout),()=>logout()),
                Divider(thickness: 1, color: Colors.grey[300]),
                getSettingScreen('회원 정보 수정', const Icon(Icons.mode_edit_outlined),(){}),
                Divider(thickness: 1, color: Colors.grey[300]),
                getSettingScreen('서비스 탈퇴', const Icon(Icons.minimize),()=> navigatorSide('withdrawal')),
                Divider(thickness: 1, color: Colors.grey[300]),
              ],
            ),
          ),
        ),
      ],
    );
  }
  navigatorSide(target){
    Navigator.push(
        context,
        CupertinoPageRoute(builder: (context)=> sidePageList[target])
    );
  }
  logout() async{
    await storage.delete(key: 'login');
    Navigator.pushReplacement(
        context,
        CupertinoPageRoute(builder: (context)=> LoginInit())
    );
  }
  Container getSettingScreen(title, icon, func){
    return Container(
      padding: const EdgeInsets.all(10),
      child: InkWell(
          onTap: func,
          child: Row(
            children: [icon, const SizedBox(width: 30), Text(title)],
          )
      )
    );
  }
}
Widget drawBaby(String name){
  return Container(
      padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
      child: Column(
          children:[
            Image.asset('assets/images/baby.png',scale: 10),
            const SizedBox(height: 8),
            Text(name)
          ]
      )
  );
}