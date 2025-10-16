part of 'user_agrrements_dart_bloc.dart';

abstract class UserAgrrementsDartState {}

class UserAgrrementsDartInitial extends UserAgrrementsDartState {}
class UserAgrrementsDartLoading extends UserAgrrementsDartState {}
class UserAgrrementsDartSuccess extends UserAgrrementsDartState {
  final List<Agreement> userAgreements;
  UserAgrrementsDartSuccess({required this.userAgreements});
}
class UserAgrrementsDartError extends UserAgrrementsDartState {
  final String message;
  UserAgrrementsDartError({required this.message});
}