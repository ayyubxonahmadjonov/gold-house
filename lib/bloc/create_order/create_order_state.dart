part of 'create_order_bloc.dart';


abstract class CreateOrderState {}

 class CreateOrderInitial extends CreateOrderState {}
class CreateOrderLoading extends CreateOrderState {}
class CreateOrderSuccess extends CreateOrderState {
   final int orderId;
  CreateOrderSuccess({required this.orderId});
}
class CreateOrderError extends CreateOrderState {
  final String message;
  CreateOrderError({required this.message});
}