import 'dart:developer' as developer;

class LoggerService {
  static const String _name = 'Shartflix';
  
  static void info(String message, {Object? error, StackTrace? stackTrace}) {
    developer.log(
      message,
      name: _name,
      level: 800,
      error: error,
      stackTrace: stackTrace,
    );
  }
  
  static void warning(String message, {Object? error, StackTrace? stackTrace}) {
    developer.log(
      message,
      name: _name,
      level: 900,
      error: error,
      stackTrace: stackTrace,
    );
  }
  
  static void error(String message, {Object? error, StackTrace? stackTrace}) {
    developer.log(
      message,
      name: _name,
      level: 1000,
      error: error,
      stackTrace: stackTrace,
    );
  }
  
  static void debug(String message) {
    assert(() {
      developer.log(
        message,
        name: _name,
        level: 500,
      );
      return true;
    }());
  }
}