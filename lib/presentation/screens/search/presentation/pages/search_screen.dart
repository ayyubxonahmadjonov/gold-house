import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gold_house/bloc/business_selection/business_selection_bloc.dart';
import 'package:gold_house/bloc/categories/get_categories_bloc.dart';
import 'package:gold_house/data/models/category_model.dart';
import 'package:gold_house/presentation/screens/search/presentation/pages/filtered_products_screen.dart';
import '../../../../../core/constants/app_imports.dart';

class SearchScreen extends StatelessWidget {
  final TextEditingController searchController = TextEditingController();
  final ValueNotifier<String> searchQuery = ValueNotifier<String>("");

   SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedLanguage = SharedPreferencesService.instance.getString("selected_lg") ?? "uz";

    return BlocBuilder<BusinessSelectionBloc, BusinessSelectionState>(
      builder: (context, businessState) {
        String selectedBusiness = "Stroy Baza №1";
        int selectedBranch = 0;

        if (businessState is BusinessSelectedState) {
          selectedBusiness = businessState.selectedBusiness;
          selectedBranch = businessState.selectedIndex; // Use index from BusinessSelectionBloc
        }

        print('Selected Business: $selectedBusiness');
        print('Selected Branch: $selectedBranch');

        return BlocListener<BusinessSelectionBloc, BusinessSelectionState>(
          listener: (context, state) {
            if (state is BusinessSelectedState) {
           
              BlocProvider.of<GetCategoriesBloc>(context).add(GetAllCategoriesEvent());
            }
          },
          child: Scaffold(
            backgroundColor: AppColors.white,
            body: BlocConsumer<GetCategoriesBloc, GetCategoriesState>(
              listener: (context, state) {
                if (state is GetCategoriesError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                }
              },
              builder: (context, state) {
                if (state is GetCategoriesSuccess) {
                  List<Category> filteredCategories = state.categories.where((category) {
                    if (category.branch != selectedBranch) {
                      return false;
                    }

                    if (searchQuery.value.isEmpty) return true;

                    final query = searchQuery.value.toLowerCase();
                    switch (selectedLanguage) {
                      case "uz":
                        return category.nameUz.toLowerCase().contains(query);
                      case "ru":
                        return category.nameRu.toLowerCase().contains(query);
                      case "en":
                        return category.nameEn.toLowerCase().contains(query);
                      default:
                        return category.nameUz.toLowerCase().contains(query) ||
                            category.nameRu.toLowerCase().contains(query) ||
                            category.nameEn.toLowerCase().contains(query);
                    }
                  }).toList();

                  return Column(
                    children: [
                      Container(
                        color: AppColors.primaryColor,
                        padding: EdgeInsets.only(top: 60.h, bottom: 10.h),
                        child: CustomSearchbar(
                          controller: searchController,
                          onClear: () {
                            searchController.clear();
                            searchQuery.value = "";
                          },
                          onChanged: (value) {
                            searchQuery.value = value;
                          },
                          hintText: "search".tr(),
                          prefixicon: Icon(Icons.search),
                        ),
                      ),
                      Expanded(
                        child: ValueListenableBuilder<String>(
                          valueListenable: searchQuery,
                          builder: (context, query, _) {
                            return ListView.builder(
                              itemCount: filteredCategories.length,
                              itemBuilder: (context, index) {
                                return _buildCategories(
                                  selectedLanguage == "uz"
                                      ? filteredCategories[index].nameUz
                                      : selectedLanguage == "ru"
                                          ? filteredCategories[index].nameRu
                                          : filteredCategories[index].nameEn,
                                  () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => FilteredProductsScreen(
                                          branchId: filteredCategories[index].branch.toString(),
                                          categoryId: filteredCategories[index].id.toString(),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  );
                } else if (state is GetCategoriesError) {
                  return Center(child: Text(state.message));
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildCategories(String title, VoidCallback? onTap) {
    return InkWell(
      onTap: onTap,
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
        ),
        trailing: Icon(Icons.navigate_next_outlined, size: 24.sp),
      ),
    );
  }
}