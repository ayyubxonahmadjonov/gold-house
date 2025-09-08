part of 'get_productbyid_bloc.dart';


abstract  class GetProductbyidState {}

 class GetProductbyidInitial extends GetProductbyidState {}
class GetProductbyidLoading extends GetProductbyidState {}
class GetProductbyidSuccess extends GetProductbyidState {
  final Product product;
  GetProductbyidSuccess({required this.product});
}
class GetProductbyidError extends GetProductbyidState {
  final String message;
  GetProductbyidError({required this.message});
}