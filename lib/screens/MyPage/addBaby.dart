import 'package:bob/models/model.dart';
import 'package:bob/screens/BaseWidget.dart';
import 'package:bob/widgets/pharse.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../services/backend.dart';
import '../../widgets/appbar.dart';
import '../../widgets/form.dart';

class AddBaby extends StatefulWidget{
  User userInfo;
  List<Baby> myBabies;
  AddBaby(this.userInfo, this.myBabies, {super.key});
  @override
  State<AddBaby> createState() => _AddBaby();
}
class _AddBaby extends State<AddBaby> {

  var nameController = TextEditingController();
  DateTime birth = DateTime(2023, 01, 01);
  List<bool> isSelected = [true, false];
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future(() => false);
      },
      child: Scaffold(
        appBar: renderAppbar('아기 추가', false),
        body : Column(
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
                child: Container(
                  padding: const EdgeInsets.all(8),
                  width: double.infinity,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.all(20),
                        elevation: 0.5,
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xfffa625f),
                        minimumSize: const Size.fromHeight(55),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0))
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
        )
      )
    );
  }
  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => Container(
          height: 216,
          padding: const EdgeInsets.only(top: 6.0),
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          color: CupertinoColors.systemBackground.resolveFrom(context),
          child: SafeArea(
            top: false,
            child: child,
          ),
        ));
  }
  void _registerBaby() async{
    // validate
    if(nameController.text.isEmpty && nameController.text.length < 5){
      return;
    }
    var response = await setBabyService({"baby_name":nameController.text, "birth":DateFormat('yyyy-MM-dd').format(birth), "gender":(isSelected[1]==true?'F':'M'),"ip":null});
    if(response['result'] == 'success'){
      Baby_relation r = Baby_relation(11, 0, 255, "", "", true);
      Baby b = Baby(nameController.text, birth, (isSelected[1]==true? 0 : 1), r);
      Get.offAll(() => BaseWidget(widget.userInfo, [b]));
    }
  }
}