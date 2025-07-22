import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/api_service.dart';
import '../cubit/photo_upload_cubit.dart';
import '../cubit/photo_upload_state.dart';

class PhotoUploadDialog extends StatelessWidget {
  final Function(String)? onPhotoUploaded;

  const PhotoUploadDialog({super.key, this.onPhotoUploaded});

  static Future<void> show(
    BuildContext context, {
    Function(String)? onPhotoUploaded,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PhotoUploadDialog(onPhotoUploaded: onPhotoUploaded),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PhotoUploadCubit(ApiService()),
      child: Dialog.fullscreen(
        backgroundColor: AppColors.background,
        child: BlocConsumer<PhotoUploadCubit, PhotoUploadState>(
          listener: (context, state) {
            if (state.isSuccess && state.uploadedPhotoUrl != null) {
              // Fotoğraf başarıyla yüklendi
              onPhotoUploaded?.call(state.uploadedPhotoUrl!);
              Navigator.of(context).pop();
            } else if (state.hasError) {
              // Hata durumunda snackbar göster
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage ?? 'Bir hata oluştu'),
                  backgroundColor: AppColors.error,
                ),
              );
            }
          },
          builder: (context, state) {
            return Scaffold(
              backgroundColor: AppColors.background,
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      // Header
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            child: Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.arrow_back,
                                color: AppColors.textPrimary,
                                size: 20,
                              ),
                            ),
                          ),
                          const Expanded(
                            child: Text(
                              'Profil Detayı',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 44), // Balance için
                        ],
                      ),

                      const SizedBox(height: 40),

                      // Title and Description
                      const Text(
                        'Fotoğraflarınızı Yükleyin',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 8),

                      Text(
                        'Resources out incentivize\nrelaxation floor loss cc.',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      // Photo Upload Area
                      Expanded(
                        child: Column(
                          children: [
                            const SizedBox(height: 40),
                            if (state.isLoading)
                              Container(
                                width: 200,
                                height: 200,
                                decoration: BoxDecoration(
                                  color: AppColors.surface,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      AppColors.primary,
                                    ),
                                  ),
                                ),
                              )
                            else
                              GestureDetector(
                                onTap: () => context
                                    .read<PhotoUploadCubit>()
                                    .pickAndUploadPhoto(),
                                child: Container(
                                  width: 200,
                                  height: 200,
                                  decoration: BoxDecoration(
                                    color: AppColors.surface,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: AppColors.textSecondary.withValues(
                                        alpha: 0.3,
                                      ),
                                      width: 1,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.add,
                                    size: 48,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),

                      // Continue Button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: state.isLoading
                              ? null
                              : () => context
                                    .read<PhotoUploadCubit>()
                                    .pickAndUploadPhoto(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            state.isLoading ? 'Yükleniyor...' : 'Devam Et',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
