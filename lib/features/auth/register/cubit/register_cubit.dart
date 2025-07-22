import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/api_exceptions.dart';
import '../../../../shared/models/auth_request.dart';
import 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final ApiService _apiService;

  RegisterCubit(this._apiService) : super(RegisterState.initial());

  Future<void> register(String name, String email, String password) async {
    emit(RegisterState.loading());

    try {
      final request = RegisterRequest(
        name: name,
        email: email,
        password: password,
      );
      final response = await _apiService.register(request);

      if (response.data != null) {
        emit(RegisterState.loaded(response.data!));
      } else {
        emit(RegisterState.error('Kayıt işlemi başarısız'));
      }
    } catch (e) {
      String errorMessage;
      
      if (e is UserAlreadyExistsException) {
        errorMessage = 'Bu e-posta adresi zaten kayıtlı. Giriş yapmayı deneyin.';
      } else if (e is ValidationException) {
        errorMessage = e.message;
      } else if (e is NetworkException) {
        errorMessage = 'İnternet bağlantınızı kontrol edin';
      } else if (e is ApiException) {
        errorMessage = e.message;
      } else {
        errorMessage = 'Kayıt olurken bir hata oluştu. Tekrar deneyin.';
      }
      
      emit(RegisterState.error(errorMessage));
    }
  }

  void resetState() {
    emit(RegisterState.initial());
  }
}