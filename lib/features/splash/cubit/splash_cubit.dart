import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/services/secure_storage_service.dart';
import '../../../core/services/logger_service.dart';
import 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(SplashState.initial());

  Future<void> initialize() async {
    emit(SplashState.loading());
    
    try {
      await Future.delayed(const Duration(seconds: 2));
      
      final hasValidToken = await SecureStorageService.hasValidToken();
      LoggerService.debug('Splash initialization completed. Has valid token: $hasValidToken');
      
      emit(SplashState.completed());
    } catch (e) {
      LoggerService.error('Splash initialization failed', error: e);
      emit(SplashState.error(e.toString()));
    }
  }

  Future<bool> hasValidToken() async {
    try {
      return await SecureStorageService.hasValidToken();
    } catch (e) {
      LoggerService.error('Error checking token validity', error: e);
      return false;
    }
  }
}