import 'package:easy_localization/easy_localization.dart';
import 'package:gold_house/core/constants/app_imports.dart';

class TotalPriceWidget extends StatelessWidget {
  final double totalPrice;
  final bool useCashback; 
  final double cashback; 

  const TotalPriceWidget({
    super.key,
    required this.totalPrice,
    required this.useCashback,
    required this.cashback,
  });

  @override
  Widget build(BuildContext context) {
    final double total = totalPrice;
    final double finalPrice =
        (useCashback && cashback > 0) ? (total - cashback) : total;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Jami
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
             Text(
              "total".tr(),
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),

            Text(
              "$total ${'currency'.tr()}",
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
          ],
        ),
SizedBox(height: 5),
        if (useCashback && cashback > 0)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Cashback chegirma:",
                style: TextStyle(color: Colors.green, fontSize: 14),
              ),
              Text(
                "-$cashback ${'currency'.tr()}",
                style: const TextStyle(
                  color: Colors.green,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

        const Divider(thickness: 1, height: 20),

        /// Yakuniy to'lov
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "To‘lanadigan summa:",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Text(
              "$finalPrice ${'currency'.tr()}",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
