import 'package:flutter/material.dart';
import 'package:bob/widgets/appbar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:bob/screens/Login/initPage.dart';

class WithdrawService extends StatefulWidget{
  const WithdrawService({super.key});
  @override
  State<WithdrawService> createState() => _WithdrawService();
}
class _WithdrawService extends State<WithdrawService> {
  final dio = Dio();    // 서버와 통신을 하기 위해 필요한 패키지
  bool _isCheked = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: renderAppbar('서비스 탈퇴', true),
      body: Container(
        margin: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
              child: Text('회원탈퇴 안내',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 26)),
            ),
            const Text('지금까지 BoB 서비스를 이용해주셔서 감사합니다.\n회원을 탈퇴하면 BoB 서비스 내 나의 계정 정보 및 근무기록 내역이 삭제되고 복구 할 수 없습니다.',
                style: TextStyle(fontSize: 24)
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Checkbox(value: _isCheked, onChanged: (val){
                  setState(() {
                    _isCheked = val!;
                  });
                }),
                const Text('위 내용을 숙지하였으며, 동의합니다.', style: TextStyle(fontSize: 20)),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(15),
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.grey,
                  ),
                  onPressed: ()=>_showDlg(),
                  child: const Text('탈퇴하기', style: TextStyle(fontSize: 20))
              )
            )
          ],
        )
      )
    );
  }
  serviceWithdraw() async{
    //var resultCode = await deleteUser();
    // 1. 삭제 - dio 사용
    // 2. 로컬 DB & secureStorage 삭제
    // 2. initPage로 이동
    /*
    Navigator.pushReplacement(
        context,
        CupertinoPageRoute(builder: (context)=> LoginInit())
    );*/
  }
  void _showDlg(){
    if(!_isCheked){
      return;
    }
    showDialog(
        context: context,
        builder: (BuildContext context){
          return SizedBox(
            width: double.infinity,
            child: AlertDialog(
              title: const Text('회원 탈퇴'),
              content: const Text('탈퇴 시 본인 계정의 모든 기록이 삭제됩니다.\n 탈퇴하시겠습니까?'),
              actions: [
                TextButton(onPressed: ()=> serviceWithdraw(),
                    child: const Text('탈퇴하기', style: TextStyle(fontSize: 20))
                ),
                TextButton(onPressed: ()=> Navigator.of(context).pop(),
                    child: const Text('취소', style: TextStyle(fontSize: 20))
                )
              ],
            )
          );
        }
    );
  }
}