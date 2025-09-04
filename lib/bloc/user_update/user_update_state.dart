part of 'user_update_bloc.dart';

@immutable
sealed class UserUpdateState {}

 class UserUpdateInitial extends UserUpdateState {}
 class UserUpdateLoading extends UserUpdateState {}
 class UserUpdateSuccess extends UserUpdateState {

 }
 class UserUpdateError extends UserUpdateState {
   final String message;
   UserUpdateError({required this.message});
 }  
