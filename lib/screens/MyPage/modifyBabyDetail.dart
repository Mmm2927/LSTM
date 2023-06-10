import 'package:bob/models/model.dart';
import 'package:flutter/material.dart';
import 'package:bob/widgets/form.dart';
import 'package:bob/widgets/appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../models/validate.dart';
import '../../services/backend.dart';

class ModifyBabyDetail extends StatefulWidget{
  final Baby baby;
  const ModifyBabyDetail(this.baby, {super.key});
  @override
  State<ModifyBabyDetail> createState() => _ModifyBabyDetail();
}
class _ModifyBabyDetail extends State<ModifyBabyDetail> {
  TextEditingController nameController = TextEditingController();
  late DateTime birth;
  List<bool> isSelected = [true, false];

  @override
  void initState() {
    super.initState();
    int tmpG = widget.baby.gender;
    birth = widget.baby.birth;
    nameController.text = widget.baby.name;
    isSelected = [tmpG == 0, tmpG == 1];
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: renderAppbar('main4_modifyBaby'.tr, true),
      body: Container(
        padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
        child: Column(
          children: [
            Expanded(
                child: SingleChildScrollView(
                    child:Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        drawTitle('babyName'.tr, 0),
                        TextFormField(
                          controller: nameController,
                          decoration: formDecoration('babyNameHint'.tr),
                        ),
                        drawTitle('birth'.tr, 40),
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
                        drawTitle('gender'.tr, 30),
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
                        const SizedBox(height: 100),

                      ],
                    )
                )
            ),
            ElevatedButton(
                onPressed: () async => await modifyBabyInfo(),
                style:ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(20),
                    foregroundColor: Colors.white,
                    backgroundColor: const Color(0xfffa625f),
                    minimumSize: const Size.fromHeight(55),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0))
                ),
                child: Text('login_modified'.tr)
            )
          ],
        ),
      )
    );
  }
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

  modifyBabyInfo() async{
    String bName = nameController.text;
    if(!validateName(bName)){
      return;
    }
    //print(widget.baby.relationInfo.BabyId);
    //print(bName);
    //print(isSelected[1]==true?'F':'M');
    if(await editBabyService(widget.baby.relationInfo.BabyId, bName, (isSelected[1]==true?'F':'M')) == 200){
      Get.back();
      Get.back(); // 2. BasePage 이동
    }
    //var re = await editBabyService(widget.baby.relationInfo.BabyId, bName, gender);
    //Navigator.pop(context);

  }
}