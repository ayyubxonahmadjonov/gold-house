part of 'auth_login_bloc.dart';


abstract class AuthLoginState {}

final class AuthLoginInitial extends AuthLoginState {}
class AuthLoginLoading extends AuthLoginState {}
class AuthLoginSuccess extends AuthLoginState {
 
}
class AuthLoginError extends AuthLoginState {
  final String message;
  AuthLoginError({required this.message});
 
}
