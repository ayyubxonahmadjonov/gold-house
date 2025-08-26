import 'package:bloc/bloc.dart';
import 'package:gold_house/data/datasources/remote/api_service.dart';
import 'package:gold_house/data/models/order_';
import 'package:meta/meta.dart';

part 'my_orders_event.dart';
part 'my_orders_state.dart';

class MyOrdersBloc extends Bloc<MyOrdersEvent, MyOrdersState> {
  MyOrdersBloc() : super(MyOrdersInitial()) {
    on<GetMyOrdersEvent>(getMyOrders);
  }

  Future<void> getMyOrders(
      GetMyOrdersEvent event, Emitter<MyOrdersState> emit) async {
    emit(MyOrdersLoading());
    final result = await ApiService.getMyOrders();
    print(result.result);
    print(result.statusCode);

    if (result.isSuccess) {
      try {
        final List<dynamic> data = result.result;
        final orders = data
            .map((e) => Order.fromJson(e as Map<String, dynamic>))
            .toList();

        emit(MyOrdersSuccess(orders: orders));
      } catch (e) {
        print(e);
        emit(MyOrdersError(message: "Parse error: $e"));
      }
    } else {
      emit(MyOrdersError(message: result.result.toString()));
    }
  }
}
