import 'package:gold_house/bloc/business_selection/business_selection_bloc.dart';

import '../constants/app_imports.dart';

class SelectableRow extends StatelessWidget {
  final ValueChanged<String>? onBusinessChanged;

   SelectableRow({super.key, this.onBusinessChanged});

  final List<String> items = ["Stroy Baza №1", "Giaz Mebel", "Goldklinker"];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BusinessSelectionBloc, BusinessSelectionState>(
      builder: (context, state) {
        int selectedIndex = 0;
        String selectedBusiness = "Stroy Baza №1";

        if (state is BusinessSelectedState) {
          selectedIndex = state.selectedIndex;
          selectedBusiness = state.selectedBusiness;
        }

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
                  // Dispatch event to BusinessSelectionBloc
                  BlocProvider.of<BusinessSelectionBloc>(context).add(
                    SelectBusinessEvent(newBusiness, index),
                  );
                  // Trigger product fetch
                  BlocProvider.of<GetProductsBloc>(context).add(
                    GetProductsByBranchIdEvent(branchId: index.toString()),
                  );
                  // Call callback
                  onBusinessChanged?.call(newBusiness);
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
      },
    );
  }
}