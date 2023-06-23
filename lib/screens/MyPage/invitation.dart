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
      appBar: renderAppbar('main4_InviteBabysitter'.tr, true),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: (){
                if(widget.activebabies.isEmpty){
                  Get.snackbar('invitation_Err'.tr, 'invitation_ErrC'.tr, snackPosition: SnackPosition.TOP, duration: const Duration(seconds: 2));
                }else{
                  Get.to(() => InvitationNew(relation0Babies));
                }
              },
              child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(3),
                  padding: const EdgeInsets.fromLTRB(20,50,20,50),
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
                    children:  [
                      Text('invitation_invTitle'.tr, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                      const SizedBox(height: 5),
                      Text('invitation_invContent'.tr)
                    ],
                  )
              ),
            ),
            const SizedBox(height: 30),
            Text('invitation_notList'.tr, style: const TextStyle(fontSize: 20)),
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
      col = Color(0xffFF766A);
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
      padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(baby.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          OutlinedButton(
            style: ElevatedButton.styleFrom(
              side: const BorderSide(width: 1.0, color: Color(0xffFF766A)),
            ),
              onPressed: (){
                Get.dialog(
                  AlertDialog(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                    title: Text('invitation_accept'.tr, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                    content: Text('invitation_acceptC'.tr),
                    actions: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(50),
                              backgroundColor: const Color(0xffFF766A),
                              foregroundColor: Colors.white
                          ),
                          onPressed: () async{
                            // 1. 초대 수락하는 API 보내기
                            var result = await acceptInvitationService(baby.relationInfo.BabyId);
                            Navigator.pop(context);
                            Get.back();
                          },
                          child: Text('confirm'.tr, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15))
                      )
                    ],
                  ),
                );
              },
              child: Text('accept'.tr, style: const TextStyle(color : Color(0xffFF766A), fontWeight: FontWeight.bold))
          )
        ],
      ),
    );
  }
}