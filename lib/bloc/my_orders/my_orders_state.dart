part of 'my_orders_bloc.dart';


  abstract class MyOrdersState {}

 class MyOrdersInitial extends MyOrdersState {}
class MyOrdersLoading extends MyOrdersState {}
class MyOrdersSuccess extends MyOrdersState {
  final List<Order> orders;
  MyOrdersSuccess({required this.orders});
}
class MyOrdersError extends MyOrdersState {
  final String message;
  MyOrdersError({required this.message});
}