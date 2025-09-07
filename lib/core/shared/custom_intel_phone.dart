import 'package:easy_localization/easy_localization.dart';
import '../constants/app_imports.dart';

class CustomPhoneForm extends StatefulWidget {
  final TextEditingController controller;
  final Function(PhoneNumber)? onPhoneChanged;

  /// Phone validator: return error string or null
  final String? Function(PhoneNumber?)? validator;

  const CustomPhoneForm({
    super.key,
    required this.controller,
    this.onPhoneChanged,
    this.validator,
  });

  @override
  State<CustomPhoneForm> createState() => _CustomPhoneFormState();
}

class _CustomPhoneFormState extends State<CustomPhoneForm> {
  @override
  Widget build(BuildContext context) {
    return IntlPhoneField(
      decoration: InputDecoration(
        labelText: 'your_phone'.tr(),
        hintText: 'enter_phone'.tr(),
        border: const OutlineInputBorder(),
      ),
      initialCountryCode: 'UZ',
      controller: widget.controller,
      onChanged: (phone) {
        if (widget.onPhoneChanged != null) {
          widget.onPhoneChanged!(phone);
        }
      },
      validator: widget.validator,
    );
  }
}
