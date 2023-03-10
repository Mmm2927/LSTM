import 'package:flutter/material.dart';
import 'package:bob/screens/main_1_home.dart';
import 'package:bob/screens/main_2_cctv.dart';
import 'package:bob/screens/main_3_diary.dart';
import 'package:bob/screens/main_4_mypage.dart';

class BaseWidget extends StatefulWidget{
  @override
  _BaseWidget createState() => _BaseWidget();
}
class _BaseWidget extends State<BaseWidget>{
  int _selectedIndex = 0; // 인덱싱
  final List<Widget> _widgetOptions = <Widget>[
    Main_Home(),
    Main_Cctv(),
    Main_Diary(),
    Main_Mypage()
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 1, // 가운데에 있는 홈버튼을 기본값으로 설정
      // vsync: this,  나중에 다른 페이지 연결했을 때 사용
      child: Scaffold(

          body: SafeArea(
            child: _widgetOptions.elementAt(_selectedIndex),
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home, size: 18,),
                  label: '홈'
              ),
              BottomNavigationBarItem(
                  icon: Icon( Icons.camera, size: 18,),
                  label: 'cctv'
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline, size: 18,),
                  label: '일기'
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline, size: 18,),
                  label: '마이 자취'
              ),
            ],
            currentIndex: _selectedIndex,
            unselectedItemColor: Colors.grey,
            selectedItemColor: const Color(0xffffa511),
            onTap: _onItemTapped,
          )
      ),
    );
  }

}