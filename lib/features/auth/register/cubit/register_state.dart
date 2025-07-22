import '../../../../shared/models/user.dart';

class RegisterState {
  final bool isLoading;
  final bool isLoaded;
  final bool hasError;
  final User? user;
  final String? errorMessage;

  RegisterState({
    this.isLoading = false,
    this.isLoaded = false,
    this.hasError = false,
    this.user,
    this.errorMessage,
  });

  RegisterState copyWith({
    bool? isLoading,
    bool? isLoaded,
    bool? hasError,
    User? user,
    String? errorMessage,
  }) {
    return RegisterState(
      isLoading: isLoading ?? this.isLoading,
      isLoaded: isLoaded ?? this.isLoaded,
      hasError: hasError ?? this.hasError,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  factory RegisterState.initial() => RegisterState();

  factory RegisterState.loading() => RegisterState(isLoading: true);

  factory RegisterState.loaded(User user) => RegisterState(
        isLoaded: true,
        user: user,
      );

  factory RegisterState.error(String message) => RegisterState(
        hasError: true,
        errorMessage: message,
      );
}