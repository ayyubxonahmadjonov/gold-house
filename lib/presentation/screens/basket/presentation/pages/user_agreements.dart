
import 'package:gold_house/bloc/user_agreement/user_agrrements_dart_bloc.dart';
import 'package:gold_house/core/constants/app_imports.dart';

class UserAgreements extends StatefulWidget {
  const UserAgreements({super.key});
  @override
  State<UserAgreements> createState() => _UserAgreementsState();
}
class _UserAgreementsState extends State<UserAgreements> {
  String language = "uz";
  @override
  void initState() {
    super.initState();
    language = SharedPreferencesService.instance.getString("selected_lg") ?? "uz";
    BlocProvider.of<UserAgrrementsDartBloc>(
      context,
    ).add(GetUserAgreementsDataEvent());
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Foydalanuvchi shartnomasi")),
      body: BlocBuilder<UserAgrrementsDartBloc, UserAgrrementsDartState>(
        builder: (context, state) {
         if(state is UserAgrrementsDartSuccess){
          return SingleChildScrollView(
            child: Column(
              children: [
                 Padding(
                   padding: const EdgeInsets.all(8.0),
                   child: Text( language == "uz" ? state.userAgreements[0].titleUz : language == "ru" ? state.userAgreements[0].titleRu : state.userAgreements[0].titleEn,style: TextStyle(fontSize: 18.sp,fontWeight: FontWeight.w600),),
                 ),
                 Padding(
                   padding: const EdgeInsets.only(left: 10,top: 10,bottom: 10),
                   child: Text(language == "uz" ? state.userAgreements[0].contentUz : language == "ru" ? state.userAgreements[0].contentRu : state.userAgreements[0].contentEn,style: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.w500),),
                 ),
            ],
                    ),
          );
         }else{
          return const Center(child: CircularProgressIndicator());
         }
        },
      ),
    );
  }
}
