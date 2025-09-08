import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:gold_house/data/datasources/remote/api_service.dart';
import 'package:gold_house/data/models/category_model.dart';
import 'package:meta/meta.dart';

part 'get_categories_event.dart';
part 'get_categories_state.dart';

class GetCategoriesBloc extends Bloc<GetCategoriesEvent, GetCategoriesState> {
  GetCategoriesBloc() : super(GetCategoriesInitial()) {
  on<GetAllCategoriesEvent>(getAllCategories);
  }
  Future<void> getAllCategories(GetAllCategoriesEvent event, Emitter<GetCategoriesState> emit) async {
    emit(GetCategoriesLoading());
    final result = await ApiService.getCategories();
    if (result.isSuccess) {
      List<dynamic> data = result.result;

        List<Category> categories = data.map((e) => Category.fromJson(e as Map<String, dynamic>)).toList();
      emit(GetCategoriesSuccess(categories: categories));
    } else {
      emit(GetCategoriesError(message: result.result.toString()));
    }
  }
  
}
