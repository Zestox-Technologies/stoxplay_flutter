import 'package:dio/dio.dart';
import 'package:stoxplay/core/local_storage/storage_service.dart';
import 'package:stoxplay/core/network/api_urls.dart';
import 'package:stoxplay/utils/constants/db_keys.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  late final Dio _dio;

  factory ApiService() {
    return _instance;
  }

  void updateAuthHeader(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  // final token = StorageService().read<String>(DBKeys.userTokenKey);

  ApiService._internal() {
    final headers = {'Content-Type': 'application/json', 'Accept': 'application/json'};
    //
    // if (token != null && token!.isNotEmpty) {
    //   headers['Authorization'] = 'Bearer $token';
    // }

    _dio = Dio(
      BaseOptions(
        baseUrl: ApiUrls.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: headers,
        validateStatus: (status) {
          return status! < 500;
        },
      ),
    );

    // Add interceptors for logging and error handling
    _dio.interceptors.add(
      LogInterceptor(request: true, requestHeader: true, requestBody: true, responseBody: true, error: true),
    );
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = StorageService().read<String>(DBKeys.userTokenKey);
          if (token != null && token.isNotEmpty) {
            print('Token: $token');
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
      ),
    );
  }

  // Getter for Dio instance
  Dio get dio => _dio;

  // Generic GET method
  Future<Response> get(String path, {Map<String, dynamic>? queryParameters, Options? options}) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters, options: options);
      return response;
    } on DioException catch (e) {
      print('GET Request Error: ${e.message}');
      print('Error Response: ${e.response?.data}');
      rethrow;
    }
  }

  // Generic POST method
  Future<Response> post(String path, {dynamic data, Map<String, dynamic>? queryParameters, Options? options}) async {
    try {
      print('Making POST request to: $path');
      print('Request data: $data');

      final response = await _dio.post(path, data: data, queryParameters: queryParameters, options: options);

      print('Response status: ${response.statusCode}');
      print('Response data: ${response.data}');

      return response;
    } on DioException catch (e) {
      print('POST Request Error: ${e.message}');
      print('Error Response: ${e.response?.data}');
      rethrow;
    }
  }

  // POST with FormData (e.g., file uploads or multipart form submissions)
  Future<Response> postFormData(
    String path, {
    required Map<String, dynamic> formFields,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final formData = FormData.fromMap(formFields);

      print('Making POST FormData request to: $path');
      print('Form fields: $formFields');

      final response = await _dio.post(
        path,
        data: formData,
        queryParameters: queryParameters,
        options: options ?? Options(contentType: 'multipart/form-data', headers: {"Accept": "*/*"}),
      );

      print('Response status: ${response.statusCode}');
      print('Response data: ${response.data}');

      return response;
    } on DioException catch (e) {
      print('POST FormData Request Error: ${e.message}');
      print('Error Response: ${e.response?.data}');
      rethrow;
    }
  }

  // Generic PUT method
  Future<Response> put(String path, {dynamic data, Map<String, dynamic>? queryParameters, Options? options}) async {
    try {
      final response = await _dio.put(path, data: data, queryParameters: queryParameters, options: options);
      return response;
    } on DioException catch (e) {
      print('PUT Request Error: ${e.message}');
      print('Error Response: ${e.response?.data}');
      rethrow;
    }
  }

  // Generic DELETE method
  Future<Response> delete(String path, {dynamic data, Map<String, dynamic>? queryParameters, Options? options}) async {
    try {
      final response = await _dio.delete(path, data: data, queryParameters: queryParameters, options: options);
      return response;
    } on DioException catch (e) {
      print('DELETE Request Error: ${e.message}');
      print('Error Response: ${e.response?.data}');
      rethrow;
    }
  }
}
