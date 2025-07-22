import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/services/api_service.dart';
import '../../../core/services/logger_service.dart';
import '../../../shared/models/movie.dart';
import '../../../shared/models/user.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ApiService _apiService;
  final ImagePicker _imagePicker = ImagePicker();

  ProfileCubit(this._apiService) : super(ProfileState.initial());

  Future<void> loadProfile() async {
    emit(ProfileState.loading());

    try {
      // Load user profile and favorite movies in parallel
      final userFuture = _apiService.getProfile();
      final favoritesFuture = _apiService.getFavoriteMovies();

      final results = await Future.wait([userFuture, favoritesFuture]);

      final user = results[0] as User;
      final favoriteMovies = results[1] as List<Movie>;

      emit(ProfileState.loaded(user: user, favoriteMovies: favoriteMovies));
    } catch (e) {
      emit(ProfileState.error(e.toString()));
    }
  }

  Future<void> refreshFavorites() async {
    LoggerService.debug('ProfileCubit: refreshFavorites called');
    emit(state.copyWith(isLoadingFavorites: true));

    try {
      final favoriteMovies = await _apiService.getFavoriteMovies();
      LoggerService.debug('ProfileCubit: Got ${favoriteMovies.length} favorite movies');
      emit(state.copyWith(isLoadingFavorites: false, favoriteMovies: favoriteMovies));
    } catch (e) {
      LoggerService.error('ProfileCubit: Error refreshing favorites', error: e);
      emit(state.copyWith(isLoadingFavorites: false, hasError: true, errorMessage: e.toString()));
    }
  }

  Future<void> pickAndUploadProfilePhoto() async {
    try {
      final XFile? image = await _imagePicker.pickImage(source: ImageSource.gallery, maxWidth: 512, maxHeight: 512, imageQuality: 80);

      if (image != null) {
        emit(state.copyWith(isUpdatingPhoto: true));

        // Upload the image to the server
        final photoUrl = await _apiService.uploadProfilePhoto(image.path);

        // Update the user's photo URL in the state
        final updatedUser = state.user?.copyWith(photoUrl: photoUrl);
        emit(state.copyWith(user: updatedUser, isUpdatingPhoto: false));
      }
    } catch (e) {
      emit(state.copyWith(isUpdatingPhoto: false, hasError: true, errorMessage: 'Fotoğraf yüklenirken hata oluştu: ${e.toString()}'));
    }
  }

  void resetState() {
    emit(ProfileState.initial());
  }
}
