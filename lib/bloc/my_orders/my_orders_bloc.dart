

import 'package:bloc/bloc.dart';
import 'package:gold_house/core/constants/app_imports.dart';
import 'package:gold_house/data/datasources/remote/api_service.dart';
import 'package:gold_house/data/models/my_order.dart';

part 'my_orders_event.dart';
part 'my_orders_state.dart';

class MyOrdersBloc extends Bloc<MyOrdersEvent, MyOrdersState> {
  MyOrdersBloc() : super(MyOrdersInitial()) {
    on<GetMyOrdersEvent>(getMyOrders);

  }
  Future<void> getMyOrders(
    GetMyOrdersEvent event, Emitter<MyOrdersState> emit) async {
  emit(MyOrdersLoading());
  try {
    final result = await ApiService.getMyOrders();
    if (result.isSuccess) {
      final orders = (result.result as List<dynamic>)
          .map((e) => OrderOfBasket.fromJson(e))
          .toList();

      emit(MyOrdersSuccess(orders: orders));
    } else {
      emit(MyOrdersError(
          message: 'Failed to fetch orders: HTTP ${result.statusCode}'));
    }
  } catch (e) {
    emit(MyOrdersError(message: 'Error parsing orders: $e'));
  }
}

}
 