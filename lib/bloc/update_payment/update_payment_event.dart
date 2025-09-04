part of 'update_payment_bloc.dart';


abstract class UpdatePaymentEvent {}
class PaymentEvent extends UpdatePaymentEvent {
  final int orderId;
  final String paymentMethod;

  PaymentEvent({required this.orderId, required this.paymentMethod});
}
