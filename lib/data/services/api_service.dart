import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cache_interceptor_hive_store/dio_cache_interceptor_hive_store.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:path_provider/path_provider.dart';
import '../../core/constants/api_config.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/strings.dart';
import 'notification_service.dart';
import '../../main.dart';

class ApiClient {
  static final ApiClient _singleton = ApiClient._internal();
  late final Dio _dio;
  late final String _baseUrl;
  late final String _apiKey;
  final List<_RequestData> _requestQueue = [];
  bool _isNetworkAvailable = true;

  factory ApiClient() {
    return _singleton;
  }

  ApiClient._internal() {
    initialize();
    _initializeNetworkListener();
  }
  Future<String> _getCacheDirectory() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  void initialize() async {
    _baseUrl = ApiConfig.baseUrl;
    _apiKey = dotenv.env['SPOONACULAR_KEY'] ?? '';

    _dio = Dio(BaseOptions(
      baseUrl: _baseUrl,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'x-api-key': _apiKey,
      },
    ));
    final cacheDir = await _getCacheDirectory();
    final cacheOptions = CacheOptions(
      store: HiveCacheStore('$cacheDir/dio_cache'),
      policy: CachePolicy.request,
      hitCacheOnErrorExcept: [401, 403],
      priority: CachePriority.normal,
      maxStale: const Duration(days: 7),
    );

    _dio.interceptors.add(DioCacheInterceptor(options: cacheOptions));
    _dio.interceptors.add(
      RetryInterceptor(
        dio: _dio,
        retries: 4,
        retryDelays: const [
          Duration(seconds: 1),
          Duration(seconds: 2),
          Duration(seconds: 3),
          Duration(seconds: 4),
        ],
      ),
    );

    _dio.interceptors.add(LogInterceptor(
      request: true,
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
      responseBody: true,
      error: true,
    ));
  }

  Future<Response> get(String path,
      {Map<String, dynamic>? queryParameters}) async {
    if (!await _hasInternetConnection()) {
      NotificationService().showSnackBar(
        context: navigatorKey.currentContext!,
        message: AppStrings.noInternet,
        duration: const Duration(days: 10),
        backgroundColor: ColorPalette.primary,
        textColor: Colors.white,
      );
      _requestQueue
          .add(_RequestData('GET', path, queryParameters: queryParameters));
      throw DioException(
        requestOptions: RequestOptions(path: path),
        type: DioExceptionType.unknown,
        error: AppStrings.noInternet,
      );
    }

    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      return response;
    } on DioException {
      // _handleError(e, navigatorKey.currentContext!);
      rethrow;
    }
  }

  Future<Response> post(String path, {dynamic data}) async {
    if (!await _hasInternetConnection()) {
      NotificationService().showSnackBar(
        context: navigatorKey.currentContext!,
        message: AppStrings.noInternet,
        duration: const Duration(days: 10),
        backgroundColor: ColorPalette.primary,
        textColor: Colors.white,
      );
      _requestQueue.add(_RequestData('POST', path, data: data));
      throw DioException(
        requestOptions: RequestOptions(path: path),
        type: DioExceptionType.unknown,
        error: AppStrings.noInternet,
      );
    }

    try {
      final response = await _dio.post(path, data: data);
      return response;
    } on DioException {
      // _handleError(e, navigatorKey.currentContext!);
      rethrow;
    }
  }

  Future<bool> _hasInternetConnection() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult.first != ConnectivityResult.none;
  }

  void _handleError(DioException error, BuildContext context) {
    final notificationService = NotificationService();

    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      notificationService.showSnackBar(
        context: context,
        message: AppStrings.connectionTimeout,
        backgroundColor: ColorPalette.primary,
        textColor: Colors.white,
      );
    } else if (error.type == DioExceptionType.cancel) {
      notificationService.showSnackBar(
        context: context,
        message: AppStrings.requestCancel,
        backgroundColor: Colors.orange,
        textColor: Colors.white,
      );
    } else if (error.type == DioExceptionType.unknown &&
        error.error == 'No internet connection') {
      notificationService.showSnackBar(
        context: context,
        message: AppStrings.noInternet,
        duration: const Duration(days: 10),
        backgroundColor: ColorPalette.primary,
        textColor: Colors.white,
      );
    } else {
      notificationService.showSnackBar(
        context: context,
        message: AppStrings.error,
        backgroundColor: ColorPalette.primary,
        textColor: Colors.white,
      );
    }
  }

  void _initializeNetworkListener() {
    Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> result) {
      _isNetworkAvailable = result.first != ConnectivityResult.none;
      if (_isNetworkAvailable) {
        Future.delayed(Duration.zero, () {
          if (navigatorKey.currentContext != null) {
            ScaffoldMessenger.of(navigatorKey.currentContext!)
                .hideCurrentSnackBar();
          }
        });
        _processRequestQueue();
      }
    });
  }

  void _processRequestQueue() {
    while (_requestQueue.isNotEmpty && _isNetworkAvailable) {
      final request = _requestQueue.removeAt(0);
      if (request.method == 'GET') {
        get(request.path, queryParameters: request.queryParameters);
      } else if (request.method == 'POST') {
        post(request.path, data: request.data);
      }
    }
  }
}

class _RequestData {
  final String method;
  final String path;
  final Map<String, dynamic>? queryParameters;
  final dynamic data;

  _RequestData(this.method, this.path, {this.queryParameters, this.data});
}
