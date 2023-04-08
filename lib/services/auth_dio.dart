import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:bob/services/storage.dart';

const String PATH = 'http://20.249.219.241:8000';

Future<Dio> authDio() async {
  var dio = Dio();
  dio.interceptors.clear();
  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) async{
      final accessToken = await getToken();
      options.headers['Authorization'] = accessToken;
      return handler.next(options); // 매 요청마다 헤더에 AccessToken을 포함
    },
    onError: (error, handler) async{
      // 인증 오류가 발생했을 경우: AccessToken의 만료
      if(error.response?.statusCode == 403){
        var refreshDio = Dio();   // 토큰 갱신 요청을 담당할 dio 객체
        //refreshDio.interceptors.clear();
        refreshDio.options.headers['Authorization'] = await getToken();
        refreshDio.options.headers['Refresh'] = await getRefreshToken();
        final refreshResponse = await refreshDio.get('${PATH}/token/refresh');
        // 갱신된 AccessToken과 RefreshToken 파싱
        final newAccessToken = refreshResponse.headers['Authorization']![0];
        final newRefreshToken = refreshResponse.headers['Refresh']![0];
        // login update
        await updateTokenInfo(newAccessToken, newRefreshToken);
        // AccessToken의 만료로 수행하지 못했던 API 요청에 담겼던 AccessToken 갱신
        error.requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';
        // 수행하지 못했던 API 요청 복사본 생성
        final clonedRequest = await dio.request(error.requestOptions.path,
            options: Options(
                method: error.requestOptions.method,
                headers: error.requestOptions.headers),
            data: error.requestOptions.data,
            queryParameters: error.requestOptions.queryParameters);
        // API 복사본으로 재요청
        return handler.resolve(clonedRequest);
      }
      return handler.next(error);
    }));
  return dio;
}