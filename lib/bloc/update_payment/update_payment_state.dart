part of 'update_payment_bloc.dart';


abstract class UpdatePaymentState {}

final class UpdatePaymentInitial extends UpdatePaymentState {}

final class UpdatePaymentLoading extends UpdatePaymentState {}

final class UpdatePaymentSuccess extends UpdatePaymentState {
  final String paymentLink;

  UpdatePaymentSuccess({required this.paymentLink});
}

final class UpdatePaymentError extends UpdatePaymentState {
  final String message;

  UpdatePaymentError({required this.message});
}

