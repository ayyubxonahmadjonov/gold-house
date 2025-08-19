import 'package:bloc/bloc.dart';
import 'package:gold_house/data/datasources/remote/api_service.dart';

part 'auth_login_event.dart';
part 'auth_login_state.dart';

class AuthLoginBloc extends Bloc<AuthLoginEvent, AuthLoginState> {
  AuthLoginBloc() : super(AuthLoginInitial()) {
    on<AuthLoginPhoneEvent>(loginWithPhone);
  }
  Future<void> loginWithPhone(
    AuthLoginPhoneEvent event,
    Emitter <AuthLoginState> emit,
  ) async {
    emit(AuthLoginLoading());
    try {
      final result = await ApiService.login(event.phone);
      print(result.result);
      if (result.isSuccess) {
        emit(AuthLoginSuccess());
      } else {
        emit(AuthLoginError(message: result.result.toString()));
      }
    } catch (e) {
      emit(AuthLoginError(message: e.toString()));
    }
  }
}
