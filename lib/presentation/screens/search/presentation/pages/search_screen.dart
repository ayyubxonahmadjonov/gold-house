import 'package:easy_localization/easy_localization.dart';
import 'package:gold_house/bloc/categories/get_categories_bloc.dart';
import 'package:gold_house/data/models/category_model.dart';
import 'package:gold_house/presentation/screens/search/presentation/pages/filtered_products_screen.dart';
import '../../../../../core/constants/app_imports.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}
class _SearchScreenState extends State<SearchScreen> {

  String searchQuery = "";
  String selectedlanguage = "";
  String selected_business = "";
    int selectedBranch = 0;

  TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    selected_business = SharedPreferencesService.instance.getString("selected_business") ?? "";
    selectedlanguage = SharedPreferencesService.instance.getString("selected_lg") ?? "";
      if (selected_business == "Stroy Baza №1") {
      selectedBranch = 0;
    } else if (selected_business == "Giaz Mebel") {
      selectedBranch = 1;
    } else if (selected_business == "Goldklinker") {
      selectedBranch = 2;
    } 
    BlocProvider.of<GetCategoriesBloc>(context).add(GetAllCategoriesEvent());
  }
  @override
  Widget build(BuildContext context) {
    print("selected_business: $selected_business");

    return Scaffold(
      backgroundColor: AppColors.white,
      body: BlocConsumer<GetCategoriesBloc, GetCategoriesState>(
        listener: (context, state) {
        },
        builder: (context, state) {
            if(state is GetCategoriesSuccess) {

         List<Category> filteredCategories = state.categories.where((category) {

  if (category.branch != selectedBranch) {
    return false;
  }

  if (searchQuery.isEmpty) return true;

  final query = searchQuery.toLowerCase();
  switch (selectedlanguage) {
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
                    searchQuery = "";
                  },
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                    });
                  },
                  hintText: "search".tr(),
                  prefixicon: Icon(Icons.search),
                ),
              ),
      
              Expanded(
                child: ListView.builder(
                  itemCount: filteredCategories.length,
                  itemBuilder: (context, index) {
                  
                    return _buildCategories(selectedlanguage == "uz" ? filteredCategories[index].nameUz : filteredCategories[index].nameRu, () {
Navigator.push(context, MaterialPageRoute(builder: (context) => FilteredProductsScreen(branchId: filteredCategories[index].branch.toString(),),),);                      
                    });
                  },
                ),
              ),
            ],
          );
            }else if(state is GetCategoriesError){
              return Center(
                child: Text(state.message),
              );
            }else{
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
        },
      ),
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
