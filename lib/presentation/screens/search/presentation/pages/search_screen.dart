import 'package:gold_house/bloc/categories/get_categories_bloc.dart';
import 'package:gold_house/data/models/category_model.dart';

import '../../../../../core/constants/app_imports.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}
class _SearchScreenState extends State<SearchScreen> {

  String searchQuery = "";
  TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    BlocProvider.of<GetCategoriesBloc>(context).add(GetAllCategoriesEvent());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: BlocConsumer<GetCategoriesBloc, GetCategoriesState>(
        listener: (context, state) {
        },
        builder: (context, state) {
            if(state is GetCategoriesSuccess) {
              List<Category> filteredCategories = state.categories.where((category) {
                if (searchQuery.isEmpty) return true; 
                return category.nameUz
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase());
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
                  hintText: "Qidirish",
                  prefixicon: Icon(Icons.search),
                ),
              ),
      
              Expanded(
                child: ListView.builder(
                  itemCount: filteredCategories.length,

                  itemBuilder: (context, index) {
                    
                    return _buildCategories(filteredCategories[index].nameUz, () {});
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
