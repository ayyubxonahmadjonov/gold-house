part of 'regions_bloc.dart';


abstract class RegionsState {}

final class RegionsInitial extends RegionsState {}
class GetRegionsSucces extends RegionsState{
   List<Region> regions;
  GetRegionsSucces({required this.regions});
}
class GetRegionsLoading extends RegionsState{


}
class GetRegionsError  extends RegionsState{
  final String message;
  GetRegionsError({required this.message});
  }

