part of 'create_credit_bloc.dart';


abstract class CreateCreditState {}

 class CreateCreditInitial extends CreateCreditState {}
 class CreateCreditLoading extends CreateCreditState {}
 class CreateCreditSuccess extends CreateCreditState {
   final String message;
   CreateCreditSuccess({required this.message});
 }
 class CreateCreditError extends CreateCreditState {
   final String message;
   CreateCreditError({required this.message});
 }
