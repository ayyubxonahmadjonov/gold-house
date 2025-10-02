import 'package:bloc/bloc.dart';
import 'package:gold_house/data/datasources/remote/api_service.dart';
import 'package:gold_house/data/models/support_model.dart';

part 'get_phone_number_event.dart';
part 'get_phone_number_state.dart';

class GetPhoneNumberBloc extends Bloc<GetPhoneNumberEvent, GetPhoneNumberState> {
  GetPhoneNumberBloc() : super(GetPhoneNumberInitial()) {
    on<GetPAllhoneNumbersEvent>(getPhoneNumber);
  }
Future<void> getPhoneNumber(
  GetPAllhoneNumbersEvent event,
  Emitter<GetPhoneNumberState> emit,
) async {
  emit(GetPhoneNumberLoading());

  final result = await ApiService.getPhoneNumber();

  if (result.isSuccess) {
    try {

      final List<SupportModel> response = (result.result as List)
          .map((e) => SupportModel.fromJson(e as Map<String, dynamic>))
          .toList();

      emit(GetPhoneNumberSuccess(response: response));
    } catch (e) {
      emit(GetPhoneNumberError(error: e.toString()));
    }
  } else {
    emit(GetPhoneNumberError(error: result.result.toString()));
  }
}

  
}
