import 'package:bloc/bloc.dart';
import 'package:gold_house/data/datasources/remote/api_service.dart';
part 'create_credit_event.dart';
part 'create_credit_state.dart';

class CreateCreditBloc extends Bloc<CreateCreditEvent, CreateCreditState> {
  CreateCreditBloc() : super(CreateCreditInitial()) {
    on<PassportFormEvent>(passportForm);
  }
  Future<void> passportForm(PassportFormEvent event, Emitter<CreateCreditState> emit) async {
    emit(CreateCreditLoading());
    final result = await ApiService.createCreditforUser(event.phone_number, event.passportId, event.birth_date, event.pinfl);
    if (result.isSuccess) {
      emit(CreateCreditSuccess(message: result.result.toString()));
    } else {
      emit(CreateCreditError(message: result.result.toString()));
    }
  }
}
