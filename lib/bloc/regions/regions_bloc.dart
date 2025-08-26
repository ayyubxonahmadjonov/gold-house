import 'package:bloc/bloc.dart';
import 'package:gold_house/data/datasources/remote/api_service.dart';
import 'package:gold_house/data/models/region_model.dart';
import 'package:meta/meta.dart';

part 'regions_event.dart';
part 'regions_state.dart';

class RegionsBloc extends Bloc<RegionsEvent, RegionsState> {
  RegionsBloc() : super(RegionsInitial()) {
    on<GetRegionsEvent>(getRegions);
  }
  Future<void> getRegions(GetRegionsEvent event, Emitter<RegionsState> emit) async {
    emit(GetRegionsLoading());
    final result = await ApiService.getRegions();
    print(result.result);
    
    if (result.isSuccess) {
      List<dynamic> data = result.result;
      List<Region> regions = data.map((e) => Region.fromJson(e as Map<String, dynamic>)).toList();
      emit(GetRegionsSucces(regions: regions));
    } else {
      emit(GetRegionsError(message: result.result.toString()));
    }
  }
}
