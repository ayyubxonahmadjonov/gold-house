import '../constants/app_imports.dart';

class SelectableRow extends StatefulWidget {
  final ValueChanged<String>? onBusinessChanged; // 👈 callback

  const SelectableRow({super.key, this.onBusinessChanged});

  @override
  State<SelectableRow> createState() => _SelectableRowState();
}

class _SelectableRowState extends State<SelectableRow> {
  int selectedIndex = 0;
  String selectedBusiness = "";

  final List<String> items = ["Stroy Baza №1", "Giaz Mebel", "Goldklinker"];

  @override
  void initState() {
    super.initState();
    selectedBusiness = SharedPreferencesService.instance.getString("selected_business") ?? "";
    selectedBusiness == "Stroy Baza №1"
        ? selectedIndex = 0
        : selectedBusiness == "Giaz Mebel"
            ? selectedIndex = 1
            : selectedBusiness == "Goldklinker"
                ? selectedIndex = 2
                : selectedIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 12.h),
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: Colors.black.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (index) {
          final isSelected = selectedIndex == index;
          return GestureDetector(
            onTap: () {
              final newBusiness = items[index];

              setState(() {
                selectedIndex = index;
                selectedBusiness = newBusiness;
              });

              // SharedPreferences ga yozamiz
              SharedPreferencesService.instance.saveString("selected_business", newBusiness);

              // Bloc event yuboramiz
              BlocProvider.of<GetProductsBloc>(context)
                  .add(GetProductsByBranchIdEvent(branchId: index.toString()));

              // 👇 callback chaqiramiz
              widget.onBusinessChanged?.call(newBusiness);
            },
            child: Text(
              items[index],
              style: TextStyle(
                color: isSelected
                    ? const Color.fromRGBO(218, 151, 0, 1)
                    : Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 14.sp,
              ),
            ),
          );
        }),
      ),
    );
  }
}
