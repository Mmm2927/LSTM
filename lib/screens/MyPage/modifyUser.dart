import 'package:bob/models/model.dart';
import 'package:flutter/material.dart';
import 'package:bob/widgets/appbar.dart';
import 'package:bob/widgets/form.dart';
import 'package:bob/services/backend.dart';
import 'package:bob/services/storage.dart';
import 'package:bob/models/validate.dart';

class ModifyUser extends StatefulWidget{
  final User userinfo;
  const ModifyUser(this.userinfo, {super.key});

  @override
  State<ModifyUser> createState() => _ModifyUser();
}
class _ModifyUser extends State<ModifyUser> {
  late TextEditingController idContoller;
  late TextEditingController passContoller;
  late TextEditingController nameContoller;
  late TextEditingController phoneContoller;
  @override
  void initState() {
    super.initState();
    passContoller = TextEditingController(text: widget.userinfo.password1);
    nameContoller = TextEditingController(text: widget.userinfo.name);
    phoneContoller = TextEditingController(text: widget.userinfo.phone);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: renderAppbar('회원 정보 수정', true),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child:
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                drawTitle('아이디', 0),
                TextFormField(
                  decoration: formDecoration(widget.userinfo.email),
                  enabled: false,
                ),
                drawTitle('비밀번호', 40),
                TextFormField(
                  controller: passContoller,
                  obscureText: true,
                  decoration: formDecoration('비밀번호 확인'),
                  onChanged: (val){setState(() {
                  });},
                ),
                drawTitle('닉네임', 40),
                TextFormField(
                  controller: nameContoller,
                  decoration: formDecoration('이름 확인'),
                  onChanged: (val){setState(() {
                  });},
                ),
                drawTitle('휴대폰 번호', 20),
                TextFormField(
                  controller: phoneContoller,
                  decoration: formDecoration('핸드폰 번호 확인'),
                  onChanged: (val){setState(() {
                  });},
                ),
                const SizedBox(height: 100),
                ElevatedButton(
                  onPressed: () async => await _ModifyUserinfo(),
                    style:ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(55),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0))
                    ),
                  child: const Text('수정 완료')
                )
              ],
            ),
          )
    );
  }
  bool validate(String pass, String name, String phone){
    if(!validatePassword(pass)){
      showDlg('비밀번호 형식을 맞춰주세요(8자 이상)');
      passContoller.clear();
      return false;
    }
    if(!validateName(name)){
      showDlg('이름 형식을 맞춰주세요(3자 이상)');
      nameContoller.clear();
      return false;
    }
    if(!validatePhone(phone)){
      showDlg('핸드폰 형식을 맞춰주세요(11자)');
      phoneContoller.clear();
      return false;
    }
    return true;
  }
  _ModifyUserinfo() async{
    // 1. validate
    String pass = passContoller.text.trim();
    String name = nameContoller.text.trim();
    String phone = phoneContoller.text.trim();
    if(!validate(pass, name, phone)){
      return;
    }
    // 2. modify
    if(await editUserService({"password":pass,"name": name,"phone": phone}) == "True"){
      editPasswordLoginStorage(pass);   // 내부 저장소 변경
      Navigator.pop(context, {"password":pass,"name": name,"phone": phone}); // 리턴
    }
    else{
      showDlg('수정 실패');
    }
  }
  void showDlg(String title){
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(title)));
  }
}
