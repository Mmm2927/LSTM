import 'package:flutter/material.dart';
import 'package:bob/screens/main_1_home.dart';
import 'package:bob/screens/main_2_cctv.dart';
import 'package:bob/screens/main_3_diary.dart';
import 'package:bob/screens/main_4_mypage.dart';
import '../models/model.dart';
import 'package:bob/widgets/appbar.dart';
import 'package:bob/screens/MyPage/manage_baby.dart';
import 'package:flutter/cupertino.dart';
import 'package:bob/widgets/bottomNav.dart';

class BaseWidget extends StatefulWidget{
  final User userinfo;
  const BaseWidget(this.userinfo, {Key?key}):super(key:key);
  @override
  State<BaseWidget> createState() => _BaseWidget();
}
class _BaseWidget extends State<BaseWidget>{
  late List<Baby> MyBabies = [];
  late int c_baby = 0;
  int _selectedIndex = 0; // 인덱싱
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  void initState() {
    super.initState();
    getBabyList();
  }
  getBabyList(){
    // 1. user와 연결된 Baby-list 가져오기
    //print('=>>>>>>>>>>>'+ DateTime.parse('10:30').toString());
    List<Baby_relation> BabyRelations = [Baby_relation(11, 0, 255, '00:00', '23:59')];  //[];
    if(BabyRelations.isEmpty){    // 아기가 없다면 아기 추가 페이지로 이동
      /*Navigator.push(
          context,
          CupertinoPageRoute(
              builder: (context) => ManageBabyWidget()
          )
      );*/
    }else{
      /*
      BabyRelations.forEach((element) {
        // dio 통해 받아오기
        // Baby에서 해당 하는 Baby ID 가져 오기 - BabyRelations[0].id 에 해당 하는 Baby 정보 가져 오기
        Baby b = Baby('nu1', DateTime.now(), 0, element);
        MyBabies.add(b);
      });*/
    }
    // 2.
    MyBabies.add(Baby('쑥이', DateTime.utc(2022,11,20), 0, Baby_relation(0, 0, 255, "00:00","23:59")));
    MyBabies.add(Baby('콩이', DateTime.utc(2021,10,3), 0, Baby_relation(1, 0, 255, "00:00","23:59")));
    MyBabies.add(Baby('얌얌', DateTime.utc(2011,5,20), 1, Baby_relation(2, 0, 255, "00:00","23:59")));
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _widgetOptions = <Widget>[
      Main_Home(MyBabies),
      Main_Cctv(),
      const MainDiary(),
      MainMyPage(widget.userinfo, MyBabies)
    ];
    return DefaultTabController(
      length: 3,
      initialIndex: 1, // 가운데에 있는 홈버튼을 기본값으로 설정
      // vsync: this,  나중에 다른 페이지 연결했을 때 사용
      child: WillPopScope(
       onWillPop: () async => false,
       child: Scaffold(
         appBar: renderAppbar_with_alarm('BoB', context),
         body: SafeArea(
             child: _widgetOptions.elementAt(_selectedIndex),
         ),
           bottomNavigationBar: bottomNavBar(_selectedIndex, _onItemTapped)
       ),
      )
    );
  }
}