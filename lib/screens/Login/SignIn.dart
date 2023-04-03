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
  late TextEditingController idContoller;
  late TextEditingController passContoller;
  late TextEditingController pass2Contoller;
  late TextEditingController nameContoller;
  late TextEditingController phoneContoller;
  User userInfo = User("","","","");
  late bool _isDuplicateCheck = false;    // fa

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
        appBar: renderAppbar('회원가입'),
        body : SingleChildScrollView(
            child: Container(
                margin: const EdgeInsets.all(20),
                child : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    drawTitle('아이디'),
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
                    const SizedBox(height: 40),
                    drawTitle('비밀번호'),
                    TextFormField(
                      obscureText: true,
                      decoration: formDecoration('비밀번호 확인'),
                      onChanged: (val){setState(() {
                      });},
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      obscureText: true,
                      decoration: formDecoration('비밀번호 확인'),
                    ),
                    const SizedBox(height: 40),
                    drawTitle('닉네임'),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      decoration: formDecoration('닉네임'),
                    ),
                    const SizedBox(height: 20),
                    drawTitle('휴대폰 번호'),
                    TextFormField(
                      keyboardType: TextInputType.phone,
                      decoration: formDecoration('핸드폰 번호를 입력해주세요'),
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
    if(_pass.isEmpty || _pass.length<5){
      showDlg('비밀번호 형식을 맞춰주세요(5자 이상)', context);
      passContoller.clear();
      return false;
    }
    String _pass2 = pass2Contoller.text.trim();
    if(_pass2.isEmpty){
      showDlg('비밀번호 형식을 맞춰주세요', context);
      pass2Contoller.clear();
      return false;
    }
    if(_pass2.compareTo(_pass) == 0){
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
    return true;
  }
  // 회원 가입
  void _register() async{
    if(validation()){
      return;
    }

    /*
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
    }*/
  }
  // 중복검사
  void duplicateCheck() async{
    print('중복 체크 : ' + idContoller.text.trim());
    if(idContoller.text.isEmpty || !RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(idContoller.text.trim())){
      showDlg('아이디 형식을 지켜주세요', context);
      return;
    }
    Response response = await dio.post('http://20.249.219.241:8000/api/user/exist/', data:{'email' : 'hehe@naver.com'});
    print(response.statusCode);
    //Response response = await dio.post('http://20.249.219.241:8000/api/user/exist/', data:{'email' : idContoller.text.trim()});
    //print(response);
    /*
    if(response.statusCode == 200){
      _isDuplicate = false;
      showDlg('증복하지 않는 아이디입니다', context);
    }
    else{
      showDlg('아이디가 중복되었습니다. 다시 입력해주세요', context);
    }*/
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
