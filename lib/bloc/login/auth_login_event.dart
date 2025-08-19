part of 'auth_login_bloc.dart';

abstract class AuthLoginEvent {}
 class AuthLoginPhoneEvent extends AuthLoginEvent {
  final String phone;
  AuthLoginPhoneEvent({required this.phone});
}
