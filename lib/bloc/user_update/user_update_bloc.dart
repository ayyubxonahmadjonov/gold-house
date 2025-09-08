import 'package:bloc/bloc.dart';
import 'package:gold_house/data/datasources/remote/api_service.dart';
import 'package:meta/meta.dart';

part 'user_update_event.dart';
part 'user_update_state.dart';

class UserUpdateBloc extends Bloc<UserUpdateEvent, UserUpdateState> {
  UserUpdateBloc() : super(UserUpdateInitial()) {}
  Future<void> userFullNameUpdate(UserFullNameUpdateEvent event) async {
    emit(UserUpdateLoading());
    try {
      final result = await ApiService.updateUser(event.firstname, event.lastname, event.userid);
if(result.statusCode == 200){
  emit(UserUpdateSuccess());
}else {
  emit(UserUpdateError(message: result.body.toString()));
}
    } catch (e) {
      emit(UserUpdateError(message: e.toString()));
    }
  }
   
  
}
