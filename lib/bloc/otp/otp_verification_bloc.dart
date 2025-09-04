import 'package:bloc/bloc.dart';
import 'package:gold_house/data/datasources/local/shared_preferences/shared_service.dart';
import 'package:gold_house/data/datasources/remote/api_service.dart';
part 'otp_verification_event.dart';
part 'otp_verification_state.dart';

class OtpVerificationBloc extends Bloc<OtpVerificationEvent, OtpVerificationState> {
  OtpVerificationBloc() : super(OtpVerificationInitial()) {
    on<OtpVerificationWithPhone>(otpVerificationWithPhone);
  }
  Future<void> otpVerificationWithPhone(
    OtpVerificationWithPhone event,
    Emitter<OtpVerificationState> emit,
  ) async {
    emit(OtpVerificationLoading());
    try {
      final result = await ApiService.loginVerify(event.phone_number, event.verification_code);
      print(result.result);
      if (result.isSuccess) {
    await SharedPreferencesService.instance.saveString("refresh", result.result["refresh"]!);
await SharedPreferencesService.instance.saveString("access", result.result["access"]!);
await SharedPreferencesService.instance.saveInt("user_id", result.result["id"]!);

        emit(OtpVerificationSuccess());
      } else {
        emit(OtpVerificationError(message: result.result.toString()));
      }
    } catch (e) {
      emit(OtpVerificationError(message: e.toString()));
    }
  }

  
}
