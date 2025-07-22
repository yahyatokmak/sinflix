import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/services/api_service.dart';
import 'photo_upload_state.dart';

class PhotoUploadCubit extends Cubit<PhotoUploadState> {
  final ApiService _apiService;
  final ImagePicker _imagePicker = ImagePicker();

  PhotoUploadCubit(this._apiService) : super(PhotoUploadState.initial());

  Future<void> pickAndUploadPhoto() async {
    try {
      final pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (pickedFile == null) return;

      emit(PhotoUploadState.loading());

      final photoUrl = await _apiService.uploadProfilePhoto(pickedFile.path);

      if (photoUrl.isNotEmpty) {
        emit(PhotoUploadState.success(photoUrl));
      } else {
        emit(PhotoUploadState.error('Fotoğraf yüklenemedi'));
      }
    } catch (e) {
      emit(PhotoUploadState.error('Fotoğraf yükleme hatası: ${e.toString()}'));
    }
  }

  Future<void> takeAndUploadPhoto() async {
    try {
      final pickedFile = await _imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (pickedFile == null) return;

      emit(PhotoUploadState.loading());

      final photoUrl = await _apiService.uploadProfilePhoto(pickedFile.path);

      if (photoUrl.isNotEmpty) {
        emit(PhotoUploadState.success(photoUrl));
      } else {
        emit(PhotoUploadState.error('Fotoğraf yüklenemedi'));
      }
    } catch (e) {
      emit(PhotoUploadState.error('Fotoğraf yükleme hatası: ${e.toString()}'));
    }
  }

  void resetState() {
    emit(PhotoUploadState.initial());
  }
}
