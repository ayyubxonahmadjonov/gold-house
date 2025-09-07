part of 'create_credit_bloc.dart';



abstract class CreateCreditEvent {}
class PassportFormEvent extends CreateCreditEvent {
  final String phone_number;
  final String passportId;
  final String birth_date;
  final String pinfl;
  PassportFormEvent({
    required this.phone_number,
    required this.passportId,
    required this.birth_date,
    required this.pinfl,
  });
}
