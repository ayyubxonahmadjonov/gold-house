import 'package:bloc/bloc.dart';
import 'package:gold_house/data/datasources/remote/api_service.dart';
import 'package:gold_house/data/models/city_model.dart';

part 'get_cities_event.dart';
part 'get_cities_state.dart';

class GetCitiesBloc extends Bloc<GetCitiesEvent, GetCitiesState> {
  GetCitiesBloc() : super(GetCitiesInitial()) {
    on<GetAllCitiesEvent>(getAllCities);
  }
  Future<void> getAllCities(GetAllCitiesEvent event, Emitter<GetCitiesState> emit) async {
    emit(GetCitiesLoading());
    try {
      final result = await ApiService.getAllCities();
      if(result.isSuccess){
  List<dynamic> data = result.result;


  List<City> cities = data.map((e) => City.fromJson(e as Map<String, dynamic>)).toList();
     
        
      emit(GetCitiesSuccess(cities: cities));

      }else{
        emit(GetCitiesError(message: result.result.toString()));
      }

    } catch (e) {
      emit(GetCitiesError(message: e.toString()));
    }
  }

  
}
