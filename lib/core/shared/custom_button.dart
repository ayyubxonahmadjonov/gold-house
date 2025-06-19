import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  final String title;
  final Color bacColor;
  final Color textColor;
  final FontWeight fontWeight;
  final double fontSize;
  final double borderRadius;
  final double width;
  final double height;
  final VoidCallback? onPressed;
  final Color? sideColor;

  const CustomButton({
    super.key,
    required this.title,
    required this.bacColor,
    required this.textColor,
    required this.fontWeight,
    required this.fontSize,
    required this.borderRadius,
    required this.width,
    required this.height,
    this.onPressed,
    this.sideColor,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: ElevatedButton(
        onPressed: widget.onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: widget.bacColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            side:
                widget.sideColor != null
                    ? BorderSide(color: widget.sideColor!)
                    : BorderSide.none,
          ),
        ),
        child: Text(
          widget.title,
          style: TextStyle(
            color: widget.textColor,
            fontWeight: widget.fontWeight,
            fontSize: widget.fontSize,
          ),
        ),
      ),
    );
  }
}
