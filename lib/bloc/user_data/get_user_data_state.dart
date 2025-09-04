part of 'get_user_data_bloc.dart';


abstract class GetUserDataState {}

final class GetUserDataInitial extends GetUserDataState {}

final class GetUserDataLoading extends GetUserDataState {}

 class GetUserDataSuccess extends GetUserDataState {
  final UserModel user;

  GetUserDataSuccess({required this.user});
}

final class GetUserDataError extends GetUserDataState {
  final String message;

  GetUserDataError({required this.message});
}

