import 'package:flutter/material.dart';
import 'package:bob/widgets/appbar.dart';
import 'package:dio/dio.dart';
import 'package:bob/models/model.dart';
import 'package:flutter/cupertino.dart';
import 'package:bob/screens/Login/initPage.dart';
import 'package:logger/logger.dart';
import 'package:bob/httpservices/backend.dart';
class SignIn extends StatefulWidget{
  @override
  _SignUp createState()=> _SignUp();
}

class _SignUp extends State<SignIn>{
  //final dio = Dio();    // 서버와 통신을 하기 위해 필요한 패키지
  late TextEditingController idContoller;
  late TextEditingController passContoller;
  late TextEditingController pass2Contoller;
  late TextEditingController nameContoller;
  late TextEditingController phoneContoller;
  late User userinfo;
  late bool _isDuplicateCheck = false;    // fa
  var logger = Logger();
  @override
  void initState() {
    super.initState();
    idContoller = TextEditingController();
    passContoller = TextEditingController();
    pass2Contoller = TextEditingController();
    nameContoller = TextEditingController();
    phoneContoller = TextEditingController();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: renderAppbar('회원 가입'),
        body : SingleChildScrollView(
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
                              TextFormField(
                                controller: idContoller,
                                onChanged: (val){ setState(() {});},
                                decoration: formDecoration('이메일 입력')
                              )
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                            flex: 3,
                            child: TextButton(onPressed: ()=> duplicateCheck(), style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.deepOrange,
                                backgroundColor: Colors.white,
                                padding: const EdgeInsets.all(15),
                                side: const BorderSide(width: 1, color: Colors.deepOrange)),
                                child: const Text('중복 검사')))
                      ],
                    ),
                    drawTitle('비밀번호', 40),
                    TextFormField(
                      controller: passContoller,
                      obscureText: true,
                      decoration: formDecoration('비밀번호 확인'),
                      onChanged: (val){setState(() {
                      });},
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: pass2Contoller,
                      obscureText: true,
                      decoration: formDecoration('비밀번호 확인'),
                    ),
                    drawTitle('닉네임', 40),
                    TextFormField(
                      controller: nameContoller,
                      keyboardType: TextInputType.text,
                      decoration: formDecoration('닉네임'),
                    ),
                    drawTitle('휴대폰 번호', 20),
                    TextFormField(
                      controller: phoneContoller,
                      keyboardType: TextInputType.phone,
                      decoration: formDecoration('핸드폰 번호를 입력해주세요(- 없이)'),
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
    );
  }

  validation(){
    String _id = idContoller.text.trim();
    var emailFormat = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    if(_id.isEmpty || !RegExp(emailFormat).hasMatch(_id)){
      showDlg('이메일 형식을 맞춰주세요', context);
      idContoller.clear();
      return false;
    }
    if(!_isDuplicateCheck){
      showDlg('이메일 중복 체크하세요', context);
      return false;
    }

    String _pass = passContoller.text.trim();
    if(_pass.isEmpty || _pass.length<8){
      showDlg('비밀번호 형식을 맞춰주세요(8자 이상)', context);
      passContoller.clear();
      return false;
    }

    String _pass2 = pass2Contoller.text.trim();
    if(_pass2.isEmpty){
      showDlg('비밀번호 체크 형식을 맞춰주세요', context);
      pass2Contoller.clear();
      return false;
    }
    if(_pass2.compareTo(_pass) != 0){
      showDlg('비밀번호와 일치하지 않습니다.', context);
      pass2Contoller.clear();
      return false;
    }
    String _name = nameContoller.text.trim();
    if(_name.isEmpty || _name.length<3){
      nameContoller.clear();
      showDlg('닉네임 형식을 맞춰주세요(3자 이상)', context);
      return false;
    }
    String _phone = phoneContoller.text.trim();
    if(_phone.isEmpty || _name.length == 13){
      phoneContoller.clear();
      showDlg('핸드폰 형식을 맞춰주세요', context);
      return false;
    }
    userinfo = User(_id, _pass, _name, _phone);
    return true;
  }
  // 회원 가입
  void _register() async{
    if(validation()){
      Map<String, dynamic> data= userinfo.toJson();
      data['password2'] = userinfo.password1;
      Response response = await registerService(data);
      print(response.statusCode);
      if(response.statusCode == 201){
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
  // 중복 검사
  void duplicateCheck() async{
    // 1. validation
    String _id = idContoller.text.trim();
    String emailForm = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    if(_id.isEmpty || !RegExp(emailForm).hasMatch(_id)){
      showDlg('아이디 형식을 지켜주세요', context);
      return;
    }
    // 2. check
    Response response = await emailOverlapService({'email' : _id});
    if(response.statusCode == 200){
      if(response.data == "True"){
        _isDuplicateCheck = true;
        showDlg('중복되지 않은 아이디 입니다.', context);
        logger.i("중복 체크 O");
      }
      else{
        showDlg('아이디가 중복되었습니다. 다시 입력해주세요', context);
        idContoller.clear();
      }
    }
  }
}

void showDlg(String title, BuildContext context){
  ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text(title)));
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
