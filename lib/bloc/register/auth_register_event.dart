part of 'auth_register_bloc.dart';


abstract class AuthRegisterEvent {}
class AuthRegisterWithPhone extends AuthRegisterEvent {
  final String phone;
  AuthRegisterWithPhone({required this.phone});
}