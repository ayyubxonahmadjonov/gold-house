import 'package:bloc/bloc.dart';
import 'package:gold_house/data/datasources/remote/api_service.dart';


part 'create_order_event.dart';
part 'create_order_state.dart';

class CreateOrderBloc extends Bloc<CreateOrderEvent, CreateOrderState> {
  CreateOrderBloc() : super(CreateOrderInitial()) {
    on<GenerateOrderEvent>(_createOrder);
  }
  Future<void> _createOrder(GenerateOrderEvent event, Emitter<CreateOrderState> emit) async {
    emit(CreateOrderLoading());
    final result = await ApiService.creatOrder(event.productId, event.variantId, event.quantity, event.deliveryAddress, event.paymentMethod, event.useCashback, event.branchId, event.part, event.status, event.delivery_method);
    print(result.result);
    print(result.statusCode);
    if (result.isSuccess) {
      emit(CreateOrderSuccess());
    } else {
      emit(CreateOrderError(message: result.result.toString()));
    }
  }

}
