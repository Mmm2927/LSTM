import 'package:flutter/material.dart';
import 'package:bob/screens/Login/SignIn.dart';
import 'package:bob/screens/Login/signUp.dart';
import 'package:get/get.dart' as GET;

class LoginInit extends StatelessWidget{
  const LoginInit({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            margin: const EdgeInsets.fromLTRB(30, 30, 30, 150),
            child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Image.asset('assets/images/logo.png',scale: 12),
                      const SizedBox(height: 100),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                            minimumSize: const Size.fromHeight(50)
                        ),
                        child: const Text('이메일로 로그인',style: TextStyle(color: Color(0xfffa625f),fontWeight: FontWeight.bold)),
                        onPressed: (){
                          GET.Get.to(() => const SignUp());
                        },
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                              onPressed: (){
                                GET.Get.to(() => const SignIn());
                              },
                              child: const Text('회원가입',style: TextStyle(color: Colors.black))
                          ),
                          const VerticalDivider(thickness: 1, color: Colors.grey),
                          TextButton(onPressed: (){}, child: const Text('로그인 문의', style: TextStyle(color: Colors.black))),
                        ],
                      )
                    ]
                )
            )
        )
    );
  }
}