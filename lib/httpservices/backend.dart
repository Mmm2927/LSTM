import 'package:bob/httpservices/storage.dart';
import 'package:dio/dio.dart';
import 'dart:convert';

final dio = Dio();    // 서버와 통신을 하기 위해 필요한 패키지

loginService(data) async{
  Response response = await dio.post('http://20.249.219.241:8000/api/user/login/', data: data);
  return response;
}
emailOverlapService(data) async{
  Response response = await dio.post('http://20.249.219.241:8000/api/user/exist/', data: data);
  if(response.statusCode == 200){
    return response.data;
  }
}
getMyBabies() async{
  var tmp = (await storage.read(key: "login"));
  Map<String,dynamic> jsonData = jsonDecode(tmp!);
  dio.options.headers['Authorization'] = "Bearer " + jsonData["token"];
  Response response = await dio.post('http://20.249.219.241:8000/api/baby/lists/');
  print('getMyBabies');
  if(response.statusCode == 200){
    return response.data;
  }
}
getBaby(int id) async{
  var tmp = (await storage.read(key: "login"));
  Map<String,dynamic> jsonData = jsonDecode(tmp!);
  dio.options.headers['Authorization'] = "Bearer " + jsonData["token"];
  Response response = await dio.post('http://20.249.219.241:8000/api/baby/<int:babyid>/get');
  print('getMyBabies');
  if(response.statusCode == 200){
    return response.data;
  }
}
registerService(data) async{
  Response response = await dio.post('http://20.249.219.241:8000/api/user/registration/', data: data);
  return response;
}
editUserService(data) async{
  var tmp = (await storage.read(key: "login"));
  Map<String,dynamic> jsonData = jsonDecode(tmp!);
  dio.options.headers['Authorization'] = "Bearer " + jsonData["token"];
  Response response = await dio.post('http://20.249.219.241:8000/api/user/edit/', data: data);
  if(response.statusCode == 200){
    return response.data;
  }
  return response.data;
}
refresh() async{
  dio.interceptors.clear();
  /*dio.interceptors.add(
      InterceptorsWrapper(onRequest: (options, handler) async {

        // 기기에 저장된 AccessToken 로드
        final accessToken = await storage.read(key: 'ACCESS_TOKEN');

        // 매 요청마다 헤더에 AccessToken을 포함
        options.headers['Authorization'] = 'Bearer $accessToken';
        return handler.next(options);
      },
      onError: (error, handler) async{

      }

  )*/
}