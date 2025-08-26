import 'package:gold_house/bloc/banners/banners_bloc.dart';
import 'package:shimmer/shimmer.dart';
import '../constants/app_imports.dart';

class CustomCarousel extends StatefulWidget {
  const CustomCarousel({super.key});

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
          final images = state.banners
              .map((e) => "https://backkk.stroybazan1.uz${e.image}")
              .toList();

          return CarouselSlider(
            options: CarouselOptions(height: 165.h, autoPlay: true),
            items: images.map((url) {
              return Builder(
                builder: (BuildContext ctx) {
                  return Container(
                    width: MediaQuery.of(ctx).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.r),
                      child: Image.network(
                        url,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return _buildShimmerPlaceholder();
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return _buildShimmerPlaceholder();
                        },
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          );
        } else {
          // Umumiy loading shimmer
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
