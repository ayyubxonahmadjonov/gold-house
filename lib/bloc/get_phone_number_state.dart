part of 'get_phone_number_bloc.dart';

abstract class GetPhoneNumberState {}

final class GetPhoneNumberInitial extends GetPhoneNumberState {}
class GetPhoneNumberSuccess extends GetPhoneNumberState {
   List<SupportModel> response;
  GetPhoneNumberSuccess({required this.response});
}
class GetPhoneNumberError extends GetPhoneNumberState {
  final String error;
  GetPhoneNumberError({required this.error});
}
class GetPhoneNumberLoading extends GetPhoneNumberState {}