import 'package:bloc/bloc.dart';
import 'package:gold_house/data/datasources/remote/api_service.dart';
import 'package:gold_house/data/models/user_data_model.dart';
part 'get_user_data_event.dart';
part 'get_user_data_state.dart';

class GetUserDataBloc extends Bloc<GetUserDataEvent, GetUserDataState> {
  GetUserDataBloc() : super(GetUserDataInitial()) {
    on<GetUserAllDataEvent>(getUserData);
  }
  Future<void> getUserData(GetUserAllDataEvent event, Emitter<GetUserDataState> emit) async {
    emit(GetUserDataLoading());
    final result = await ApiService.getUserData(event.id);
    if (result.isSuccess) {
      final user = UserModel.fromJson(result.result as Map<String, dynamic>);
      emit(GetUserDataSuccess(user: user));
    } else {
      emit(GetUserDataError(message: result.result.toString()));
    }
  }
 
  
}
