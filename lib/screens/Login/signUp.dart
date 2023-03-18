import 'package:flutter/material.dart';
import 'package:bob/screens/Login/find_id.dart';
import 'package:bob/screens/Login/find_password.dart';
import 'package:bob/widgets/appbar.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:bob/models/model.dart';
import 'package:bob/screens/BaseWidget.dart';

class SignUp extends StatefulWidget{
  @override
  _SignUp createState() => _SignUp();
}
class _SignUp extends State<SignUp>{
  static final storage = FlutterSecureStorage(); // 토큰 값과 로그인 유지 정보를 저장, SecureStorage 사용
  // 폼에 부여할 수 있는 유니크한 글로벌 키를 생성한다.
  final _formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  final dio = Dio();    // 서버와 통신을 하기 위해 필요한 패키지
  var o;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: renderAppbar('이메일 로그인'),
      body: Container(
        margin: EdgeInsets.all(25),
        child:
          Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children:[
                    const SizedBox(height: 5),
                    renderTextFormField(
                      label: '이메일',
                      onSaved : (val){
                        setState(() {
                          this.email = val;
                        });
                      },
                        validator:(val){
                          if(val.length < 1) {
                            return '이메일은 필수사항입니다.';
                          }
                          if(!RegExp(
                              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                              .hasMatch(val.trim())){
                            return '잘못된 이메일 형식입니다.';
                          }
                          return null;},
                        isObscureText:false
                    ),
                    const SizedBox(height: 10),
                    renderTextFormField(
                        label: '비밀번호',
                        onSaved : (val){
                          setState(() {
                            this.password = val;
                          });
                        },
                        validator:(val){
                          if(val.length < 1) {
                            return '패스워드는 필수사항입니다.';
                          }
                          return null;
                          },
                        isObscureText:true
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.grey[300],
                          elevation: 0,
                          minimumSize: const Size.fromHeight(50)
                        ),
                        child: const Text('로그인'),
                        onPressed: () async{
                          o = Navigator.of(context);
                          if(_formKey.currentState!.validate()) {  // validation 통과
                            _formKey.currentState!.save(); // validation 성공 시 폼 저장
                            Response response = await dio.post('http://20.249.219.241:8000/api/user/login/', data: {'email' : this.email, 'password': this.password});
                            if(response.statusCode == 200){
                              _showDialog('환영합니다');
                              String token = response.data['access_token']; // response의 token키에 담긴 값을 token 변수에 담아서
                              Map<dynamic, dynamic> payload = Jwt.parseJwt(token);
                              int loginID = payload['user_id'];
                              var val = jsonEncode(Login(token,loginID));
                              await storage.write(key: 'login', value: val);
                              if (!mounted) return;
                              //await time();
                              o.push(
                                MaterialPageRoute(builder: (context) => BaseWidget()),);
                            }
                            else{
                              _showDialog('등록된 사용자가 아닙니다.');
                            }
                          }
                        },
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(onPressed: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => FindId()),
                          );
                        }, child: const Text('아이디 찾기',style: TextStyle(color: Colors.black))),
                        Container(
                          width: 10,
                          height: 15,
                          color: Colors.black,
                        ),
                        //VerticalDivider(thickness: 1, color: Colors.grey),
                        TextButton(onPressed: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => FindId()),
                          );
                        }, child: const Text('비밀번호 찾기',style: TextStyle(color: Colors.black))),
                      ],
                    )
                  ]
                ),
              )
          )

      )
    );
  }
  void _showDialog(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  renderTextFormField({
    required String label,
    required FormFieldSetter onSaved,
    required FormFieldValidator validator,
    required bool isObscureText,
    })
  {
    assert(onSaved != null);
    assert(validator != null);
    return Column(
      children: [
        TextFormField(
          obscureText: isObscureText,
          decoration: InputDecoration(labelText: label),
          onSaved: onSaved,
          validator: validator,
        ),
        Container(height: 16.0),
      ],
    );
  }
}

