part of 'get_products_bloc.dart';


abstract class GetProductsEvent {}
class GetProductsByBranchIdEvent extends GetProductsEvent {
  final String branchId;
  GetProductsByBranchIdEvent({required this.branchId});
}
