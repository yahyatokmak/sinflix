class SplashState {
  final bool isLoading;
  final bool isCompleted;
  final bool hasError;
  final String? errorMessage;

  const SplashState({
    this.isLoading = false,
    this.isCompleted = false,
    this.hasError = false,
    this.errorMessage,
  });

  factory SplashState.initial() {
    return const SplashState();
  }

  factory SplashState.loading() {
    return const SplashState(isLoading: true);
  }

  factory SplashState.completed() {
    return const SplashState(isCompleted: true);
  }

  factory SplashState.error(String message) {
    return SplashState(hasError: true, errorMessage: message);
  }

  SplashState copyWith({
    bool? isLoading,
    bool? isCompleted,
    bool? hasError,
    String? errorMessage,
  }) {
    return SplashState(
      isLoading: isLoading ?? this.isLoading,
      isCompleted: isCompleted ?? this.isCompleted,
      hasError: hasError ?? this.hasError,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}