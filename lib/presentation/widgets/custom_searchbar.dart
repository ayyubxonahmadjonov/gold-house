import '../../core/constants/app_imports.dart';

class CustomSearchbar extends StatefulWidget {
  final String hintText;
  final Icon? prefixicon;
  const CustomSearchbar({super.key, required this.hintText, this.prefixicon});

  @override
  State<CustomSearchbar> createState() => _CustomSearchbarState();
}

class _CustomSearchbarState extends State<CustomSearchbar> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: TextField(
        decoration: InputDecoration(
          fillColor: AppColors.white,
          filled: true,
          hintText: widget.hintText,

          prefixIcon: widget.prefixicon ?? null,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
