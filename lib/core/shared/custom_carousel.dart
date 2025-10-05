import 'package:cached_network_image/cached_network_image.dart';
import 'package:gold_house/bloc/banners/banners_bloc.dart';
import 'package:gold_house/core/constants/app_imports.dart';

class CustomCarousel extends StatefulWidget {
   String branchId; 

   CustomCarousel({super.key, required this.branchId});

  @override
  State<CustomCarousel> createState() => _CustomCarouselState();
}

class _CustomCarouselState extends State<CustomCarousel> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<BannersBloc>(context).add(GetBannersEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BannersBloc, BannersState>(
      listener: (context, state) {
        if (state is BannersErrorState) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        if (state is BannersSuccessState) {
          final banners = state.banners
              .where((e) => e.branch == int.parse(widget.branchId))
              .toList();

     final images = banners
    .map((e) => "https://backkk.stroybazan1.uz${e.image}")
    .toList();
if (images.length == 1) {
  images.addAll(List.filled(2, images.first));
}
        return CarouselSlider(
  options: CarouselOptions(
    height: MediaQuery.of(context).size.width / 2.2,
    autoPlay: true,
    viewportFraction: 0.9, 
  ),
            items: images.map((url) {
              return Builder(
                builder: (BuildContext ctx) {
                  return Container(
                    width: MediaQuery.of(ctx).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.r),
                      child: CachedNetworkImage(
                        imageUrl: url,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => _buildShimmerPlaceholder(),
                        errorWidget: (context, url, error) => _buildShimmerPlaceholder(),
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          );
        } else {
          return _buildShimmerPlaceholder();
        }
      },
    );
  }

  Widget _buildShimmerPlaceholder() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: 165.h,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(10.r),
        ),
      ),
    );
  }
}
