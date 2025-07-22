import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/api_exceptions.dart';
import '../../../../shared/models/auth_request.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final ApiService _apiService;

  LoginCubit(this._apiService) : super(LoginState.initial());

  Future<void> login(String email, String password) async {
    emit(LoginState.loading());

    try {
      final request = LoginRequest(email: email, password: password);
      final response = await _apiService.login(request);

      if (response.data != null) {
        emit(LoginState.loaded(response.data!));
      } else {
        emit(LoginState.error('Giriş başarısız'));
      }
    } catch (e) {
      String errorMessage;
      
      if (e is UnauthorizedException) {
        errorMessage = 'E-posta veya şifre hatalı';
      } else if (e is ValidationException) {
        errorMessage = e.message;
      } else if (e is NetworkException) {
        errorMessage = 'İnternet bağlantınızı kontrol edin';
      } else if (e is ApiException) {
        errorMessage = e.message;
      } else {
        errorMessage = 'Giriş yaparken bir hata oluştu. Tekrar deneyin.';
      }
      
      emit(LoginState.error(errorMessage));
    }
  }

  void resetState() {
    emit(LoginState.initial());
  }
}