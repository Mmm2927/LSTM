import 'package:flutter/material.dart';
import 'package:bob/widgets/appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:dio/dio.dart';
import 'package:bob/screens/MyPage/modifyBaby.dart';
import 'package:intl/intl.dart';
import '../../models/model.dart';
import 'package:bob/services/backend.dart';
import 'package:get/get.dart' as GET;

class ManageBabyWidget extends StatefulWidget{
  final List<Baby> babies;
  const ManageBabyWidget(this.babies, {Key?key}):super(key:key);
  @override
  State<ManageBabyWidget> createState() => _ManageBabyWidget();
}
class _ManageBabyWidget extends State<ManageBabyWidget> with TickerProviderStateMixin{
  final dio = Dio();    // 서버와 통신을 하기 위해 필요한 패키지
  late TabController _tabController;
  int _valueGender = 0;
  DateTime birth = DateTime(2016, 10, 26);
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
      vsync: this,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: renderAppbar('아이 관리', true),
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
                  addBaby(),
                  modifyBaby(context),
                ],
              )
          )
        ],
      )
    );
  }
  Widget modifyBaby(BuildContext rootContext){
    List<Baby> myBabies = [];
    for (var value in widget.babies) {
      if(value.relationInfo.relation == 0){
        myBabies.add(value);
      }
    }
    return Expanded(
            child: GridView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: myBabies.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1 / 1,
                ),
                itemBuilder: (BuildContext context, int index){
                  return drawBaby(myBabies[index], rootContext);
                },
            )
    );
  }
  drawBaby(Baby baby, BuildContext rootContext){
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: Colors.grey)
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/baby.png',scale: 10),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
            child : Text(baby.name, style: TextStyle(fontSize: 24)),
          ),
          Row(
            children: [
              Expanded(
                  child: OutlinedButton(onPressed: (){
                    Navigator.push(
                        rootContext,
                        CupertinoPageRoute(builder: (context)=> ModifyBaby(baby))
                    );
                  }, child: const Text('수정', style: TextStyle(color: Color(0xfffa625f)))),
              ),
              Padding(padding: EdgeInsets.all(2)),
              Expanded(
                  child: OutlinedButton(onPressed: (){}, child: Text('삭제',style: TextStyle(color: Colors.black)))
              )
            ],
          )
        ],
      ),
    );
  }
  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }
  Widget addBaby(){
    return SingleChildScrollView(
      child: Container(
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
                    initialDateTime: birth,
                    mode: CupertinoDatePickerMode.date,
                    use24hFormat: true,
                    // This is called when the user changes the date.
                    onDateTimeChanged: (DateTime newDate) {
                      setState(() => birth = newDate);
                    },
                  ),
                ),
                child: Text(
                  '${birth.year}년 ${birth.month}월 ${birth.day}일',
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
              SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.all(20),
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
                        _registerBaby();
                      },
                      child: Text('등록'))
              )
            ],
          )
      )
    );
  }
  void _registerBaby() async{
    // validate
    if(nameController.text.isEmpty && nameController.text.length < 5){
      return;
    }
    var response = await setBabyService({"baby_name":nameController.text, "birth":DateFormat('yyyy-MM-dd').format(birth), "gender":(_valueGender==0?'F':'M'),"ip":null});
    if(response['result'] == 'success'){
      GET.Get.back();
    }
    else{
      print('errorr');
    }
  }
}


