part of 'auth_register_bloc.dart';


abstract class AuthRegisterState {}

 class AuthRegisterInitial extends AuthRegisterState {}
 class AuthRegisterLoading extends AuthRegisterState {}


 class AuthRegisterSuccess extends AuthRegisterState {}

 class AuthRegisterError extends AuthRegisterState {
final String message;

AuthRegisterError({required this.message});
 }