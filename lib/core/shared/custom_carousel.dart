import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gold_house/bloc/banners/banners_bloc.dart';
import 'package:gold_house/core/constants/app_imports.dart';
import 'package:shimmer/shimmer.dart';

class CustomCarousel extends StatefulWidget {
  final String branchId;

  const CustomCarousel({super.key, required this.branchId});

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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        if (state is BannersSuccessState) {
          final banners = state.banners
              .where((e) => e.branch == int.parse(widget.branchId))
              .toList();

          // Check if the filtered banners list is empty
          if (banners.isEmpty) {
            return const SizedBox.shrink();
          }

          final images = banners
              .map((e) => "https://backkk.stroybazan1.uz${e.image}")
              .toList();

          // Ensure at least 3 images for carousel (duplicate if necessary)
          if (images.length == 1) {
            images.addAll(List.filled(2, images.first));
          } else if (images.length == 2) {
            images.add(images.first);
          }

          return CarouselSlider(
            options: CarouselOptions(
              height: MediaQuery.of(context).size.width / 1.9,
              autoPlay: true,
              viewportFraction: 0.9,
              enlargeCenterPage: true, // Slightly enlarge the center image
              autoPlayInterval: const Duration(seconds: 3),
            ),
            items: images.map((url) {
              return Builder(
                builder: (BuildContext ctx) {
                  return Container(
                    width: MediaQuery.of(ctx).size.width,
                    margin: const EdgeInsets.symmetric(horizontal: 5.0),
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
        }

        // Show shimmer placeholder while loading or in case of error
        return _buildShimmerPlaceholder();
      },
    );
  }

  Widget _buildShimmerPlaceholder() {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          height: MediaQuery.of(context).size.width / 1.9,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(10.r),
          ),
        ),
      ),
    );
  
  }

}