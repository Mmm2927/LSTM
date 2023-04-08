import 'package:bob/services/storage.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:bob/services/auth_dio.dart';

const String PATH = 'http://20.249.219.241:8000';
final dio = Dio();    // 서버와 통신을 하기 위해 필요한 패키지

loginService(id, pass) async{
  Response response = await dio.post('${PATH}/api/user/login/', data: {'email' : id, 'password': pass});
  if(response.statusCode == 200){
    return response.data;
  }else{
    return null;
  }
}
// 중복 검사 서비스
emailOverlapService(id) async{
  Response response = await dio.post('${PATH}/api/user/exist/', data: {'email' : id});
  if(response.statusCode == 200){
    return response.data;
  }
}
// 회원가입 서비스
registerService(email, pass, name, phone) async{
  Response response = await dio.post('${PATH}/api/user/registration/',
      data: {"email": email, "password1": pass, "password2": pass, "name": name, "phone": phone}
  );
  return response;
}


getMyBabies() async{
  dio.options.headers['Authorization'] = await getToken();
  Response response = await dio.post('${PATH}/api/baby/lists/');
  if(response.statusCode == 200){
    return response.data as List<dynamic>;
  }
}
getBaby(int id) async{
  dio.options.headers['Authorization'] = await getToken();
  Response response = await dio.post('${PATH}/api/baby/${id}/get/');
  if(response.statusCode == 200){
    return response.data;
  }
}
setBabyService(data) async{
  dio.options.headers['Authorization'] = await getToken();
  Response response = await dio.post('${PATH}/api/baby/set/', data: data);
  if(response.statusCode == 200){
    return response.data;
  }
}
editUserService(data) async{
  try{
    dio.options.headers['Authorization'] = await getToken();
    Response response = await dio.post('${PATH}/api/user/edit/', data: data);
    print(response.statusCode);
    return response.data;
  }catch(e){
    dio.options.headers['Authorization'] = await refresh();
    Response response = await dio.post('${PATH}/api/user/edit/', data: data);
    response.data;
    return response.data;
  }
  /*
  if(response.statusCode == 200){
    return response.data;
  }
  if(response.statusCode == 403){
    dio.options.headers['Authorization'] = await refresh();
    Response response = await dio.post('${PATH}/api/user/edit/', data: data);
    response.data;
  }
  return response.data;*/
}
deleteUser() async{
  dio.options.headers['Authorization'] = await getToken();
  Response response = await dio.post('${PATH}/api/user/remove/');
  if(response.statusCode == 200){
    await storage.delete(key: 'login');
    return response.statusCode;
  }
  if(response.statusCode == 403){
    print('no auth');
    return;
  }
  //await storage.delete(key: 'login');
  return response.statusCode;
}
// 토큰 갱신
refresh() async{
  var refreshDio = Dio();   // 토큰 갱신 요청을 담당할 dio 객체
  refreshDio.options.headers['Authorization'] = await getToken();
  refreshDio.options.headers['Refresh'] = await getRefreshToken();
  final refreshResponse = await refreshDio.get('${PATH}/token/refresh');
  // 갱신된 AccessToken과 RefreshToken 파싱
  final newAccessToken = refreshResponse.headers['Authorization']![0];
  final newRefreshToken = refreshResponse.headers['Refresh']![0];
  // login update
  await updateTokenInfo(newAccessToken, newRefreshToken);
  return newAccessToken;
}
