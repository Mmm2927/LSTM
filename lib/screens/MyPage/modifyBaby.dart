import 'package:bob/models/model.dart';
import 'package:flutter/material.dart';
import 'package:bob/widgets/form.dart';
import 'package:bob/widgets/appbar.dart';
import 'package:flutter/cupertino.dart';

class ModifyBaby extends StatefulWidget{
  final Baby baby;
  const ModifyBaby(this.baby, {super.key});
  @override
  State<ModifyBaby> createState() => _ModifyBaby();
}
class _ModifyBaby extends State<ModifyBaby> {
  late int _valueGender;
  late DateTime date;
  @override
  void initState() {
    super.initState();
    _valueGender = widget.baby.gender;
    date = widget.baby.birth;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: renderAppbar('아기 정보 수정'),
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
                  onPressed: () async => await _ModifyBabyinfo(),
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
  _ModifyBabyinfo() async{
    
  }
}