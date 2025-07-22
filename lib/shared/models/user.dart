import '../../core/services/logger_service.dart';

class User {
  final String? id;
  final String? name;
  final String? email;
  final String? photoUrl;
  final String? token;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl,
    this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    try {
      LoggerService.debug('User fromJson parsing');
      return User(
        id: json['id']?.toString() ?? json['_id']?.toString(),
        name: json['name']?.toString() ?? json['username']?.toString() ?? json['fullName']?.toString(),
        email: json['email']?.toString(),
        photoUrl: json['photoUrl']?.toString() ?? json['photo']?.toString() ?? json['profilePhoto']?.toString(),
        token: json['token']?.toString(),
      );
    } catch (e, stackTrace) {
      LoggerService.error('User fromJson parsing failed', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'token': token,
    };
  }

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? photoUrl,
    String? token,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      token: token ?? this.token,
    );
  }
}
