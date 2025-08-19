part of 'otp_verification_bloc.dart';


abstract class OtpVerificationState {}


 class OtpVerificationInitial extends OtpVerificationState {}
 class OtpVerificationLoading extends OtpVerificationState {}

 class OtpVerificationSuccess extends OtpVerificationState {}

  class OtpVerificationError extends OtpVerificationState {
    final String message;
    OtpVerificationError({required this.message});
  }
