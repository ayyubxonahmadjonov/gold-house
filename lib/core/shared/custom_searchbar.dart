import '../constants/app_imports.dart';

class CustomSearchbar extends StatefulWidget {
  TextEditingController? controller;
  final String hintText;
  final Icon? prefixicon;
  VoidCallback? onClear;
   Function(String)? onChanged;
   CustomSearchbar({super.key, required this.hintText, this.prefixicon,   this.onChanged,this.onClear,this.controller});

  @override
  State<CustomSearchbar> createState() => _CustomSearchbarState();
}

class _CustomSearchbarState extends State<CustomSearchbar> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: TextField(
        controller: widget.controller,
        
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          
          fillColor: AppColors.white,
          filled: true,
          hintText: widget.hintText,
suffixIcon:IconButton(onPressed:widget.onClear,  icon: Icon(Icons.cancel)),
          prefixIcon: widget.prefixicon,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10),
          ),
        
        ),
      ),
    );
  }
}
