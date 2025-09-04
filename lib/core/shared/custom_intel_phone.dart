
import 'package:easy_localization/easy_localization.dart';

import '../constants/app_imports.dart';

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
    return IntlPhoneField(
      decoration:  InputDecoration(
        labelText: 'your_phone'.tr(),
        hintText: 'enter_phone'.tr(),
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
    );
  }
}
