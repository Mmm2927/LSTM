import 'package:flutter/material.dart';
import 'package:bob/screens/MyPage/modifyBabyDetail.dart';
import 'package:bob/services/backend.dart';
import '../../models/model.dart';
import '../../widgets/pharse.dart';
import 'package:get/get.dart';
import 'package:easy_localization/easy_localization.dart' hide StringTranslateExtension;

class ModifyBabyWidget extends StatefulWidget{
  final List<Baby> babies;
  const ModifyBabyWidget(this.babies, {Key?key}):super(key:key);
  @override
  State<ModifyBabyWidget> createState() => _ModifyBabyWidget();
}
class _ModifyBabyWidget extends State<ModifyBabyWidget> with TickerProviderStateMixin{
  late List<Baby> allowedBabies;
  @override
  void initState() {
    super.initState();
    allowedBabies = [];
    for(int i=0; i<widget.babies.length; i++){
      Baby tmp = widget.babies[i];
      if(tmp.relationInfo.relation == 0){
        allowedBabies.add(tmp);  // 자기 자식으로 등록된 아기만 수정가능
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
        child: Column(
          children: [
            getErrorPharse('modi_BabyErr'.tr),
            const SizedBox(height: 15),
            Expanded(
              child: ListView.builder(
                itemCount: allowedBabies.length,
                  itemBuilder: (BuildContext ctx, int idx) {
                    return drawBaby(allowedBabies[idx], context);
                  }
              )
            )
          ],
        )
      )
    );
  }
  drawBaby(Baby baby, BuildContext rootContext){
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.fromLTRB(30, 10, 10, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(
          left: BorderSide(
              color: Color(0xfffa625f),
              width: 3.0
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(baby.name, style: const TextStyle(fontSize: 22)),
              const SizedBox(width: 5),
              Text(baby.relationInfo==0?'genderF'.tr:'genderM'.tr),
            ],
          ),
          const SizedBox(height: 2),
          Text('${'birth'.tr} : ${DateFormat('yyyy-MM-dd').format(baby.birth)}'),
          const SizedBox(height: 5),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                    onPressed: (){
                      Get.to(() => ModifyBabyDetail(baby));
                    },
                    child: Text('modify'.tr, style: const TextStyle(color: Color(0xfffa625f)))),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: OutlinedButton(
                    onPressed: () => delete(baby.relationInfo.BabyId),
                    child: Text('delete'.tr,style: const TextStyle(color: Colors.black))
                )
              ),
            ],
          )
        ],
      ),
    );
  }
  delete(int targetBabyID){
    Get.dialog(
     AlertDialog(
        title: const Text('warning', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('한 번 삭제한 내용은 복구가 불가능합니다.\n 정말로 삭제하시겠습니까?'),
        actions: [
          TextButton(onPressed: () => serviceDeleteBaby(targetBabyID),
              child: const Text('삭제', style: TextStyle(fontSize: 18, color:Colors.black))
          ),
          TextButton(
              onPressed: (){
                Get.back();
              },
              child: const Text('취소', style: TextStyle(fontSize: 18, color:Colors.black))
          )
        ],
      ),
      barrierDismissible: false
    );
  }

  serviceDeleteBaby(int targetId) async{
    if(await deleteBabyService(targetId) == 200){
      Get.back();
      Get.back(); // 2. BasePage 이동
    }
    else{
      Get.snackbar('삭제 실패', '', snackPosition: SnackPosition.TOP, duration: const Duration(seconds: 2));
    }
  }
}