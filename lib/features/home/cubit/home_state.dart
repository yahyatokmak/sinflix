import '../../../shared/models/movie.dart';

class HomeState {
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasError;
  final bool hasReachedMax;
  final List<Movie> movies;
  final String? errorMessage;
  final int currentPage;

  HomeState({
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasError = false,
    this.hasReachedMax = false,
    this.movies = const [],
    this.errorMessage,
    this.currentPage = 1,
  });

  HomeState copyWith({
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasError,
    bool? hasReachedMax,
    List<Movie>? movies,
    String? errorMessage,
    int? currentPage,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasError: hasError ?? this.hasError,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      movies: movies ?? this.movies,
      errorMessage: errorMessage ?? this.errorMessage,
      currentPage: currentPage ?? this.currentPage,
    );
  }

  factory HomeState.initial() => HomeState();

  factory HomeState.loading() => HomeState(isLoading: true);

  factory HomeState.loadingMore(
    List<Movie> currentMovies,
    int currentPage,
  ) =>
      HomeState(
        isLoadingMore: true,
        movies: currentMovies,
        currentPage: currentPage,
      );

  factory HomeState.loaded(
    List<Movie> movies,
    int currentPage,
    bool hasReachedMax,
  ) =>
      HomeState(
        movies: movies,
        currentPage: currentPage,
        hasReachedMax: hasReachedMax,
      );

  factory HomeState.error(String message) => HomeState(
        hasError: true,
        errorMessage: message,
      );
}