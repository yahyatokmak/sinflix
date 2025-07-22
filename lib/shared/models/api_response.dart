class ApiResponse<T> {
  final ResponseInfo response;
  final T? data;

  ApiResponse({
    required this.response,
    this.data,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) {
    return ApiResponse<T>(
      response: ResponseInfo.fromJson(json['response'] as Map<String, dynamic>),
      data: json['data'] != null ? fromJsonT(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson(Object Function(T value) toJsonT) {
    return {
      'response': response.toJson(),
      'data': data != null ? toJsonT(data as T) : null,
    };
  }
}

class ResponseInfo {
  final int code;
  final String message;

  ResponseInfo({
    required this.code,
    required this.message,
  });

  factory ResponseInfo.fromJson(Map<String, dynamic> json) {
    return ResponseInfo(
      code: json['code'] as int,
      message: json['message'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'message': message,
    };
  }
}