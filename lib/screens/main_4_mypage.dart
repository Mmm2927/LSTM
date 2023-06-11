import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:bob/screens/Login/initPage.dart';
import 'package:bob/screens/MyPage/manage_baby.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:intl/intl.dart';
import '../models/model.dart';
import 'package:bob/screens/MyPage/invitation.dart';
import 'package:bob/screens/MyPage/withdraw.dart';
import 'package:bob/screens/MyPage/modifyUser.dart';
import 'package:bob/widgets/appbar.dart';
import 'package:get/get.dart' hide Trans;
import '../services/storage.dart';
import 'package:easy_localization/easy_localization.dart' hide StringTranslateExtension;

// 앱에서 지원하는 언어 리스트 변수
final supportedLocales = [
  const Locale('en', 'US'),
  const Locale('ko', 'KR')
];
class MainMyPage extends StatefulWidget{
  final User userinfo;
  final getBabiesFuction; // 아기 불러오는 fuction
  final reloadBabiesFunction;
  const MainMyPage(this.userinfo, {Key?key, this. getBabiesFuction, this.reloadBabiesFunction}):super(key:key);
  @override
  State<MainMyPage> createState() => MainMyPageState();
}
class MainMyPageState extends State<MainMyPage>{
  late List<Baby> activateBabies;
  late List<Baby> disActivateBabies;
  String selectedLanguageMode = '한국어';

  @override
  void initState() {
    activateBabies = widget.getBabiesFuction(true);
    disActivateBabies = widget.getBabiesFuction(false);
    log('MyPage : ${activateBabies.length} | ${disActivateBabies.length}');
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
            margin: const EdgeInsets.fromLTRB(10,0,10,0),
            padding: const EdgeInsets.all(20),
              child :Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${widget.userinfo.name}${'main4_profileName'.tr}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
                          const SizedBox(height: 5),
                          Text('main4_profileGreeting'.tr, style: const TextStyle(color: Colors.grey))
                        ],
                      ),
                      Image.asset('assets/images/person.png',scale: 12, color: Colors.grey[800])
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(5),
                        width: 130,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('main4_profileMyBaby'.tr, style: TextStyle(color: Colors.grey[600])),
                            const SizedBox(height: 5),
                            Center(
                              child: Text(activateBabies.length.toString(), style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20)),
                            ),
                            const SizedBox(height: 10)
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.all(5),
                        width: 130,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('main4_profileAwaitingBaby'.tr, style: TextStyle(color: Colors.grey[600])),
                            const SizedBox(height: 5),
                            Center(
                              child: Text(disActivateBabies.length.toString(), style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20)),
                            ),
                            const SizedBox(height: 10)
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              )
          ),
          Divider(color: Colors.grey[200], thickness: 7),
          Expanded(
            child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          //margin: const EdgeInsets.all(10),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('main4_manageBaby'.tr, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xfffa625f))),
                              const SizedBox(height: 10),
                              SizedBox(
                                  height: 110,
                                  child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: activateBabies.length + 1,
                                      itemBuilder: (BuildContext context, int index){
                                        if(index < activateBabies.length){
                                          return drawBaby(activateBabies[index]!);
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
                                                            await Get.to(ManageBabyWidget(activateBabies));
                                                            await widget.reloadBabiesFunction();
                                                          },
                                                          iconSize: 40,
                                                          color: Colors.grey,
                                                          icon: const Icon(Icons.add)),
                                                    ),
                                                    const SizedBox(height: 8),
                                                    Text('main4_addBaby'.tr)
                                                  ]
                                              )
                                          );
                                        }
                                      }
                                  )
                              )
                            ],
                          )
                      ),
                      getSettingScreen('main4_babyAddModify'.tr, const Icon(Icons.edit_attributes_sharp),() async{
                        await Get.to(() => ManageBabyWidget(activateBabies));
                        await widget.reloadBabiesFunction();
                      }),
                      getSettingScreen('main4_InviteBabysitter'.tr, const Icon(Icons.diamond_outlined),() async{
                        await Get.to(() => Invitation(activateBabies, disActivateBabies));
                        await widget.reloadBabiesFunction();
                      }),
                      const SizedBox(height: 30),
                      const Text('Common', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.grey)),
                      const SizedBox(height: 10),
                      getSettingScreen('main4_logout'.tr, const Icon(Icons.logout),() => logout()),
                      getSettingScreen('main4_modifyUserInfo'.tr, const Icon(Icons.mode_edit_outlined),() async {
                        var modifyInfo = await Get.to(() => ModifyUser(widget.userinfo));
                        if(modifyInfo != null){
                          setState((){
                            widget.userinfo.modifyUserInfo(modifyInfo['pass'], modifyInfo['name'], modifyInfo['phone']);
                          });
                        }
                      }),
                      getLanguageModeScreen('main4_changeLanguage'.tr),
                      getSettingScreen('main4_withdrawal'.tr, const Icon(Icons.minimize),(){
                        Get.to(() => const WithdrawService());
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
  changeLanguageMode(){
    Get.dialog(
        AlertDialog(
          title: Text('main4_changeLM'.tr),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(
                    onPressed: (){
                      setState(() {
                        selectedLanguageMode = '한국어';
                        Get.updateLocale(const Locale('ko','KR'));
                      });
                      Get.back();
                    },
                    child: const Text('한국어')
                ),
                const Divider(thickness: 0.2, color: Colors.grey),
                TextButton(
                    onPressed: (){
                      setState(() {
                        selectedLanguageMode = 'English';
                        Get.updateLocale(const Locale('en','US'));
                      });
                      Get.back();
                    },
                    child: const Text('English')
                ),
                const Divider(thickness: 0.2, color: Colors.grey),
                TextButton(
                    onPressed: (){
                      setState(() {
                        selectedLanguageMode = '中国';
                      });
                      Get.back();
                    },
                    child: const Text('中国')
                ),
              ],
            )
        )
    );
  }

  logout() async{
    await deleteLogin();
    Get.offAll(const LoginInit());
  }

  Container getLanguageModeScreen(title){
    return Container(
      padding: const EdgeInsets.all(8),
        child: InkWell(
            onTap: ()=> changeLanguageMode(),
            child : Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: [const Icon(Icons.language), const SizedBox(width: 30), Text(title)]),
                    Text(selectedLanguageMode, style: const TextStyle(color: Colors.grey))
                  ],
                ),
                const SizedBox(height: 8),
                Divider(thickness: 1, color: Colors.grey[300]),
              ],
            )
        )
    );
  }
  Container getSettingScreen(title, icon, func){
    return Container(
      padding: const EdgeInsets.all(8),
      child: InkWell(
          onTap: func,
          child : Column(
            children: [
              Row(children: [icon, const SizedBox(width: 25), Text(title, style: const TextStyle(fontSize: 13))]),
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
                Text(baby.name, style: TextStyle(fontSize: 12))
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
