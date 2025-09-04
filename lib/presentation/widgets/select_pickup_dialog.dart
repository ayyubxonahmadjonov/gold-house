import 'package:flutter/material.dart';
import 'package:gold_house/data/datasources/local/shared_preferences/shared_service.dart';
import 'package:gold_house/data/models/locations_model.dart';

class SelectPickupDialog extends StatefulWidget {
  final Widget? route;
  final List<BranchModel> branches;
  final String? initialSelectedCity;
  final ValueChanged<BranchModel>? onSelected; 
  int? selectedId;

   SelectPickupDialog({
    Key? key,
    required this.branches,
    this.initialSelectedCity,
    this.route,
    this.onSelected, 
    this.selectedId,
  }) : super(key: key);

  @override
  State<SelectPickupDialog> createState() => _SelectPickupDialogState();
}

class _SelectPickupDialogState extends State<SelectPickupDialog> {
  int? tempSelectedId;
  String selectedBusiness = "";
   List<BranchModel> filteredBranches = [];

  @override
  void initState() {
    super.initState();
    selectedBusiness = SharedPreferencesService.instance.getString("selected_business") ?? "";
    tempSelectedId = widget.initialSelectedCity != null
        ? int.tryParse(widget.initialSelectedCity!)
        : null;
        filteredBranches = widget.branches
        .where((b) => b.nameUz == selectedBusiness)
        .toList();
  }
  @override
  Widget build(BuildContext context) {
    print(selectedBusiness);
    print(widget.branches.first.nameUz);
    print(selectedBusiness == widget.branches.first.nameUz);
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
          itemCount: filteredBranches.length,
          itemBuilder: (context, index) {
            final branch = filteredBranches[index];
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
              value: branch.id,
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
              : () {
                  final selectedBranch = widget.branches.firstWhere(
                    (b) => b.id == tempSelectedId,
                  );

                  // ✅ callback ishlatish
                  if (widget.onSelected != null) {
                    widget.onSelected!(selectedBranch);
                    widget.selectedId = selectedBranch.id;
                  }

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
