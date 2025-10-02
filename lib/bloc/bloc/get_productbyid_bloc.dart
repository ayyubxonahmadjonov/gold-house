import 'package:bloc/bloc.dart';
import 'package:gold_house/data/datasources/remote/api_service.dart';
import 'package:gold_house/data/models/product_model.dart';
part 'get_productbyid_event.dart';
part 'get_productbyid_state.dart';

class GetProductbyidBloc extends Bloc<GetProductDataEvent, GetProductbyidState> {
  GetProductbyidBloc() : super(GetProductbyidInitial()) {
    on<GetProductDataEvent>(getProductbyid);
  }
  Future<void> getProductbyid(GetProductDataEvent event, Emitter<GetProductbyidState> emit) async {
    emit(GetProductbyidLoading());
    final result = await ApiService.getProductbyId(event.productId);
    (result.result);
    if (result.isSuccess) {
   
      final product = Product.fromJson(result.result);
  
      emit(GetProductbyidSuccess(product: product));
    } else {
      emit(GetProductbyidError(message: result.result.toString()));
    }
  }
  
}
