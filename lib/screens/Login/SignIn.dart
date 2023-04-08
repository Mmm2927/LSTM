import 'package:flutter/material.dart';
import 'package:bob/widgets/appbar.dart';
import 'package:dio/dio.dart';
import 'package:bob/models/model.dart';
import 'package:flutter/cupertino.dart';
import 'package:bob/screens/Login/initPage.dart';
import 'package:bob/services/backend.dart';
import 'package:bob/models/validate.dart';
import 'package:bob/widgets/form.dart';
import 'package:get/get.dart' as GET;

class SignIn extends StatefulWidget{
  const SignIn({super.key});
  @override
  State<SignIn> createState()=> _SignUp();
}

class _SignUp extends State<SignIn>{
  final formKey = GlobalKey<FormState>();
  late String email = "";
  late String pass = "";
  late String name = "";
  late String phone = "";
  late bool _isDuplicateCheck = false;    // fa
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: renderAppbar('회원 가입', true),
        body : SingleChildScrollView(
          child: Form(
            key : formKey,
            child: Container(
              margin: const EdgeInsets.all(20),
              child : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  drawTitle('아이디', 0),
                  Row(
                    children: [
                      Expanded(
                        flex: 7,
                        child:
                          renderForm(
                            TextInputType.emailAddress, false, '이메일 입력', (val){  return validateEmail2String(email);}, (val){  setState(() {email = val!;});}
                          ),

                      ),
                      const SizedBox(width: 10),
                      Expanded(
                          flex: 3,
                          child: TextButton(onPressed: ()=> duplicateCheck(),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.deepOrange,
                                backgroundColor: Colors.white,
                                padding: const EdgeInsets.all(15),
                                side: const BorderSide(width: 1, color: Colors.deepOrange)
                              ),
                              child: const Text('중복 검사'))
                      )
                    ],
                  ),
                  drawTitle('비밀번호', 40),
                  renderForm(
                      TextInputType.text, true, '비밀번호', (val){  return validatePassword2String(pass);}, (val){  setState(() {pass = val!;});}
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    autovalidateMode : AutovalidateMode.always,
                    obscureText: true,
                    decoration: formDecoration('비밀번호 확인'),
                    validator: (val){
                      if(pass != val){
                        return '비밀번호와 일치하지 않습니다';
                      }
                      return null;
                    },
                    onSaved: (val){
                      setState(() {});
                    },
                  ),
                  drawTitle('닉네임', 40),
                  renderForm(
                      TextInputType.text, false, '닉네임', (val){  return validateName2String(name);}, (val){  setState(() {name = val!;});}
                  ),
                  drawTitle('휴대폰 번호', 20),
                  renderForm(
                    TextInputType.phone, false, '핸드폰 번호를 입력해주세요(- 없이)', (val){  return validatePhone2String(phone);}, (val){  setState(() {phone = val!;});}
                  ),
                  const SizedBox(height: 50),
                  ElevatedButton(
                      onPressed: () => _register(),
                      style:ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          minimumSize: const Size.fromHeight(55),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0))
                      ),
                      child: const Text('회원가입')
                  )
                ],
              ),
            )
          )
        )
    );
  }

  renderForm(keyType, ob, hint, validator, onSaved){
    return TextFormField(
      obscureText: ob,
      keyboardType: keyType,
      decoration: formDecoration(hint),
      validator : validator,
      onChanged: onSaved,
      onSaved : onSaved
    );
  }
  // 회원 가입
  void _register() async{
    if((formKey.currentState?.validate())! && _isDuplicateCheck){
      Response response = await registerService(email, pass, name, phone);
      if(response.statusCode == 201){
        GET.Get.snackbar('회원가입 성공', '회원가입에 성공하였습니다. 횐영합니다 \u{1F606}', snackPosition: GET.SnackPosition.TOP, duration: const Duration(seconds: 2));
        GET.Get.to(() => const LoginInit());
      }
      else{
        GET.Get.snackbar('회원가입 실패', '회원가입에 실패하였습니다. 다시 시도해주세요 \u{1F613}', snackPosition: GET.SnackPosition.TOP, duration: const Duration(seconds: 2));
      }
    }
  }
  // 중복 검사
  void duplicateCheck() async{
    // 1. validation
    if(!validateEmail(email)){
      GET.Get.snackbar('', '아이디 형식을 지켜주세요', snackPosition: GET.SnackPosition.TOP, duration: const Duration(seconds: 2));
      return;
    }
    // 2. check
    String responseData = await emailOverlapService(email);
    if(responseData == "True"){
      _isDuplicateCheck = true;
      GET.Get.snackbar('중복 검사', '사용 가능한 아이디 입니다.', snackPosition: GET.SnackPosition.TOP, duration: const Duration(seconds: 2));
    }else{
      GET.Get.snackbar('중복 검사', '중복된 아이디 입니다.', snackPosition: GET.SnackPosition.TOP, duration: const Duration(seconds: 2));
    }
  }
}
Column drawTitle(String title, double hSize){
  return Column(
    children: [
      SizedBox(height: hSize),
      Text(title),
      const SizedBox(height: 10),
    ],
  );
}