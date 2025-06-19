import '../../core/constants/app_imports.dart';

class CustomCarousel extends StatefulWidget {
  final List<String> images;
  const CustomCarousel({super.key, required this.images});

  @override
  State<CustomCarousel> createState() => _CustomCarouselState();
}

class _CustomCarouselState extends State<CustomCarousel> {
  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(height: 165.h, autoPlay: true),
      items:
          widget.images.map((i) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(horizontal: 5.0),

                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: Image.network(i),
                  ),
                );
              },
            );
          }).toList(),
    );
  }
}
