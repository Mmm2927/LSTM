import 'package:bob/models/model.dart';
import 'package:flutter/material.dart';
import 'package:bob/widgets/form.dart';
import 'package:bob/widgets/appbar.dart';
import 'package:flutter/cupertino.dart';

class ModifyBabyDetail extends StatefulWidget{
  final Baby baby;
  const ModifyBabyDetail(this.baby, {super.key});
  @override
  State<ModifyBabyDetail> createState() => _ModifyBabyDetail();
}
class _ModifyBabyDetail extends State<ModifyBabyDetail> {
  late int _valueGender;
  late DateTime birth;
  @override
  void initState() {
    super.initState();
    _valueGender = widget.baby.gender;
    birth = widget.baby.birth;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: renderAppbar('아기 정보 수정', true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
          child:Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              drawTitle('아기 이름', 0),
              TextFormField(
                decoration: formDecoration(widget.baby.name),
                enabled: false,
              ),
              drawTitle('생일', 40),
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
              drawTitle('성별', 40),
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
              const SizedBox(height: 100),
              ElevatedButton(
                  onPressed: (){
                    print(_valueGender);
                  },
                  style:ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(55),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0))
                  ),
                  child: const Text('수정 완료')
              )
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
  _ModifyBabyinfo(){
    print(';;ddd');
    // validate
    //print(_valueGender);
    //print(birth);
  }
}