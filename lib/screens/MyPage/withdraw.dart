import 'package:flutter/material.dart';
import 'package:bob/widgets/appbar.dart';
import 'package:bob/screens/Login/initPage.dart';
import 'package:bob/services/backend.dart';
import 'package:bob/services/storage.dart';
import 'package:get/get.dart';
import 'package:get/get.dart' hide Trans;

class WithdrawService extends StatefulWidget{
  const WithdrawService({super.key});
  @override
  State<WithdrawService> createState() => _WithdrawService();
}
class _WithdrawService extends State<WithdrawService> {
  bool _isCheked = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: renderAppbar('main4_withdrawal'.tr, true),
      body: Container(
        margin: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
              child: Text('withdraw_title'.tr,style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 24)),
            ),
            Text('withdraw_content'.tr, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 15),
            Row(
              children: [
                Checkbox(value: _isCheked, onChanged: (val){
                  setState(() {
                    _isCheked = val!;
                  });
                }),
                Text('withdraw_checkPhrase'.tr, style: const TextStyle(fontSize: 18)),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(15),
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.grey[300],
                    elevation: 0
                  ),
                  onPressed: ()=> _showDlg(),
                  child: Text('withdraw_btn'.tr, style: const TextStyle(fontSize: 20))
              )
            )
          ],
        )
      )
    );
  }
  serviceWithdraw() async{
    // 1. 삭제 - dio 사용
    if(await deleteUserService() == 204){
      await storage.delete(key: 'login');    // 2. 로컬 DB & secureStorage 삭제
      Get.offAll(const LoginInit());            // 2. initPage로 이동
    }
  }
  void _showDlg(){
    if(!_isCheked){
      return;
    }
    Get.defaultDialog(
      contentPadding: const EdgeInsets.only(left: 25, right: 25, bottom: 20),
      titlePadding:  const EdgeInsets.all(20),
      confirm: TextButton(onPressed: ()=> serviceWithdraw(),
          child: Text('withdraw_btn'.tr, style: const TextStyle(fontSize: 14, color: Colors.black))
      ),
      cancel: TextButton(onPressed: ()=> Get.back(),
          child: Text('cancle'.tr, style: const TextStyle(fontSize: 14, color: Colors.black))
      ),
      title: 'main4_withdrawal'.tr,
      titleStyle: TextStyle(fontWeight: FontWeight.bold),
      content: Text('withdraw_finalchekContent'.tr),
    );
  }
}