import 'package:flutter/material.dart';
import 'package:bob/widgets/appbar.dart';
class ManageBabyWidget extends StatefulWidget{
  //ManageBabyWidget(User? userInfo);
  @override
  _ManageBabyWidget createState() => _ManageBabyWidget();
}
class _ManageBabyWidget extends State<ManageBabyWidget> with TickerProviderStateMixin{
  late TabController _tabController;
  @override
  void initState() {
    _tabController = TabController(
      length: 2,
      vsync: this, //vsync에 this 형태로 전달해야 애니메이션이 정상 처리됨
    );
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: renderAppbar('아이 관리'),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(25),
            child: TabBar(
              tabs: [
                Container(
                    height: 35,
                    alignment: Alignment.center,
                    child: const Text('아이 수정')
                ),
                Container(
                    height: 35,
                    alignment: Alignment.center,
                    child: const Text('아이 추가')
                )
              ],
              labelStyle: const TextStyle(fontWeight: FontWeight.bold),
              labelColor: const Color(0xffff846d),
              indicatorColor: const Color(0xffff846d),
              unselectedLabelColor: Colors.grey,
              controller: _tabController,
            ),
          ),
          Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  Center(child: Text('아이 수정'),),
                  Center(child: Text('아이 추가'),)
                ],
              )
          )
        ],
      )
    );
  }
}
Widget addBaby(){
  return Container(
    child: Text('아이 추가')
  );
}
Widget modifyBaby(){
  return Container(
      child: Text('아이 수정')
  );
}