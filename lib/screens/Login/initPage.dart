import 'package:flutter/material.dart';
import 'package:bob/screens/Login/SignIn.dart';
import 'package:bob/screens/Login/signUp.dart';
import 'package:get/get.dart' as GET;
import 'package:get/get.dart';

class LoginInit extends StatelessWidget {
  const LoginInit({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: InkWell(
          onTap: openBottomSheet,
          child: Container(
              child: Center(
                  child:
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 110),
                        Image.asset('assets/icon/bob.png', scale: 8),
                        const Text('Best of Baby', style: TextStyle(color: Colors.grey)),
                        const SizedBox(height: 100),
                        const Text('Press to login', style: TextStyle(color: Colors.grey, fontSize: 20))
                      ]
                  )
              )
          )
        )
    );
  }
  void openBottomSheet() {
    Get.bottomSheet(
      Container(
        height: 270,
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text('Welcome', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black)),
            const SizedBox(height: 10),
            const Text('종합 육아 서비스를 지원하는 BoB입니다.\n생활 기록, 성장 기록, 하루 일기 등의 다양한 기록과 아기의 수면 모니터링을 지원합니다.', style: TextStyle(fontSize: 15, color: Colors.black)),
            const SizedBox(height: 40),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: ElevatedButton(
                      style:ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          minimumSize: const Size.fromHeight(55),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))
                      ),
                      onPressed: (){
                        GET.Get.to(() => const SignUp());
                      },
                      child: const Text('로그인')
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 1,
                  child: ElevatedButton(
                      style:ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          minimumSize: const Size.fromHeight(55),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))
                      ),
                      onPressed: (){
                        GET.Get.to(() => const SignIn());
                      }, child: const Text('회원가입')
                  ),
                )
              ],
            )
          ],
        ),
      ),
      backgroundColor: const Color(0xffFF6D60),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
