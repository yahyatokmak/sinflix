import '../../../../shared/models/user.dart';

class LoginState {
  final bool isLoading;
  final bool isLoaded;
  final bool hasError;
  final User? user;
  final String? errorMessage;

  LoginState({
    this.isLoading = false,
    this.isLoaded = false,
    this.hasError = false,
    this.user,
    this.errorMessage,
  });

  LoginState copyWith({
    bool? isLoading,
    bool? isLoaded,
    bool? hasError,
    User? user,
    String? errorMessage,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      isLoaded: isLoaded ?? this.isLoaded,
      hasError: hasError ?? this.hasError,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  factory LoginState.initial() => LoginState();

  factory LoginState.loading() => LoginState(isLoading: true);

  factory LoginState.loaded(User user) => LoginState(
        isLoaded: true,
        user: user,
      );

  factory LoginState.error(String message) => LoginState(
        hasError: true,
        errorMessage: message,
      );
}