class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, [this.statusCode]);

  @override
  String toString() => 'ApiException: $message';
}

class NetworkException extends ApiException {
  NetworkException() : super('İnternet bağlantısı bulunamadı');
}

class ServerException extends ApiException {
  ServerException([String? message]) 
      : super(message ?? 'Sunucu hatası oluştu', 500);
}

class UnauthorizedException extends ApiException {
  UnauthorizedException() : super('Yetkisiz erişim', 401);
}

class ValidationException extends ApiException {
  ValidationException(String message) : super(message, 400);
}

class UserAlreadyExistsException extends ApiException {
  UserAlreadyExistsException() : super('Bu e-posta adresi zaten kayıtlı', 409);
}