import 'package:bob/models/model.dart';
import 'package:flutter/material.dart';
import 'package:bob/widgets/appbar.dart';
import 'package:get/get.dart' as GET;
import 'package:bob/screens/MyPage/invitationNew.dart';

import '../../services/backend.dart';
class Invitation extends StatefulWidget{
  final List<Baby> activebabies;
  final List<Baby> disactivebabies;
  const Invitation(this.activebabies, this.disactivebabies, {super.key});
  @override
  State<Invitation> createState() => _Invitation();
}
class _Invitation extends State<Invitation> {
  //late List<Baby> notAllowedBabies;
  @override
  void initState() {
    /*notAllowedBabies = [];
    for(int i=0; i<widget.babies.length;i++){
      if(!widget.babies[i].relationInfo.active){
        notAllowedBabies.add(widget.babies[i]);
      }
    }*/
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: renderAppbar('양육자 / 베이비시터 초대', true),
      body: Container(
        margin: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: (){
                if(widget.activebabies.isEmpty){
                  GET.Get.snackbar('초대 불가', '아이를 먼저 등록해주세요', snackPosition: GET.SnackPosition.TOP, duration: const Duration(seconds: 2));
                  return;
                }
                GET.Get.to(()=>InvitationNew(widget.activebabies));
              },
              child: Container(
                  width: double.infinity,
                  height: 150,
                  margin: const EdgeInsets.all(3),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.grey)
                  ),
                  child : Column(
                    children: [
                      Image.asset('assets/images/baby.png',scale: 10),
                      const Padding(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child : Text('초대 하기', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                      ),
                      const Text('공유 코드를 발급해주세요')
                    ],
                  )
              ),
            ),
            const SizedBox(height: 20),
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
    return Card(
        elevation: 2,
        shadowColor: Colors.grey[50],
      child: Container(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(baby.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            IconButton(onPressed: (){
              showDialog(
                  context: context,
                  builder: (BuildContext context){
                    return AlertDialog(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                      title: Text('초대 수락', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                      content: Text('초대를 수락하시겠습니까?'),
                      actions: [
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(50),
                              backgroundColor: const Color(0xfffa625f),
                              foregroundColor: Colors.white
                            ),
                            onPressed: () async{
                              // 1. 초대 수락하는 API 보내기
                              var i = await acceptInvitationService(baby.relationInfo.BabyId);
                              print(i);
                              Navigator.pop(context);
                              // 2. 돌아가면 babyList 다시 로딩하기
                              GET.Get.back();
                            },
                            child: const Text('확인')
                        )
                      ],
                    );
                  }
              );
            }, icon: Icon(Icons.check_circle_outline, color: Colors.green, size: 30))
          ],
        ),
      )
    );
  }
}