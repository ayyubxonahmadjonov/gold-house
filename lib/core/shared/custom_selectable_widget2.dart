import 'package:flutter/material.dart';

class CustomSelectable2Widget extends StatefulWidget {
  final String title1;
  final String title2;
  bool isInstallment;

  CustomSelectable2Widget({super.key, required this.isInstallment, required this.title1, required this.title2});
  @override
  State<CustomSelectable2Widget> createState() => _CustomSelectable2WidgetState();
}

class _CustomSelectable2WidgetState extends State<CustomSelectable2Widget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => widget.isInstallment = false),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: !widget.isInstallment ? const Color.fromRGBO(213, 213, 213, 0.63) : null,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                child: Center(child: Text(widget.title1,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600),overflow: TextOverflow.ellipsis)),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => widget.isInstallment = true),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: widget.isInstallment ?  Color.fromRGBO(213, 213, 213, 0.63) : null,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  ),
                ),
                child: Center(child: Text(widget.title2,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600),overflow: TextOverflow.ellipsis)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
