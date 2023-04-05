import 'package:flutter/material.dart';
import 'package:checkbox_formfield/checkbox_formfield.dart';
import 'package:bob/widgets/appbar.dart';

class SignIn extends StatefulWidget{
  @override
  _SignUp createState()=> _SignUp();
}

class _SignUp extends State<SignIn>{
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String nickname = "";
  String email = "";
  String password = "";
  var _isChecked = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: renderAppbar('회원가입'),
      body : Container(
          child:Container(
              margin: const EdgeInsets.all(20),
              child : Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                        flex : 8,
                        child: Column(
                          children: [
                            renderTextFormField(label:'이메일',
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
                                  return null;},isObscureText:false
                            ),
                            const SizedBox(height: 10),
                            renderTextFormField(
                                label:'닉네임',
                                onSaved : (val){
                                  setState(() {
                                    this.nickname = val;
                                  });
                                },
                                validator:(val){ if(val!.isEmpty){
                                  return "닉네임을 입력해 주세요";
                                }return null;},isObscureText:false),
                            const SizedBox(height: 10),
                            renderTextFormField(
                                label:'비밀번호',
                                onSaved : (val){
                                  setState(() {
                                    this.password = val;
                                  });
                                },
                                validator:(val){
                                  if(val!.isEmpty)  return "비밀번호를 입력해 주세요";
                                  return null;
                                },
                                isObscureText:true
                            ),
                            renderTextFormField(label:'비밀번호 확인',onSaved : (val){},
                                validator:(val){
                                  if(val!.isEmpty)  return "비밀번호 확인을 입력해주세요";
                                  else if(val != this.password)  return "비밀번호와 일치하지 않습니다";
                                  return null;
                                },
                                isObscureText:true
                            ),

                          ],
                        )
                    ),
                    Flexible(
                        flex : 1,
                        child: renderButton()
                    ),

                  ],
                ),

              )
          )
      )
    );

  }
  renderCheckBoxFormField({
    required String label,
    required dynamic validator,
    required FormFieldSetter onSaved,
  }){
    return CheckboxListTileFormField(
      title: Text(label, textAlign: TextAlign.start,),
      validator: validator,
      onSaved: onSaved,
        contentPadding : EdgeInsets.all(0)
    );
  }
  renderTextFormField({
      required String label,
      required FormFieldSetter onSaved,
      required FormFieldValidator validator,
      required bool isObscureText,
      }
    )
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
  renderButton(){
    return ElevatedButton(
      style:ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(55),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0))
      ),
        onPressed: () async{
          if(this._formKey.currentState!.validate()){
            // 즉, validation 통과시
            print('(button) validate 성공');
            this._formKey.currentState!.save(); // validation 성공 시 폼 저장
          }
          else
            print('(button) validate 실패');
        },
        child: Text('회원가입')
    );
  }
  renderValues(){
    return Column(
      children: [
        Text('nickname: $nickname'),
        Text('email: $email'),
        Text('password: $password'),
      ],
    );
  }
  void _register() async{

  }

}