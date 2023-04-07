import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:bob/screens/main_1_home.dart';
import 'package:bob/screens/main_2_cctv.dart';
import 'package:bob/screens/main_3_diary.dart';
import 'package:bob/screens/main_4_mypage.dart';
import '../models/model.dart';
import 'package:flutter/cupertino.dart';
import 'package:bob/widgets/bottomNav.dart';
import 'package:bob/httpservices/backend.dart';

class BaseWidget extends StatefulWidget{
  final User userinfo;
  const BaseWidget(this.userinfo, {Key?key}):super(key:key);
  @override
  State<BaseWidget> createState() => _BaseWidget();
}
class _BaseWidget extends State<BaseWidget>{
  late Future babyFuture;
  int _selectedIndex = 0; // 인덱싱
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    babyFuture = _getBabyList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: babyFuture,
        builder: (BuildContext context, AsyncSnapshot snapshot){
          if (snapshot.hasData == false){
            return CircularProgressIndicator();
          }else if (snapshot.hasError) {
            return Padding(
              padding: const EdgeInsets.all(8.0),

              child: Text(
                'Error: ${snapshot.error}', // 에러명을 텍스트에 뿌려줌
                style: TextStyle(fontSize: 15),
              ),
            );
          }else {
            List<Baby> MyBabies = snapshot.data as List<Baby>;
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
                      body: SafeArea(
                        child: _widgetOptions.elementAt(_selectedIndex),
                      ),
                      bottomNavigationBar: bottomNavBar(_selectedIndex, _onItemTapped)
                  ),
                )
            );
          }
        }
    );
  }
  Future _getBabyList() async{
    List<Baby> MyBabies = [];
    // 1. user와 연결된 Baby-list 가져오기
    var babyList = await getMyBabies();
    List<dynamic> babyListParsed = babyList;
    for(int i=0; i<babyListParsed.length;i++){
      // 1. baby relation도 받아오기
      print('-=-------------');
      print(babyListParsed[i]);
      Baby_relation relation;
      if(babyListParsed[i]['relation']==0)
        relation = Baby_relation(babyListParsed[i]['baby'], babyListParsed[i]['relation'], 255,"","");
      else
        relation = Baby_relation.fromJson(babyListParsed[i]);
      // 2. 아기 등록
      var baby = await getBaby(babyListParsed[i]['baby']);
      baby['relationInfo'] = relation.toJson();
      Baby newBaby = Baby.fromJson(baby);
      MyBabies.add(newBaby);
    }
    return MyBabies;
  }
}