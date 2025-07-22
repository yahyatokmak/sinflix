import 'package:dio/dio.dart';
import '../constants/api_constants.dart';
import '../../shared/models/user.dart';
import '../../shared/models/api_response.dart';
import '../../shared/models/auth_request.dart';
import '../../shared/models/movie.dart';
import '../../shared/models/movie_list_response.dart';
import 'api_exceptions.dart';
import 'secure_storage_service.dart';
import 'logger_service.dart';

class ApiService {
  late final Dio _dio;

  ApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': ApiConstants.contentType,
          'accept': ApiConstants.contentType,
        },
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await SecureStorageService.getToken();
          if (token != null) {
            options.headers[ApiConstants.authorization] = token;
          }
          handler.next(options);
        },
        onError: (error, handler) {
          final exception = _handleError(error);
          handler.reject(
            DioException(
              requestOptions: error.requestOptions,
              error: exception,
            ),
          );
        },
      ),
    );
  }

  Future<ApiResponse<User>> login(LoginRequest request) async {
    try {
      final response = await _dio.post(
        ApiConstants.login,
        data: request.toJson(),
      );

      final apiResponse = ApiResponse<User>.fromJson(
        response.data,
        (json) => User.fromJson(json as Map<String, dynamic>),
      );

      if (apiResponse.data?.token != null && apiResponse.data?.id != null) {
        await SecureStorageService.saveToken(apiResponse.data!.token!);
        await SecureStorageService.saveUserId(apiResponse.data!.id!);
      }

      return apiResponse;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<ApiResponse<User>> register(RegisterRequest request) async {
    try {
      final response = await _dio.post(
        ApiConstants.register,
        data: request.toJson(),
      );

      final apiResponse = ApiResponse<User>.fromJson(
        response.data,
        (json) => User.fromJson(json as Map<String, dynamic>),
      );

      if (apiResponse.data?.token != null && apiResponse.data?.id != null) {
        await SecureStorageService.saveToken(apiResponse.data!.token!);
        await SecureStorageService.saveUserId(apiResponse.data!.id!);
      }

      return apiResponse;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<User> getProfile() async {
    try {
      final response = await _dio.get(ApiConstants.profile);
      LoggerService.debug('Profile API loaded successfully');
      
      // API response structure'ına göre düzenle
      final userData = response.data;
      if (userData is Map<String, dynamic>) {
        // Eğer data içinde user bilgisi varsa
        if (userData.containsKey('data') && userData['data'] is Map<String, dynamic>) {
          return User.fromJson(userData['data']);
        } else {
          return User.fromJson(userData);
        }
      } else {
        throw Exception('Invalid response format');
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<ApiResponse<MovieListResponse>> getMovies({int page = 1}) async {
    try {
      final response = await _dio.get(
        ApiConstants.movieList,
        queryParameters: {'page': page},
      );

      final apiResponse = ApiResponse<MovieListResponse>.fromJson(
        response.data,
        (json) => MovieListResponse.fromJson(json as Map<String, dynamic>),
      );

      return apiResponse;
    } catch (e) {
      if (e is DioException) {
        throw _handleError(e);
      } else {
        throw ApiException('JSON parsing hatası: ${e.toString()}');
      }
    }
  }

  Future<List<Movie>> getFavoriteMovies() async {
    try {
      final response = await _dio.get(ApiConstants.movieFavorites);

      final apiResponse = ApiResponse<List<Movie>>.fromJson(
        response.data,
        (json) => (json as List)
            .map((item) => Movie.fromJson(item as Map<String, dynamic>))
            .toList(),
      );

      return apiResponse.data ?? [];
    } catch (e) {
      if (e is DioException) {
        throw _handleError(e);
      } else {
        throw ApiException(
          'Favori filmler JSON parsing hatası: ${e.toString()}',
        );
      }
    }
  }

  Future<void> toggleMovieFavorite(String movieId) async {
    try {
      await _dio.post(ApiConstants.movieFavorite(movieId));
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<String> uploadProfilePhoto(String imagePath) async {
    try {
      String fileName = imagePath.split('/').last;
      FormData formData = FormData.fromMap({
        'photo': await MultipartFile.fromFile(imagePath, filename: fileName),
      });

      final response = await _dio.post(
        '${ApiConstants.baseUrl}/profile/photo',
        data: formData,
        options: Options(headers: {'Content-Type': 'multipart/form-data'}),
      );

      return response.data['photoUrl'] ?? '';
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<bool> validateToken() async {
    try {
      final token = await SecureStorageService.getToken();
      if (token == null) return false;

      final response = await _dio.get(ApiConstants.profile);
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  ApiException _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return NetworkException();

      case DioExceptionType.connectionError:
        return NetworkException();

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message =
            error.response?.data?['message'] ??
            error.response?.data?['response']?['message'];

        switch (statusCode) {
          case 400:
            // Check for specific error messages
            if (message != null &&
                message.toLowerCase().contains('user already exists')) {
              return UserAlreadyExistsException();
            }
            return ValidationException(message ?? 'Geçersiz istek');
          case 401:
            return UnauthorizedException();
          case 409:
            return UserAlreadyExistsException();
          case 500:
            return ServerException(message);
          default:
            return ApiException(
              message ?? 'Bilinmeyen hata oluştu',
              statusCode,
            );
        }

      default:
        return ApiException('Beklenmeyen hata oluştu');
    }
  }
}
