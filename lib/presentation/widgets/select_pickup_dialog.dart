import 'package:flutter/material.dart';
import 'package:gold_house/data/datasources/local/shared_preferences/shared_service.dart';
import 'package:gold_house/data/models/locations_model.dart';

class SelectPickupDialog extends StatefulWidget {
  final Widget? route;
  final List<BranchModel> branches;
  final String? initialSelectedCity;

  const SelectPickupDialog({
    Key? key,
    required this.branches,
    this.initialSelectedCity,
    this.route,
  }) : super(key: key);

  @override
  State<SelectPickupDialog> createState() => _SelectPickupDialogState();
}

class _SelectPickupDialogState extends State<SelectPickupDialog> {
  int? tempSelectedId;

  @override
  void initState() {
    super.initState();
    // agar initialSelectedCity ID ko‘rinishida kelgan bo‘lsa
    tempSelectedId = widget.initialSelectedCity != null
        ? int.tryParse(widget.initialSelectedCity!)
        : null;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: const Text(
        "Lokatsiyani tanlang",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: widget.branches.length,
          itemBuilder: (context, index) {
            final branch = widget.branches[index];
            return RadioListTile<int>(
              title: Text(
                branch.addressUz,
                style: TextStyle(
                  fontSize: 16,
                  color: tempSelectedId == branch.id
                      ? Colors.amber[800]
                      : Colors.black87,
                ),
              ),
              value: branch.id, // har bir filial unique id bo‘lishi kerak
              groupValue: tempSelectedId,
              activeColor: Colors.amber[800],
              onChanged: (value) {
                setState(() {
                  tempSelectedId = value;
                });
              },
            );
          },
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amber[800],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 12,
            ),
          ),
          onPressed: tempSelectedId == null
              ? null
              : () async {
                  final selectedBranch = widget.branches.firstWhere(
                    (b) => b.id == tempSelectedId,
                  );

                  // agar kerak bo‘lsa local saqlab qo‘yish
                  await SharedPreferencesService.instance
                      .saveString("selected_branch", selectedBranch.addressUz);

                  if (widget.route != null) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => widget.route!,
                      ),
                    );
                  } else {
                    Navigator.pop(context, selectedBranch);
                  }
                },
          child: const Text(
            "Tasdiqlash",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
        ),
      ],
    );
  }
}
