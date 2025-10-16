import 'package:easy_localization/easy_localization.dart';
import 'package:gold_house/core/constants/app_imports.dart';
import 'dart:math'; 
import 'package:intl/intl.dart'; 

class TotalPriceWidget extends StatelessWidget {
  final double totalPrice;
  final bool useCashback;
  final double cashback;

  const TotalPriceWidget({
    super.key,
    required this.totalPrice,
    required this.useCashback,
    required this.cashback,
  }) : assert(totalPrice >= 0, 'Total price cannot be negative'),
       assert(cashback >= 0, 'Cashback cannot be negative');

  @override
  Widget build(BuildContext context) {
    final double total = totalPrice;
    final double effectiveCashback =
        (useCashback && cashback > 0) ? min(cashback, total) : 0;
    final double finalPrice =
        (useCashback && cashback > 0) ? max(0, total - cashback) : total;


    final formatter = NumberFormat('#,##0.00');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Jami
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "total".tr(),
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            Text(
              "${formatter.format(total)} ${'currency'.tr()}",
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
          ],
        ),
        const SizedBox(height: 5),
        if (useCashback && cashback > 0)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "cashback_discount".tr(),
                style: const TextStyle(color: Colors.green, fontSize: 14),
              ),
              Text(
                "-${formatter.format(effectiveCashback)} ${'currency'.tr()}",
                style: const TextStyle(
                  color: Colors.green,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        if (useCashback && cashback > total)
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text(
              "full_discount_applied".tr(),
              style: const TextStyle(color: Colors.green, fontSize: 12),
            ),
          ),
        const Divider(thickness: 1, height: 20),
        /// Yakuniy to'lov
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "final_price".tr(),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Text(
              "${formatter.format(finalPrice)} ${'currency'.tr()}",
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
