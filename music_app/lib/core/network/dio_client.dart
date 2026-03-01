import 'package:dio/dio.dart';
import '../storage/secure_storage.dart';

class DioClient {
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: "http://192.168.0.109:8080/api", 
      // 10.0.2.2 untuk emulator Android
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
    ),
  )..interceptors.add(
  InterceptorsWrapper(
    onRequest: (options, handler) async {
      final token = await SecureStorage.getToken();
      if (token != null) {
        options.headers["Authorization"] = "Bearer $token";
      }
      return handler.next(options);
    },
  ),
);
}

