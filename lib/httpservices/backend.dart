import 'package:dio/dio.dart';

final dio = Dio();    // 서버와 통신을 하기 위해 필요한 패키지

loginService(data) async{
  Response response = await dio.post('http://20.249.219.241:8000/api/user/login/', data: data);
  return response;
}
emailOverlapService(data) async{
  Response response = await dio.post('http://20.249.219.241:8000/api/user/exist/', data: data);
  return response;
}
registerService(data) async{
  Response response = await dio.post('http://20.249.219.241:8000/api/user/registration/', data: data);
  return response;
}