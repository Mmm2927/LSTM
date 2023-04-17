import 'package:bob/screens/MyPage/manage_baby.dart';
import 'package:flutter/material.dart';
import 'package:bob/screens/main_1_home.dart';
import 'package:bob/screens/main_2_cctv.dart';
import 'package:bob/screens/main_3_diary.dart';
import 'package:bob/screens/main_4_mypage.dart';
import '../models/model.dart';
import 'package:flutter/cupertino.dart';
import 'package:bob/widgets/bottomNav.dart';
import 'package:get/get.dart' as GET;
import 'package:bob/services/backend.dart';

class BaseWidget extends StatefulWidget{
  final User userinfo;
  final List<Baby> MyBabies;
  const BaseWidget(this.userinfo, this.MyBabies, {Key?key}):super(key:key);
  @override
  State<BaseWidget> createState() => _BaseWidget();
}
class _BaseWidget extends State<BaseWidget>{
  int _selectedIndex = 0; // 인덱싱
  late List<int> babyIds;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  void initState() {
    super.initState();
    babyIds = [];
    for(int i=0;i<widget.MyBabies.length;i++){
      babyIds.add(widget.MyBabies[i].relationInfo.BabyId);
    }
    if(widget.MyBabies.isEmpty){
      loadData();
    }
  }
  Future<void> loadData() async {
    await GET.Get.to(ManageBabyWidget(widget.MyBabies));
    print('dd');
    List<dynamic> babyRelationList = await getMyBabies();
    print(babyRelationList);
    for(int i=0; i<babyRelationList.length;i++){
      // 기존에 있는 아이디인지 확인
      if(!babyIds.contains(babyRelationList[i]['baby'])){
        // 없으면 ADD  // 2. 아기 등록
        Baby_relation relation = Baby_relation.fromJson(babyRelationList[i]);
        var baby = await getBaby(babyRelationList[i]['baby']);
        baby['relationInfo'] = relation.toJson();
        setState(() {
          babyIds.add(babyRelationList[i]['baby']);
          widget.MyBabies.add(Baby.fromJson(baby));
        });
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    final List<Widget> widgetOptions = <Widget>[
      Main_Home(widget.MyBabies, widget.userinfo),
      Main_Cctv(),
      const MainDiary(),
      MainMyPage(widget.userinfo, widget.MyBabies)
    ];
    return DefaultTabController(
        length: 3,
        initialIndex: 1, // 가운데에 있는 홈버튼을 기본값으로 설정
        child: WillPopScope(
          onWillPop: () async => false,
          child: Scaffold(
              body: SafeArea(
                child: widgetOptions.elementAt(_selectedIndex),
              ),
              bottomNavigationBar: bottomNavBar(_selectedIndex, _onItemTapped)
          ),
        )
    );
  }

}