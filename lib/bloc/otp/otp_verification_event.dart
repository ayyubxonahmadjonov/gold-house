part of 'otp_verification_bloc.dart';


abstract class OtpVerificationEvent {}

class OtpVerificationWithPhone extends OtpVerificationEvent {
  final String phone_number;
  final String verification_code;
  OtpVerificationWithPhone({required this.verification_code, required this.phone_number});
}
