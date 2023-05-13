import 'package:bob/models/model.dart';
import 'package:flutter/material.dart';
import 'package:bob/widgets/appbar.dart';
import 'package:get/get.dart';
import 'package:bob/screens/MyPage/invitationNew.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../services/backend.dart';
class Invitation extends StatefulWidget{
  final List<Baby> activebabies;
  final List<Baby> disactivebabies;
  const Invitation(this.activebabies, this.disactivebabies, {super.key});
  @override
  State<Invitation> createState() => _Invitation();
}
class _Invitation extends State<Invitation> {
  late List<Baby> relation0Babies;
  @override
  void initState() {
    relation0Babies = [];
    for(int i=0; i<widget.activebabies.length; i++){
      if(widget.activebabies[i].relationInfo.relation==0) {
        relation0Babies.add(widget.activebabies[i]);
      }
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: renderAppbar('양육자 / 베이비시터 초대', true),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: (){
                if(widget.activebabies.isEmpty){
                  Get.snackbar('초대 불가', '아이를 먼저 등록해주세요', snackPosition: SnackPosition.TOP, duration: const Duration(seconds: 2));
                }else{
                  Get.to(() => InvitationNew(relation0Babies));
                }
              },
              child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(3),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 5,
                      )
                    ],
                    color: Colors.white,
                  ),
                  child : Column(
                    children: const [
                      Text('초대 하기', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                      Text('공유 코드를 발급해주세요')
                    ],
                  )
              ),
            ),
            const SizedBox(height: 30),
            const Text('미수락 초대들', style: TextStyle(fontSize: 20)),
            const Divider(thickness: 1, color: Colors.grey),
            Expanded(
                child: ListView.builder(
                  scrollDirection : Axis.vertical,
                  itemCount: widget.disactivebabies.length,
                  itemBuilder: (BuildContext context, int index){
                    return drawBaby(widget.disactivebabies[index]);
                  },
                )
            )
          ],
        )
      )
    );
  }
  Widget drawBaby(Baby baby){
    Color col;
    if(baby.relationInfo.relation == 0){
      col = Colors.pinkAccent;
    }
    else if(baby.relationInfo.relation == 1){
      col = Colors.blueAccent;
    }
    else{
      col = Colors.grey;
    }
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          left: BorderSide(
              color: col,
              width: 3.0
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 1,
          )
        ],
      ),
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(baby.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          OutlinedButton(
            style: ElevatedButton.styleFrom(
              side: const BorderSide(width: 1.0, color: Color(0xfffa625f)),
            ),
              onPressed: (){
                Get.dialog(
                  AlertDialog(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                    title: const Text('초대 수락', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                    content: const Text('초대를 수락하시겠습니까?'),
                    actions: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(50),
                              backgroundColor: const Color(0xfffa625f),
                              foregroundColor: Colors.white
                          ),
                          onPressed: () async{
                            // 1. 초대 수락하는 API 보내기
                            var result = await acceptInvitationService(baby.relationInfo.BabyId);
                            Navigator.pop(context);
                            // 2. 돌아가면 babyList 다시 로딩하기
                            Get.back();
                          },
                          child: const Text('확인', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15))
                      )
                    ],
                  ),
                );
              },
              child: const Text('수락', style: TextStyle(color : Color(0xfffa625f), fontWeight: FontWeight.bold))
          )
        ],
      ),
    );
  }
}