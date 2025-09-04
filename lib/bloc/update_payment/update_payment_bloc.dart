import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:gold_house/data/datasources/remote/api_service.dart';
part 'update_payment_event.dart';
part 'update_payment_state.dart';

class UpdatePaymentBloc extends Bloc<UpdatePaymentEvent, UpdatePaymentState> {
  UpdatePaymentBloc() : super(UpdatePaymentInitial()) {
    on<PaymentEvent>(updatePayment);
  }
  Future<void> updatePayment(PaymentEvent event, Emitter<UpdatePaymentState> emit) async {
    emit(UpdatePaymentLoading());
    final result = await ApiService.updatePayment(event.orderId, event.paymentMethod);

   final data = jsonDecode(result.body);

    if (result.statusCode == 200) {
      emit(UpdatePaymentSuccess(paymentLink: data["payment_link"]));
    } else {
      emit(UpdatePaymentError(message: result.body));
    }
  }
  
}
