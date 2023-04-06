import 'package:flutter/material.dart';
import 'package:bob/widgets/appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:dio/dio.dart';

class ManageBabyWidget extends StatefulWidget{
  //ManageBabyWidget(User? userInfo);
  @override
  _ManageBabyWidget createState() => _ManageBabyWidget();
}
class _ManageBabyWidget extends State<ManageBabyWidget> with TickerProviderStateMixin{
  final dio = Dio();    // 서버와 통신을 하기 위해 필요한 패키지
  late TabController _tabController;
  int _valueGender = 0;
  DateTime date = DateTime(2016, 10, 26);
  var nameController = TextEditingController();
  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => Container(
          height: 216,
          padding: const EdgeInsets.only(top: 6.0),
          // The Bottom margin is provided to align the popup above the system
          // navigation bar.
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          // Provide a background color for the popup.
          color: CupertinoColors.systemBackground.resolveFrom(context),
          // Use a SafeArea widget to avoid system overlaps.
          child: SafeArea(
            top: false,
            child: child,
          ),
        ));
  }
  @override
  void initState() {
    _tabController = TabController(
      length: 2,
      vsync: this, // vsync에 this 형태로 전달 해야 애니메이션이 정상 처리됨
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
                    child: const Text('아이 추가')
                ),
                Container(
                    height: 35,
                    alignment: Alignment.center,
                    child: const Text('아이 수정')
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
                  SingleChildScrollView(child: addBaby(),),
                  SingleChildScrollView(child: modifyBaby()),
                ],
              )
          )
        ],
      )
    );
  }
  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }
  Widget addBaby(){
    return Container(
        margin: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('아기 이름'),
            TextFormField(
              controller: nameController,
            ),
            const SizedBox(height: 30),
            const Text('생일'),
            CupertinoButton(
              // Display a CupertinoDatePicker in date picker mode.
              onPressed: () => _showDialog(
                CupertinoDatePicker(
                  initialDateTime: date,
                  mode: CupertinoDatePickerMode.date,
                  use24hFormat: true,
                  // This is called when the user changes the date.
                  onDateTimeChanged: (DateTime newDate) {
                    setState(() => date = newDate);
                  },
                ),
              ),
              child: Text(
                '${date.year}년 ${date.month}월 ${date.day}일',
                style: const TextStyle(
                  fontSize: 22.0,
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Text('성별'),
            const SizedBox(height: 10),
            Wrap(
                spacing: 10.0,
                children: List<Widget>.generate(
                    2, (int index){
                  List<String> gender = ['남자', '여자'];
                  return ChoiceChip(
                    elevation: 6.0,
                    padding: const EdgeInsets.all(10),
                    selectedColor: const Color(0xffff846d),
                    label: Text(gender[index]),
                    selected: _valueGender == index,
                    onSelected: (bool selected){
                      setState((){
                        _valueGender = (selected ? index : null)!;
                      });
                    }
                  );
                }).toList()
            ),
            const SizedBox(height: 50),
            Container(
              width: double.infinity,
              child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.all(20),
                    elevation: 0.0,
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xfffa625f),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                      side: const BorderSide(
                        color: Colors.grey,
                        width: 0.5,
                      )
                  ),
                  onPressed: (){
                    if(nameController.text.isEmpty && nameController.text.length < 5){
                      return;
                    }
                    _registerBaby();
                    //print(nameController.text + date.toString());
                  },
                  child: Text('등록'))
            )
          ],
        )
    );
  }
  void _registerBaby() async{
    // 2. Login
    //Response response = await dio.post('http://20.249.219.241:8000/api/user/login/', data:{'email' : "hehe@kyonggi.ac.kr", 'password': "qwe123!@#"});
    Response response = await dio.post('http://20.249.219.241:8000/api/baby/set/', data:{'baby_name' : nameController.text, 'birth': date,'gender': _valueGender==0?'M':'F'});
    if(response.statusCode == 200){
      /*
      String token = response.data['access_token']; // response의 token키에 담긴 값을 token 변수에 담아서
      Map<dynamic, dynamic> payload = Jwt.parseJwt(token);
      // 로그인 정보 저장
      User uinfo = User(response.data['email'], passController.text, response.data['name'], "01092982310");    // response.data['phone']
      Login loginInfo = Login(token, payload['user_id'], uinfo);
      await storage.write(key: 'login', value: jsonEncode(loginInfo));
      Navigator.pushReplacement(
          context,
          CupertinoPageRoute(builder: (context)=> BaseWidget(uinfo))
      );*/
    }else{
      /*
      print(response.statusCode.toString());
      _showDialog("등록된 사용자가 아닙니다");
      idController.clear();
      passController.clear();*/
    }
  }
}

Widget modifyBaby(){
  return Container(
      margin: const EdgeInsets.all(15),
      child: Text('아이 수정')
  );
}
