import 'package:bloc/bloc.dart';
import 'package:gold_house/data/datasources/remote/api_service.dart';
import 'package:gold_house/data/models/product_model.dart';
import 'package:meta/meta.dart';

part 'get_products_event.dart';
part 'get_products_state.dart';

class GetProductsBloc extends Bloc<GetProductsEvent, GetProductsState> {
  GetProductsBloc() : super(GetProductsInitial()) {
    on<GetProductsByBranchIdEvent>(_getProductsByBranchId);
  }
  Future<void> _getProductsByBranchId(GetProductsByBranchIdEvent event, Emitter<GetProductsState> emit) async {
    emit(GetProductsLoading());
    final result = await ApiService.getProductsbyBranchId(event.branchId,);
    if (result.isSuccess) {
   final List<Product> products = (result.result as List)
          .map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList();

      emit(GetProductsSuccess(products: products));
    } else {
      emit(GetProductsError(message: result.result.toString()));
    }
  }
  
  
}
