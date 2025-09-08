part of 'get_productbyid_bloc.dart';


abstract class GetProductbyidEvent {}
class GetProductDataEvent extends GetProductbyidEvent {
  final String productId;
  GetProductDataEvent({required this.productId});
}
