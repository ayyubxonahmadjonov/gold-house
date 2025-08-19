import 'package:gold_house/core/constants/app_imports.dart';

class CustomTextField extends StatefulWidget {
  final String? label;
  final String hintText;
  final TextEditingController? controller;

  const CustomTextField({
    super.key,
    this.label,
    required this.hintText,
    this.controller,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: TextField(
        onChanged: (value) {
          widget.controller?.text = value;
        },
        controller: widget.controller,
        decoration: InputDecoration(
          labelText: widget.label,
          hintText: widget.hintText,
          floatingLabelBehavior: FloatingLabelBehavior.always,

          border: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.black),
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ),
    );
  }
}
