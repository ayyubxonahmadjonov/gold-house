import 'package:flutter/material.dart';
import 'package:gold_house/data/local/shared_preferences/shared_service.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';

class CustomPhoneForm extends StatefulWidget {
  final TextEditingController controller;

  /// Tashqariga phone objectni uzatish uchun callback
  final Function(PhoneNumber)? onPhoneChanged;

  const CustomPhoneForm({
    super.key,
    required this.controller,
    this.onPhoneChanged,
  });

  @override
  State<CustomPhoneForm> createState() => _CustomPhoneFormState();
}

class _CustomPhoneFormState extends State<CustomPhoneForm> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: IntlPhoneField(
        decoration: const InputDecoration(
          labelText: 'Telefon Raqamingiz',
          hintText: 'Telefon raqamingizni kiriting',
          border: OutlineInputBorder(borderSide: BorderSide()),
        ),
        initialCountryCode: 'UZ',
        controller: widget.controller,
        initialValue: widget.controller.text,
        onChanged: (phone) {
          // Callbackni chaqirish
          if (widget.onPhoneChanged != null) {
            widget.onPhoneChanged!(phone);
          }
        },
      ),
    );
  }
}
