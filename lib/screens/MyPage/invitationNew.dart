import 'package:flutter/material.dart';
import 'package:get/get.dart' as GET;
import 'package:bob/widgets/appbar.dart';
import 'package:bob/widgets/form.dart';
import 'package:bob/models/model.dart';
import 'package:time_range_picker/time_range_picker.dart';
import 'package:bob/models/validate.dart';
import 'package:bob/services/backend.dart';

class InvitationNew extends StatefulWidget{
  final List<Baby> babies;
  const InvitationNew(this.babies, {super.key});
  @override
  State<InvitationNew> createState() => _InvitationNew();
}
class _InvitationNew extends State<InvitationNew> {
  late String selectedBaby;
  String targetID = '';
  final List<String> week = ['월', '화', '수', '목', '금', '토', '일'];
  // 선택 창
  bool _getAdditionalInfo = false;
  List<String> selectedWeek = ['0','0','0','0','0','0','0'];   // 요일 택
  late String startTime;
  late String endTime;
  int selectedRelation = 0;
  late TextEditingController idController;

  @override
  void initState() {
    selectedBaby = "0";
    idController = TextEditingController();
    startTime = "00:00";
    endTime = "23:59";
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: renderAppbar('초대', true),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('초대할 ID'),
              Padding(
                  padding : const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Row(
                    children: [
                      Expanded(
                          flex: 7,
                          child: TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            controller: idController,
                            decoration: formDecoration('아이디를 입력해주세요'),
                            onChanged: (val){
                              setState(() {});
                            },
                          )
                      ),
                      Expanded(
                          flex: 1,
                          child: IconButton(
                            icon: Icon(Icons.search),
                            onPressed: ()=>duplicateCheck(),
                          )
                      )
                    ],
                  )
              ),
              Visibility(
                visible: targetID.isNotEmpty,
                child: Text(targetID, style: const TextStyle(color: Colors.green)),
              ),
              const Padding(
                padding : EdgeInsets.fromLTRB(0, 30, 0, 10),
                child: Text('아기 선택'),
              ),
              SizedBox(
                width: double.infinity,
                child: DropdownButton(
                  value: selectedBaby,
                  items: dropdownItems,
                  onChanged: (String? value) {
                    setState(() {
                      selectedBaby = value!;
                    });
                  },
                ),
              ),
              const SizedBox(height: 30),
              const Text('관계'),
              Padding(
                padding : const EdgeInsets.fromLTRB(0, 10, 0, 20),
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
                          selected: selectedRelation == index,
                          onSelected: (bool selected){
                            setState((){
                              selectedRelation = (selected ? index : null)!;
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
                              children: getWeek()
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
              const SizedBox(height: 10),
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
                  onPressed: ()=> invitation(),
                  child: Text('등록'))
            ],
          ),
        )
      )
    );
  }
  void invitation() async{
    String targetemail = idController.text.trim();
    if(!validateEmail(targetemail)){
      GET.Get.snackbar('', '아이디 형식을 지켜주세요', snackPosition: GET.SnackPosition.TOP, duration: const Duration(seconds: 2));
      return;
    }
    if(selectedBaby.isEmpty)
      return;
    Baby invitBaby = widget.babies[int.parse(selectedBaby)];
    Baby_relation relation;
    if(selectedRelation==0){  // -> 부모
      relation = Baby_relation(invitBaby.relationInfo.BabyId, 0, 127, "00:00", "23:59", false);
    }else{    // 가족 or 베이비시터
      relation = Baby_relation(invitBaby.relationInfo.BabyId, selectedRelation, int.parse(selectedWeek.join(), radix: 2), startTime, endTime, false);
    }
    var tmp = relation.toJson();
    tmp['email'] = targetemail;
    var i = await invitationService(tmp);
    print(i);
    GET.Get.back();    // 2. 돌아가기
  }
  void duplicateCheck() async{
    String email = idController.text.trim();
    // 1. validation
    if(!validateEmail(email)){
      GET.Get.snackbar('', '아이디 형식을 지켜주세요', snackPosition: GET.SnackPosition.TOP, duration: const Duration(seconds: 2));
      return;
    }
    // 2. check
    String responseData = await emailOverlapService(email);
    if(responseData == "True"){
      GET.Get.snackbar('경고', '존재하지 않는 아이디입니다', snackPosition: GET.SnackPosition.TOP, duration: const Duration(seconds: 2));
    }else{
      setState(() {
        targetID = email;
      });
      GET.Get.snackbar('검색 완료', '아이디를 찾았습니다', snackPosition: GET.SnackPosition.TOP, duration: const Duration(seconds: 2));
    }
  }
  List<DropdownMenuItem<String>> get dropdownItems{
    List<DropdownMenuItem<String>> menuItems = [];
    for(int i=0; i<widget.babies.length; i++){
      menuItems.add(DropdownMenuItem(child: Text(widget.babies[i].name), value: i.toString()));
    }
    return menuItems;
  }
  getWeek(){
    List<FilterChip> wget = [];
    for(int i=0; i<7; i++){
      wget.add(FilterChip(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          selectedColor: const Color(0xffffc8c7),
          label: Text(week[i]),
          selected: selectedWeek[i]=="1",
          onSelected: (bool notSelected){
            setState(() {
              if(notSelected){
                if(selectedWeek[i]!=1){
                  selectedWeek[i] = "1";
                }
              }
              else{
                selectedWeek[i] = "0";
              }
            });
          }
      ));
    }
    return wget.toList();
  }
}