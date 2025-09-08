import 'package:bloc/bloc.dart';
import 'package:gold_house/data/datasources/remote/api_service.dart';

part 'auth_register_event.dart';
part 'auth_register_state.dart';

class AuthRegisterBloc extends Bloc<AuthRegisterEvent, AuthRegisterState> {
  AuthRegisterBloc() : super(AuthRegisterInitial()) {
    on<AuthRegisterWithPhone>(registerWithPhone);
  }
  Future<void> registerWithPhone(
    AuthRegisterWithPhone event,
    Emitter<AuthRegisterState> emit,
  ) async {
    emit(AuthRegisterLoading());
    try {
      final result = await ApiService.registr(event.phone);
      if (result.isSuccess) {
        emit(AuthRegisterSuccess());
      } else {
        emit(AuthRegisterError(message: result.result.toString()));
      }
    } catch (e) {
      emit(AuthRegisterError(message: e.toString()));
    }
  }
}
