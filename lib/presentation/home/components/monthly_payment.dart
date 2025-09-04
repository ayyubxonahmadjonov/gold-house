import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class MonthlyPaymentWidget extends StatefulWidget {
  final String? monthlyPrice3;
  final String? monthlyPrice6;
  final String? monthlyPrice12;
  final String? monthlyPrice24;

  const MonthlyPaymentWidget({
    super.key,
    required this.monthlyPrice3,
    required this.monthlyPrice6,
    required this.monthlyPrice12,
    required this.monthlyPrice24,
  });

  @override
  State<MonthlyPaymentWidget> createState() => _MonthlyPaymentWidgetState();
}

class _MonthlyPaymentWidgetState extends State<MonthlyPaymentWidget> {
  int selectedIndex = 1; // default 24 oy tanlangan
  final List<String> months = ['months_3'.tr(), 'months_6'.tr(), 'months_12'.tr(), 'months_24'.tr()];

  @override
  Widget build(BuildContext context) {
    final Map<String, String?> prices = {
      'months_3'.tr(): widget.monthlyPrice3,
      'months_6'.tr(): widget.monthlyPrice6,
      'months_12'.tr(): widget.monthlyPrice12,
      'months_24'.tr(): widget.monthlyPrice24,
    };
print(widget.monthlyPrice3);
    String currentMonth = months[selectedIndex];
    String price = prices[currentMonth] ?? "0";

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          // Tabs
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade400,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(months.length, (index) {
                final isSelected = selectedIndex == index;
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.white : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        months[index],
                        style: TextStyle(
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
           SizedBox(height: 20),

          // Price section
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.yellow.shade200,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  "$price ${'currency'.tr()}",
                  style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 17),
                ),
              ),
              const SizedBox(width: 8),
              Text("x $currentMonth"),
            ],
          ),
        ],
      ),
    );
  }
}
