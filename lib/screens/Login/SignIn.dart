import 'package:flutter/material.dart';
import 'package:bob/widgets/appbar.dart';
import 'package:dio/dio.dart';
import 'package:bob/models/model.dart';
import 'package:flutter/cupertino.dart';
import 'package:bob/screens/Login/initPage.dart';

class SignIn extends StatefulWidget{
  @override
  _SignUp createState()=> _SignUp();
}

class _SignUp extends State<SignIn>{
  final dio = Dio();    // 서버와 통신을 하기 위해 필요한 패키지
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  User userInfo = User("","","","");
  late bool _isDuplicate = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: renderAppbar('회원가입'),
        body : SingleChildScrollView(
            child: Container(
                margin: const EdgeInsets.all(20),
                child : Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      drawTitle('아이디'),
                      Row(
                        children: [
                          Expanded(
                              flex: 7,
                              child: TextFormField(
                                  onSaved: (val){ setState(() {
                                    userInfo.email = val!;
                                  });},
                                  validator: (val){
                                    if(val.toString().isEmpty) {
                                      return '이메일은 필수사항입니다.';
                                    }
                                    if(!RegExp(
                                        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                                        .hasMatch(val.toString().trim())){
                                      return '잘못된 이메일 형식입니다.';
                                    }
                                    if(_isDuplicate){
                                      return "중복체크를 해주세요";
                                    }
                                  },
                                  decoration: formDecoration('이메일 입력')
                              )
                          ),
                          const Padding(
                            padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                          ),
                          Expanded(
                              flex: 3,
                              child: TextButton(onPressed: ()=> duplicateCheck, style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.deepOrange,
                                  backgroundColor: Colors.white,
                                  padding: const EdgeInsets.all(15),
                                  side: const BorderSide(width: 1, color: Colors.deepOrange)),
                                  child: const Text('중복 검사')))
                        ],
                      ),
                      const SizedBox(height: 40),
                      drawTitle('비밀번호'),
                      TextFormField(
                        obscureText: true,
                        decoration: formDecoration('비밀번호 확인'),
                        onSaved : (val){ setState(() { userInfo.password = val!;});},
                        validator:(val){
                          if(val!.isEmpty)  return "비밀번호를 입력해 주세요";
                          if(val!.length<8) return "비밀번호는 8자를 넘겨야 합니다";
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        obscureText: true,
                        decoration: formDecoration('비밀번호 확인'),
                        onSaved: (val){},
                        validator: (val){
                          if(val.toString().isNotEmpty && val !=  userInfo.password){
                            return '비밀번호와 맞지 않습니다';
                          }
                        },
                      ),
                      const SizedBox(height: 40),
                      drawTitle('닉네임'),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        decoration: formDecoration('닉네임'),
                        onSaved: (val){userInfo.nickname = val!;},
                        validator: (val){
                          if(userInfo.nickname.length<5){
                            return "닉네임은 5자를 넘겨야 합니다";
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                      drawTitle('휴대폰 번호'),
                      TextFormField(
                        keyboardType: TextInputType.phone,
                        decoration: formDecoration('핸드폰 번호를 입력해주세요'),
                        onSaved: (val){
                          userInfo.phone = val!;
                        },
                        validator: (val){
                          if(userInfo.phone.length!=13){
                            return "핸드폰 번호를 입력해주세요";
                          }
                        },
                      ),
                      const SizedBox(height: 50),
                      ElevatedButton(
                          onPressed: () => _register,
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
  // 회원 가입
  void _register() async{
    if(_formKey.currentState!.validate()){  // validation 통과
      _formKey.currentState!.save();        // validation 성공 시 폼 저장
      Response response = await dio.post('http://20.249.219.241:8000/api/user/registration/', data: userInfo.toJson());
      if(response.statusCode == 200){
        showDlg("회원가입에 성공하였습니다. 횐영합니다 \u{1F606}", context);
        Navigator.pushReplacement(
            context,
            CupertinoPageRoute(builder: (context)=> LoginInit())
        );
      }
      else{
        showDlg("회원가입에 실패하였습니다. 다시 시도해주세요 \u{1F613}", context);
      }
    }
  }
  // 중복검사
  void duplicateCheck() async{
    if(userInfo.email.isNotEmpty && !RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(userInfo.email.toString().trim())){
      showDlg('아이디 형식을 지켜주세요', context);
      return;
    }
    Response response = await dio.post('http://20.249.219.241:8000/api/user/duplicate_check/', data:{'email' : userInfo.email});
    if(response.statusCode == 200){
      _isDuplicate = false;
      showDlg('증복하지 않는 아이디입니다', context);
    }
    else{
      showDlg('아이디가 중복되었습니다. 다시 입력해주세요', context);
    }
  }
}
void showDlg(String title, BuildContext context){
  ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text(title)));
}
Column drawTitle(String title){
  return Column(
    children: [
      Text(title),
      const SizedBox(height: 10),
    ],
  );
}
InputDecoration formDecoration(String title){
  return InputDecoration(
      hintText: title,
      filled: true,
      fillColor: Colors.grey[200],
      enabled: true,
      enabledBorder: const UnderlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: Colors.grey)
      ),
      border: InputBorder.none
  );
}
