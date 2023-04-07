import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:bob/models/model.dart';

final storage = FlutterSecureStorage(); //flutter_secure_storage 사용을 위한 초기화 작업

getLoginStorage() async{
var login = await storage.read(key: "login");
return login;
}
editPasswordLoginStorage(String password) async{
  var login = await storage.read(key: "login");
  Login Newlogin = login as Login;
  Newlogin.changePassword(password);
  await storage.write(key: 'login', value: jsonEncode(Newlogin));
}