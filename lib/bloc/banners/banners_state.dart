part of 'banners_bloc.dart';

  abstract class BannersState {}

final class BannersInitial extends BannersState {}

 class BannersSuccessState extends BannersState {
  final List<BannerModel> banners;
  BannersSuccessState({required this.banners});
 }

 class BannersErrorState extends BannersState {
  final String message;
  BannersErrorState({required this.message});
 }
  class BannersLoading extends BannersState {}