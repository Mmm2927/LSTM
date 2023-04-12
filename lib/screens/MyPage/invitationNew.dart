import 'package:flutter/material.dart';
import 'package:get/get.dart' as GET;
import 'package:bob/widgets/appbar.dart';
import 'package:bob/widgets/form.dart';
import 'package:bob/models/model.dart';
import 'package:time_range_picker/time_range_picker.dart';

class InvitationNew extends StatefulWidget{
  final List<Baby> babies;
  const InvitationNew(this.babies, {super.key});
  @override
  State<InvitationNew> createState() => _InvitationNew();
}
class _InvitationNew extends State<InvitationNew> {
  final List<String> week = ['월', '화', '수', '목', '금', '토', '일'];
  // 선택 창
  bool _getAdditionalInfo = false;
  List<String> selectedWeek = [];   // 요일 택
  late String startTime;
  late String endTime;
  int _valueGender = 0;
  late TextEditingController idController;
  @override
  void initState() {
    idController = TextEditingController();
    startTime = "00:00";
    endTime = "23:59";
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: renderAppbar('초대', true),
      body: Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('초대할 ID'),
            Padding(
              padding : EdgeInsets.fromLTRB(0, 10, 0, 30),
              child: TextFormField(
              keyboardType: TextInputType.emailAddress,
              controller: idController,
              decoration: formDecoration('아이디를 입력해주세요'),
                onChanged: (val){
                  setState(() {});
                },
              ),
            ),
            const Text('아기 선택'),
            Padding(
              padding : EdgeInsets.fromLTRB(0, 10, 0, 30),
              child: Text('아기 선택'),

            ),
            const Text('관계'),
            Padding(
              padding : EdgeInsets.fromLTRB(0, 10, 0, 20),
              child: Wrap(
                  spacing: 10.0,
                  children: List<Widget>.generate(
                      3, (int index){
                    List<String> gender = ['부모', '가족','베이비시터'];
                    return ChoiceChip(
                        elevation: 6.0,
                        padding: const EdgeInsets.all(10),
                        selectedColor: const Color(0xffff846d),
                        label: Text(gender[index]),
                        selected: _valueGender == index,
                        onSelected: (bool selected){
                          setState((){
                            _valueGender = (selected ? index : null)!;
                            if(index!=0){
                              _getAdditionalInfo = true;
                            }else{
                              _getAdditionalInfo = false;
                            }
                          });
                        }
                    );
                  }).toList()
              ),
            ),
            Offstage(
              offstage: !_getAdditionalInfo,
              child : Card(
                elevation: 2,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('접근 요일 선택', style: TextStyle()),
                      Wrap(
                        spacing: 2.0,
                        children: week.map((String name){
                          return FilterChip(
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                              selectedColor: const Color(0xffffc8c7),
                              label: Text(name),
                              selected: selectedWeek.contains(name),
                              onSelected: (bool value){
                                setState(() {
                                  if(value){
                                    if(!selectedWeek.contains(name))
                                      selectedWeek.add(name);
                                  }else{
                                    selectedWeek.removeWhere((String n){
                                      return n == name;
                                    });
                                  }
                                });
                              }
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 15),
                      const Text('접근 시간 설정', style: TextStyle()),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${startTime} ~ ${endTime}', style: TextStyle(fontSize: 28, fontWeight : FontWeight.bold, color : Color(0xfff1421f))),
                          OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xffff846d),
                              ),
                              onPressed: () async{
                                TimeRange result = await showTimeRangePicker(context: context);
                                setState(() {
                                  startTime = "${result.startTime.hour}:${result.startTime.minute}";
                                  endTime = "${result.endTime.hour}:${result.endTime.minute}";
                                });
                              },
                              child: Text('시간 선택')
                          )
                        ],
                      )
                    ],
                  ),
                )
              )
            ),
            SizedBox(height: 10),
            OutlinedButton(
                style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
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
                onPressed: (){},
                child: Text('등록'))
          ],
        ),
      )
    );
  }

}