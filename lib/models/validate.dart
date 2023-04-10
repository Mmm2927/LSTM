import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

bool validateEmail(String email){
  var emailFormat = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  if(email.isEmpty || !RegExp(emailFormat).hasMatch(email)){
    return false;
  }
  return true;
}
bool validatePassword(String pass){
  if(pass.isEmpty || pass.length<8) {
    return false;
  }
  return true;
}
bool validateName(String name){
  if(name.isEmpty || name.length<3) {
    return false;
  }
  return true;
}
bool validatePhone(String phone){
  if(phone.isEmpty || phone.length!=11) {
    return false;
  }
  return true;
}
String? validateEmail2String(String email){
  if(email.isEmpty){
    return "이메일을 입력해주세요";
  }
  var emailFormat = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  if(!RegExp(emailFormat).hasMatch(email)){
    return "이메일을 형식을 맞춰주세요";
  }
  return null;
}
String? validatePassword2String(String pass){
  if(pass.isEmpty){
    return "비밀번호를 입력해주세요.";
  }
  if(pass.length < 8){
    return "비밀번호는 8자 이상입니다.";
  }
  return null;
}
String? validateName2String(String name){
  if(name.isEmpty){
    return "이름을 입력해주세요.";
  }
  if(name.length < 3){
    return "이름은 3자 이상입니다.";
  }
  return null;
}
String? validatePhone2String(String phone){
  if(phone.isEmpty){
    return "핸드폰 번호를 입력해주세요.";
  }
  if(phone.length != 11){
    return "핸드폰 번호은 -를 제외한 11자입니다.";
  }
  return null;
}