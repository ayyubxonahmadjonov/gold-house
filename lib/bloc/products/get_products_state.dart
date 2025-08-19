part of 'get_products_bloc.dart';


abstract class GetProductsState {}

final class GetProductsInitial extends GetProductsState {}
final class GetProductsLoading extends GetProductsState {}
final class GetProductsSuccess extends GetProductsState {
  final List<Product> products;
  GetProductsSuccess({required this.products});
}
final class GetProductsError extends GetProductsState {
  final String message;
  GetProductsError({required this.message});
}

