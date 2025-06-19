import 'package:flutter/material.dart';

class CustomSelectableWidget extends StatefulWidget {
  bool isInstallment;

  CustomSelectableWidget({super.key, required this.isInstallment});
  @override
  State<CustomSelectableWidget> createState() => _CustomSelectableWidgetState();
}

class _CustomSelectableWidgetState extends State<CustomSelectableWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => widget.isInstallment = false),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: !widget.isInstallment ? const Color(0xFFD8BB6C) : null,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    bottomLeft: Radius.circular(8),
                  ),
                ),
                child: const Center(child: Text('Hozirroq to‘lash')),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => widget.isInstallment = true),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: widget.isInstallment ? const Color(0xFFD8BB6C) : null,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                ),
                child: const Center(child: Text('Muddatli to‘lov')),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
