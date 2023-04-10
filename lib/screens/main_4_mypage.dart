import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:bob/screens/Login/initPage.dart';
import 'package:bob/screens/MyPage/manage_baby.dart';
import 'package:intl/intl.dart';
import '../models/model.dart';
import 'package:bob/screens/MyPage/invitation.dart';
import 'package:bob/screens/MyPage/switchNotice.dart';
import 'package:bob/screens/MyPage/withdraw.dart';
import 'package:bob/screens/MyPage/modifyUser.dart';
import 'package:bob/screens/MyPage/modifyBaby.dart';
import 'package:bob/widgets/appbar.dart';
import 'package:get/get.dart' as GET;

import '../services/storage.dart';

class MainMyPage extends StatefulWidget{
  final User userinfo;
  final List<Baby> babies;
  const MainMyPage(this.userinfo, this.babies, {Key?key}):super(key:key);
  @override
  State<MainMyPage> createState() => _MainMyPage();
}
class _MainMyPage extends State<MainMyPage>{
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: renderAppbar_with_alarm('BoB', context),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              width: double.infinity,
              color: const Color(0xffffc8c7),
              padding: const EdgeInsets.all(20),
              child : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Text(widget.userinfo.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
                  const SizedBox(height: 10),
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
                              return drawBaby(widget.babies[index]);
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
                                              onPressed: () async{
                                                Baby newBabyInfo = await GET.Get.to(ManageBabyWidget(widget.babies));
                                                setState(() {
                                                  widget.babies.add(newBabyInfo);
                                                });
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
                  getSettingScreen('아이 추가 / 수정', const Icon(Icons.edit_attributes_sharp),(){
                    GET.Get.to(() => ManageBabyWidget(widget.babies));
                  }),
                  getSettingScreen('양육자 / 베이비시터 초대', const Icon(Icons.diamond_outlined),(){
                    GET.Get.to(() => Invitation());
                  }),
                  getSettingScreen('알림 ON / OFF', const Icon(Icons.notifications_off_outlined),(){
                    GET.Get.to(() => SwitchNotice(widget.babies));
                  })
                ],
              )
          ),
          Expanded(
            child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Common'),
                      const SizedBox(height: 10),
                      getSettingScreen('로그아웃', const Icon(Icons.logout),() => logout()),
                      getSettingScreen('회원 정보 수정', const Icon(Icons.mode_edit_outlined),() async {
                        var modifyInfo = await GET.Get.to(() => ModifyUser(widget.userinfo));
                        if(modifyInfo != null){
                          setState((){
                            widget.userinfo.modifyUserInfo(modifyInfo['pass'], modifyInfo['name'], modifyInfo['phone']);
                          });
                        }
                      }),
                      getSettingScreen('언어 모드 변경', const Icon(Icons.language),(){}),
                      getSettingScreen('서비스 탈퇴', const Icon(Icons.minimize),(){
                        GET.Get.to(() => const WithdrawService());
                      }),
                    ],
                  ),
                )
            ),
          )

        ],
      )
    );
  }
  logout() async{
    await deleteLogin();
    GET.Get.to(() => const LoginInit());
  }
  Container getSettingScreen(title, icon, func){
    return Container(
      padding: const EdgeInsets.all(8),
      child: InkWell(
          onTap: func,
          child : Column(
            children: [
              Row(children: [icon, const SizedBox(width: 30), Text(title)]),
              const SizedBox(height: 8),
              Divider(thickness: 1, color: Colors.grey[300]),
            ],
          )
      )
    );
  }
  Widget drawBaby(Baby baby){
    return InkWell(
      child: Container(
          padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
          child: Column(
              children:[
                Image.asset('assets/images/baby.png',scale: 10),
                const SizedBox(height: 8),
                Text(baby.name)
              ]
          )
      ),
      onTap: (){
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context){
              return AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                content: SizedBox(
                  height: 300,
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.topRight,
                        child: IconButton(
                            onPressed: (){Navigator.pop(context);},
                            icon: const Icon(Icons.close)
                        ),
                      ),
                      const SizedBox(height: 10),
                      Image.asset('assets/images/baby.png',scale: 8),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: Text(baby.name, style: const TextStyle(fontSize: 24,fontWeight: FontWeight.bold)),
                      ),
                      Text('생일 : ${DateFormat('yyyy년 MM월 dd일').format(baby.birth)}', style:const TextStyle(fontSize: 20)),
                      Text('성별 : ${baby.getGenderString()}', style:const TextStyle(fontSize: 20)),
                      Text('관계 : ${baby.relationInfo.getRelationString()}', style:const TextStyle(fontSize: 20)),
                    ],
                  ),
                )
              );
            }
        );
      },
    );
  }
}
