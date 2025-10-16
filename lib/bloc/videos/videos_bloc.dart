import 'package:bloc/bloc.dart';
import 'package:gold_house/data/datasources/remote/api_service.dart';
import 'package:gold_house/data/models/videos_model.dart';


part 'videos_event.dart';
part 'videos_state.dart';

class VideosBloc extends Bloc<VideosEvent, VideosState> {
  VideosBloc() : super(VideosInitial()) {
    on<GetVideosEvent>(getVideos);
  }
  
Future<void> getVideos(
  GetVideosEvent event,
  Emitter<VideosState> emit,
) async {
  emit(VideosLoading());
  final result = await ApiService.getVideos();
  if (result.isSuccess) {
    final List<VideosModel> response = (result.result as List)
        .map((e) => VideosModel.fromJson(e as Map<String, dynamic>))
        .toList();
    emit(VideosSuccess(videos: response));
  } else {
    emit(VideosError(message: result.result.toString()));
  }
}
}