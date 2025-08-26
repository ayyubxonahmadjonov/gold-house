part of 'create_order_bloc.dart';


abstract class CreateOrderEvent {}

class GenerateOrderEvent extends CreateOrderEvent {
   List<int> productId;
   List<int> variantId;
     List<int> quantity;
  final String deliveryAddress;
  final String paymentMethod;
  final bool useCashback;
  final int branchId;
  final int part;
  final String status;
  final String delivery_method;
  GenerateOrderEvent({
    required this.productId,
    required this.variantId,
    required this.quantity,
    required this.deliveryAddress,
    required this.paymentMethod,
    required this.useCashback,
    required this.branchId,
    required this.part,
    required this.status,
    required this.delivery_method,
  });
}