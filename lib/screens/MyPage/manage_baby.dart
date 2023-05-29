import 'package:flutter/material.dart';
import 'package:bob/widgets/appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:dio/dio.dart';
import 'package:bob/screens/MyPage/modifyBabyDetail.dart';
import 'package:intl/intl.dart';
import '../../models/model.dart';
import 'package:bob/services/backend.dart';
import 'package:get/get.dart' as GET;
import '../../widgets/form.dart';
import './modifyBaby.dart';
class ManageBabyWidget extends StatefulWidget{
  final List<Baby> babies;
  const ManageBabyWidget(this.babies, {Key?key}):super(key:key);
  @override
  State<ManageBabyWidget> createState() => _ManageBabyWidget();
}
class _ManageBabyWidget extends State<ManageBabyWidget> with TickerProviderStateMixin{
  late TabController _tabController;
  var nameController = TextEditingController();
  DateTime birth = DateTime(2023, 01, 01);
  List<bool> isSelected = [true, false];

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
                  ModifyBabyWidget(widget.babies)
                  //modifyBaby(context),
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
    return Column(
      children: [
        Expanded(
            flex : 8,
            child: SingleChildScrollView(
                child: Container(
                    margin: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('최소 한명의 아기는 등록되어 있어야 합니다!', style: TextStyle(color: Colors.pink)),
                        const SizedBox(height: 50),
                        const Text('아기 이름'),
                        const SizedBox(height: 8),
                        TextFormField(
                          decoration: formDecoration('아기의 이름 또는 별명을 입력해 주세요'),
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
                                color: Colors.black
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        const Text('성별'),
                        const SizedBox(height: 10),
                        ToggleButtons(
                            borderRadius: BorderRadius.circular(8.0),
                            fillColor: const Color(0x98ffd3d2),
                            selectedColor : const Color(0xfffa625f),
                            color: Colors.grey,
                            onPressed: (int idx){
                              setState(() {
                                isSelected = [idx == 0, idx == 1];
                              });
                            },
                            isSelected: isSelected,
                            children: [
                              SizedBox(
                                  width: (MediaQuery.of(context).size.width - 36)/5*2,
                                  child: const Center(
                                      child: Text('남아', style: TextStyle(fontSize: 18))
                                  )
                              ),
                              SizedBox(
                                  width: (MediaQuery.of(context).size.width - 36)/5*2,
                                  child: const Center(
                                      child: Text('여아', style: TextStyle(fontSize: 18))
                                  )
                              ),
                            ]
                        ),
                      ],
                    )
                )
            )
        ),
        Expanded(
            flex : 1,
            child: Container(
                padding: const EdgeInsets.all(8),
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
                    child: const Text('등록', style: TextStyle(fontSize: 18))
                )
            )
        ),
        const SizedBox(height: 30)
      ],
    );
  }
  void _registerBaby() async{
    // validate
    if(nameController.text.isEmpty && nameController.text.length < 5){
      return;
    }
    var response = await setBabyService({"baby_name":nameController.text, "birth":DateFormat('yyyy-MM-dd').format(birth), "gender":(isSelected[1]==true?'F':'M'),"ip":null});
    if(response['result'] == 'success'){
      GET.Get.back();
    }
  }
}


