part of 'get_cities_bloc.dart';


abstract class GetCitiesState {}

 class GetCitiesInitial extends GetCitiesState {}

class GetCitiesLoading extends GetCitiesState {}
class GetCitiesSuccess extends GetCitiesState {
  final List<City> cities;
  GetCitiesSuccess({required this.cities});
}
class GetCitiesError extends GetCitiesState {
  final String message;
  GetCitiesError({required this.message});
}