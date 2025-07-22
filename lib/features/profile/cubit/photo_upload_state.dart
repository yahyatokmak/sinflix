class PhotoUploadState {
  final bool isLoading;
  final bool hasError;
  final String? errorMessage;
  final String? uploadedPhotoUrl;
  final bool isSuccess;

  const PhotoUploadState({
    this.isLoading = false,
    this.hasError = false,
    this.errorMessage,
    this.uploadedPhotoUrl,
    this.isSuccess = false,
  });

  factory PhotoUploadState.initial() {
    return const PhotoUploadState();
  }

  factory PhotoUploadState.loading() {
    return const PhotoUploadState(isLoading: true);
  }

  factory PhotoUploadState.success(String photoUrl) {
    return PhotoUploadState(isSuccess: true, uploadedPhotoUrl: photoUrl);
  }

  factory PhotoUploadState.error(String message) {
    return PhotoUploadState(hasError: true, errorMessage: message);
  }

  PhotoUploadState copyWith({
    bool? isLoading,
    bool? hasError,
    String? errorMessage,
    String? uploadedPhotoUrl,
    bool? isSuccess,
  }) {
    return PhotoUploadState(
      isLoading: isLoading ?? this.isLoading,
      hasError: hasError ?? this.hasError,
      errorMessage: errorMessage ?? this.errorMessage,
      uploadedPhotoUrl: uploadedPhotoUrl ?? this.uploadedPhotoUrl,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}
