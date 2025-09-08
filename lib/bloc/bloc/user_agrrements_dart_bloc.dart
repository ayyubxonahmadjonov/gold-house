
import 'package:bloc/bloc.dart';
import 'package:gold_house/data/datasources/remote/api_service.dart';
import 'package:gold_house/data/models/uset_agreement.dart';

part 'user_agrrements_dart_event.dart';
part 'user_agrrements_dart_state.dart';

class UserAgrrementsDartBloc extends Bloc<UserAgrrementsDartEvent, UserAgrrementsDartState> {
  UserAgrrementsDartBloc() : super(UserAgrrementsDartInitial()) {
    on<GetUserAgreementsDataEvent>(getUserAgreements);
  }
  Future<void> getUserAgreements(GetUserAgreementsDataEvent event, Emitter<UserAgrrementsDartState> emit) async {
    emit(UserAgrrementsDartLoading());
    final result = await ApiService.getUserAgreements();
    print(result.result);
    if (result.isSuccess) {

      final userAgreements = (result.result as List).map((e) => Agreement.fromJson(e)).toList();
      emit(UserAgrrementsDartSuccess(userAgreements: userAgreements));
    } else {
      emit(UserAgrrementsDartError(message: result.result.toString()));
    }
  }
  
}
