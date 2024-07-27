import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cache_interceptor_hive_store/dio_cache_interceptor_hive_store.dart';
import 'package:logger/logger.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:path_provider/path_provider.dart';

class ApiClient {
  static final ApiClient _singleton = ApiClient._internal();
  late final Dio _dio;
  late final String _baseUrl;
  late final String _apiKey;
  final Logger _logger = Logger();
  final List<_RequestData> _requestQueue = [];
  bool _isNetworkAvailable = true;

  factory ApiClient() {
    return _singleton;
  }

  ApiClient._internal() {
    _initializeNetworkListener();
  }
  Future<String> _getCacheDirectory() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  void initialize(String baseUrl, String apiKey) async {
    _baseUrl = baseUrl;
    _apiKey = apiKey;

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
    _dio.interceptors.add(LogInterceptor(
      request: false,
      requestHeader: false,
      requestBody: false,
      responseHeader: false,
      responseBody: true,
      error: true,
    ));
  }

  Future<Response> get(String path,
      {Map<String, dynamic>? queryParameters}) async {
    if (!await _hasInternetConnection()) {
      _logger.w('No internet connection. Queuing GET request.');
      _requestQueue
          .add(_RequestData('GET', path, queryParameters: queryParameters));
      throw DioException(
          requestOptions: RequestOptions(path: path),
          type: DioExceptionType.unknown,
          error: 'No internet connection');
    }

    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      _logger.i('GET $path: ${response.data}');
      return response;
    } on DioException catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  Future<Response> post(String path, {dynamic data}) async {
    if (!await _hasInternetConnection()) {
      _logger.w('No internet connection. Queuing POST request.');
      _requestQueue.add(_RequestData('POST', path, data: data));
      throw DioException(
          requestOptions: RequestOptions(path: path),
          type: DioExceptionType.unknown,
          error: 'No internet connection');
    }

    try {
      final response = await _dio.post(path, data: data);
      _logger.i('POST $path: ${response.data}');
      return response;
    } on DioException catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  Future<bool> _hasInternetConnection() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  void _handleError(DioException error) {
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      _logger.e('Connection Timeout Error: ${error.message}');
      // Handle specific UI notification for connection timeouts
    } else if (error.type == DioExceptionType.badResponse) {
      _logger.e('Bad Response: ${error.response?.statusCode} ${error.message}');
      // Handle UI notification for server errors
    } else if (error.type == DioExceptionType.cancel) {
      _logger.e('Request Cancelled: ${error.message}');
      // Handle UI notification for request cancellations
    } else if (error.type == DioExceptionType.unknown &&
        error.error == 'No internet connection') {
      _logger.e('No Internet Connection: ${error.message}');
      // Handle UI notification for no internet connection
    } else {
      _logger.e('Unexpected Error: ${error.message}');
      // Handle other unexpected errors
    }
  }

  void _initializeNetworkListener() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      _isNetworkAvailable = result != ConnectivityResult.none;
      if (_isNetworkAvailable) {
        _logger.i('Internet connection restored. Processing queued requests.');
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
