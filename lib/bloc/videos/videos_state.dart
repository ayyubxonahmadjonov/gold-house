part of 'videos_bloc.dart';


 abstract class VideosState {}

final class VideosInitial extends VideosState {}
class VideosLoading extends VideosState {}
class VideosSuccess extends VideosState {
  final List<VideosModel> videos;
  VideosSuccess({required this.videos});
}
class VideosError extends VideosState {
  final String message;
  VideosError({required this.message});
}