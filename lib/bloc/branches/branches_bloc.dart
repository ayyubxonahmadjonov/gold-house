import 'package:bloc/bloc.dart';
import 'package:gold_house/data/datasources/remote/api_service.dart';
import 'package:gold_house/data/models/locations_model.dart';
part 'branches_event.dart';
part 'branches_state.dart';

class BranchesBloc extends Bloc<BranchesEvent, BranchesState> {
  BranchesBloc() : super(BranchesInitial()) {
    on<GetBranchesEvent>(getBranches);
  }
  Future<void> getBranches(GetBranchesEvent event, Emitter<BranchesState> emit) async {
    emit(GetBranchesLoading());
    final result = await ApiService.getBranches();
    print(result.result);
    if (result.isSuccess) {
      List<dynamic> data = result.result;
       List<BranchModel> branches = data.map((e) => BranchModel.fromJson(e as Map<String, dynamic>)).toList();
    
      emit(GetBranchesSuccess(branches: branches));
    } else {
      emit(GetBranchesError(message: result.result.toString()));
    }
  }

}
