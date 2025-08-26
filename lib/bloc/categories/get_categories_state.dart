part of 'get_categories_bloc.dart';

abstract class GetCategoriesState {}

 class GetCategoriesInitial extends GetCategoriesState {}
class GetCategoriesLoading extends GetCategoriesState {}
class GetCategoriesSuccess extends GetCategoriesState {
  final List<Category> categories;
  GetCategoriesSuccess({required this.categories});
}
class GetCategoriesError extends GetCategoriesState {
  final String message;
  GetCategoriesError({required this.message});
}