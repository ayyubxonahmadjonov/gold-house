import 'package:gold_house/core/constants/app_imports.dart';

class PaymentOption {
  final String title;
  final String assetIcon; 
  final bool isCredit;
  PaymentOption({required this.title, required this.assetIcon, required this.isCredit});
}

class PaymentSelector extends StatefulWidget {
  final List<PaymentOption> paymentMethods;
  const PaymentSelector({super.key, required this.paymentMethods});

  @override
  State<PaymentSelector> createState() => _PaymentSelectorState();
}

class _PaymentSelectorState extends State<PaymentSelector> {
  String? selectedPayment;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: widget.paymentMethods.map((method) {
          return InkWell(
            onTap: () {
              setState(() {
                selectedPayment = method.title;
                SharedPreferencesService.instance.saveString("payment_method", method.title);
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: method != widget.paymentMethods.last
                        ? Colors.grey.shade300
                        : Colors.transparent,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  // image icon
                  Image.asset(
                    "assets/icons/${method.assetIcon}",

                  ),
                  const SizedBox(width: 12),
                  // title
                  Expanded(
                    child: Text(
                      method.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  // custom radio
                  Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.brown, width: 2),
                      color: selectedPayment == method.title
                          ? Colors.brown
                          : Colors.transparent,
                    ),
                    child: selectedPayment == method.title
                        ? const Icon(Icons.check,
                            color: Colors.white, size: 16)
                        : null,
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
