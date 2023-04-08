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

class BaseWidget extends StatefulWidget{
  final User userinfo;
  final List<Baby> MyBabies;
  const BaseWidget(this.userinfo, this.MyBabies, {Key?key}):super(key:key);
  @override
  State<BaseWidget> createState() => _BaseWidget();
}
class _BaseWidget extends State<BaseWidget>{
  int _selectedIndex = 0; // 인덱싱
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  void initState() {
    if(widget.MyBabies.isEmpty){
      GET.Get.to(()=>ManageBabyWidget(widget.MyBabies));
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