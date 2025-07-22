import '../../../shared/models/user.dart';
import '../../../shared/models/movie.dart';

class ProfileState {
  final bool isLoading;
  final bool isLoadingFavorites;
  final bool isUpdatingPhoto;
  final bool hasError;
  final User? user;
  final List<Movie> favoriteMovies;
  final String? errorMessage;

  ProfileState({
    this.isLoading = false,
    this.isLoadingFavorites = false,
    this.isUpdatingPhoto = false,
    this.hasError = false,
    this.user,
    this.favoriteMovies = const [],
    this.errorMessage,
  });

  ProfileState copyWith({
    bool? isLoading,
    bool? isLoadingFavorites,
    bool? isUpdatingPhoto,
    bool? hasError,
    User? user,
    List<Movie>? favoriteMovies,
    String? errorMessage,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      isLoadingFavorites: isLoadingFavorites ?? this.isLoadingFavorites,
      isUpdatingPhoto: isUpdatingPhoto ?? this.isUpdatingPhoto,
      hasError: hasError ?? this.hasError,
      user: user ?? this.user,
      favoriteMovies: favoriteMovies ?? this.favoriteMovies,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  factory ProfileState.initial() => ProfileState();

  factory ProfileState.loading() => ProfileState(isLoading: true);

  factory ProfileState.loadingFavorites() => ProfileState(isLoadingFavorites: true);

  factory ProfileState.loaded({
    required User user,
    required List<Movie> favoriteMovies,
  }) =>
      ProfileState(
        user: user,
        favoriteMovies: favoriteMovies,
      );

  factory ProfileState.error(String message) => ProfileState(
        hasError: true,
        errorMessage: message,
      );
}