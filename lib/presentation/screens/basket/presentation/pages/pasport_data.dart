import 'package:gold_house/bloc/bloc/create_credit_bloc.dart';
import 'package:gold_house/core/constants/app_imports.dart';
import 'package:intl/intl.dart';

class PassportFormPage extends StatefulWidget {
  const PassportFormPage({super.key});

  @override
  State<PassportFormPage> createState() => _PassportFormPageState();
}
class _PassportFormPageState extends State<PassportFormPage> {
  final _formKey = GlobalKey<FormState>();

  final _passportController = TextEditingController();
  final _dobController = TextEditingController();
  final _pinflController = TextEditingController();
  final _phoneController = TextEditingController();
  String phoneNumber = '';

  DateTime? _selectedDob;

  @override
  void dispose() {
    _passportController.dispose();
    _dobController.dispose();
    _pinflController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime d) => DateFormat('dd/MM/yyyy').format(d);
  Future<void> _pickDob() async {
    final now = DateTime.now();
    final initial = DateTime(now.year - 18, now.month, now.day);
    final first = DateTime(1900, 1, 1);
    final last = now;

    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDob ?? initial,
      firstDate: first,
      lastDate: last,
      helpText: "Tug'ilgan kunni tanlang",
      cancelText: "Bekor qilish",
      confirmText: "Tanlash",
    );
    if (picked != null) {
      setState(() {
        _selectedDob = picked;
        _dobController.text = _formatDate(picked);
      });
    }
  }

  List<TextInputFormatter> get _passportFormatters => [
    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
    LengthLimitingTextInputFormatter(9),
    _UpperCaseTextFormatter(),
  ];

  String? _validatePhone() {
    if ((phoneNumber).isEmpty) return "Telefon raqami bo'sh.";
    return null;
  }

  String? _validatePassport(String? v) {
    final value = (v ?? '').trim();
    if (value.isEmpty) return "Passport raqami bo'sh.";
    final re = RegExp(r'^[A-Z]{2}\d{7}$');
    if (!re.hasMatch(value)) return "Format: AA1234567 (2 harf + 7 raqam).";
    return null;
  }

  String? _validateDob(String? v) {
    if ((_selectedDob) == null || (v ?? '').isEmpty)
      return "Tug'ilgan kun bo'sh.";
    if (_selectedDob!.isAfter(DateTime.now()))
      return "Sana kelajakda bo'lmasin.";
    return null;
  }

  void _submit() {
    final formOk = _formKey.currentState?.validate() ?? false;
    if (!formOk) return;

    final data = {
      "phone": phoneNumber,
      "passportId": _passportController.text.trim(),
      "dob": _selectedDob?.toIso8601String(),
      "pinfl": _pinflController.text.trim(),
    };

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Yuborildi ✅\n$data")));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Passport ma'lumotlari"),
        backgroundColor: Colors.amber.shade300,
        foregroundColor: Colors.black,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          LayoutBuilder(
            builder: (context, c) {
              final maxW = c.maxWidth;
              final horizontal = maxW > 560 ? (maxW - 520) / 2 : 16.0;

              return Form(
                key: _formKey,
                child: ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.fromLTRB(horizontal, 20, horizontal, 24),
                  children: [
                    SizedBox(height: 50),

                    Text("Telefon raqam", style: _labelStyle(context)),
                    const SizedBox(height: 8),
                    CustomPhoneForm(
                      validator: (p0) {
                        return _validatePhone();
                      },
                      controller: _phoneController,
                      onPhoneChanged: (phone) {
                        phoneNumber = phone.completeNumber;
                        print("bu phone $phoneNumber");
                      },
                    ),

                    Text(
                      "Passport seriya yoki (ID)raqam",
                      style: _labelStyle(context),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _passportController,
                      textCapitalization: TextCapitalization.characters,
                      inputFormatters: _passportFormatters,
                      keyboardType: TextInputType.text,
                      decoration: _decoration(context, hint: "AD 1234567"),
                      validator: _validatePassport,
                    ),
                    const SizedBox(height: 18),

                    Text("Tug'ilgan kun", style: _labelStyle(context)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _dobController,
                      readOnly: true,
                      onTap: _pickDob,
                      decoration: _decoration(
                        context,
                        hint: "dd/MM/yyyy (masalan: 01/02/2000)",
                        suffixIcon: const Icon(Icons.calendar_month),
                      ),
                      validator: _validateDob,
                    ),
                    const SizedBox(height: 18),
                    Text("PINFL", style: _labelStyle(context)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _pinflController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(
                          14,
                        ), // faqat 14 ta raqam kiritiladi
                      ],
                      decoration: _decoration(context, hint: "12345678900987"),
                      validator: (v) {
                        final value = (v ?? '').trim();
                        if (value.isEmpty) return "PINFL bo'sh.";
                        final re = RegExp(r'^\d{14}$');
                        if (!re.hasMatch(value))
                          return "PINFL 14 ta raqamdan iborat bo‘lishi kerak.";
                        return null;
                      },
                    ),

                    const SizedBox(height: 70),

                    BlocConsumer<CreateCreditBloc, CreateCreditState>(
                      listener: (context, state) {
                        if (state is CreateCreditSuccess) {
                          return CustomAwesomeDialog.showInfoDialog(
                            dismissOnTouchOutside: false,

                            context,
                            title: "Muvaffaqiyatli yuborildi",
                            desc:
                                "Tanlovingiz uchun raxmat tez orada opertorlar siz bilan bog’lanishadi!",
                            dialogtype: DialogType.success,
                            onOkPress: () {
                              Navigator.pop(context);
                            },
                          );
                        } else if (state is CreateCreditError) {
                          return CustomAwesomeDialog.showInfoDialog(
                            context,
                            title: "Xatolik",
                            desc: "Ma'lumotlar yuborildi",
                            dialogtype: DialogType.error,
                            onOkPress: () {
                              HiveBoxes.basketData.clear();
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const MainScreen(),
                                ),
                                (route) => false,
                              );
                            },
                          );
                        }
                      },
                      builder: (context, state) {
                        return SizedBox(
                          height: 56,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.amber,
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            onPressed: () async {
                              print("bu phone $phoneNumber");
                              print(
                                "bu passportId ${_passportController.text.trim()}",
                              );
                              print(
                                "bu dob ${_selectedDob?.toIso8601String()}",
                              );
                              print("bu pinfl ${_pinflController.text.trim()}");
                              final formOk =
                                  _formKey.currentState?.validate() ?? false;
                              if (!formOk) return;
                              final data = {
                                "phone": phoneNumber,
                                "passportId": _passportController.text.trim(),
                                "dob": _selectedDob?.toIso8601String(),
                                "pinfl": _pinflController.text.trim(),
                              };

                              try {
                                context.read<CreateCreditBloc>().add(
                                  PassportFormEvent(
                                    phone_number: phoneNumber,
                                    passportId: _passportController.text.trim(),
                                    birth_date:
                                        _selectedDob?.toIso8601String() ?? "",
                                    pinfl: _pinflController.text.trim(),
                                  ),
                                );
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Xatolik: $e")),
                                );
                              }
                            },
                            child: const Text(
                              "Davom etish",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      backgroundColor:
          isDark ? const Color(0xFF0E0E0E) : const Color(0xFFF7F7F7),
    );
  }

  InputDecoration _decoration(
    BuildContext context, {
    String? hint,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade400),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.amber, width: 1.6),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      suffixIcon: suffixIcon,
    );
  }

  TextStyle _labelStyle(BuildContext context) =>
      const TextStyle(fontWeight: FontWeight.w600, fontSize: 14);
}

class _UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return newValue.copyWith(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
      composing: TextRange.empty,
    );
  }
}
