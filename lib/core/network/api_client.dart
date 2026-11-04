import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Dio buildDio(String baseUrl) {
  final storage = FlutterSecureStorage();
  final dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 20),
    headers: {'Accept': 'application/json'},
  ));

  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (opt, handler) async {
      final token = await storage.read(key: 'access_token');
      if (token != null) opt.headers['Authorization'] = 'Bearer $token';
      handler.next(opt);
    },
    onError: (e, handler) {
      // TODO: refresh-token flow
      handler.next(e);
    },
  ));
  return dio;
}