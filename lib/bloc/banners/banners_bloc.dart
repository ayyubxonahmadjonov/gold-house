import 'package:bloc/bloc.dart';
import 'package:gold_house/data/datasources/remote/api_service.dart';
import 'package:gold_house/data/models/banners_model.dart';

part 'banners_event.dart';
part 'banners_state.dart';

class BannersBloc extends Bloc<BannersEvent, BannersState> {
  BannersBloc() : super(BannersInitial()) {
    on<GetBannersEvent>(getBanners);
  }
  
  Future<void> getBanners(GetBannersEvent event, Emitter<BannersState> emit) async {
    emit( BannersLoading());
    final result = await ApiService.getBanners();

    if (result.isSuccess) {

List<dynamic> data = result.result;

          List<BannerModel> banners = data.map((e) => BannerModel.fromJson(e as Map<String, dynamic>)).toList();


    emit(BannersSuccessState(banners: banners));
  } else {
    emit(BannersErrorState(message: result.result.toString()));
  }
  
  
}
}