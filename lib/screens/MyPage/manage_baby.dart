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
      appBar: renderAppbar('main4_manageBaby'.tr, true),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(25),
            child: TabBar(
              tabs: [
                Container(
                    height: 35,
                    alignment: Alignment.center,
                    child: Text('main4_addBaby'.tr)
                ),
                Container(
                    height: 35,
                    alignment: Alignment.center,
                    child: Text('main4_modifyBaby'.tr)
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
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
      child: Column(
        children: [
          Expanded(
              child: SingleChildScrollView(
                  child: Container(
                      margin: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('babyNullErr'.tr, style: const TextStyle(color: Color(0xfffa625f))),
                          const SizedBox(height: 30),
                          Text('babyName'.tr),
                          const SizedBox(height: 8),
                          TextFormField(
                            decoration: formDecoration('babyNameHint'.tr),
                            controller: nameController,
                          ),
                          const SizedBox(height: 30),
                          Text('birth'.tr),
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
                          Text('gender'.tr),
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
                                    child: Center(
                                        child: Text('genderM'.tr, style: const TextStyle(fontSize: 18))
                                    )
                                ),
                                SizedBox(
                                    width: (MediaQuery.of(context).size.width - 36)/5*2,
                                    child: Center(
                                        child: Text('genderF'.tr, style: const TextStyle(fontSize: 18))
                                    )
                                ),
                              ]
                          ),
                        ],
                      )
                  )
              )
          ),
          Container(
              padding: const EdgeInsets.all(8),
              width: double.infinity,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(18),
                      elevation: 0.0,
                      backgroundColor: const Color(0xfffa625f),
                      foregroundColor: Colors.white,
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
                  child: Text('registration'.tr, style: const TextStyle(fontSize: 18))
              )
          )
        ],
      )
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


